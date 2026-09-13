#!/usr/bin/env bash
# =============================================================================
# Axiarch Boot Reminder Hook (UserPromptSubmit / additionalContext emitter)
# https://github.com/hiroyuki-miyauchi/axiarch
#
# Outputs a JSON payload conforming to Claude Code's hookSpecificOutput.additionalContext
# spec (https://code.claude.com/docs/en/hooks). The reminder is injected directly
# into Claude's context instead of being splashed in transcript / Plan-mode UI.
#
# Beyond the static AXIARCH BOOT message, this script performs lightweight
# project-state checks and APPENDS violation flags to the reminder when found,
# enabling the AI to self-correct on the next turn (warning, not hard-block).
#
#   Check A  task.md missing load history                       → flag appended
#   Check B  core/010_project_lessons_log.md domain ≥3 unsorted  → flag appended
#   Check C  core/010 lesson dated >180 days (stale)            → flag appended (v1.6.0+)
#   Check D  Task boundary detection — current prompt domain    → flag + TTL bypass (v1.8.0+)
#            ≠ domains in process docs (task.md / implementation_plan.md / walkthrough.md)
#
# v1.6.0+ TWO-STAGE OUTPUT (token-cost optimisation):
#   - First fire (or after TTL expires)            → FULL reminder + timestamp
#   - Subsequent fires within TTL + no violations  → SHORT-CIRCUIT [AXIARCH REMINDER]
#   - Any violation detected (A/B/C/D)             → forced FULL reminder (TTL ignored)
#
# v1.8.0+ TASK BOUNDARY DETECTION (Check D):
#   - Reads current user prompt from stdin (Claude Code passes JSON payload)
#   - Extracts domain keywords (security/architecture/ui_design/api/performance/etc.)
#   - Compares against the AXIARCH current-task mandatory trio (task.md / implementation_plan.md
#     / walkthrough.md) — full-text grep, not just task.md's load-history table
#   - On mismatch: LOAD REVIEW + force full reminder (override TTL short-circuit)
#   - Addresses the "AI judges 'same session, no re-load needed' and misses a relevant rule" issue
#     identified by adopter feedback. Provides a heuristic scope-change hint, not proof of a violation.
#   - Reading all 3 process docs avoids false positives where the plan / walkthrough
#     already contains the prompt's domain context (these files are kept
#     up-to-date by the AI; trusting all 3 mirrors the AI's actual working state).
#
#   TTL: ${AXIARCH_REMINDER_TTL_SECONDS:-1800}  (default 30 min, 0 disables short-circuit)
#   State file: ${TMPDIR:-/tmp}/axiarch-reminder-{project_hash}.timestamp
#   Stale lesson threshold: ${AXIARCH_LESSON_STALE_DAYS:-180}  (0 disables Check C)
#   Task boundary detection: ${AXIARCH_TASK_BOUNDARY_DETECT:-1}  (0 disables Check D)
#
#   Shorter repeated context; total-token savings depend on the actual workload.
#
# Python 3 and the distributed axiarch_hook.py helper are required; no jq needed.
# =============================================================================

set -uo pipefail

# -----------------------------------------------------------------------------
# Read hook input from stdin (Claude Code passes JSON payload for UserPromptSubmit)
# Format (per https://code.claude.com/docs/en/hooks):
#   {"prompt": "...", "session_id": "...", "transcript_path": "...", "cwd": "..."}
# Read the supplied pipe through EOF; interactive stdin is left untouched.
# -----------------------------------------------------------------------------
INPUT=""
INPUT_WARNING=""

# Resolve project directory: prefer Claude Code's CLAUDE_PROJECT_DIR if exported,
# otherwise fall back to two levels up from this script (axiarch/axiarch-scripts/<this>).
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-}"
if [[ -z "${PROJECT_DIR}" || ! -d "${PROJECT_DIR}" ]]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  PROJECT_DIR="$(dirname "${SCRIPT_DIR}")"
fi
HOOK_HELPER="${PROJECT_DIR}/axiarch-scripts/axiarch_hook.py"
if ! command -v python3 >/dev/null 2>&1 || [[ ! -f "$HOOK_HELPER" || ! -f "${PROJECT_DIR}/axiarch-scripts/axiarch_state.py" ]]; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"[HOOK INPUT WARNING] Python 3 or Axiarch helpers unavailable; state was not inspected. / Python 3または補助ファイルがないため状態を検査していません。"}}'
  exit 0
