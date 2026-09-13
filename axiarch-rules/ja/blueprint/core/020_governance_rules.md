# 020. Governance Rules

> [!NOTE]
> このファイルは Blueprint Rule（プロジェクト固有ルール）です。
> `core/010_project_lessons_log.md` から自動結晶化されました。
> Created: 2026-06-12

> [!IMPORTANT]
> **Domain**: ガバナンス
> **Location**: `blueprint/core/020_governance_rules.md`
> **Related Universal Rules**: `universal/core/000_core_mindset.md`, `axiarch-rules/ja/universal/core/100_governance.md`
> **4 recorded lessons.**

---

## 📒 目次

| セクション | 内容 | セクション数 |
|:---------|:-----|:--:|
| 教訓 | 結晶化されたルール・教訓 | 4 |
| Appendix A | 逆引き索引 & クロスリファレンス | 1 |

---

## 教訓

### [Initial] プロジェクト開始時の教訓
**Domain:** ガバナンス
**Context:** 新規プロジェクトまたはルールの刷新時。
**Rule:** `AXIARCH.md` をAxiarchの入口正本として扱い、詳細なプロトコル本体は `AXIARCH.md` から `axiarch-rules` をロードして参照すること。`AGENTS.md` は対応環境向けアダプターとして扱うこと。

---

### [2026-06-08] 正本化リファクタによる厳格ルールの暗黙的劣化と多面的復元
**Domain:** ガバナンス
**Context:** #46 で AGENTS.md を AXIARCH.md へ正本化した際、旧 §2「Language First」が §6.10 の弱い1行（owner-facing 文書のみ列挙）に格下げされ、AI 応答面（見出し・要約・ラベル・箇条書き・表）への強制力と違反条項が消失していた（採用先から「指定言語対応が弱くなった」と報告）。
**Problem:** 大規模な正本化・統合では、強い旧ルールが silent に劣化しても気づきにくい。さらに復元時、正本（AXIARCH.md）と reminder だけ直しても、AI 向けダイジェスト（llms.txt / llms-full.txt）や ROADMAP の ja/en ミラーなど周辺 surface に旧表現が取り残されやすい。
**Solution/Rule:** (1) §6.10 非劣化原則に基づき、置換境界を明示しない限り旧来の厳しい解釈を保持する。(2) 復元は「正本 + reminder + AI 向けダイジェスト + ja/en ミラー」の全 surface で同期する。(3) 復元した不変条項は health-check の専用 Check（例: Check 16）で grep ガードし、将来の silent な削除/劣化を EXIT_CODE=1 で検出して再発リスクを下げる。
**Reference:** #46 / v1.13.1 / AXIARCH.md §7.10 / axiarch-scripts/check-axiarch-health.sh Check 16

---

### [2026-06-12] 読み取り専用 subagent / security-scan fanout と人間承認ゲートの混同を避ける
**Domain:** ガバナンス
**Context:** Codex が「正式な Codex Security Deep Security Scan はサブエージェント明示許可が必要」と判断し、ユーザーが deep scan / exhaustive review を求めているにもかかわらず、読み取り専用 fanout を追加承認待ち扱いにして停止するリスクが確認された。
**Problem:** Human Approval Gate は stage、commit、push、deploy、DB適用、本番変更、課金増、機微境界などの高リスク操作を止めるためのものだが、サブエージェントや scan tool を使うという理由だけで読み取り専用調査まで止めると、Execution Harness の role pass / audit / verification が実行されず、かえって品質保証が弱くなる。
**Solution/Rule:** 読み取り専用の role pass、audit、security scan、bounded subagent delegation は、ユーザーがその調査を求めており、file write / remote mutation / production access / install / auth / cost / sensitive data retrieval を伴わない限り、追加の「サブエージェント明示許可」を待たずに実行してよい。Codex Security Deep Security Scan などの名前付き workflow が明示された場合、必要な読み取り専用 worker fanout はその要求に含まれる。委任機能が runtime にない場合は、正式 Deep Security Scan 実行済みと主張せず、通常 scan またはメインエージェント順次 role pass へ fallback する。
**Reference:** AXIARCH.md §7.2 / §10, `axiarch-harness/{ja,en}/SUBAGENT_DELEGATION_PROTOCOL.md`, `axiarch-harness/{ja,en}/HUMAN_APPROVAL_GATE.md`, Codex Security `deep-security-scan/SKILL.md`

