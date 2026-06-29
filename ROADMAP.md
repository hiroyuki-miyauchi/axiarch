# Axiarch Roadmap

> **現在の安定版 / Current Stable**: v1.14.0 Security Authentication Stack (security 400-450)\
> **次期作業 / Next**: Read-only subagent / Deep Security Scan approval-boundary patch + Static Lint & Process Supervision（候補 / candidate）\
> **ステータス / Status**: Actively Maintained

---

## 🇯🇵 ロードマップ

このロードマップはAxiarchの開発方向性を共有するための公開文書です。\
優先度・スコープは実際の使用フィードバックと企業採用ニーズに基づいて調整されます。

---

### 🎯 戦略フォーカス — 主対象3系統への集中（2026-05-15）

- **実運用稼働確認済み主対象**: Google Antigravity・OpenAI Codex・Claude Code（いずれもドッグフーディングで稼働確認済み・全環境保証なし）
- **主対象**: OpenAI Codex / Claude Code / Google Antigravity
- **拡張互換**: Cursor / GitHub Copilot / Windsurf は、未検証のポインター補助対象として扱い、動作保証しない
- **Codex**: `.codex/hooks.json`、PostToolUse diff guard、`update_plan` 連携を持つ主対象。実運用（ドッグフーディング）で稼働確認済みだが、全環境での動作保証はしない
- **Claude Code**: hook 補強モデルとTask tools連携を持つ主対象。実運用（ドッグフーディング）で稼働確認済みだが、全環境での動作保証はしない
- **Antigravity**: agent-first IDE 時代の実運用稼働確認済み対象として、長い自律タスクにおける品質床を訴求する
- **市場戦略文書**: Axiarch 本体固有の戦略は `MARKET_STRATEGY.md` に分離し、採用先へコピーされる `axiarch-rules/{lang}/blueprint/` には混入させない

---

> **履歴注記**: v1.11.2以前の完了済みリリース項目には、当時の正本であった `AGENTS.md` や Protocol 0-9 の表記が残っています。v1.12.0以降の現行正本は `AXIARCH.md` であり、過去項目はリリース履歴として扱います。

---

### ✅ v1.15.0 — Agent Validation Status Reversal & Wording Parity Wave（2026-06-30）

- **検証ステータスの反転** — Antigravity・OpenAI Codex・Claude Code を、いずれも実運用（ドッグフーディング＝本リポジトリ自体の開発を含む）で稼働確認済みの主対象として公開表現。Antigravity を最初の実証対象、Codex・Claude Code 経由のコミット履歴を継続使用の証跡として扱う。全環境での動作保証はしない歯止めは維持。
- **保護文言の lockstep 更新** — README 日英・MARKET_STRATEGY・ROADMAP・llms.txt・llms-full.txt・rules/{ja,en}/{LOADING_PROTOCOL,README}.md・init.sh と `check-axiarch-health.sh` Check 15 を同時更新し、docs↔チェックの整合を検証可能に維持。
- **Read-only Subagent / Deep Security Scan 承認境界パッチ** — 誤停止リスク低減（Codex の「Codex Security Deep Security Scan はサブエージェント明示許可が必要」誤判定対策。ユーザーが deep audit / security scan / exhaustive review / Deep Security Scan を明示した場合、必要な読み取り専用 worker fanout はその要求に含まれる）。Human Approval Gate の非劣化（stage/commit/push/deploy/DB適用/本番変更/課金増/機微データ取得/外部 tool install/auth は明示承認対象のまま）。Fallback の正直性（委任不可時は Deep Security Scan 実行済みと主張せず通常 scan へ fallback）。再発検知（boot reminder と health Check 16 で文言劣化を検出）。
- **Loading / Blueprint wording parity** — `LOADING_PROTOCOL.md` / `INDEX.md` の 15→16 段階 stale 表記、ロード完了宣言の境界、Blueprint 事前フォルダ README の「空」表現、プロジェクト概要の過大評価表現を同期。
- **Market research wording and deletion/addition audit** — `MARKET_STRATEGY.md` と ROADMAP の市場調査節を2026-06-12時点の一次情報ベースへ更新。

---

### ✅ v1.0.0 — 初回公開リリース（2026-04-10）

- **AGENTS.md** — AI行動憲法（9プロトコル）
- **Universal Rules** — 38ファイル × 2言語（JA/EN）、2,500以上の憲法基準
- **Blueprint Templates** —
  プロジェクト固有テンプレート（フォルダ分け構造、Universal と対称化）
- **LOADING_PROTOCOL.md / CRYSTALLIZATION_PROTOCOL.md** — ルール管理プロトコル
- **Prompt Library** — 16本 × 2言語（JA/EN）の再利用可能プロンプトテンプレート
  - 役割別4フォルダ構成（`develop/`, `audit/`, `govern/`, `operate/`）
- **`init.sh`** —
  インタラクティブセットアップスクリプト（Antigravity検証済み、Codex/Claude Codeは主対象、Cursor/Copilot/Windsurfは未検証ポインター）
- **`.github/CODEOWNERS`** — ガバナンス責任範囲の明確化
- **`.github/workflows/lint.yml`** — Markdown + JA/EN対称性CI自動検証
- **`llms.txt`** — AI検索エンジン最適化（GEO）
- **`question.yml`** — Q&A用 Issue テンプレート
- **Codex / Cursor / Claude Code / Copilot / Windsurf 向けセットアップガイド** —
  README内エージェント別手順 + `init.sh` 自動化
- **AGENTS.md 起動プロトコル** — エージェント非依存の汎用 Boot Sequence Protocol
- **GitHub Discussions** の有効化 — Q&A・ユースケース共有
- **`llms-full.txt`** — AI検索エンジン向け完全仕様書（詳細版）

---

### ✅ v1.1.0 — Design & UX Strategy v3.0 / Protocol 6（2026-04-12）

- **AGENTS.md §6: Anti-Full-Overwrite Protocol** — 差分編集義務化プロトコル追加
- **`universal/{ja,en}/design/000_design_ux.md`** — 25パート完成版 v3.0
- **`.github/workflows/release.yml`** — CHANGELOG自動バージョン検出 →
  タグ・Release自動生成

---

### ✅ v1.2.0 — Universal Rules 大規模ブラッシュアップ（2026-04-29）

- **Universal Rules** — 全16ファイル × 2言語を2026 Staff
  Engineer基準に拡張（57ファイル変更、+59,500行）
- **Blueprint 構造正規化** — YAGNI原則に基づき、ドメインフォルダ README
  に結晶化プロトコル説明を追加
- **`.github/dependabot.yml`** — GitHub Actions 依存関係自動更新

---

### ✅ v1.3.0 — バイリンガル構造リアーキテクチャ（2026-04-30）

- **ディレクトリ構造の全面再編** — `axiarch-rules/universal/{lang}/` →
  `axiarch-rules/{lang}/universal/`
  へ「言語ファースト」構造に移行（156ファイル変更）
- **`CLAUDE.md`** — Claude
  Code固有のポインターファイルを新規追加（旧シムリンク方式を廃止）
- **全クロスリファレンス同期** —
  ポインター5種、プロンプト32本、CI/CD、設定ファイル等の全パス参照を更新

---

### ✅ v1.3.1 — Claude Code `@import` 統合（2026-05-03）

- **`CLAUDE.md`** — `@AGENTS.md` import 構文追加により、Claude Code 起動時に
  AGENTS.md（最上位プロトコル・9プロトコル）全文が自動 inline 注入される機構を実装
- **物理的 BOOT SEQUENCE 強制** — AI
  の自律ロード行動に依存せず、プロトコル遵守を初動から補強
- **後方互換性を維持** — 他エージェント（Cursor / Copilot / Windsurf /
  Antigravity / Codex）には影響なし

---

### ✅ v1.3.2 — Universal Engineering 600 新設 + Git Workflow Refactor + Worktree Hygiene（2026-05-03）

- **`engineering/600_git_workflow.md` 新設** — 日常的な Git 運用（Trunk-Based /
  Commit & PR / Branch Hygiene / **Worktree Hygiene Protocol** / Repository
  Hygiene）をドメイン非依存の Universal Rule として集約（5パート・18ルール）
- **`.git/config` 汚染問題（Antigravity Go ベース language server
  クラッシュ）の恒久対策** — `[extensions] worktreeConfig = true`
  残留検出・修復プロトコルを Universal に永続化
- **`axiarch-scripts/check-git-config-clean.sh` 新規配布** —
  自動検出・修復スクリプト（`--fix` / `--quiet` / `--full-clean`
  モード対応）。`init.sh` 経由で全採用プロジェクトに自動配布
- **構造正規化** — `engineering/000` Part X から pure-git workflow を 600
  へ抽出（§10.0 / §10.3 / §10.1 部分移動）
- **後方互換性を維持** — 既存採用プロジェクトは `git pull` で新ルールと script
  を取得。3シナリオ（Claude Code 単体 / Antigravity 単体 / 並行使用）全てで
  Pareto-improvement

---

### ✅ v1.4.0 — Claude Code Hook補強機構（UserPromptSubmit Hook）（2026-05-04）