fi
if [[ ! -t 0 ]] && ! INPUT=$(python3 "$HOOK_HELPER" normalize); then
  INPUT_WARNING=" [HOOK INPUT WARNING] Invalid raw JSON; input was not inspected. / 不正なJSON入力は検査できていません。"
fi
if [[ -z "$INPUT_WARNING" ]]; then
  if ACTIVE_PROJECT=$(printf '%s' "$INPUT" | python3 "$HOOK_HELPER" project --project "$PROJECT_DIR"); then
    PROJECT_DIR="${ACTIVE_PROJECT%.}"
  else
    printf '%s\n' '[HOOK INPUT WARNING] Working project unresolved; no other checkout was inspected. / 作業先を特定できず、別の作業コピーは検査していません。' |
      python3 "$HOOK_HELPER" emit --event UserPromptSubmit
    exit 0
  fi
fi

# -----------------------------------------------------------------------------
# Static base reminder (bilingual; identical to the inline reminder previously
# distributed via .claude/settings.json or .codex/hooks.json before externalization)
# -----------------------------------------------------------------------------
read -r -d '' CORE_REMINDER <<'EOF' || true
[AXIARCH BOOT] This project enforces axiarch governance. Before non-trivial changes or verdicts, the AI must load and apply AXIARCH.md (canonical protocol) and the LOADING_PROTOCOL.md BOOT SEQUENCE. Tool adapters such as AGENTS.md point to AXIARCH.md and are not separate rule sources. Follow the latest explicit user language instruction, then the Project Native Language declared in AXIARCH.md and is applied to every heading, summary, label, list, table, and bullet in the response; when that language is Japanese, emitting English headings, summaries, labels, or section titles is a protocol violation (code, APIs, logs, paths stay in their required language). For H2+, record actual paths and read ranges in the session task.md after reading. H0 needs no durable record; H1 needs only a short record. A missing recognizable row is a review hint, not proof of missing reads. task.md / implementation_plan.md / walkthrough.md are current-task Markdown evidence, not native task/plan UI state. When available, Codex must also update_plan, and Claude Code must also use TaskCreate / TaskUpdate / TaskList / TaskGet, with TodoWrite only as an older-runtime fallback. For non-trivial tasks (H2+), the Execution Harness in axiarch-harness/ is mandatory: run role passes, produce an audit verdict and an evidence packet, and stop at the human approval gate; read-only subagent delegation is not a human approval gate by itself, and named read-only workflows such as Deep Security Scan include their required worker fanout when explicitly requested; final judgment stays with the main agent. When creating or updating lessons, follow axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md Steps 1–6, including count and age triggers and index updates. H0 read-only work needs no lesson cleanup. / 本プロジェクトは axiarch ガバナンスを採用しています。非自明な修正や判定の前に、AI は AXIARCH.md（正本プロトコル）と LOADING_PROTOCOL.md の BOOT SEQUENCE を読み込んで適用する必要があります。AGENTS.md などのツールアダプターは AXIARCH.md への入口であり、別のルール正本ではありません。ユーザーの明示言語指定を最優先し、それ以外では応答言語は AXIARCH.md で宣言された Project Native Language に従い、応答中のすべての見出し・要約・ラベル・箇条書き・表に適用されます。その言語が日本語の場合、英語の見出し・要約・ラベル・節タイトルを出すことはプロトコル違反です（コード・API・ログ・パスは必要な言語のまま）。H2以上では実際に読んだパスと範囲をセッションのtask.mdへ記録します。H0は永続記録不要、H1は短い記録で足ります。履歴行の未検出は見直し候補であり、未読の証明ではありません。task.md / implementation_plan.md / walkthrough.md は現在タスク用のMarkdown証跡であり、ネイティブなタスク・プランUI状態ではありません。対応ランタイムでは Codex は update_plan、Claude Code は TaskCreate / TaskUpdate / TaskList / TaskGet も併用し、TodoWrite は古いランタイム向けのフォールバックに限定します。非自明なタスク（H2 以上）では axiarch-harness/ の Execution Harness が必須です。ロールパスを実行し、監査判定と証跡パケットを出し、人間承認ゲートで停止してください。読み取り専用のサブエージェント委任はそれ自体では人間承認ゲートではありません。Deep Security Scan などの名前付き読み取り専用 workflow が明示された場合、必要な worker fanout はその要求に含まれます。最終判断はメインエージェントが保持します。教訓を作成・更新するときは axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md のStep 1–6（件数・経過日、索引更新を含む）に従います。H0の読取だけに教訓整理は要求しません。
EOF