---

### [2026-09-11] 記録・候補・実証・保証を混同しない
Domain: ガバナンス
Target Folder: blueprint/core/
Context: Axiarch全体一貫性の監査で、英語教訓の診断漏れ、補足による未読の断定、全3エージェント実証済みという合格条件、未配線の見出し参照を確認した。
Problem: 文言だけを固定する検査は、誤った仕様を合格条件として温存しうる。ファイルの存在、候補検索、実際の読込、結果の検証は別の事実である。
Solution/Rule: 診断は確認対象と判定可能な範囲を明示し、現在の所有者説明と実行結果へ突合する。テンプレート、ヒューリスティック、アダプターの存在を完了・実証の証拠にしない。既存の文字列検査に隔離した実動作・負例テストを組み合わせ、日英と追加カテゴリを同じ導線で検査する。
Reference: `tests/test_consistency.py`, `tests/test_runtime.py`, `axiarch-scripts/axiarch_inspect.py`, `AXIARCH.md` §1.1

追補（同日の再監査）: 構造検査が過去の完了記録にも現在の鮮度を要求していたこと、更新の中断後に適用済みハッシュより古いbaseを優先して再実行を妨げることを負例で確認した。現在の判断に使う証拠の突合と履歴の形式検査を分け、再実行・同時実行・自己更新も実入力で検証する。既存教訓への補足であり、件数を水増ししない。参照: `axiarch-scripts/axiarch_state.py`、`axiarch-scripts/axiarch_upgrade.py`、`tests/test_runtime.py`。

---

同日の導入経路の追補: 任意生成処理が独自コマンドを上書きし、明示dry-runが後続の引数で解除されることを実動作で確認した。「任意」「安全」「確認済み」という名称だけを根拠にせず、衝突・空入力・選択範囲・エラー後の記録まで検証する。旧生成物は推測で所有判定せず、内容確認を経て移行する。参照: `tests/test_setup.py`、`axiarch-scripts/axiarch_setup.py`。

## Appendix A: 逆引き索引 & クロスリファレンス

### 逆引き索引（Keyword → Section）

| Keyword | Section | Related Rule |
|:---------|:------------|:---------|
| AXIARCH.md, AGENTS.md, 正本入口 | 教訓 — プロジェクト開始時の教訓 | `axiarch-rules/ja/universal/core/100_governance.md` |
| Language First, silent degradation, Check 16 | 教訓 — 正本化リファクタによる厳格ルールの暗黙的劣化 | `axiarch-rules/ja/universal/core/100_governance.md` |
| subagent, Deep Security Scan, Human Approval Gate, fanout | 教訓 — 読み取り専用 subagent / security-scan fanout と人間承認ゲートの混同を避ける | `universal/core/000_core_mindset.md`, `axiarch-rules/ja/universal/core/100_governance.md` |
| 候補、実証、保証、診断、日英 | 教訓 — 記録・候補・実証・保証を混同しない | `axiarch-rules/ja/universal/core/100_governance.md` |

### クロスリファレンス

| Related File | Relationship |
|:-----------|:-----|
| `universal/core/000_core_mindset.md` | Agentic AI の自律度、権限、承認境界の上位原則 |
| `axiarch-rules/ja/universal/core/100_governance.md` | Axiarch ルール運用と改正統制の上位原則 |
| `core/010_project_lessons_log.md` | Index（結晶化元） |
| `AXIARCH.md` | 実行・委任・承認境界の正本入口 |
| `axiarch-harness/{ja,en}/` | Execution Harness の運用プロトコル |