- **`.claude/settings.json` 新規同梱** — Claude Code 採用プロジェクトに
  `UserPromptSubmit`
  フックを標準配置。**毎ユーザープロンプト送信時**にバイリンガル system reminder
  を注入し、AI に AGENTS.md プロトコルと LOADING_PROTOCOL の BOOT SEQUENCE
  実行を物理的に強制
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`
  に「Hook補強機構」セクション追加** —
  フック削除を「憲法改正」レベルの破壊的変更と明記
- **`CLAUDE.md` の `@AGENTS.md` import 削除** — フック経由の Read
  ロード（`view_file` 履歴付与・`task.md` 記録発火）に統一し、Anti-Laziness Rule
  との整合を確保
- **`.gitignore` 細分化** — `.claude/` 全無視を `worktrees/` / `projects/` /
  `settings.local.json` の3項目に分解。チーム共有設定 `.claude/settings.json`
  をコミット可能に
- **`init.sh` 拡張** — `SETUP_CLAUDE` 分岐で `.claude/settings.json` を配布、非
  Claude Code 選択時のみ `.claude/` 削除（既存採用者の `worktrees/` 温存）
- **後方互換性を維持** — 既存 v1.3.x
  採用プロジェクトはフック不在でも従来通り動作（自律遵守モード）

---

### ✅ v1.5.0 — Universal Rules 大規模拡充 + Hook 言語遵守強化（2026-05-06）

- **`core_mindset.md` (Rev.14)** — §1.14-§1.17（Post-Quantum / Regulatory
  Agility / Developer Wellbeing / Technology Governance）+ §1.18-§1.35（SBOM /
  AI-Native Test / Evaluation-Driven / Feature Flag / Platform Reliability /
  DevX as Product / Responsible AI / Data Architecture / API Design / Green
  Software / Incident Response / AI Regulatory / Ethical Engineering / Type
  Safety / Compositional Architecture / Inversion Thinking / YAGNI / Strong
  Opinions Weakly Held）+ §9.8-§9.11（Model Governance / Agentic Workflow
  Patterns / AI Cost Governance / Computer Use Agent Safety）を追加。総 46
  セクション
- **`engineering/510_aws_cloud.md`** — Primary Directives 0.9 Resilience & Chaos
  Engineering / 0.10 Observability-First / 0.11 Shared Responsibility &
  Compliance-by-Design / 0.12 Operational Excellence Culture を追加（合計
  0.1〜0.12）
- **`engineering/600_git_workflow.md`** — 18 ルール / 5 Part → **45 ルール / 10
  Part** へ大規模拡充。§2.6 Merge Strategy / §2.7 Force-Push Protocol / §2.8
  Commit Body & Trailers / §2.9 Fixup・Autosquash / §2.10 Conventional Commit
  Validation 追加、Part 6 Branch Protection & Code Review、Part 7
  Tags/Releases/History、Part 8 Repository Configuration & Assets、Part 9 Modern
  Tooling & Automation、Part 10 Anti-Pattern Catalog 新設
- **`product/700_appstore_compliance.md`** — 5 Part / 101 行 → **20 Part / 約
  1,099 行**（Apple Privacy Stack: ATT・Privacy Manifests・Required Reason
  API・Privacy Nutrition Labels、StoreKit 2、Sign in with Apple、Account
  Deletion 5.1.1(v)、TestFlight、Google Play AAB、Play Integrity
  API、子供向けアプリ・DMA・GenAI コンプライアンス、Specialized Verticals）
- **`product/900_fundraising_ir.md`** — 7 Part / 340 行 → **15 Part / 約 1,110
  行**（Cap Table & ESOP / SAFE・Convertible Note / Term Sheet
  数学・Anti-Dilution / FEFTA・CFIUS・MNPI・税制 / IPO 準備 / M&A Exit / Founder
  Wellbeing / Investor Tech Stack / Anti-Pattern Catalog）
- **`product/800_internationalization.md` (v6.1)** — 25 Part / 114 セクション →
  **29 Part / 133 セクション**。Part XXVI 2026 規制フロンティア（EU AI Act /
  India DPDP / Saudi PDPL / China PIPL / LATAM・アフリカ）、Part XXVII
  新興UXパラダイム（XR・Generative UI・CRDT・Shadow DOM・Foldable）、Part XXVIII
  翻訳品質フロンティア（MQM ASTM F2575・Constrained Decoding・xCOMET-22 /
  CometKiwi・Domain Adaptation・翻訳安全性分類器）、Part XXIX
  危機対応・レジリエンス を追加
- **`.claude/settings.json` フックメッセージ強化** — `UserPromptSubmit` system
  reminder に
  `Output language MUST follow Project Native Language in AGENTS.md（見出し・要約・ラベル・箇条書き・表すべて）`
  を追加。AI が日本語プロジェクトで英語見出し・要約を出すサボりを物理的に防止
- **後方互換性を維持** — Universal Rules
  拡充は既存ルール非破壊・純粋追補。フックメッセージ強化は既存採用者にも
  `git pull` で自動適用

---

### ✅ v1.5.1 — Hook 効果最大化 + 結晶化プロトコル遵守強化（2026-05-06）

- **`axiarch-scripts/check-axiarch-health.sh` 新規配布（全プロトコル監視）** —
  Axiarch 公式健全性診断ツール。**10 段階の遵守チェック** を一発実行：Hook 関連
  4 / `task.md` 遵守 / 結晶化閾値 / **§8 Process & Documentation** / **§1
  Deployment Ban** / **§4 SSOT Sync** / **§2 Language
  First**。「どこサボってるか」が一発でわかる。検証困難な §0/§3/§5/§6/§7 は Out
  of Scope として明示
- **`axiarch-scripts/README.md` 新規** — scripts/
  ディレクトリの索引兼ガイド（バイリンガル）。各診断ツールの目的・使い方・診断項目・推奨ワークフローを記載。採用先が
  `axiarch-scripts/` 配下の存在意義を即座に把握できる
- **`.claude/settings.json` フックメッセージ二重強化** — （1）`task.md`
  記録義務（AGENTS.md §8.4 準拠）追加、（2）**CRYSTALLIZATION_PROTOCOL Step 5
  THRESHOLD CHECK 遵守義務追加**。「`core/010` への追記 =
  完了は誤認」を明示し、3件以上のドメインがあれば Blueprint
  への昇華まで完了させる義務を AI に課す
- **`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md` §5 強化** — 強い CAUTION
  ブロック追加。「Step 4 (ACCUMULATE) は完了ではない」「タスク完了前に必ず Step
  5 を実行」「違反は `axiarch-scripts/check-axiarch-health.sh` Check 6
  で外部検証可能」
- **`README.md` トラブルシュート章新設（縮小版）** — Hook Reinforcement Mechanism
  サブセクション直下に `bash axiarch-scripts/check-axiarch-health.sh` への誘導 +
  公式 docs 参照
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** —
  「Hook補強機構」セクションに診断スクリプト参照を追記
- **`init.sh`** — `.claude/settings.json` 配布直後に `jq` JSON
  構文検証を追加（jq 不在時はスキップ、依存追加なし）。`axiarch-scripts/`
  既存配布ロジックで診断スクリプトも自動配布対象
- **真因確定**: AI 遵守ギャップ（フック発火 ≠ AI 遵守、結晶化「追記 =
  完了」誤認）。3 並列調査で「JSON 構造誤り説」「Bash permission
  不足説」をともに反証
- **後方互換性を維持** — `git pull` + `init.sh` 再実行 OR 手動で
  `.claude/settings.json` 上書き + `axiarch-scripts/check-axiarch-health.sh`
  をコピー

---

### ✅ v1.5.2 — Hook Output 形式変更（additionalContext / format クリーン化）（2026-05-06）

- **`.claude/settings.json` フック出力形式を変更** — `echo` (transcript 全表示)
  → `printf` で **`hookSpecificOutput.additionalContext` JSON 形式**
  に切り替え。公式 docs (code.claude.com/docs/en/hooks) 推奨の format
- **Format クリーン化** — system-reminder のラベルが
  `UserPromptSubmit hook success` から
  `UserPromptSubmit hook additional context` に変わり、より自然な形に。**ただし
  system-reminder ラップ自体は残るため「完全 invisible」ではない**（公式 "more
  discretely" は完全消去ではなく format 改善程度を意味する）
- **AI への visibility 維持** — context 直接注入で遵守は確保（v1.5.1
  のメッセージ内容を完全保持）
- **依存追加なし** — `printf` は POSIX 標準（jq 不要）。既存採用者の互換性を維持

---

### ✅ v1.5.3 — 動的違反検出 reminder + ROADMAP 整合化（2026-05-06）

- **`axiarch-scripts/axiarch-boot-reminder.sh` 新規** — フック呼び出しを inline
  `printf` から専用スクリプトに切り出し。スクリプトはプロジェクト状態（`task.md`
  ロード履歴 / `core/010` 結晶化閾値）を毎ターン動的にチェックし、違反検出時に
  reminder に **🚨 [VIOLATION-A/B]** フラグを追記する仕組み。これで AI
  は静的命令だけでなく**現在の違反状況**を毎ターン自覚できる
- **`.claude/settings.json` 簡素化** — `command` を
  `bash "${CLAUDE_PROJECT_DIR:-.}/axiarch-scripts/axiarch-boot-reminder.sh"`
  に変更。長文インライン JSON が消え、settings.json 自体がスリム化
- **依存追加なし** — JSON 出力は pure bash（`escape_json` 関数で実装、`jq`
  不要）
- **物理 block ではなく警告強化** — `decision: "block"` で prompt
  を遮断する選択肢もあったが副作用大のため採用せず、「violation
  を毎ターン認識させる」設計
- **ROADMAP の v1.5.2 記述を honest 化** — 「Plan mode
  表示汚染を解消」が過剰だったため「format クリーン化（system-reminder
  ラップ自体は残る）」に修正
- **後方互換性を維持** — `git pull` + `init.sh` 再実行 OR
  `.claude/settings.json` + `axiarch-scripts/axiarch-boot-reminder.sh`
  を手動コピー

---

### ✅ v1.5.4 — 健全性診断スクリプトの v1.5.3 互換性 patch（2026-05-06）

- **`axiarch-scripts/check-axiarch-health.sh` の Check 3/4 リグレッション修正**
  — v1.5.3 で hook command を inline →
  外出しスクリプト（`axiarch-boot-reminder.sh`）に切り出した結果、診断側の grep
  が `AXIARCH BOOT` marker を見失い、Check 3 が誤検出していた問題を解消
- **Check 3 にフォールバック分岐追加** — hook command が
  `axiarch-boot-reminder.sh` を呼ぶ場合、スクリプト本体に `AXIARCH BOOT`
  リテラルが含まれることを確認することで、inline 形式（v1.4.0–v1.5.2）と
  externalized 形式（v1.5.3+）の双方で PASS する設計に
- **Check 4 の grep pattern を拡張** — v1.5.2+ の transcript JSONL で hook
  出力ラベルが `success` → `additional context`
  に変わっていたため、`grep -cE "UserPromptSubmit hook (success|additional context)"`
  で両方マッチするよう修正
- **バージョン記述ポリシー違反を 17 ラウンド調査で発見・訂正** —
  `axiarch-scripts/axiarch-boot-reminder.sh` のコメントと
  `axiarch-scripts/check-axiarch-health.sh` の `print_info` ランタイム出力から
  `v1.5.x` literal を除去（汎用ファイルは version-free 厳守）
- **`README.md` 必須ファイル表に `axiarch-boot-reminder.sh` を追記** — v1.5.3
  新規スクリプトの言及漏れ訂正
- **`core/010_project_lessons_log.md` (ja/en) は Initial entry のみに restore**
  — axiarch は OSS template のため、axiarch 開発者側で得た lesson
  は本ファイルに残さず CHANGELOG / ROADMAP / commit body に記録する方針。v1.5.4
  中間 commit で誤って開発側 lesson を結晶化した記述があったため訂正
- **18 ラウンド調査で Check 3 else 分岐の false-negative bug 発見・修正** — hook
  command が `AXIARCH BOOT` literal も `axiarch-boot-reminder.sh`
  文字列も含まない（hook 完全破損）状態で `EXIT_CODE=1` 未設定だった致命的 bug
  を修正。CI 連携で「hook 壊れているのに exit 0」を返す問題を解消
- **後方互換性を維持** — pure bash
  修正のみ。依存追加なし。`bash axiarch-scripts/check-axiarch-health.sh`
  再実行で Check 3/4 が PASS することを確認可能
- **設計反省** — hook の format 変更を伴う patch では診断スクリプトの grep
  対象も同時更新する責務を見落とした。今後は format 変更と diagnostic update
  をセットでリリースする運用に切り替え（→ axiarch 本体の `core/010` には残さず
  CHANGELOG / commit body に記録、CONTRIBUTING.md Maintainer Guide で再発防止）

---

### ✅ v1.5.5 — Physical Block + Tone Refactor + SessionStart Bootstrap（2026-05-07）

26 ラウンド徹底市場調査（4 並列 Agent: AI compliance frameworks / 競合 AI ツール
/ Claude Code 公式機能 / 学術 2024-2026）の統合分析を踏まえ、**「Reminder →
Physical Block」パラダイムシフト**を実装。

- **`axiarch-scripts/axiarch-protect-antifull.sh` 新規** — PreToolUse hook で
  `Write` tool を傍受、既存ファイル対象なら `decision:"block"` JSON + exit 2
  で**物理遮断**。§6 ANTI-FULL-OVERWRITE 違反リスクを低減
- **`axiarch-scripts/axiarch-init-task-md.sh` 新規** — SessionStart hook
  で会話開始時に task.md 自動ブートストラップ（不在時は load-history scaffold
  生成）
- **`axiarch-scripts/axiarch-boot-reminder.sh` トーンリファクタ** —
  `🚨【厳守命令】` `No skipping` 等の CAPS /
  命令調を排し、`This project enforces axiarch governance`
  の事実陳述に統一。Anthropic 公式 + Robert Glaser「Prompts as Programs in
  GPT-5」に基づく最適化。9 protocols 反復構造は arXiv:2512.14982 の根拠で維持
- **`axiarch-scripts/check-axiarch-health.sh` Check 11/12 追加** — 12
  段階診断に拡張（PreToolUse / SessionStart 配線確認）
- **`.claude/settings.json` に 3 hook 配線** — SessionStart / UserPromptSubmit /
  PreToolUse(Write matcher)
- **`.claude/axiarch-overwrite-allow.txt` whitelist サポート** — 自動生成
  artefact 等の正当な full-overwrite に escape hatch
- **`CONTRIBUTING.md` に Maintainer Guide 追記** — 「lessons_log は Initial
  のみ保持」「採用先で削除推奨ファイル」「placeholder 形式を保つ template」を
  ja/en 対称的に明文化、再発防止
- **学術裏付け**: arXiv:2503.18666 (AgentSpec ICSE'26 — 90%+ 阻止) /
  arXiv:2502.15851 (Control Illusion — instruction-hierarchy 失敗の構造的回避) /
  arXiv:2310.01798 (Huang — single-LLM self-correct 不可、external verifier
  必須)
- **後方互換性を維持** — 既存 UserPromptSubmit hook 維持、新 hook
  追加のみ、依存追加なし（pure bash）

---

### ✅ v1.6.0 — Reminder TTL + 時間軸結晶化 + Pre-commit Installer + Session 跨ぎ基準 + APPEND ガイド（2026-05-08）

採用先プロジェクトの実運用フィードバック「ガバナンス機能評価レポート」で抽出された
5 項目を minor release として bundling。「設計 vs 現実」の乖離（context budget /
token cost / 既存 sublimated file 認識率 / stale lesson 放置）を構造的に解消。

- **`axiarch-scripts/axiarch-boot-reminder.sh` Two-Stage Output (TTL)** — 初回
  fire = full reminder + timestamp 記録、TTL 内（default 30 分）かつ違反なしなら
  `[AXIARCH REMINDER]` short-circuit、違反検出時は強制
  full。`AXIARCH_REMINDER_TTL_SECONDS=0` で disable。**長時間 session で token
  約 87% 削減**（24k → 3k）
- **Check C — Stale Lesson Detection** — `core/010` の `[YYYY-MM-DD]` 日付が 180
  日以上経過した lesson を `🚨 [VIOLATION-C]`
  として検出。`AXIARCH_LESSON_STALE_DAYS` で閾値調整可
- **`check-axiarch-health.sh` Check 6 拡張 — CRYSTAL §5 Time-Axis Trigger** —
  既存の count threshold (3+ per domain, trigger (a)) に **time-axis trigger
  (b)** 追加。stale lesson の長期放置を防止
- **`check-axiarch-health.sh` Check 13 — Sublimated Files Index** — 既存の
  `blueprint/{domain}/{NNN}_{topic}.md` を一覧表示、AI が **APPEND**
  を選択しやすくする。「12 連続 N/A」フィードバックの根治
- **`check-axiarch-health.sh --quiet` flag** — pre-commit / CI 用 silent mode
- **`init.sh` Pre-commit Hook Installer (opt-in)** — STEP 3.5
  で質問、`.git/hooks/pre-commit` への
  append/create、lefthook/pre-commit-framework/husky 検出時は warn
  のみ。`AXIARCH_PRECOMMIT_SKIP=1` で per-commit bypass
- **`CRYSTALLIZATION_PROTOCOL.md` (ja/en) Step 5** — Dual-trigger table
  化（count + time-axis）、time-axis trigger の意義を明文化
- **`LOADING_PROTOCOL.md` (ja/en) Step 4** — 「Cross-Session Re-load
  Criteria」セクション追加。「全文 load = サボり禁止」と「context budget
  の現実」のトレードオフを 4 状況別に明示的解消、`task.md` 履歴を SSOT
  として参照
- **学術裏付け**: Memory in LLMs serial-position effects / Constitutional AI
  系譜 / Anthropic「reminder less is more」公式ガイダンス
- **後方互換性を維持** — TTL/Check C/pre-commit installer すべて opt-in or env
  var 制御、既存環境破壊なし

---

### ✅ v1.7.0 — Task Boundary Detection + Claude Code 検証ログ拡充（2026-05-08, **独立 release せず v1.8.0 に統合**）

> **注記**: v1.7.0 は内部開発のみ。独立した Git tag は存在せず、全 feature は
> v1.8.0 の BREAKING `scripts/` → `axiarch-scripts/` rename と同時に統合 release
> された。開発履歴は git log（commits 770150b / f60ced8 / c6aee62 / eddeb01 /
> 69c44b8 / 8d94938）を参照。

- **`axiarch-scripts/axiarch-boot-reminder.sh` Check D 追加** — UserPromptSubmit
  hook stdin から現プロンプト JSON を読み、domain keyword（security /
  architecture / ui_design / api / performance / push / commit / migration
  等）を **whole-word match** (`grep -oiwE`) で抽出。**AGENTS §8.4 必須トリオ全
  3 ファイル**（task.md / implementation_plan.md / walkthrough.md）を full-text
  grep して既存 domain context と比較。新 keyword 検出時に `🚨 [VIOLATION-D]`
  flag + TTL 強制 bypass
- **`check-axiarch-health.sh` Check 14 追加** — Check D wiring 確認（13 段階 →
  14 段階）
- **`LOADING_PROTOCOL.md` (ja/en) Step 4 update** — Cross-Session Re-load
  Criteria に Check D 補足追加
- **Claude Code 検証ログ拡充** — axiarch 自身の開発サイクルで hook 補強モデルの検証材料を蓄積
- **後方互換性を維持** — `AXIARCH_TASK_BOUNDARY_DETECT=0` で disable 可

---

### ✅ v1.8.0 — BREAKING `scripts/` → `axiarch-scripts/` rename + Check D Task Boundary Detection + Claude Code 検証ログ拡充（2026-05-10）

採用先実運用で判明した「同一 session 内でも実際タスクは異なるのに、AI
が『session 継続中だから rule 再 load 不要』と判断してサボる」confirmation bias
loophole のリスクを下げるための hot-fix。

- **`axiarch-scripts/axiarch-boot-reminder.sh` Check D 追加** — UserPromptSubmit
  hook の stdin から現プロンプトを読み、**whole-word match** (`grep -oiwE`) で
  domain keyword を抽出、**AGENTS §8.4 必須トリオ全 3 ファイル**（task.md /
  implementation_plan.md / walkthrough.md）を full-text grep して比較。プラン側
  / walkthrough 側に書かれた domain context も漏れなく捕捉。新 keyword 検出時に
  `🚨 [VIOLATION-D]` flag + TTL 強制 bypass で full reminder 再発火
- **AI 自己判断ループホールを機械的にバックアップ** — v1.6.0 LOADING_PROTOCOL
  §4「タスクタイプ不変」条項の判定を AI に任せていた問題を、hook
  側で検出補助する設計に転換
- **`axiarch-scripts/check-axiarch-health.sh` Check 14 追加** — Check D の
  wiring 確認（13 段階 → 14 段階）
- **環境変数**: `AXIARCH_TASK_BOUNDARY_DETECT=0` で disable /
  `AXIARCH_TASK_DOMAIN_KEYWORDS` で keyword 集合 override
- **`LOADING_PROTOCOL.md` (ja/en) Step 4 update** — Cross-Session Re-load
  Criteria に Check D 補足、「v1.8.0 改善」セクションで loophole
  軽減メカニズム明文化
- **後方互換性を維持** — `AXIARCH_TASK_BOUNDARY_DETECT=0` で v1.6.0
  動作完全再現、stdin 不在時は自動 skip
- **Claude Code 検証ログ拡充** — axiarch 自身の開発サイクル（v1.4.0+ の hook 統合以降）で hook 補強モデルの検証材料を蓄積。v1.8.0時点の公開ステータスでは Antigravity のみを実務検証済みとし、Claude Code は主対象として扱った

---

### ✅ v1.8.1 — Check 4 Codex 互換性 + Check 13 quiet mode バグ修正 + ドキュメント訂正（2026-05-11）

41〜42 ラウンド調査で発見した 2 件のバグ修正 + 3 件のドキュメント訂正 patch。

- **`axiarch-scripts/check-axiarch-health.sh` Check 4 Codex ランタイム検出** —
  OpenAI Codex 環境（`CODEX_THREAD_ID` / `CODEX_CI` 環境変数）では Claude Code
  セッションログが存在しないため false-negative `[FAIL] Hook never fired`
  を返していた bug を修正。Codex 検出時は
  `[PASS] Codex runtime detected — not applicable` を返す
- **Check 13 `--quiet` モード verbose 出力バグ修正** — `--quiet` / `-q`
  フラグ指定時も `printf` と `print_info` 2 行がターミナルに出力されていた bug
  を修正（`if ! "${QUIET_MODE}"; then` で正しく抑制）。CI / pre-commit
  連携の不要出力を解消
- **`axiarch-scripts/README.md` JA overview + stage 数訂正 (42 ラウンド)** —
  日本語 overview の「8 領域」を「10 領域以上」に修正（v1.5.1
  時点の古い記述のままだった）；英語 overview 文の「One-shot 13-stage
  check」を「One-shot 14-stage check」に修正（v1.8.0 で Check 14
  追加済みだったが更新漏れ）；v1.8.0 Check D の言及を追加
- **`CHANGELOG.md` v1.6.0 Out of Scope バージョンラベル訂正 (42 ラウンド)** —
  `(Check 14)` → `(Check 15)`；`v1.7.0 (Tier 2)` →
  `v1.9.0 (Tier 2)`；当時の暫定整理として古い Tier 3 ラベルを次期候補枠へ修正。
  後続の採用先アップグレード課題により、現在の v1.10.0 は Safe Upgrade Wizard
  に再配分し、Static Lint は v1.11.0 へ移動
- **後方互換性を維持** — pure bug fix のみ、機能変更ゼロ。Codex
  以外の環境では挙動変化なし

---

### ✅ v1.8.2 — Native Codex Environment Integration（2026-05-12）

- **`init.sh`**: `.codex/hooks.json` の自動初期化・検証・クリーンアップ機構を追加
- **Diagnostic / Script Support**: `check-axiarch-health.sh`, `check-git-config-clean.sh`, `axiarch-protect-antifull.sh` 等のインフラ全体で `.codex/hooks.json` と関連ホワイトリストを第一級サポート
- **Documentation**: `LOADING_PROTOCOL.md` 等の憲法レベルのフック配線規定に Codex を明記

---

### ✅ v1.9.0 — Memory Persistence & Glob-Scoped Rules（2026-05-15）

26 ラウンド市場調査（v1.5.5 release notes 参照）で抽出された Tier 2
改善案。v1.6.0 で別軸（採用先フィードバックの 5 項目）を先行実装、v1.8.0 で
confirmation-bias loophole の hot-fix + BREAKING `scripts/` → `axiarch-scripts/`
rename を統合したため、本 Tier 2 群を v1.9.0 にずらして整理。

- **実装済み: `PostToolUse` hook + git diff 検証** — Edit 後に diff line count
  を測定、閾値超過時に warn / block。PreToolUse の safety net（v1.5.5 では
  `Write` のみ block、`Edit` による潜在的に大規模な変更は post-hoc で検出）
- **実装済み: Cursor `globs:` パターン採用 + path-scoped rules** —
  `.cursor/rules/axiarch.mdc` に `globs: "**/*"` を明示し、
  `axiarch-rules/{lang}/universal/{domain}/` の `paths:` frontmatter
  仕様候補を README に追加。Universal本文への一括付与は検証後に実施
- **実装済み: Memory Persistence 強化** — Windsurf Cascade Memories / Codeium Memories
  の考え方を参考に、`.claude/memory/MEMORY.md`
  を任意テンプレートとして追加。会話全文や秘密情報は保存せず、実際に起きた再発防止事項だけを短く残す補助層として扱う
- **Aider 流 prompt cache 最適化** — `axiarch-rules/{lang}/universal/`
  を「読み取り専用」として宣言し Anthropic prompt caching API の `cache_control`
  対象とする hook 改修。毎ターン全文注入のコスト課題解決（v1.6.0 reminder TTL
  と相補）
- **実装済み: shellcheck CI 統合** — `axiarch-scripts/*.sh` の静的解析を `lint.yml`
  に追加（v1.5.4 deferred）
- **実装済み: `init.sh` 配布後の syntax 検証** —
  `axiarch-{boot-reminder,protect-antifull,init-task-md,check-axiarch-health}.sh`
  を `bash -n` で配布後検証（`.claude/settings.json` の `jq` 検証と対称化）
- ~~**Universal Rules フッター整理** — `**Last Updated**: 2026-05-06 (v1.5.0)`
  形式から version literal を除去~~ → **v1.8.0 で先行実施完了**（commit
  `08c6ecf`、8 files cleanup）
- **HealthCheck Workflow** — リポジトリ状態自動診断（Blueprint未入力、Lessons
  log 蓄積超過等の検知）
- **実装済み: Post-release README integration 自動検証 (Check 15)** — 24/27/28 ラウンド +
  v1.6.0/v1.7.0 で繰り返し発生した「新リリース feature → ancillary doc
  反映漏れ」を機械検出。`axiarch-scripts/check-axiarch-health.sh` に README /
  scripts/README の v1.9.0 diff guard / memory / 15-stage 反映確認を追加

---

### ✅ v1.10.0 — Safe Upgrade Wizard & Manifest-Based Upgrades（2026-05-17）

既存採用プロジェクトで「必要なAxiarch更新だけを取り込む」ための安全アップグレード導線。Universal、protocol、scriptsは更新しやすくしつつ、プロジェクト固有Blueprintは既定保持し、怪しい差分は人間が選択できる状態にする。

- **`axiarch-manifest.json`** — Axiarch所有ファイル、Axiarch共有Blueprint、プロジェクト固有Blueprint、任意ファイル、本体リポジトリ専用ファイルを分別する所有境界マニフェスト
- **`axiarch-scripts/axiarch-upgrade.sh`** — `--dry-run` / `--safe-only` / `--interactive` / `--apply` に対応したローカルファーストなアップグレード補助
- **グループ単位の対話選択** — `preserve（保持・上書きしない）`、`show-diff（差分だけ表示）`、`update-all（すべて更新）`、`review-each（ファイルごとに確認）`、`skip（今回はスキップ）`。本体リポジトリ専用ファイルは既定skipのまま、明示選択時のみ確認・適用候補にする
- **プロジェクト固有状態の既定保持** — `blueprint/core/000_project_overview.md`、`blueprint/core/010_project_lessons_log.md`、`blueprint/*/[0-9][0-9][0-9]_*.md` は既定で上書きしない
- **アップグレード証跡** — 反映時に `.axiarch/version.json`、`.axiarch/upgrade-report.md`、`.axiarch/files.sha256` を作成
- **`axiarch-prompts/{ja,en}/develop/safe_upgrade_execute.md`** — AIエージェントにSafe Upgrade Wizardを実行させ、source-only既定skipと明示選択まで扱うための専用promptを追加

---

### ✅ v1.11.0 — Native Task State Sync & Process Document Lifecycle（2026-05-18）

Claude Code / Codex の長期セッションで `task.md` / `implementation_plan.md` / `walkthrough.md` が古い内容を蓄積し続ける問題と、Markdown証跡がネイティブタスク・プランUIへ自動反映されるという誤認を分離して解消。

- **`axiarch-scripts/axiarch-task-state.sh`** — 3つの現在タスク文書をarchive-before-refreshで管理し、過去内容を `.axiarch/process-doc-history/` へ退避
- **Project Native Languageテンプレート** — `AXIARCH_PROCESS_DOC_LANG=auto|ja|en` により、`AGENTS.md` の `Project Native Language` に合わせて日本語/英語テンプレートを分離生成
- **SessionStart強化** — `axiarch-init-task-md.sh` が `task.md` 単体ではなく、`task.md` / `implementation_plan.md` / `walkthrough.md` を現在タスク用にbootstrap
- **ネイティブ状態同期** — Codexでは `update_plan`、Claude Codeでは `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` を併用する責務を明文化。`TodoWrite` は古いランタイム向けfallbackとして扱う
- **後方互換** — `AXIARCH_PROCESS_DOC_MODE=append` により、従来の追記運用を必要とする採用先も維持可能
- **Health再発検知** — Check 12/15でtask-state script、native state wording、version metadata、docs parityを検査

---

### ✅ v1.11.1 — Hybrid Autonomous Boot Sequence for Safe Upgrade（2026-06-02）

`safe_upgrade_execute.md` のアップグレード実行プロンプトを、user が 5 項目を手動入力する旧 Stop & Wait から、AI が context から自律推定して進める Hybrid モードへ改善。

- **Boot Sequence 6 Step 化** — Phase 0 即 context load → Phase 1 自動推定（version / agent / lang / mode）→ 推定結果提示 + dry-run 承認（安全フェンス 1）→ dry-run 自律実行 → 結果提示 + apply 承認（安全フェンス 2）→ apply 自律実行
- **安全境界の明文化** — apply / `--with-prompts` / mixed ownership 書込 / `git push` 等は明示承認必須。Phase 0/1/3 dry-run と health check は自律 OK
- **Edge Cases** — 同 version スキップ / 複数版跨ぎ警告 / baseline 不在 / 複数 agent 検出 / release 取得失敗
- **後方互換** — 旧 Stop & Wait は user 明示時の fallback として残存。Wizard 本体ロジック不変、prompt 文言のみの改善
- **実証元** — 採用先 chronoviq の Safe Upgrade Wizard 経由 v1.11.0 自律適用成功事例を規格化（PR #43）

---

### ✅ v1.11.2 — Multi-Agent Detection Fix for Safe Upgrade（2026-06-03）

`safe_upgrade_execute.md` の agent auto-detection が Antigravity を誤った path（`.antigravity/`）で検出していた不具合と、併用プロジェクトでの単一 agent 選択による hook 取り残しを修正。

- **Antigravity 検出修正** — `.antigravity/`（非生成 path）→ `init.sh` 生成の `.agents/rules/prompt_pointer.md` に修正。codex も `.codex/`→`.codex/hooks.json` に統一し 3 agent の検出粒度を揃えた
- **マルチエージェント設計** — 3 代表ファイルを全確認して存在 agent を全列挙。1 つ→その agent / 2 つ以上（併用、例: inucomi = codex+claude+antigravity）→`--agent all`（単一指定は他 agent の hook を計画から落として stale 化させるため）
- **安全性実証** — `--safe-only` 下では未使用 agent（cursor/copilot/windsurf）の pointer は `add` 状態でも書込されない（`path_status` + `execute_item` で確認）
- **後方互換** — 単一 agent 採用先は挙動不変、Wizard 本体ロジック不変、prompt 文言のみ
- **実証元** — inucomi（codex+claude+antigravity 併用）での Antigravity 検出漏れ報告

---

### ✅ v1.12.0 — AXIARCH Canonical Entrypoint & Execution Harness / Harness Engineering（2026-06-08）

- **`AXIARCH.md` 正本化** — `AGENTS.md` をCodex専用でも単独正本でもなく、AGENTS標準を読む環境向けの薄いアダプターとして整理。Claude Code、Antigravity、Cursor、Copilot、Windsurfの各入口も `AXIARCH.md` だけを指す。
- **ハーネスエンジニアリング導入** — Execution Harnessを第4ルール層ではなく、Universal / Blueprint / Promptsの3層を実行順序、監査Verdict、役割パス、証跡、人間承認、サブエージェント委任へ接続する運用工学として明文化。
- **Execution Harness** — 実行、監査、役割パス、証跡、人間承認、サブエージェント委任を `axiarch-harness/{ja,en}/` に分離。サブエージェントがない環境ではメインエージェントが順番に同じパスを実行する。
- **既存価値の維持** — Universal / Blueprint / Prompts、Crystallization、Native Language、Safe Upgrade、Hook補強、現在タスク文書ローテーションを壊さず、正本入口だけを明確化する。
- **後続候補** — Static Lint & Process Supervision は本正本化後の候補として継続検討する。

---

### ✅ v1.12.1 — Harness Engineering Release Parity Patch（2026-06-08）

- **版数保護** — 既存の `v1.12.0` タグを上書きせず、タグ後のHarness Engineering追修をパッチ版として整理。
- **実行プロトコル補強** — `EXECUTION_HARNESS_PROTOCOL.md` のja/en本文に、ハーネスエンジニアリングが第4層ではなく3層モデルを実行順序、監査、証跡、人間承認へ接続する手順であることを明記。
- **Safe Upgrade整合** — manifestを読めないfallbackでも `Execution Harness / Harness Engineering` のグループ表示を維持し、一時helper取得例とupgrade helper usage例も `v1.12.1` へ揃える。
- **再発検知** — `check-axiarch-health.sh` が実行プロトコル本文、Safe Upgrade fallback label、current release helper pin、upgrade helper usage例を検査。
- **配布メタデータ整合** — installer、manifest、README、llms、Safe Upgrade prompts、Blueprint INDEXの現在安定版を `v1.12.1` へ更新。

---

### ✅ v1.13.0 — Prompt Slash Commands for Claude Code（2026-06-08）

`axiarch-prompts/` がコピペ運用のみで `/` に出ない摩擦を解消し、プロンプトを Claude Code native slash command として first-class 化。市場調査フォーキャスト賭け #2（AGENTS.md 標準との関係明文化）は #49 で実装済、本リリースで slash-command 基盤を提供し、賭け #1（SKILL.md 移行）の前提を整える。

- **`axiarch-scripts/axiarch-prompts-install.sh`** — prompts から `.claude/commands/axiarch-<name>.md`（`/axiarch-<name>`）を生成。正本プロンプトを Read+実行する thin pointer（single source of truth）。冪等・bilingual（`--lang ja|en|auto`）・`--clean`/`--dry-run`・pure bash
- **init.sh opt-in** — プロンプトコピー かつ Claude Code 選択時のみ slash command 生成を質問・実行
- **エージェント別の正直な対応** — Claude Code のみ native 生成。Codex（custom prompts は global-only・deprecated）/ Antigravity（workflow project-file 規約未文書化）はコピペ/AGENTS 運用
- **生成物は artifact 扱い** — `.claude/commands/axiarch-*.md` を gitignore、generator を source of truth とする

---

### ✅ v1.13.1 — Restore Language First Enforcement（2026-06-08）

「指定言語（日本語）対応が弱くなった」という採用先報告を調査し、#46 正本化で旧 §2 Language First の AI 応答面への強制力が希薄化していた regression を修正。

- **AXIARCH.md §6.10** — Language invariant を「応答 + 文書」へ強化。AI のユーザー応答の全見出し・要約・ラベル・箇条書き・表に Project Native Language を強制、日本語時の英語見出し等を違反と明記、code/API/log/path は例外
- **boot-reminder（言語条項）** — 毎ターン発火の言語条項を同趣旨で強化し、正本と一致
- **boot-reminder（Harness 喚起）** — reminder が §8 で「非自明な作業に必須」とされる Execution Harness を一度も言及していなかった gap を解消。CORE/SHORT 双方に L2+ でハーネス（ロールパス・監査判定・証跡パケット・人間承認ゲート）を適用するトリガーを追加（ja/en）
- **EXECUTION_HARNESS_PROTOCOL（正本根拠）** — 「非自明（§8）= L2 以上」の対応をハーネス層に明記し、reminder の「L2+」表現に SSOT 根拠を付与
- **health Check 16** — reminder が言語違反条項と Harness 喚起を ja/en 両方で含むことを検査し、将来の silent な削除/劣化を検出（#46 型 regression の再発防止）
- **根拠** — §6.10 非劣化原則（旧来より厳しいルールは保持）に基づく復元
- 独立 patch（v1.14.0 skills とは別ブランチ）

---

### ✅ v1.14.0 — Security Authentication Stack（2026-06-09）

高セキュリティ認証〜認可〜MCP セキュリティの Universal Rules を 6 ファイル新設（Universal ルール 39→45）。市場調査（一次情報・最新標準）と敵対的レビューを反映。

- **security/400** パスキー・MFA / **410** OAuth・OIDC連携・SSO / **420** ステップアップ・OTP・重要操作 / **430** 認可（ReBAC/Zanzibar・Cedar/OPA）/ **440** 非人間・ワークロード・AIエージェントID（SPIFFE・OBO・MCP/XAA）/ **450** MCPセキュリティ（使う側+作る側、token passthrough禁止・rug pull検知等）
- **000 de-dup** — §4/§18.3 に深掘りファイルへのクロスリファレンス
- **フレームワーク文言是正（#52）** — 断言/誇張の是正・en側の一般化・採番/ロード仕様の明確化
- **整合** — INDEX(ja/en)・README ドメイン表・llms ダイジェスト・件数（39→45）を同期
- **正確性** — OAuth 2.1=ドラフト・RFC 9700 基準、WebAuthn L3=CR、MCP=新興として正確表記
- PR #52 / #53 を集約

---

### 🔬 市場調査ベース戦略ロードマップ（2026-06-12追補、優先度順）

AGENTS.md 標準、OpenAI Codex、Claude Code Skills・Subagents・Hooks、GitHub Copilot / VS Code custom instructions、Kiro / GitHub Spec Kit、MCP authorization、OWASP agentic security、agentic coding tool configuration研究を確認したうえでの戦略フォーキャスト。各賭けは**製品方向を変える憲法級変更**を含むため、確認済み事実と戦略仮説を分け、慎重な独立リリースで段階実行する。

| 優先 | 賭け | 狙い（業界整合） | リスク | 想定リリース |
|:--|:--|:--|:--|:--|
| 1 | **Agent Skills (SKILL.md) 任意パッケージ化** | prompts を `SKILL.md`（metadata + progressive disclosure + supporting files）でも配布できる形にする。Claude Codeではsupporting filesが必要な場合にSkillsが推奨されるため、slash-commandの置換ではなく任意の上位配布形として検討 | 中（v1.13.0 slash-command の発展形。先行マージ後に着手）| v1.13.0 マージ後 |
| 2 | **AGENTS.md 標準との関係明文化** | AGENTS.md は Linux Foundation 傘下標準・60,000+ 採用・nearest-file override が中核。「なぜ AXIARCH.md 正本か」「標準とどう相互運用するか」を README で明示し新規採用摩擦を解消 | 低（doc 追記）| 即時〜近リリース |
| 3 | **結晶化 v2（検証 + 剪定/重要度）** | 採用前検証ループ・教訓の重要度付け・剪定・矛盾解消を CRYSTALLIZATION_PROTOCOL に追加。Context Files が広く使われる一方でSkills/Subagents採用は浅いという研究動向を踏まえ、Blueprint が受動的な知識置き場に劣化するリスクを下げる | 中（protocol 拡張）| 近-中期 |
| 4 | **adapter 鮮度追従** | `.windsurfrules`（レガシー単一）→ `.windsurf/rules/*.md`（新標準）併存、Cline の AGENTS.md ネイティブ対応等。init.sh の adapter 保守方針を文書化 | 低-中（配布ロジック）| 近期 |
| 5 | **AXIARCH.md progressive disclosure** | 516行の正本を「短いコア憲章 + オンデマンド詳細プロトコル」に分割し毎ターン全文ロードの文脈コストを削減。AGENTS.md nearest-file、Claude Skills progressive disclosure、VS Code path-specific instructionsなどの最小ロード設計と整合させる | **高**（正本大改修＝憲法改正級。health check・safe-upgrade・全アダプター・bilingual 整合を同時検証。十分な実機テスト必須）| 専用メジャー（v1.14/v2.0） |

> **市場内の位置づけ（調査結論）**: 調査範囲では、Axiarch の「3層 + ハーネス + 人間承認ゲート + 教訓結晶化」を同じ粒度で束ねるOSSは確認できていない。ただし、spec-driven dev（Kiro / Spec Kit）やAGENTS.md標準、Skills/Subagents、MCP securityとは重なる領域があるため、Axiarch はそれらを置き換えるのではなく、ファイルベースの正本、証跡、承認境界、教訓昇華で補完する位置づけにする。最大の構造的論点は「全文先読み vs 必要時注入」（賭け #5 で対処）と「単一正本 vs AGENTS.md ネスト標準」（賭け #2 で関係明文化）。

---

### 🔮 v1.13.0以降 — Static Lint & Process Supervision（Tier 3、検討中）

学術裏付けが強く工数も大きい改善案を、AXIARCH正本入口とExecution Harnessの後続候補として独立計画。

- **`axiarch-doctor` CI lint 機構（npx 配布）** — Cursor の `cursor-doctor` /
  `cursor-lint-action` 模倣。frontmatter 検証 / Universal vs Blueprint 責務違反
  / `compliance_matrix.md` 同期 を PR 時に強制チェック（出典:
  <https://github.com/nedcodes-ok/cursor-lint-action>）
- **IFEval 風自動回帰スイート** — `tests/ifeval/` に「task.md
  記録義務」「core/010 結晶化閾値」を verifiable instruction 化、PR ごとに
  Claude API で実走 → pass/fail 判定。reliable@k 評価で「言い換えに弱い
  rule」を検出（出典: arXiv:2311.07911 / arXiv:2512.14754）
- **Deliberative Alignment 模倣 — Harness Gate Recall 強制** — 高リスク tool
  実行前に「AXIARCH.md と該当 harness gate のうち今回関係するものを列挙し、各々への適合理由を 1
  行ずつ書け」reasoning step を必須化。OpenAI o3 で safety 違反 13%→0.4%
  を達成（出典: arXiv:2412.16339）
- **AI Agent Compatibility Matrix** — 主対象（Codex / Claude Code /
  Antigravity）と拡張互換（Cursor / GitHub Copilot / Windsurf /
  Aider / Zed 等）を分け、検証日・検証範囲・hook 対応範囲を定期更新するメタ仕様

---

### 🔮 v2.0.0 — AgentSpec DSL & Constitutional AI 系譜（戦略、長期）

- **AgentSpec 型 DSL 導入** — `axiarch-rules/policies/*.spec` で trigger +
  predicate + enforcement を宣言的記述。ICSE'26 (arXiv:2503.18666)
  で「コードエージェント不正実行 90%+ 阻止」実証された手法を OSS 化。axiarch を
  Anthropic Constitutional AI 系譜の OSS 実装として再定義（出典:
  arXiv:2503.18666 / Constitutional AI Bai et al. 2022 / C3AI WWW'25）
- **Multi-Agent Verification** — 重要 commit 前に Architect role / Auditor role
  の 2 sub-agent で相互検証（出典: arXiv:2305.14325 / arXiv:2510.12697）
- **Axiarch CLI** — `npx axiarch-init` による自動セットアップ
- **コミュニティ貢献プロンプト** — ユーザー投稿プロンプトの審査・統合フロー
- **`decision: "block"` 一般化** — v1.5.5 で `Write` matcher を block
  しているが、Bash / Edit にも段階的拡張（whitelist 駆動）

---

### 💡 検討中 / Future Ideas

以下は将来的に検討しているアイデアです。優先度は未確定です。

- **マルチリポジトリ対応** — モノレポ構成での Axiarch 管理
- **Axiarch Web UI** — ルールの閲覧・検索・進捗管理のためのダッシュボード
- **GitHub App** — PR時にAxiarch準拠チェックを自動実行

---

### フィードバック・要望

ロードマップへの意見・優先度に関するフィードバックは Issue にてお寄せください:

👉
[github.com/hiroyuki-miyauchi/axiarch/issues](https://github.com/hiroyuki-miyauchi/axiarch/issues)

---

## 🇺🇸 Roadmap

This roadmap is a public document sharing the direction of Axiarch's
development.\
Priorities and scope will be adjusted based on actual usage feedback and
enterprise adoption needs.

---

### 🎯 Strategic Focus — Concentrate on Three Primary Agents (2026-05-15)

- **Production-validated primary targets**: Google Antigravity, OpenAI Codex, and Claude Code are all validated through real operational use (dogfooding), with no operation guarantee for every environment
- **Primary targets**: OpenAI Codex / Claude Code / Google Antigravity
- **Extended compatibility**: Cursor / GitHub Copilot / Windsurf are unverified pointer-only auxiliary targets with no operation guarantee
- **Codex**: Primary target with `.codex/hooks.json`, PostToolUse diff guard, and `update_plan` integration; validated through real operational use (dogfooding), with no operation guarantee for every environment
- **Claude Code**: Primary target with the hook-reinforcement model and Task tools integration; validated through real operational use (dogfooding), with no operation guarantee for every environment
- **Antigravity**: Production-validated agent-first IDE target; the clearest platform for explaining Axiarch as a quality floor for long-running autonomous work
- **Market strategy document**: Axiarch-specific strategy lives in `MARKET_STRATEGY.md`, not in adopter-facing `axiarch-rules/{lang}/blueprint/`

---

> **Historical note**: Completed release entries for v1.11.2 and earlier may still mention `AGENTS.md` and Protocol 0-9 because those were the canonical labels at the time. From v1.12.0 onward, the active source of truth is `AXIARCH.md`; older entries are release history.

---

### 🚧 v1.14.1 Candidate — Read-only Subagent / Deep Security Scan Approval-Boundary Patch

- **False-block risk reduction** — Make it less likely that Codex stops with "formal Codex Security Deep Security Scan requires explicit subagent permission." When the user explicitly asks for deep audit, security scan, exhaustive review, or Deep Security Scan, the required read-only worker fanout is included in that request.
- **No Human Approval Gate regression** — stage, commit, push, deploy, DB apply, production data mutation, increased billing, sensitive-data retrieval, and external tool install/auth remain approval-required. Only the false block on read-only delegation is relaxed.
- **Honest fallback** — If the runtime lacks delegation capability, do not claim that Deep Security Scan ran; fall back to the ordinary scan or main-agent sequential role passes.
- **Regression detection** — Keep the boundary in the boot reminder and health Check 16 so deletion or weakening is detected.

---

### ✅ v1.0.0 — Initial Public Release (2026-04-10)

- **AGENTS.md** — AI Behavior Constitution (9 protocols)
- **Universal Rules** — 38 files × 2 languages (JA/EN), 2,500+ engineering
  standards
- **Blueprint Templates** — Project-specific templates (subdirectory structure,
  symmetric with Universal)
- **LOADING_PROTOCOL.md / CRYSTALLIZATION_PROTOCOL.md** — Rule management
  protocols
- **Prompt Library** — 16 templates × 2 languages (JA/EN), reusable prompt
  library
  - Role-based 4-folder structure (`develop/`, `audit/`, `govern/`, `operate/`)
- **`init.sh`** — Interactive setup script (Antigravity verified,
  Codex/Claude Code primary targets, Cursor/Copilot/Windsurf unverified pointers)
- **`.github/CODEOWNERS`** — Clear governance responsibility boundaries
- **`.github/workflows/lint.yml`** — Automated Markdown + JA/EN symmetry CI
- **`llms.txt`** — AI search engine optimization (GEO)
- **`question.yml`** — Q&A issue template
- **Setup guides for Codex / Cursor / Claude Code / Copilot / Windsurf** —
  Agent-specific setup in README + `init.sh` automation
- **AGENTS.md boot protocol** — Agent-agnostic generic Boot Sequence Protocol
- Enable **GitHub Discussions** — Q&A and use case sharing
- **`llms-full.txt`** — Full spec document for AI search engines (detailed
  version)

---

### ✅ v1.1.0 — Design & UX Strategy v3.0 / Protocol 6 (2026-04-12)

- **AGENTS.md §6: Anti-Full-Overwrite Protocol** — Added diff-based editing
  mandate protocol
- **`universal/{ja,en}/design/000_design_ux.md`** — 25-part complete edition
  v3.0
- **`.github/workflows/release.yml`** — Auto-detect version from CHANGELOG →
  auto-create tag & Release

---

### ✅ v1.2.0 — Universal Rules Major Brushup (2026-04-29)

- **Universal Rules** — Expanded all 16 files × 2 languages to 2026 Staff
  Engineer standards (57 files changed, +59,500 lines)
- **Blueprint Structure Normalization** — Added crystallization protocol
  explanation to domain folder READMEs based on YAGNI principle
- **`.github/dependabot.yml`** — Dependabot for GitHub Actions dependencies

---

### ✅ v1.3.0 — Bilingual Directory Re-Architecture (2026-04-30)

- **Full directory restructure** — Migrated from
  `axiarch-rules/universal/{lang}/` to `axiarch-rules/{lang}/universal/`
  ("Language-First" layout, 156 files changed)
- **`CLAUDE.md`** — Added Claude Code-specific pointer file (replaced former
  symlink approach)
- **Full cross-reference sync** — Updated all path references across 5 pointers,
  32 prompts, CI/CD, and config files

---

### ✅ v1.3.1 — Claude Code `@import` Integration (2026-05-03)

- **`CLAUDE.md`** — Added `@AGENTS.md` import syntax to auto-inline AGENTS.md
  (Top-Level Protocol / 9 protocols) into the system prompt at Claude Code session
  start
- **Physical BOOT SEQUENCE Enforcement** — Protocol compliance reinforced from
  the first turn, no longer depending on AI's autonomous file-loading behavior
- **Backwards compatibility maintained** — No effect on other agents (Cursor / Copilot /
  Windsurf / Antigravity / Codex)

---

### ✅ v1.3.2 — Universal Engineering 600 + Git Workflow Refactor + Worktree Hygiene (2026-05-03)

- **NEW `engineering/600_git_workflow.md`** — Consolidates daily Git operations
  (Trunk-Based / Commit & PR / Branch Hygiene / **Worktree Hygiene Protocol** /
  Repository Hygiene) as a domain-agnostic Universal Rule (5 parts, 18 rules)
- **Permanent fix for `.git/config` pollution problem (Antigravity Go-based
  language server crash)** — Detection and repair protocol for
  `[extensions] worktreeConfig = true` residue persisted to Universal level
- **NEW `axiarch-scripts/check-git-config-clean.sh` distribution** —
  Auto-detection and repair script (`--fix` / `--quiet` / `--full-clean` modes).
  Distributed automatically to all adopting projects via `init.sh`
- **Structural normalization** — Extracted pure-git workflow from
  `engineering/000` Part X into 600 (§10.0 / §10.3 / partial §10.1)
- **Backwards compatibility maintained** — Existing adopters obtain new rules and script
  via `git pull`. Pareto-improvement across all three scenarios (Claude Code
  only / Antigravity only / parallel use)

---

### ✅ v1.4.0 — Claude Code Hook Reinforcement Mechanism (UserPromptSubmit Hook) (2026-05-04)

- **NEW `.claude/settings.json`** — Claude Code projects ship with a standard
  `UserPromptSubmit` hook that injects a bilingual system reminder **on every
  user prompt submission**, making skipped AGENTS.md protocol and
  LOADING_PROTOCOL BOOT SEQUENCE steps easier to surface and correct
- **NEW "Hook Reinforcement Mechanism" section in
  `axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** — Declares hook removal as a
  constitution-amending destructive change
- **Removed `@AGENTS.md` import from `CLAUDE.md`** — Unified loading via the
  hook-driven Read flow (preserves `view_file` history and triggers `task.md`
  recording), aligning with the Anti-Laziness Rule
- **Refined `.gitignore`** — Split `.claude/` blanket ignore into `worktrees/` /
  `projects/` / `settings.local.json`, allowing the team-shared
  `.claude/settings.json` to be committed
- **Extended `init.sh`** — `SETUP_CLAUDE` branch now distributes
  `.claude/settings.json`; `.claude/` cleanup runs only for non-Claude-Code
  agents (preserves existing adopters' `worktrees/`)
- **Backwards compatibility maintained** — Existing v1.3.x adopters work without the hook
  (autonomous-enforcement mode)

---

### ✅ v1.5.0 — Major Universal Rules Expansion + Hook Language Enforcement (2026-05-06)

- **`core_mindset.md` (Rev.14)** — Added §1.14-§1.17 (Post-Quantum / Regulatory
  Agility / Developer Wellbeing / Technology Governance) + §1.18-§1.35 (SBOM /
  AI-Native Test / Evaluation-Driven / Feature Flag / Platform Reliability /
  DevX as Product / Responsible AI / Data Architecture / API Design / Green
  Software / Incident Response / AI Regulatory / Ethical Engineering / Type
  Safety / Compositional Architecture / Inversion Thinking / YAGNI / Strong
  Opinions Weakly Held) + §9.8-§9.11 (Model Governance / Agentic Workflow
  Patterns / AI Cost Governance / Computer Use Agent Safety). Total 46 sections
- **`engineering/510_aws_cloud.md`** — Added Primary Directives 0.9 Resilience &
  Chaos Engineering / 0.10 Observability-First / 0.11 Shared Responsibility &
  Compliance-by-Design / 0.12 Operational Excellence Culture (now 0.1–0.12)
- **`engineering/600_git_workflow.md`** — Expanded from 18 rules / 5 Parts to
  **45 rules / 10 Parts**. Added §2.6 Merge Strategy / §2.7 Force-Push Protocol
  / §2.8 Commit Body & Trailers / §2.9 Fixup・Autosquash / §2.10 Conventional
  Commit Validation, plus Part 6 Branch Protection & Code Review, Part 7
  Tags/Releases/History, Part 8 Repository Configuration & Assets, Part 9 Modern
  Tooling & Automation, Part 10 Anti-Pattern Catalog
- **`product/700_appstore_compliance.md`** — Expanded from 5 Parts / 101 lines
  to **20 Parts / ~1,099 lines** (Apple Privacy Stack: ATT, Privacy Manifests,
  Required Reason API, Privacy Nutrition Labels; StoreKit 2; Sign in with Apple;
  Account Deletion 5.1.1(v); TestFlight; Google Play AAB; Play Integrity API;
  Children's Apps; DMA; GenAI compliance; Specialized Verticals)
- **`product/900_fundraising_ir.md`** — Expanded from 7 Parts / 340 lines to
  **15 Parts / ~1,110 lines** (Cap Table & ESOP / SAFE & Convertible Note / Term
  Sheet math & Anti-Dilution / FEFTA, CFIUS, MNPI, Tax / IPO Preparation / M&A
  Exit / Founder Wellbeing / Investor Tech Stack / Anti-Pattern Catalog)
- **`product/800_internationalization.md` (v6.1)** — Expanded from 25 Parts /
  114 sections to **29 Parts / 133 sections**. Added Part XXVI 2026 Regulatory
  Frontier (EU AI Act / India DPDP / Saudi PDPL / China PIPL / LATAM & Africa),
  Part XXVII Emerging UX Paradigms (XR / Generative UI / CRDT / Shadow DOM /
  Foldable), Part XXVIII Translation Quality Frontier (MQM ASTM F2575 /
  Constrained Decoding / xCOMET-22 / CometKiwi / Domain Adaptation / Translation
  Safety Classifiers), Part XXIX Crisis Response & Resilience
- **`.claude/settings.json` hook message enhanced** — Added
  `Output language MUST follow Project Native Language in AGENTS.md (headings, summaries, labels, lists, tables — all)`
  to the `UserPromptSubmit` system reminder. Reduces the risk of English
  headings/summaries in Japanese-native projects
- **Backwards compatibility maintained** — Universal Rules expansions are non-breaking
  and purely additive. Hook message enhancement applies automatically to
  existing adopters via `git pull`

---

### ✅ v1.5.1 — Hook Efficacy + Crystallization Adherence Strengthening (2026-05-06)

- **NEW `axiarch-scripts/check-axiarch-health.sh` (full-protocol monitoring)** —
  Official Axiarch health diagnostic with **10-stage compliance check**: Hook
  (4) + `task.md` adherence + crystallization threshold + **§8 Process &
  Documentation** + **§1 Deployment Ban** + **§4 SSOT Sync** + **§2 Language
  First**. Pinpoints exactly which protocol needs attention. Out-of-scope protocols
  (§0/§3/§5/§6/§7) explicitly marked for manual review
- **NEW `axiarch-scripts/README.md`** — Bilingual index & guide for the
  `axiarch-scripts/` directory. Each diagnostic tool's purpose, usage, check
  items, and recommended workflow documented in one place
- **`.claude/settings.json` reminder doubly strengthened** — Added (1) `task.md`
  recording mandate (per AGENTS.md §8.4) and (2) **CRYSTALLIZATION_PROTOCOL Step
  5 THRESHOLD CHECK execution mandate**. Explicitly states "appending to
  `core/010` is NOT completion" and forces AI to promote 3+ unsorted domains to
  Blueprint files before declaring task done
- **`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md` §5 strengthened** —
  Added strong CAUTION block: "Step 4 (ACCUMULATE) alone is NOT completion",
  "Step 5 MUST run before task completion", "violations externally detectable
  via `axiarch-scripts/check-axiarch-health.sh` Check 6"
- **NEW concise Troubleshooting subsection in `README.md`** — Directs users to
  `bash axiarch-scripts/check-axiarch-health.sh` plus official-docs links
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** — Added one-paragraph
  reference to the diagnostic script
- **`init.sh`** — Optional `jq` JSON syntax validation post-copy; existing
  `axiarch-scripts/` distribution covers the new diagnostic
- **Root cause confirmed**: AI adherence gap (hook firing ≠ AI adherence,
  crystallization "appending = done" misconception). 3-parallel investigation
  refuted both "JSON structure error" and "Bash permission insufficient"
  hypotheses
- **Backwards compatibility maintained** — `git pull` + re-run `init.sh`, or manually
  overwrite `.claude/settings.json` + copy
  `axiarch-scripts/check-axiarch-health.sh`

---

### ✅ v1.5.2 — Hook Output Format Change (additionalContext / format cleanup) (2026-05-06)

- **`.claude/settings.json` hook output format switched** — From `echo`
  (transcript full-display) to `printf` emitting
  **`hookSpecificOutput.additionalContext` JSON**, the official docs-recommended
  format (code.claude.com/docs/en/hooks)
- **Format cleanup** — system-reminder label changed from
  `UserPromptSubmit hook success` to `UserPromptSubmit hook additional context`
  for a more natural form. **However, the system-reminder wrap itself remains**
  — "more discretely" in official docs means format improvement, not full
  invisibility
- **AI visibility preserved** — direct context injection retains adherence (the
  v1.5.1 reminder content is preserved verbatim)
- **No new dependencies** — `printf` is POSIX-standard (no `jq` required)
- **Backwards compatibility maintained** — `git pull` + re-run `init.sh`, or manually
  overwrite `.claude/settings.json`

---

### ✅ v1.5.3 — Dynamic Violation-Detection Reminder + ROADMAP Honesty Fix (2026-05-06)

- **NEW `axiarch-scripts/axiarch-boot-reminder.sh`** — Hook command is now
  externalized to a dedicated script. Each turn it dynamically inspects project
  state (`task.md` load history, `core/010` crystallization threshold) and
  **appends 🚨 [VIOLATION-A/B] flags to the reminder when violations are
  detected**. The AI thus receives not just static directives but **the current
  violation context** every turn
- **`.claude/settings.json` simplified** — `command` is reduced to
  `bash "${CLAUDE_PROJECT_DIR:-.}/axiarch-scripts/axiarch-boot-reminder.sh"`,
  removing the bulky inline JSON
- **No new dependencies** — JSON output is built in pure bash (`escape_json`
  helper, no `jq`)
- **Warning strengthening, not hard block** — `decision: "block"` was considered
  for prompt-level enforcement, but the side-effects are too large; instead we
  make the AI **aware of violations every turn**
- **ROADMAP v1.5.2 entry honesty-corrected** — "Plan-mode pollution fixed" was
  overstated; replaced with "format cleanup (system-reminder wrap remains)"
- **Backwards compatibility maintained** — `git pull` + re-run `init.sh`, or manually
  copy `.claude/settings.json` + `axiarch-scripts/axiarch-boot-reminder.sh`

---

### ✅ v1.5.4 — Health-Diagnostic Compatibility Patch for v1.5.3 (2026-05-06)

- **`axiarch-scripts/check-axiarch-health.sh` Check 3/4 regression fix** —
  v1.5.3 externalized the hook command to
  `axiarch-scripts/axiarch-boot-reminder.sh`, which broke the diagnostic's grep
  for the `AXIARCH BOOT` marker (Check 3) and the legacy `success` log label
  (Check 4). Both produced false negatives on freshly-installed v1.5.3 projects
- **Check 3 fallback branch** — When the hook command delegates to
  `axiarch-scripts/axiarch-boot-reminder.sh`, the diagnostic now inspects the
  externalized script for the `AXIARCH BOOT` literal, allowing both inline
  (v1.4.0–v1.5.2) and externalized (v1.5.3+) formats to PASS
- **Check 4 grep pattern expanded** — v1.5.2+ transcripts log
  `UserPromptSubmit hook additional context` instead of the legacy
  `UserPromptSubmit hook success`. Pattern updated to
  `grep -cE "UserPromptSubmit hook (success|additional context)"` to match both
- **17th-round audit: version-string-policy violations corrected** — Removed
  `v1.5.x` literals from `axiarch-scripts/axiarch-boot-reminder.sh` (header
  comment) and `axiarch-scripts/check-axiarch-health.sh` (a runtime-visible
  `print_info`). Generic files now stay version-free
- **`README.md` required-files table updated** — Added the missing reference to
  `axiarch-boot-reminder.sh` (introduced in v1.5.3 but never listed)
- **`core/010_project_lessons_log.md` (ja/en) restored to Initial entry only** —
  axiarch is an OSS template; lessons learned by axiarch maintainers belong in
  CHANGELOG / ROADMAP / commit bodies, not in this template file. An interim
  commit mistakenly crystallized a maintainer-side lesson here, and this release
  reverts it
- **18th-round audit: Check 3 else-branch false-negative fix** — When the hook
  command contains neither `AXIARCH BOOT` literal nor `axiarch-boot-reminder.sh`
  reference (i.e. fully broken hook), the diagnostic was emitting `print_warn`
  without setting `EXIT_CODE=1`, returning exit 0 on a broken state. CI
  integrations would falsely report success. Now correctly fails the run
- **Backwards compatibility maintained** — pure bash fix, no new dependencies. Re-run
  `bash axiarch-scripts/check-axiarch-health.sh` to verify Check 3/4 PASS
- **Design retrospective** — When changing hook output format, the diagnostic's
  grep targets must be updated in the same patch. Going forward, format changes
  and diagnostic updates ship together (recorded in CHANGELOG / commit bodies,
  not in axiarch core's `core/010` — see CONTRIBUTING.md Maintainer Guide for
  the policy)

---

### ✅ v1.5.5 — Physical Block + Tone Refactor + SessionStart Bootstrap (2026-05-07)

Based on 26 rounds of audit synthesised with a 4-agent parallel market study (AI
compliance frameworks / competitor tools / Claude Code official / academic
2024-2026), v1.5.5 implements the **"reminder → physical block" paradigm
shift**.

- **NEW `axiarch-scripts/axiarch-protect-antifull.sh`** — PreToolUse hook that
  intercepts `Write` calls and **physically blocks** (decision:"block" JSON +
  exit 2) when the target file already exists, preventing §6 ANTI-FULL-OVERWRITE
  violations
- **NEW `axiarch-scripts/axiarch-init-task-md.sh`** — SessionStart hook that
  auto-bootstraps task.md on session start (scaffolds with load-history table
  when missing)
- **`axiarch-scripts/axiarch-boot-reminder.sh` tone refactor** — Stripped CAPS /
  imperative markers (🚨/`No skipping`) and shifted to factual statements ("This
  project enforces axiarch governance"), per Anthropic guidance and Robert
  Glaser's "Prompts as Programs in GPT-5". The 9-protocol repetition structure
  is preserved per arXiv:2512.14982 (Prompt Repetition Improves Non-Reasoning
  LLMs)
- **`axiarch-scripts/check-axiarch-health.sh` Check 11/12 added** — Diagnostic
  extended to 12 stages (PreToolUse / SessionStart wiring verification)
- **`.claude/settings.json` three-hook wiring** — SessionStart /
  UserPromptSubmit / PreToolUse(Write matcher)
- **`.claude/axiarch-overwrite-allow.txt` whitelist support** — escape hatch for
  legitimate full-overwrite cases (autogenerated artefacts etc.)
- **`CONTRIBUTING.md` Maintainer Guide added** — Documents "lessons_log keeps
  Initial only", "files recommended for deletion in adopters", and "templates
  kept in placeholder form" symmetrically in JA/EN to prevent regression
- **Academic backing**: arXiv:2503.18666 (AgentSpec ICSE'26 — 90%+ block rate) /
  arXiv:2502.15851 (Control Illusion — structural workaround for
  instruction-hierarchy failure) / arXiv:2310.01798 (Huang — single-LLM
  self-correction insufficient, external verifier required)
- **Backwards compatibility maintained** — existing UserPromptSubmit hook preserved, new
  hooks added only, no new dependencies (pure bash)

---

### ✅ v1.6.0 — Reminder TTL + Time-Axis Crystallization + Pre-commit Installer + Session Re-load Criteria + APPEND Guide (2026-05-08)

Bundles five improvements driven by adopter-project feedback ("governance
functional evaluation report"). Structurally resolves the design-vs-reality gap
(context budget, token cost, sublimated-file recognition, stale-lesson neglect).

- **`axiarch-scripts/axiarch-boot-reminder.sh` Two-Stage Output (TTL)** — First
  fire returns full reminder + writes timestamp; subsequent fires within TTL
  (default 30 min) with no violations return short-circuit `[AXIARCH REMINDER]`; any
  violation forces full reminder. `AXIARCH_REMINDER_TTL_SECONDS=0` disables.
  **Token impact: ~24k → ~3k (87% reduction in long sessions)**
- **Check C — Stale Lesson Detection** — Detects any `core/010` lesson dated
  `>180 days` ago as `🚨 [VIOLATION-C]`. Threshold tunable via
  `AXIARCH_LESSON_STALE_DAYS`
- **`check-axiarch-health.sh` Check 6 expanded — CRYSTAL §5 Time-Axis Trigger**
  — Existing count threshold (3+ per domain, trigger (a)) joined by **time-axis
  trigger (b)**. Reduces the risk of long-term neglect of stale lessons
- **`check-axiarch-health.sh` Check 13 — Sublimated Files Index** — Lists
  existing `blueprint/{domain}/{NNN}_{topic}.md` files so the AI prefers APPEND.
  Addresses "12 consecutive N/A" feedback at the root
- **`check-axiarch-health.sh --quiet` flag** — Silent mode for pre-commit / CI
  usage
- **`init.sh` Pre-commit Hook Installer (opt-in)** — STEP 3.5 asks the user;
  appends/creates `.git/hooks/pre-commit` axiarch block; warns instead of
  overwriting when lefthook/pre-commit-framework/husky is detected. Bypass
  per-commit via `AXIARCH_PRECOMMIT_SKIP=1`
- **`CRYSTALLIZATION_PROTOCOL.md` (ja/en) Step 5** — Replaced single trigger
  with dual-trigger table (count + time-axis); time-axis rationale documented
- **`LOADING_PROTOCOL.md` (ja/en) Step 4** — New "Cross-Session Re-load
  Criteria" section explicitly resolves the "full load = no laziness" vs
  "context budget reality" trade-off across 4 situations; `task.md` history is
  the Single Source of Truth
- **Academic backing**: Memory-in-LLMs serial-position effects / Constitutional
  AI lineage / Anthropic "reminder less is more" official guidance
- **Backwards compatibility maintained** — TTL / Check C / pre-commit installer all
  opt-in or env-var controlled; existing setups untouched

---

### ✅ v1.7.0 — Task Boundary Detection + Claude Code Validation-Log Expansion (2026-05-08, **not independently released; bundled into v1.8.0**)

> **Note**: v1.7.0 was an internal development milestone only. No independent
> Git tag was created; all features were bundled into the v1.8.0 release
> together with the BREAKING `scripts/` → `axiarch-scripts/` rename. Development
> history is preserved in git log (commits 770150b / f60ced8 / c6aee62 / eddeb01
> / 69c44b8 / 8d94938).

- **`axiarch-scripts/axiarch-boot-reminder.sh` Check D added** — Reads
  current-prompt JSON from UserPromptSubmit hook stdin; extracts domain keywords
  (security / architecture / ui_design / api / performance / push / commit /
  migration etc.) via **whole-word match** (`grep -oiwE`); full-text greps the
  **AGENTS §8.4 mandatory trio** (task.md / implementation_plan.md /
  walkthrough.md) to compare with known domain context. On new-keyword
  detection, emits `🚨 [VIOLATION-D]` flag + forces TTL bypass
- **`check-axiarch-health.sh` Check 14 added** — Verifies Check D wiring
  (13-stage → 14-stage)
- **`LOADING_PROTOCOL.md` (ja/en) Step 4 update** — Added Check D backstop note
  to Cross-Session Re-load Criteria
- **Claude Code validation-log expansion** — Evidence for the hook-reinforcement model accumulated through axiarch's own development cycles
- **Backwards compatibility maintained** — `AXIARCH_TASK_BOUNDARY_DETECT=0` disables

---

### ✅ v1.8.0 — BREAKING `scripts/` → `axiarch-scripts/` rename + Check D Task Boundary Detection + Claude Code Validation-Log Expansion (2026-05-10)

Hot-fix for an adopter-feedback issue: "Within the same session, actual tasks
differ, yet the AI judges 'session is continuing → no rule re-load needed' and
slacks" — a confirmation-bias risk in v1.6.0's LOADING_PROTOCOL §4
self-judgment clause.

- **NEW `axiarch-scripts/axiarch-boot-reminder.sh` Check D** — Reads
  current-prompt JSON from UserPromptSubmit hook stdin; extracts domain keywords
  via **whole-word match** (`grep -oiwE`); full-text greps the **AGENTS §8.4
  mandatory trio** (task.md / implementation_plan.md / walkthrough.md),
  capturing domain context from both the plan and the walkthrough rather than
  task.md alone. On new-keyword detection, emits `🚨 [VIOLATION-D]` + forces TTL
  bypass (suppresses short-circuit, re-injects full reminder)
- **Mechanically backs up AI self-judgment** — v1.6.0's "task type unchanged"
  decision was AI-self-judged (confirmation-bias prone). v1.8.0 detects
  task-boundary candidates at the hook layer
- **`axiarch-scripts/check-axiarch-health.sh` Check 14 added** — Verifies Check
  D wiring (13-stage → 14-stage)
- **Env vars**: `AXIARCH_TASK_BOUNDARY_DETECT=0` to disable;
  `AXIARCH_TASK_DOMAIN_KEYWORDS` to override the keyword set
- **`LOADING_PROTOCOL.md` (ja/en) Step 4 update** — Added Check D backstop note
  to the "task continues" row; new "v1.8.0 improvement" section documents the
  risk-reduction mechanism
- **Backwards compatibility maintained** — `AXIARCH_TASK_BOUNDARY_DETECT=0` reproduces
  v1.6.0 behaviour; auto-skipped when stdin is unavailable (direct invocation
  outside hook context)
- **Claude Code validation-log expansion** — Evidence for the hook-reinforcement model accumulated through axiarch's own development cycles (since v1.4.0+ native hook integration). At the v1.8.0 release point, public status treated Antigravity as the only production-validated agent and Claude Code as a primary target

---

### ✅ v1.8.1 — Check 4 Codex Compatibility + Check 13 Quiet-Mode Fix + Docs Corrections (2026-05-11)

Patch release with 2 bug fixes + 3 documentation corrections discovered in the
41st–42nd-round audits.

- **`axiarch-scripts/check-axiarch-health.sh` Check 4 Codex runtime detection**
  — In OpenAI Codex environments (`CODEX_THREAD_ID` / `CODEX_CI` env vars),
  Claude Code session logs do not exist, causing a false
  `[FAIL] Hook never fired`. Now returns
  `[PASS] Codex runtime detected — not applicable` when Codex is detected
- **Check 13 `--quiet` mode verbose output fix** — Even with `--quiet` / `-q`
  flag, the `printf` and two `print_info` lines were executing unconditionally.
  Wrapped in `if ! "${QUIET_MODE}"; then` to correctly suppress output in CI /
  pre-commit usage
- **`axiarch-scripts/README.md` JA overview + stage count corrections
  (42nd-round)** — Fixed JA "8 領域" → "10 領域以上" (stale count from v1.5.1
  era); fixed EN "One-shot 13-stage" → "One-shot 14-stage" (missed in v1.8.0);
  added v1.8.0 Check D mention
- **`CHANGELOG.md` v1.6.0 Out of Scope version label corrections (42nd-round)**
  — `(Check 14)` → `(Check 15)`; `v1.7.0 (Tier 2)` → `v1.9.0 (Tier 2)`;
  the stale Tier-3 label was moved to the then-next candidate slot as the
  provisional organisation at that time. The current roadmap reallocates v1.10.0
  to Safe Upgrade Wizard and moves Static Lint to v1.11.0 after adopter-upgrade
  needs were prioritised
- **Backwards compatibility maintained** — Pure bug fixes only, zero functional changes.
  No impact on non-Codex environments

---

### ✅ v1.8.2 — Native Codex Environment Integration (2026-05-12)

- **`init.sh`**: Added automatic initialization, validation, and cleanup mechanism for `.codex/hooks.json`
- **Diagnostic / Script Support**: First-class support for `.codex/hooks.json` and related allow-lists across the entire infrastructure, including `check-axiarch-health.sh`, `check-git-config-clean.sh`, and `axiarch-protect-antifull.sh`
- **Documentation**: Explicitly documented Codex hook mechanisms in constitutional rules like `LOADING_PROTOCOL.md`

---

### ✅ v1.9.0 — Memory Persistence & Glob-Scoped Rules (2026-05-15)

Tier-2 improvement candidates extracted from the 26-round market study (see
v1.5.5 release notes). v1.6.0 delivered a different axis (5 items from
adopter-project feedback); v1.8.0 delivered the confirmation-bias loophole
hot-fix bundled with the BREAKING `scripts/` → `axiarch-scripts/` rename; these
Tier-2 items are now organised under v1.9.0.

- **Implemented: `PostToolUse` hook + git diff verification** — Measure diff line count after
  Edit, warn/block above threshold. Safety net for PreToolUse (v1.5.5 only
  blocks `Write`; large Edit changes detected post-hoc)
- **Implemented: Cursor `globs:` adoption + path-scoped rules** —
  Declare `globs: "**/*"` in `.cursor/rules/axiarch.mdc` and document the
  future `paths:` frontmatter schema for `axiarch-rules/{lang}/universal/{domain}/`.
  Bulk frontmatter insertion into Universal files remains deferred until validation.