# v1.6.0+ short-circuit reminder (used after TTL window when no review hints)
read -r -d '' SHORT_REMINDER <<'EOF' || true
[AXIARCH REMINDER] axiarch governance applies to this project. Continue applying AXIARCH.md / LOADING_PROTOCOL. Follow the latest explicit user language instruction, then respond in the Project Native Language declared in AXIARCH.md — every heading, summary, label, list, table, and bullet (code, APIs, logs, paths excepted); when it is Japanese, English headings/labels are a protocol violation. For non-trivial tasks (H2+), apply the Execution Harness (axiarch-harness/): role passes, audit verdict, evidence packet, and stop at the human approval gate. Read-only subagent delegation is not a human approval gate; explicit Deep Security Scan requests include required read-only fanout. Keep native task/plan state in sync when available. Full reminder reappears on TTL expiry, review hints, or new session. / axiarch ガバナンスは本プロジェクトに適用されます。AXIARCH.md / LOADING_PROTOCOL の適用を継続。ユーザーの明示言語指定を最優先し、それ以外では応答は AXIARCH.md の Project Native Language で行い、すべての見出し・要約・ラベル・箇条書き・表に適用する（コード・API・ログ・パスは例外）。日本語の場合、英語の見出し・ラベルはプロトコル違反です。非自明なタスク（H2 以上）では axiarch-harness/ の Execution Harness（ロールパス・監査判定・証跡パケット・人間承認ゲート）を適用してください。読み取り専用のサブエージェント委任は人間承認ゲートではありません。明示された Deep Security Scan は必要な読み取り専用 fanout を含みます。利用可能ならネイティブなタスク・プラン状態も同期してください。TTL 期限切れ・見直し候補・新規 session 時に full reminder が再表示されます。
EOF

VIOLATIONS=""
VIOLATIONS="${VIOLATIONS}${INPUT_WARNING}"
if [[ -n "$INPUT_WARNING" ]]; then
  SESSION_ID=""
elif ! SESSION_ID=$(printf '%s' "$INPUT" | python3 "$HOOK_HELPER" session); then
  VIOLATIONS="${VIOLATIONS} [HOOK INPUT WARNING] Invalid hook identity; see stderr. Session unresolved. / 入力が不正なためセッションを特定していません。"
  SESSION_ID=""
fi
DOC_DIR=""
if [[ -n "${SESSION_ID}" ]]; then
  RESOLVED_DOC_DIR=$(bash "${PROJECT_DIR}/axiarch-scripts/axiarch-task-state.sh" --project "${PROJECT_DIR}" --mode path --session "${SESSION_ID}" 2>/dev/null) || RESOLVED_DOC_DIR=""
  if [[ -n "${RESOLVED_DOC_DIR}" ]]; then DOC_DIR="${RESOLVED_DOC_DIR}"; fi
fi

# -----------------------------------------------------------------------------
# Check A: task.md missing load history
# -----------------------------------------------------------------------------
if [[ -n "${DOC_DIR}" && -f "${DOC_DIR}/task.md" ]]; then
  if ! grep -qE '^\|[^|]*(AXIARCH\.md|INDEX\.md|LOADING_PROTOCOL\.md)[^|]*\|' "${DOC_DIR}/task.md" 2>/dev/null; then
    VIOLATIONS="${VIOLATIONS} [LOAD REVIEW] No recognizable load-history row found in this session. For H2+ read the applicable files before recording them; H0 does not require task records. / このセッションのロード履歴行を確認できません。H2以上は必要な実ファイルを読んでから記録し、H0の読み取りには記録作成を要求しません。"
  fi
fi
# Note: task.md absence is allowed (created on first task per AXIARCH current-task protocol).

