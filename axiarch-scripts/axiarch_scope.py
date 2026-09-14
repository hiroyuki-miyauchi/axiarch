#!/usr/bin/env python3
"""Bounded JA/EN keyword hints, not semantic analysis or proof of rule loading."""
import argparse
import os
from pathlib import Path
import re
import stat
import subprocess
import sys
import unicodedata

sys.dont_write_bytecode = True
from axiarch_hook import payload, read_utf8_stdin
from axiarch_state import identifier, inside

# Existing English labels identify topics. Japanese phrases and selected
# English equivalents map to the same families across record languages.
ALIASES = {
    'security': ('セキュリティ', '個人情報', 'privacy', 'プライバシー'),
    'rls': (), 'auth': ('authentication', '認証'),
    'authn': (), 'authz': ('authorization', '認可'),
    'encryption': ('暗号化',), 'vulnerability': ('脆弱性',),
    'architecture': ('アーキテクチャ',), 'migration': ('マイグレーション',),
    'schema': ('スキーマ',), 'refactor': ('リファクタリング',), 'restructure': ('再構成',),
    'performance': ('パフォーマンス', '性能'), 'optimization': ('最適化',),
    'cache': ('キャッシュ',), 'latency': ('レイテンシ', '遅延'),
    'ui_design': ('画面設計',), 'ui': ('画面',), 'ux': ('ユーザー体験',),
    'accessibility': ('アクセシビリティ',), 'a11y': (), 'layout': ('レイアウト',),
    'api': (), 'endpoint': ('エンドポイント',), 'rest': (), 'graphql': (),
    'contract': ('契約',), 'i18n': ('国際化', '多言語'),
    'localization': ('ローカライズ',), 'translation': ('翻訳',),
    'finops': (), 'cost': ('コスト',), 'billing': ('課金',),
    'testing': ('テスト',), 'qa': ('品質保証',), 'e2e': (), 'unit': ('単体',),
    'deploy': ('デプロイ',), 'release': ('リリース',), 'push': ('プッシュ',),
    'pr': ('プルリクエスト',), 'commit': ('コミット',), 'merge': ('マージ',), 'tag': ('タグ',),
}


def keywords(text, custom=''):
    if custom:
        # Preserve POSIX ERE / -w semantics, including [[:digit:]], rather than
        # interpreting an adopter's existing setting as a Python regex.
        try:
            result = subprocess.run(['grep', '-oiwE', '--', '(' + custom + ')'],
                input=text.encode('utf-8'), capture_output=True, timeout=3)
        except (OSError, subprocess.SubprocessError) as error:
            raise ValueError('custom keyword inspection unavailable') from error
        if result.returncode not in (0, 1):
            raise ValueError('invalid custom keyword expression')
        try:
            return {line.lower() for line in result.stdout.decode('utf-8').split('\n') if line}
        except UnicodeError as error:
            raise ValueError('custom keyword output is not UTF-8') from error
    value = unicodedata.normalize('NFKC', text).casefold()
    found = set()
    for key, aliases in ALIASES.items():
        for word in (key, *aliases):
            if word.isascii():
                matched = re.search(r'(?<![a-z0-9_])' + re.escape(word) + r'(?![a-z0-9_])', value)
            else:
                matched = word in value  # Japanese phrases need no surrounding spaces.
            if matched:
                found.add(key)
                break
    equivalents = {'authn': 'auth', 'a11y': 'accessibility', 'ui_design': 'ui'}
    return {equivalents.get(key, key) for key in found}


def context_text(root, session):
    if not session:
        return ''  # Do not borrow shared root documents or require H0 records.
    session = identifier(session)
    records = []
    for name in ('task.md', 'implementation_plan.md', 'walkthrough.md'):
        try:
            path = inside(root, f'.axiarch/sessions/{session}/{name}')
            fd = os.open(path, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK)
            try:
                if not stat.S_ISREG(os.fstat(fd).st_mode):
                    raise ValueError('regular file required')
                with os.fdopen(fd, 'rb', closefd=False) as stream:
                    text = stream.read().decode('utf-8')
                if '\x00' in text:
                    raise ValueError('NUL in context')
                records.append(text)
            finally:
                os.close(fd)
        except (OSError, ValueError) as error:
            raise ValueError('session document unavailable: ' + name) from error
    return '\n'.join(records)


def review(data, root, session):
    prompt = data.get('prompt', '')
    if not isinstance(prompt, str) or '\x00' in prompt:
        raise ValueError('prompt must be a string without NUL')
    if not prompt:
        return ''
    custom = os.environ.get('AXIARCH_TASK_DOMAIN_KEYWORDS', '')
    current = keywords(prompt, custom)
    previous = keywords(context_text(root, session), custom)
    if not current - previous:
        return ''
    # Custom expressions may match personal data or entire sentences. Compare
    # their values internally, but never echo them into the reminder or logs.
    labels = 'custom matches / 独自パターンの一致' if custom else ' '.join(sorted(current - previous))
    return (' [LOAD REVIEW] New prompt keywords (' + labels + ') are absent from recorded context. '
            'This is a task-scope review hint, not proof of a missing load. '
            'Load additional rules only if the actual task needs them. / '
            '新しい話題は分類の見直し候補です。未ロードや違反の証明ではありません。'
            '実際の作業に関連する場合だけ追加ロードし、実読込した範囲を記録してください。')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--project', required=True)
    parser.add_argument('--session', default='')
    args = parser.parse_args()
    if os.name != 'posix':
        raise ValueError('POSIX Python required; use Linux Python inside WSL 2 on Windows')
    root = Path(args.project).resolve(strict=True)
    print(review(payload(read_utf8_stdin()), root, args.session), end='')


if __name__ == '__main__':
    try:
        main()
    except (OSError, ValueError, TypeError) as error:
        print('Scope review unavailable / 作業範囲の補助検査を確認できません: ' + str(error), file=sys.stderr)
        sys.exit(2)