- **Implemented: Memory Persistence enhancement** — Adds
  `.claude/memory/MEMORY.md` as an optional template inspired by the operating
  model of Windsurf Cascade Memories / Codeium Memories. It does not store full
  conversations or secrets; it is only a short auxiliary layer for recurrence
  prevention notes from events that actually happened
- **Aider-style prompt-cache optimisation** — Declare
  `axiarch-rules/{lang}/universal/` as read-only and target Anthropic
  prompt-caching API `cache_control`. Solves the per-turn full-injection cost
  issue (complementary to v1.6.0 reminder TTL)
- **Implemented: shellcheck CI integration** — Add `axiarch-scripts/*.sh` static analysis to
  `lint.yml` (deferred from v1.5.4)
- **Implemented: Post-distribution syntax validation in `init.sh`** — Run `bash -n` on
  `axiarch-{boot-reminder,protect-antifull,init-task-md,check-axiarch-health}.sh`
  after copy, mirroring the existing `jq` validation
- ~~**Universal Rules footer cleanup** — Remove `(v1.5.0)` version literals from
  `**Last Updated**` footers; keep date only, completing the version-free policy
  for generic files~~ → **Completed in v1.8.0** (commit `08c6ecf`, 8 files
  cleanup)
- **HealthCheck Workflow** — Automated repository health diagnostics (empty
  Blueprint, accumulated Lessons-log overflow detection, etc.)