# -----------------------------------------------------------------------------
# Check B: Crystallization threshold breach (3+ unsorted per domain)
# Check C: Stale lesson detection (date >180 days, v1.6.0+)
# -----------------------------------------------------------------------------
# Check every installed language and only actual lesson entries; quoted/fenced templates are ignored.
LESSON_REPORT=""
if ! LESSON_REPORT=$(python3 "${PROJECT_DIR}/axiarch-scripts/axiarch_inspect.py" --project "${PROJECT_DIR}" --mode lessons 2>&1); then
  VIOLATIONS="${VIOLATIONS} [LESSON REVIEW] ${LESSON_REPORT}. Read axiarch-rules/{lang}/CRYSTALLIZATION_PROTOCOL.md Step 5. / 指摘の実ファイルを確認し、教訓の分類・昇華を見直してください。"
fi

# -----------------------------------------------------------------------------
# Check D (v1.8.0+): Task boundary detection
# Detects mismatch between current prompt's domain keywords and task.md's recorded
# load history. Forces full reminder (TTL bypass) when a new task type is detected,
# reviewing the "AI judges 'same session, no re-load needed' and misses a relevant rule" loophole.
#
# Domain keywords (extensible via AXIARCH_TASK_DOMAIN_KEYWORDS env var):
#   security / rls / auth / authn / authz / encryption / vulnerability
#   architecture / migration / schema / refactor / restructure
#   performance / optimization / cache / latency
#   ui_design / ux / accessibility / a11y / layout
#   api / endpoint / rest / graphql / contract
#   i18n / localization / translation
#   finops / cost / billing
#   testing / qa / e2e / unit
#   deploy / release / push / pr / commit / merge / tag
# -----------------------------------------------------------------------------
if [[ "${AXIARCH_TASK_BOUNDARY_DETECT:-1}" == "1" ]] && [[ -n "${INPUT}" ]]; then
  # Decode complete prompt text consistently, including Unicode escapes.
  CURRENT_PROMPT=""
  if ! CURRENT_PROMPT=$(printf '%s' "$INPUT" | python3 "$HOOK_HELPER" prompt); then
    VIOLATIONS="${VIOLATIONS} [HOOK INPUT WARNING] Invalid prompt; see stderr. Prompt keywords were not inspected. / 入力が不正なためキーワードを検査していません。"
    CURRENT_PROMPT=""
  fi

  if [[ -n "${CURRENT_PROMPT}" ]]; then
    # Default domain keyword set (lowercased, regex-friendly)
    DOMAIN_KEYWORDS_DEFAULT="security|rls|auth|authn|authz|encryption|vulnerability|architecture|migration|schema|refactor|restructure|performance|optimization|cache|latency|ui_design|ui|ux|accessibility|a11y|layout|api|endpoint|rest|graphql|contract|i18n|localization|translation|finops|cost|billing|testing|qa|e2e|unit|deploy|release|push|pr|commit|merge|tag"
    DOMAIN_KEYWORDS="${AXIARCH_TASK_DOMAIN_KEYWORDS:-${DOMAIN_KEYWORDS_DEFAULT}}"

    # Extract domains from current prompt (whole-word match, case-insensitive, dedupe, sort).
    # -w (word match) prevents "ui_design" from greedily consuming "ui" — both
    # are matched independently when present as whole words.
    CURRENT_DOMAINS=$(printf '%s' "${CURRENT_PROMPT}" \
      | grep -oiwE "(${DOMAIN_KEYWORDS})" \
      | tr '[:upper:]' '[:lower:]' \
      | sort -u | tr '\n' ',' | sed 's/,$//')

    # Extract previously-known domains from the AXIARCH current-task mandatory trio:
    #   task.md, implementation_plan.md, walkthrough.md
    # Rationale: domain context often lives in implementation_plan.md (the plan
    # written during task analysis) and walkthrough.md (the diff narrative),
    # not just task.md's load-history table. Reading only task.md misses
    # plan-side domains and produces false-positive LOAD REVIEW for tasks
    # whose plan is already consistent with the current prompt.
    # Scan strategy: full-text grep over all 3 files (each is small per-task
    # ephemeral doc), dedupe + sort.
    PREV_DOMAINS=""
    PREV_SOURCES=""
    for fname in task.md implementation_plan.md walkthrough.md; do
      [[ -n "${DOC_DIR}" ]] || continue
      fpath="${DOC_DIR}/${fname}"
      [[ -f "${fpath}" ]] || continue
      file_domains=$(grep -oiwE "(${DOMAIN_KEYWORDS})" "${fpath}" 2>/dev/null \
        | tr '[:upper:]' '[:lower:]' | sort -u)
      if [[ -n "${file_domains}" ]]; then
        PREV_DOMAINS+="${file_domains}"$'\n'
        PREV_SOURCES+="${fname} "
      fi
    done
    PREV_DOMAINS=$(printf '%s' "${PREV_DOMAINS}" | sort -u | tr '\n' ',' | sed 's/,$//')

    # Compare: domain shift detected if current ∋ keyword AND keyword ∉ previous
    if [[ -n "${CURRENT_DOMAINS}" ]]; then
      NEW_DOMAINS=""
      IFS=',' read -ra CUR_ARR <<< "${CURRENT_DOMAINS}"
      for kw in "${CUR_ARR[@]}"; do
        [[ -z "${kw}" ]] && continue
        if [[ -z "${PREV_DOMAINS}" ]] || ! printf '%s' ",${PREV_DOMAINS}," | grep -qF ",${kw},"; then
          NEW_DOMAINS+="${kw} "
        fi
      done
      NEW_DOMAINS=$(printf '%s' "${NEW_DOMAINS}" | sed 's/[[:space:]]*$//')
      if [[ -n "${NEW_DOMAINS}" ]]; then
        SCANNED_SOURCES=$(printf '%s' "${PREV_SOURCES}" | sed 's/[[:space:]]*$//')
        [[ -z "${SCANNED_SOURCES}" ]] && SCANNED_SOURCES="(none)"
        VIOLATIONS="${VIOLATIONS} [LOAD REVIEW] New prompt keywords (${NEW_DOMAINS}) are absent from recorded context (${SCANNED_SOURCES}). This is a task-scope review hint, not proof of a missing load. Load additional rules only if the actual task needs them. / 新しいキーワード (${NEW_DOMAINS}) は分類の見直し候補です。未ロードや違反の証明ではありません。実際の作業に関連する場合だけ追加ロードし、実読込した範囲を記録してください。"
      fi
    fi
  fi