- **Implemented: Post-release README integration auto-verification** — Prevent the recurring
  "new release feature → README update missed" pattern (24/27/28th-round
  audits + v1.6.0 `12-stage` residue). Check 15 now verifies README /
  scripts README references for v1.9.0 diff guard, memory, and 15-stage
  diagnostics

---

### ✅ v1.10.0 — Safe Upgrade Wizard & Manifest-Based Upgrades (2026-05-17)

Safe-upgrade path for existing adopter projects that need to merge only the necessary Axiarch changes. Universal rules, protocols, and scripts become easier to update, while project-owned Blueprint state is preserved by default and ambiguous differences remain selectable by the operator.

- **`axiarch-manifest.json`** — Ownership-boundary manifest separating Axiarch-owned files, Axiarch-shared Blueprint rules, project-owned Blueprint state, optional files, and source-repository-only files
- **`axiarch-scripts/axiarch-upgrade.sh`** — Local-first upgrade helper supporting `--dry-run`, `--safe-only`, `--interactive`, and `--apply`
- **Group-level interactive choices** — `preserve`, `show-diff`, `update-all`, `review-each`, and `skip`; source-repository-only files stay skipped by default and move into review/application only when explicitly selected
- **Project-owned state preserved by default** — `blueprint/core/000_project_overview.md`, `blueprint/core/010_project_lessons_log.md`, and `blueprint/*/[0-9][0-9][0-9]_*.md` are not overwritten by default
- **Upgrade evidence** — Applied upgrades write `.axiarch/version.json`, `.axiarch/upgrade-report.md`, and `.axiarch/files.sha256`
- **`axiarch-prompts/{ja,en}/develop/safe_upgrade_execute.md`** — Dedicated prompts for having AI agents execute the Safe Upgrade Wizard, including source-only default skip with explicit selection

---

### ✅ v1.11.0 — Native Task State Sync & Process Document Lifecycle (2026-05-18)

Separates and addresses two problems in long Claude Code / Codex sessions:
`task.md` / `implementation_plan.md` / `walkthrough.md` accumulating old task
content indefinitely, and the mistaken assumption that Markdown evidence
automatically updates native task/plan panels.

- **`axiarch-scripts/axiarch-task-state.sh`** — Manages the three current-task
  documents with archive-before-refresh and stores previous content under
  `.axiarch/process-doc-history/`
- **Project Native Language templates** — `AXIARCH_PROCESS_DOC_LANG=auto|ja|en`
  separates Japanese and English templates according to the `Project Native
  Language` in `AGENTS.md`
- **SessionStart reinforcement** — `axiarch-init-task-md.sh` bootstraps
  `task.md` / `implementation_plan.md` / `walkthrough.md`, not only `task.md`
- **Native state sync** — Codex uses `update_plan`; Claude Code uses
  `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet`. `TodoWrite` is treated
  as a fallback for older runtimes
- **Backward compatibility** — `AXIARCH_PROCESS_DOC_MODE=append` preserves legacy
  append behavior when adopter projects explicitly need it
- **Health regression checks** — Check 12/15 verify the task-state script,
  native state wording, version metadata, and documentation parity