fi

# -----------------------------------------------------------------------------
# v1.6.0+ Two-stage output: TTL state management
# -----------------------------------------------------------------------------
TTL_SECONDS="${AXIARCH_REMINDER_TTL_SECONDS:-1800}"  # default 30 min, 0 disables short-circuit
CACHE_ARGS=()
[[ -n "$VIOLATIONS" ]] && CACHE_ARGS=(--force-full)
USE_SHORT=$(python3 "$HOOK_HELPER" cache --project "$PROJECT_DIR" --session "$SESSION_ID" --ttl "$TTL_SECONDS" "${CACHE_ARGS[@]+"${CACHE_ARGS[@]}"}") || USE_SHORT=false

# -----------------------------------------------------------------------------
# Compose final reminder
# -----------------------------------------------------------------------------
if "${USE_SHORT}"; then
  FULL_REMINDER="${SHORT_REMINDER}"
else
  if [[ -n "${VIOLATIONS}" ]]; then
    FULL_REMINDER="${CORE_REMINDER}${VIOLATIONS}"
  else
    FULL_REMINDER="${CORE_REMINDER}"
  fi
fi
DOC_CONTEXT="${DOC_DIR:-unresolved (legacy root documents are shared references, not current session evidence)}"
FULL_REMINDER="${FULL_REMINDER} [TASK CONTEXT] docs=${DOC_CONTEXT}; goal/current-state authority: axiarch-rules/{lang}/universal/core/300_goal_and_current_state.md; executable evidence contract: axiarch-harness/{lang}/TASK_STATE_PROTOCOL.md. Structure health is not task completion or semantic proof. Domain keyword flags are review hints; do not demand irrelevant rules or user checks. / 記録先=${DOC_CONTEXT}。未解決の場合、ルート文書を現在セッションの記録として扱いません。core/300を直接参照。構造healthは完了・意味理解の証明ではありません。キーワード検知は見直し候補であり、不要なロードやユーザーへの確認を要求しません。"

# -----------------------------------------------------------------------------
# JSON-encode the reminder, including every JSON control character.
# -----------------------------------------------------------------------------
if ! printf '%s' "$FULL_REMINDER" | python3 "$HOOK_HELPER" emit --event UserPromptSubmit; then
  printf '%s\n' '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"[HOOK INPUT WARNING] Context encoding failed; state was not confirmed. / 補足の生成に失敗し、状態を確認済みとは扱えません。"}}'
fi