---

### ✅ v1.11.1 — Hybrid Autonomous Boot Sequence for Safe Upgrade (2026-06-02)

Improves the `safe_upgrade_execute.md` upgrade prompt from the legacy Stop & Wait
mode (five manual user inputs) to a Hybrid mode where the AI auto-detects context.

- **Six-step Boot Sequence** — Phase 0 immediate context load → Phase 1 auto-detection
  (version / agent / lang / mode) → present inference + dry-run approval (safety fence 1)
  → autonomous dry-run → present results + apply approval (safety fence 2) → autonomous apply
- **Documented safety boundary** — apply / `--with-prompts` / mixed-ownership writes /
  `git push` etc. require explicit approval; Phase 0/1/3 dry-run and health check are autonomous-OK
- **Edge cases** — same-version skip / multi-version jump warning / missing baseline /
  multiple-agent detection / release lookup failure
- **Backward compatibility** — legacy Stop & Wait remains as an explicit user fallback;
  Wizard logic unchanged, prompt-text-only improvement
- **Source pattern** — standardizes the autonomous-execution success observed in adopter
  project chronoviq's Safe Upgrade Wizard v1.11.0 application (PR #43)

---

### ✅ v1.11.2 — Multi-Agent Detection Fix for Safe Upgrade (2026-06-03)

Fixes the `safe_upgrade_execute.md` agent auto-detection that looked for Antigravity at
the wrong path (`.antigravity/`), plus the single-agent trap that left other agents' hooks
stale in multi-agent projects.

- **Antigravity detection fix** — `.antigravity/` (never generated) → `init.sh`-generated
  `.agents/rules/prompt_pointer.md`; codex unified from `.codex/` to `.codex/hooks.json` so
  all three agents key on their representative generated file
- **Multi-agent design** — enumerate every present agent across the three representative
  files; one → that agent, two+ (multi-agent, e.g. inucomi = codex+claude+antigravity) →
  `--agent all` (a single agent drops the others' hooks from the plan and lets them go stale)
- **Safety proof** — under `--safe-only`, unused-agent pointers (cursor/copilot/windsurf) are
  never written even in `add` status (verified via `path_status` + `execute_item`)
- **Backward compatibility** — single-agent adopters unaffected; Wizard logic unchanged, prompt-text-only
- **Source pattern** — Antigravity detection gap reported in adopter project inucomi (codex+claude+antigravity)

---

### ✅ v1.12.0 — AXIARCH Canonical Entrypoint & Execution Harness / Harness Engineering (2026-06-08)

- **`AXIARCH.md` canonicalization** — Treat `AGENTS.md` as neither Codex-only nor the standalone source of truth. It is a thin adapter for environments that read the AGENTS standard. Claude Code, Antigravity, Cursor, Copilot, and Windsurf entrypoints also point only to `AXIARCH.md`.
- **Harness Engineering introduced** — Defines the Execution Harness not as a fourth rule layer, but as operational engineering that connects Universal / Blueprint / Prompts to execution order, audit verdicts, role passes, evidence, human approval, and subagent delegation.
- **Execution Harness** — Split execution, audit, role passes, evidence, human approval, and subagent delegation into `axiarch-harness/{ja,en}/`. When subagents are unavailable, the main agent executes the same passes sequentially.
- **Existing value preservation** — Keep Universal / Blueprint / Prompts, Crystallization, Native Language, Safe Upgrade, hook reinforcement, and current-task document rotation intact while clarifying only the canonical entrypoint.
- **Follow-up candidate** — Keep Static Lint & Process Supervision as a follow-up candidate after canonicalization.

---

### ✅ v1.12.1 — Harness Engineering Release Parity Patch (2026-06-08)

- **Version protection** — Keep the existing `v1.12.0` tag immutable and express the post-tag Harness Engineering follow-up as a patch release.
- **Execution protocol reinforcement** — Clarify in ja/en `EXECUTION_HARNESS_PROTOCOL.md` that Harness Engineering is not a fourth layer; it connects the three-layer model to execution order, audit, evidence, and human approval.
- **Safe Upgrade parity** — Keep the fallback `execution_harness` group label aligned with `Execution Harness / Harness Engineering` even when manifest metadata is unavailable, and align temporary-helper and upgrade-helper usage examples with `v1.12.1`.
- **Regression detection** — Extend `check-axiarch-health.sh` to verify the execution protocol wording, Safe Upgrade fallback label, current-release helper pins, and upgrade helper usage examples.
- **Distribution metadata parity** — Update installer, manifest, README, llms, Safe Upgrade prompts, and Blueprint INDEX current-stable metadata to `v1.12.1`.

---

### ✅ v1.13.0 — Prompt Slash Commands for Claude Code (2026-06-08)

Removes the copy-paste-only friction where `axiarch-prompts/` never appeared under `/`, making prompts first-class Claude Code native slash commands. Strategic-roadmap bet #2 (AGENTS.md standard relationship) shipped in #49; this release provides the slash-command foundation and sets up bet #1 (SKILL.md migration).

- **`axiarch-scripts/axiarch-prompts-install.sh`** — Generates `.claude/commands/axiarch-<name>.md` (`/axiarch-<name>`) from the prompt library. Thin pointers that Read and execute the canonical prompt (single source of truth). Idempotent, bilingual (`--lang ja|en|auto`), `--clean`/`--dry-run`, pure bash
- **init.sh opt-in** — Offers generation only when the prompt library is copied and Claude Code is selected
- **Honest per-agent support** — Native generation for Claude Code only; Codex (custom prompts global-only/deprecated) and Antigravity (undocumented workflow project-file convention) use copy-paste / AGENTS
- **Generated files as artifacts** — `.claude/commands/axiarch-*.md` is gitignored; the generator is the source of truth

---

### ✅ v1.13.1 — Restore Language First Enforcement (2026-06-08)

Fixes the adopter-reported regression ("native-language adherence weakened") where the #46 canonicalization diluted the old §2 Language First binding on the agent response surface.

- **AXIARCH.md §6.10** — Strengthens the Language invariant to "response + documents": Project Native Language binds every heading, summary, label, list, and table in the agent response; English mixing when Japanese is the native language is a protocol violation; code/API/log/path are exempt
- **boot-reminder (language clause)** — Strengthens the per-turn language clause to match the canonical rule
- **boot-reminder (Harness activation)** — Closes a gap where the reminder never referenced the Execution Harness despite §8 marking it mandatory for non-trivial work; adds a trigger to both CORE/SHORT to apply the L2+ harness (role passes, audit verdict, evidence packet, human approval gate) in ja/en
- **EXECUTION_HARNESS_PROTOCOL (canonical basis)** — Anchors the "non-trivial (§8) = L2+" mapping in the harness layer so the reminder's "L2+" wording has an SSOT source
- **health Check 16** — Verifies the reminder retains the language-violation clause and the Harness trigger in both ja and en, detecting future silent removal/degradation and reducing recurrence risk for the #46-style regression
- **Basis** — Restoration under §6.10's non-degradation principle (preserve the stricter older interpretation)
- Independent patch (separate branch from v1.14.0 skills)

---

### ✅ v1.14.0 — Security Authentication Stack (2026-06-09)

Adds six new authentication→authorization→MCP security Universal Rules (Universal rules 39→45), informed by primary-source market research and adversarial review.

- **security/400** passkeys & MFA / **410** OAuth & OIDC federation & SSO / **420** step-up, OTP & sensitive operations / **430** authorization (ReBAC/Zanzibar, Cedar/OPA) / **440** non-human, workload & AI-agent identity (SPIFFE, OBO, MCP/XAA) / **450** MCP security (consumer + builder; token-passthrough prohibition, rug-pull detection, etc.)
- **000 de-dup** — §4/§18.3 cross-reference the deep-dive files
- **Framework wording pass (#52)** — de-overclaiming, language-neutral generalization, numbering/loading clarity
- **Consistency** — INDEX (ja/en), README domain table, llms digests, counts (39→45) synced
- **Accuracy** — OAuth 2.1 = draft with RFC 9700 baseline, WebAuthn L3 = CR, MCP = emerging, stated precisely
- Consolidates PR #52 / #53

---

### 🔬 Market-Research-Driven Strategic Roadmap (2026-06-12 refresh, priority order)

Strategic forecast based on current checks across the AGENTS.md standard, OpenAI Codex, Claude Code Skills/Subagents/Hooks, GitHub Copilot / VS Code custom instructions, Kiro / GitHub Spec Kit, MCP authorization, OWASP agentic security, and agentic coding tool configuration research. Each bet includes canonical-level change, so confirmed facts and strategic hypotheses are separated and executed as deliberate, separately-tested releases.

| Priority | Bet | Goal (industry alignment) | Risk | Target |
|:--|:--|:--|:--|:--|
| 1 | **Optional Agent Skills (SKILL.md) packaging** | Make prompts distributable as `SKILL.md` packages as well (metadata + progressive disclosure + supporting files). Claude Code recommends Skills when supporting files are needed, so this should be an optional higher-level packaging path rather than a replacement for slash commands | Medium (evolution of v1.13.0 slash commands; start after it merges) | after v1.13.0 |
| 2 | **Clarify relationship to the AGENTS.md standard** | AGENTS.md is a Linux-Foundation-stewarded standard (60,000+ adopters, nearest-file override at its core). Document "why AXIARCH.md is canonical" and "how it interoperates with the standard" in README to reduce new-adopter friction | Low (doc) | immediate–near |
| 3 | **Crystallization v2 (verification + pruning/importance)** | Add pre-promotion verification, lesson importance scoring, pruning, and conflict resolution to CRYSTALLIZATION_PROTOCOL. Configuration research shows Context Files are widely used while Skills/Subagents adoption is still shallow, so Blueprint needs active curation to reduce passive knowledge-dump decay | Medium (protocol) | near–mid |
| 4 | **Adapter freshness** | `.windsurfrules` (legacy single) → `.windsurf/rules/*.md` (new standard) coexistence; Cline AGENTS.md native support, etc. Document the init.sh adapter-maintenance policy | Low–Medium (distribution) | near |
| 5 | **AXIARCH.md progressive disclosure** | Split the 516-line canonical file into a short core charter + on-demand detailed protocols to cut per-turn full-load context cost. Align with AGENTS.md nearest-file loading, Claude Skills progressive disclosure, and VS Code path-specific instructions | **High** (canonical surgery = constitution-amendment level; must jointly verify health check, safe-upgrade, all adapters, bilingual parity with real agent-load testing) | dedicated major (v1.14/v2.0) |

> **Market positioning (study conclusion)**: In the checked scope, no OSS framework was found that bundles Axiarch's three layers, harness, human-approval gate, and lesson crystallization at the same granularity. This is not a claim of uniqueness across the whole market: spec-driven dev (Kiro / Spec Kit), the AGENTS.md standard, Skills/Subagents, and MCP security overlap with parts of the problem. Axiarch should position itself as a file-based governance layer that complements those mechanisms with source-of-truth files, evidence, approval boundaries, and lesson crystallization. The two main structural tensions are "full pre-load vs context-aware load" (addressed by bet #5) and "single canonical vs AGENTS.md nested standard" (addressed by relationship clarification in bet #2).

---

### 🔮 v1.13.0 or later — Static Lint & Process Supervision (Tier 3, Under Consideration)

Improvements with strong academic backing but larger implementation effort,
planned independently after the AXIARCH canonical entrypoint and Execution Harness work.

- **`axiarch-doctor` CI lint mechanism (npx-distributed)** — Mirror Cursor
  `cursor-doctor` / `cursor-lint-action`. Forces frontmatter validation /
  Universal-vs-Blueprint responsibility checks / `compliance_matrix.md` sync as
  PR gates (source: <https://github.com/nedcodes-ok/cursor-lint-action>)
- **IFEval-style auto-regression suite** — Convert "task.md recording
  obligation" / "core/010 crystallization threshold" to verifiable instructions
  in `tests/ifeval/`, run via Claude API per PR for pass/fail. Detect rules
  brittle to paraphrase via reliable@k evaluation (sources: arXiv:2311.07911 /
  arXiv:2512.14754)
- **Deliberative-Alignment imitation — forced Harness Gate Recall** — Before
  high-risk tool calls, require a reasoning step: "list which AXIARCH.md and
  relevant harness gates apply now and write one-line justification per match".
  OpenAI o3 reduced safety violations 13%→0.4% with this approach (source:
  arXiv:2412.16339)
- **AI Agent Compatibility Matrix** — Meta-spec that separates primary targets
  (Codex / Claude Code / Antigravity) from extended compatibility targets
  (Cursor / GitHub Copilot / Windsurf / Aider / Zed, etc.) and periodically
  records verification date, scope, and hook coverage

---

### 🔮 v2.0.0 — AgentSpec DSL & Constitutional AI Lineage (Strategic, Long-Term)

- **AgentSpec-style DSL adoption** — Declarative trigger + predicate +
  enforcement in `axiarch-rules/policies/*.spec`. OSS-ifies the technique that
  achieves 90%+ block rate in ICSE'26 (arXiv:2503.18666). Repositions axiarch as
  the OSS implementation in the Anthropic Constitutional AI lineage (sources:
  arXiv:2503.18666 / Constitutional AI Bai et al. 2022 / C3AI WWW'25)
- **Multi-Agent Verification** — Architect / Auditor sub-agent cross-checking
  before critical commits (sources: arXiv:2305.14325 / arXiv:2510.12697)
- **Axiarch CLI** — Automated setup via `npx axiarch-init`
- **Community Prompt Contributions** — User-submitted prompt review and
  integration flow
- **`decision: "block"` generalisation** — v1.5.5 blocks `Write` only; gradual
  extension to Bash / Edit (whitelist-driven)

---

### 💡 Future Ideas (Under Discussion)

The following are ideas being considered for the future. Prioritization is not
yet determined.

- **Multi-repository support** — Axiarch management in monorepo configurations
- **Axiarch Web UI** — Dashboard for rule browsing, search, and progress
  tracking
- **GitHub App** — Automatic Axiarch compliance check on every PR

---

### Feedback & Feature Requests

Share your feedback on the roadmap or feature priorities via Issues:

👉
[github.com/hiroyuki-miyauchi/axiarch/issues](https://github.com/hiroyuki-miyauchi/axiarch/issues)
