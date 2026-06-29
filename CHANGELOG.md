# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

過去のエントリでは、各リリース時点で有効だった名称とファイル役割をそのまま保持します。
v1.12.0以降の現行Axiarch正本は `AXIARCH.md` です。このファイル内の過去の
`AGENTS.md` / Protocol 0-9 表記はリリース履歴であり、現行の正本番号体系ではありません。

Historical entries preserve the labels and file roles that were active at the
time of each release. From v1.12.0 onward, the active Axiarch source of truth is
`AXIARCH.md`; earlier `AGENTS.md` / Protocol 0-9 references in this file are
release history, not current canonical numbering.

---

## [Unreleased]

## [1.15.0] — 2026-06-30

### Agent Validation Status Reversal & Wording Parity Wave

主対象 3エージェントの検証ステータスを、コミット履歴（dogfooding）が示す実体に合わせて反転。
Antigravity・OpenAI Codex・Claude Code を、いずれも実運用で稼働確認済みの主対象として公開表現し、
全環境での動作保証はしないという歯止めだけを残した。あわせて、これまで [Unreleased] に蓄積していた
ガバナンス文言の同期群（subagent 境界・Public/AI-facing docs parity・Loading/Blueprint wording parity・
market-research 文言）を本リリースに集約する。

Reverses the validation status of all three primary agents to match what the commit history (dogfooding)
actually shows. Antigravity, OpenAI Codex, and Claude Code are now all presented as validated through
real operational use, while keeping the no-operation-guarantee-for-every-environment boundary.
Releases the previously accumulated [Unreleased] wording-parity items (subagent boundary, public/AI-facing
docs parity, loading/blueprint wording parity, market-research wording) as part of this release.

### Fixed

- **読み取り専用 subagent / Deep Security Scan の誤停止リスク低減** — `AXIARCH.md` と `axiarch-harness/{ja,en}/` で、読み取り専用のサブエージェント委任はそれ自体では Human Approval Gate 対象ではないことを明文化。ユーザーが deep audit / security scan / exhaustive review / Codex Security Deep Security Scan などの名前付き読み取り専用 workflow を明示した場合、必要な read-only worker fanout はその要求に含まれるため、別途「サブエージェント明示許可」を求めて停止しない。委任機能が runtime にない場合は正式 Deep Security Scan 実行済みとは主張せず、通常 scan またはメインエージェント順次 role pass へ fallback する。
- **Runtime reminder / health 再発検知** — `axiarch-boot-reminder.sh` に同趣旨の短い境界文を追加し、`check-axiarch-health.sh` Check 16 で Language First / Execution Harness に加えて read-only subagent/security-scan delegation boundary の保持を検査する。
- **Public / AI-facing docs parity** — README、`llms.txt`、`llms-full.txt`、ROADMAP を同期し、Harness Engineering の承認境界が digest だけを読む AI にも伝わるようにした。
- **Agent validation status parity** — README、`llms.txt`、`llms-full.txt`、ROADMAP、MARKET_STRATEGY、`axiarch-rules/{ja,en}/README.md`、`LOADING_PROTOCOL.md`、`init.sh`、`check-axiarch-health.sh` を同期し、主対象の Google Antigravity・OpenAI Codex・Claude Code を、いずれも実運用（ドッグフーディング＝本リポジトリ自体の開発を含む）で稼働確認済みの主対象として公開表現する境界へそろえた。Antigravity を最初の実証対象とし、Codex・Claude Code 経由のコミット履歴を継続使用の証跡とする。全環境での動作保証はしない境界は維持し、Cursor / GitHub Copilot / Windsurf は拡張ポインター候補（未検証）のまま。Check 15 の保護文言も同表現へ更新。
- **Loading / Blueprint wording parity** — `LOADING_PROTOCOL.md` / `INDEX.md` の 15→16 段階 stale 表記、ロード完了宣言の境界、Blueprint 事前フォルダ README の「空」表現、プロジェクト概要の過大評価表現を同期し、Universal / Blueprint / optional Prompts の3層責務と品質底上げの言い回しへ寄せた。
- **Market research wording and deletion/addition audit** — `MARKET_STRATEGY.md` と ROADMAP の市場調査節を2026-06-12時点の一次情報ベースへ更新し、未確認のバージョン追従、唯一性、先取り、完全防止に見える表現を確認済み事実と戦略仮説へ分離。tracked削除なし、必要な未追跡追加は `axiarch-rules/{ja,en}/blueprint/core/020_governance_rules.md` の2件であることを監査した。

### Fixed (English)

- **Read-only subagent / Deep Security Scan false-block risk reduction** — Clarifies in `AXIARCH.md` and `axiarch-harness/{ja,en}/` that read-only subagent delegation is not a Human Approval Gate action by itself. When the user explicitly requests a named read-only workflow such as deep audit, security scan, exhaustive review, or Codex Security Deep Security Scan, the workflow's required read-only worker fanout is included in that request; agents must not stop for separate "explicit subagent permission." If delegation is unavailable, agents must not claim the formal Deep Security Scan ran, and should use the ordinary scan or main-agent sequential role-pass fallback.
- **Runtime reminder / health regression detection** — Adds the same boundary to `axiarch-boot-reminder.sh` and extends `check-axiarch-health.sh` Check 16 to verify the read-only subagent/security-scan delegation boundary alongside Language First and Execution Harness.
- **Public / AI-facing docs parity** — Syncs README, `llms.txt`, `llms-full.txt`, and ROADMAP so agents that load only the digest still receive the Harness Engineering approval boundary.
- **Agent validation status parity** — Syncs README, `llms.txt`, `llms-full.txt`, ROADMAP, MARKET_STRATEGY, `axiarch-rules/{ja,en}/README.md`, `LOADING_PROTOCOL.md`, `init.sh`, and `check-axiarch-health.sh` so Google Antigravity, OpenAI Codex, and Claude Code are all presented as validated through real operational use (dogfooding, including building this repository itself). Antigravity was validated first; the Codex- and Claude-Code-authored commit history serves as continuous-use evidence. The no-operation-guarantee-for-every-environment boundary is preserved, Cursor / GitHub Copilot / Windsurf remain extended pointer-only candidates (unverified), and the Check 15 protected wording is updated to match.
- **Loading / Blueprint wording parity** — Syncs stale 15→16-stage references in `LOADING_PROTOCOL.md` / `INDEX.md`, the load-completion claim boundary, pre-provisioned Blueprint folder README wording, and project-overview overclaim wording around the three-layer Universal / Blueprint / optional Prompts responsibility model and quality-floor language.
- **Market research wording and deletion/addition audit** — Refreshes `MARKET_STRATEGY.md` and the ROADMAP market-research section against 2026-06-12 primary-source checks, separating verified facts from strategic hypotheses and softening unverified version-following, uniqueness, anticipation, and absolute-prevention wording. Confirms no tracked deletions and identifies the only required untracked additions as `axiarch-rules/{ja,en}/blueprint/core/020_governance_rules.md`.

---

## [1.14.0] — 2026-06-09

### セキュリティ認証スタックの新設とフレームワーク整合 / Security Authentication Stack & Framework Consistency

高セキュリティ認証〜認可〜MCP セキュリティの Universal Rules を 6 ファイル新設し（Universal ルール 39→45）、併せてフレームワーク全体の文言・整合を是正した。市場調査（一次情報・最新標準）と敵対的レビューを反映。既存 `security/000_security_privacy.md` は概要を保持し、深掘りはクロスリファレンスで分離（二重定義回避）。Universal Rules 変更はユーザーの明示承認に基づく。/ Adds six new authentication→authorization→MCP security Universal Rules (39→45 files) and a framework-wide wording/consistency pass, informed by primary-source market research and adversarial review.

### Added

- **`security/400_authentication_and_passkeys.md`（ja/en）** — パスキー/WebAuthn(L2 REC/L3 CR)/FIDO2、MFA/2FA（TOTP・Number Matching・ハードウェアキー・SMS非推奨）、NIST SP 800-63B/-4 パスワードポリシー、パスワードレス移行、クレデンシャルライフサイクル、アカウントリカバリー、CIAM↔Workforce、CXP/CXF / Authentication credentials & passkeys deep-dive
- **`security/410_federated_identity_and_oauth.md`（ja/en）** — OAuth 2.1（IETFドラフト、ベースライン RFC 9700）、PKCE/PAR/RAR/DPoP、OIDC・ID Token検証・JWKS、Google/Apple/Microsoft/GitHub 連携、SSO（SAML/OIDC）、リフレッシュローテーション+再利用検知、consent/device-code phishing、FedCM / Federated identity & OAuth/OIDC
- **`security/420_step_up_auth_and_sensitive_operations.md`（ja/en）** — acr/amr・AAL、ステップアップ/再認証、リスクベース/CAEP/SSF、OTP/マジックリンク、トランザクション署名（WYSIWYS/PSD2 SCA）、重要操作ゲート、セッション管理、侵害時 Kill Switch、列挙防止 / Step-up authentication & sensitive operations
- **`security/430_authorization_and_access_control.md`（ja/en）** — PDP/PEP・deny-by-default、RBAC/ABAC/ReBAC、Google Zanzibar（OpenFGA/SpiceDB）、Policy as Code（Cedar/OPA）、decision log、マルチテナント/RLS / Fine-grained authorization
- **`security/440_workload_and_agent_identity.md`（ja/en）** — 非人間ID/ワークロード（SPIFFE/SPIRE・WIF・M2M・Zero Standing Privilege）、AIエージェント認証/委任（Tier-0・OBO via RFC 8693・委任チェーン制限・MCP/XAA） / Non-human, workload & AI-agent identity
- **`security/450_mcp_security.md`（ja/en）** — MCP セキュリティ（使う側＋作る側、仕様 2025-11-25）。OAuth 2.1 Resource Server・RFC 9728/8707・token passthrough禁止（Confused Deputy）・Origin/DNSリバインディング対策・tool annotations・実行隔離・rug pull/tool poisoning検知・人間承認 / MCP security, consumer + builder sides

### Changed

- **フレームワーク全体の文言是正（#52）** — 断言・完璧防止・誇張表現を「リスク低減・最低品質の底上げ・多領域」に即した表現へ、en 側の日本語固有内容を Project Native Language / CJK へ一般化、採番（予約帯なし・000非必須・初期8フォルダは開いた集合）とロード/結晶化の仕様境界を明確化（AXIARCH §3/§4/§12）。XSS の MUST 強度回復・文の長さ上限の回復・採番表現統一を含む / Framework-wide wording & consistency pass
- **`security/000_security_privacy.md`（ja/en）** — §4・§18.3 に深掘りファイル（400–450）へのクロスリファレンス NOTE を追加（要約は保持・de-dup）
- **`axiarch-rules/{ja,en}/INDEX.md`** — security セクションに 400–450 の 6 行を追加
- **`README.md` / `llms.txt` / `llms-full.txt`** — Universal 件数 39→45、README ドメイン表 Security 4→10、llms-full security 4→10 files に更新し 400–450 を列挙
- **`axiarch-rules/{ja,en}/universal/security/200_oss_compliance.md` / `300_ip_due_diligence.md`** — ja/en 見出し対称を同期
- **version 1.13.1 → 1.14.0** — init.sh / axiarch-manifest.json / llms / blueprint INDEX / upgrade 例示 / safe_upgrade prompt を同期

### References

- 一次情報: W3C WebAuthn L2/L3, FIDO CTAP 2.2 / CXP-CXF, RFC 9700 (OAuth Security BCP), RFC 9449 (DPoP), RFC 9126 (PAR), RFC 9396 (RAR), RFC 8693 (Token Exchange), RFC 8707 (Resource Indicators), NIST SP 800-63-4, OpenFGA/SpiceDB/AWS Cedar/OPA, SPIFFE/SPIRE, MCP Authorization 仕様 2025-11-25
- PR #52（文言是正）/ #53（認証スタック）を本リリースに集約

---

## [1.13.1] — 2026-06-08

### Restore Language First Enforcement / Language First（指定言語遵守）の強制力を復元

採用先からの「指定言語（日本語）対応が弱くなった」報告を調査した結果、#46 の正本化（AGENTS.md → AXIARCH.md）で、旧 AGENTS.md §2「Language First」の **AI 応答面への強制力と違反条項が希薄化**していたことを確認。AXIARCH.md では §6.10 Preserved Invariants の 1 行に格下げされ、しかも「owner-facing 計画・証跡・仕様・監査・walkthrough・承認依頼」という**文書種別の列挙**に留まり、**AI のユーザー応答（見出し・要約・ラベル・箇条書き・表）を明示的に強制していなかった**。これは §6.10 自身の非劣化原則（旧来より厳しいルールは置換境界を明示しない限り保持）に反する regression。本リリースで復元する。

Fixes a regression found via adopter feedback ("native-language adherence weakened"): the #46 canonicalization (AGENTS.md → AXIARCH.md) diluted the old AGENTS.md §2 "Language First" enforcement. In AXIARCH.md it had been reduced to a single §6.10 Preserved-Invariants row that only listed owner-facing document types and did not explicitly bind the agent's user-facing response (headings, summaries, labels, lists, tables). This violated §6.10's own non-degradation principle, and is restored here.

### Fixed

- **AXIARCH.md §6.10 Preserved Invariants** — 「Language discipline」行を「**Language First（response + documents）**」に強化。Project Native Language が、AI のユーザー向け応答（**その中のすべての見出し・要約・ラベル・箇条書き・表を含む**）と各種文書の言語を決めること、日本語時に英語の見出し・要約・ラベル・節タイトルを出すのは**プロトコル違反**であること、code/API/log/path/外部ツール慣習は例外であることを明記（ja/en）/ Strengthens the Language invariant to bind the agent response surface and mark English mixing as a protocol violation
- **`axiarch-scripts/axiarch-boot-reminder.sh`** — 毎ターン発火する UserPromptSubmit reminder の言語条項を同趣旨で強化（応答の全見出し・要約・ラベル・箇条書き・表 + 違反明記 + code/API/log/path 例外、ja/en）。正本 §6.10 と reminder の文言を一致させる / Strengthens the per-turn reminder's language clause to match the restored canonical rule
- **`axiarch-scripts/axiarch-boot-reminder.sh`（Harness 喚起の復元）** — reminder が AXIARCH.md §8 で「非自明な作業に必須」とされる Execution Harness を **一度も言及していなかった**（`grep -ci "harness" = 0`）gap を修正。CORE_REMINDER / SHORT_REMINDER 双方に、L2 以上のタスクで axiarch-harness/ の Execution Harness（ロールパス・監査判定・証跡パケット・人間承認ゲート。サブエージェント委任は任意で最終判断はメインエージェント保持）を適用するトリガーを追加（ja/en）。実行ハーネス（hooks）自体は機能していたが、エンジニアリング層（axiarch-harness/）が reminder から喚起されず休眠していたギャップを解消 / Adds an Execution Harness trigger to both reminder bodies, closing a gap where the per-turn reminder never referenced the harness despite §8 marking it mandatory for non-trivial work
- **`axiarch-harness/{ja,en}/EXECUTION_HARNESS_PROTOCOL.md`（正本根拠）** — 「§8 の『非自明な作業』= タスクレベル L2 以上」という対応をタスクレベル表直後に明記。reminder の「L2+」表現が reminder 単独の解釈ではなく、ハーネス層の SSOT に裏付けられるようにする（ja/en）/ Anchors the "non-trivial (§8) = L2+" mapping in the harness protocol so the reminder's "L2+" wording has a canonical source
- **`axiarch-scripts/check-axiarch-health.sh`（Check 16 追加・15→16 段階）** — reminder が (A) Language First（応答全域の言語強制 + 違反条項）と (B) Execution Harness 喚起を **ja/en 両方で保持**しているかを検査する Check 16 を新設。将来の編集でこれらが silent に削除/劣化した場合に `EXIT_CODE=1` で検出し、#46 型 regression の再発を防ぐ（負のテストで劣化検出を確認済み）。診断段階数を 15→16 へ更新し、`init.sh` / `README.md` / `axiarch-scripts/README.md` の現行カウント表記と Check 15 の parity grep アンカー（`16 段階` / `16-stage`）も同期 / Adds Check 16 verifying the reminder retains the Language First and Execution Harness invariants in ja/en (EXIT_CODE=1 on silent removal), bumps the diagnostic from 15 to 16 stages, and syncs the count across init.sh, README files, and the Check 15 parity anchors
- **`llms.txt` / `llms-full.txt`（Language First 取り残しの解消）** — AI 向け正本ダイジェストの「Project Native Language」記述が #46 由来の弱い表現（文書種別の列挙のみ）のまま残存していたため、§6.10 と同趣旨に強化（応答の全見出し・要約・ラベル・箇条書き・表への強制 + 日本語時の英語混入を違反と明記）。`llms.txt` の Execution Harness 項に「非自明 L2+ で必須」を追記 / Strengthens the Project Native Language entry in the AI-facing digests to match §6.10 (response-surface enforcement + violation), closing the same regression left behind in llms files; notes the harness is mandatory for non-trivial (L2+) work
- **Check 16 アンカーの堅牢化** — 言語違反アンカーを節固有の `a protocol violation` / `プロトコル違反です` に絞り、task.md ロード記録文（`treated as protocol violations` / `プロトコル違反として扱われます`）への誤マッチによる偽陰性を排除。remediation に `init.sh` 再実行案内を追加 / Tightens the Check 16 language-violation anchors to clause-specific phrases to eliminate a false-negative against the unrelated task.md sentence, and adds init.sh remediation guidance

### References

- 旧 AGENTS.md §2 Japanese Language First Protocol（厳格）/ AXIARCH.md §6.10 非劣化互換（より厳しい解釈の保持）
- regression 起点: #46 refactor(protocol): canonicalize axiarch entrypoint and harness

---

## [1.13.0] — 2026-06-08

### Prompt Slash Commands for Claude Code / プロンプトの Claude Code スラッシュコマンド化

`axiarch-prompts/` がコピペ運用のみで `/` から呼び出せなかった摩擦を解消し、プロンプトを Claude Code の native slash command（`/axiarch-*`）として生成する仕組みを追加。コマンド本体は正本プロンプトを Read して実行する thin pointer で、プロンプトを single source of truth として常に最新参照する。各エージェントの機構を authoritative に検証した結果、project-level の native slash command が確実に動くのは Claude Code のみ（Codex の custom prompts は global-only かつ deprecated、Antigravity の workflow は project-file 規約未文書化）であるため、Claude Code 向けのみ生成し、他はコピペ/AGENTS 運用を案内する。

Adds generation of Claude Code native slash commands (`/axiarch-*`) from the prompt library, removing the copy-paste-only friction. Each command is a thin pointer that Reads and executes the canonical prompt file. Only Claude Code has a reliable project-level native slash-command mechanism (Codex custom prompts are global-only/deprecated; Antigravity workflow project-file conventions are undocumented), so commands are generated for Claude Code only.

### Added

- **`axiarch-scripts/axiarch-prompts-install.sh`** — `axiarch-prompts/{lang}/{category}/*.md` から `.claude/commands/axiarch-<name>.md`（`/axiarch-<name>`）を生成する installer。冪等（マーカー付き生成物のみ再生成、採用先独自コマンド不可侵）、bilingual（`--lang ja|en|auto`）、`--clean`/`--dry-run`、pure bash / jq 非依存 / Generates Claude Code slash commands from the prompt library; idempotent, bilingual-aware, `--clean`/`--dry-run`, pure bash
- **init.sh opt-in** — プロンプトライブラリをコピーし、かつ Claude Code を選択した場合のみ slash command 生成を質問・実行 / Offers generation only when the prompt library is copied and Claude Code is selected

### Changed

- **docs（README / blueprint INDEX ja+en / axiarch-prompts README / axiarch-scripts README）** — 呼び出し方法（slash command / コピペ）とエージェント別対応を明文化 / Documents invocation methods and per-agent support
- **`.gitignore`** — `.claude/commands/axiarch-*.md` は v1.12.1 で既に追跡対象外（generator が source of truth）/ Already excluded since v1.12.1

### References

- 機構検証: Claude Code `.claude/commands/*.md`（公式・project-level）/ Codex custom prompts は global-only・deprecated / Antigravity workflow は project-file 規約未文書化
- 次の発展（ROADMAP 戦略フォーキャスト #1）: Agent Skills (SKILL.md) 標準への移行で progressive disclosure + マルチツール移植性

---

## [1.12.1] — 2026-06-08

### Fixed

- Treats Harness Engineering follow-up work as a patch release after the existing `v1.12.0` tag instead of overwriting the release tag.
- `axiarch-harness/{ja,en}/EXECUTION_HARNESS_PROTOCOL.md` now explicitly states that Harness Engineering applies the three-layer model to task execution and is not a fourth rule layer.
- `axiarch-scripts/axiarch-upgrade.sh` now keeps the `execution_harness` fallback group label aligned with `Execution Harness / Harness Engineering` when manifest metadata is unavailable.
- Safe Upgrade temporary helper examples and `axiarch-upgrade.sh` usage examples now point to `v1.12.1`, preventing users from following a stale `v1.12.0` execution path.
- `check-axiarch-health.sh` now verifies Harness Engineering wording, the Safe Upgrade fallback label, current-release Safe Upgrade helper pins, and upgrade helper usage examples, preventing the same documentation drift from returning.

### Changed

- `init.sh`, `axiarch-manifest.json`, README, llms files, scripts README, Safe Upgrade prompts, Blueprint indexes, and roadmap metadata now point the current stable release to `v1.12.1`, while preserving `v1.12.0` as the historical AXIARCH canonical entrypoint and Harness Engineering introduction release.

---

## [1.12.0] — 2026-06-08

### AXIARCH Canonical Entrypoint / AXIARCH正本入口

`AXIARCH.md` をAxiarchの正本入口として追加し、`AGENTS.md` / `CLAUDE.md` / `.agents/rules/prompt_pointer.md` / Cursor / Copilot / Windsurf向けファイルを `AXIARCH.md` だけを指す薄いアダプターへ整理。

Adds `AXIARCH.md` as the canonical Axiarch entrypoint and turns `AGENTS.md`, `CLAUDE.md`, `.agents/rules/prompt_pointer.md`, Cursor, Copilot, and Windsurf files into thin adapters that point only to `AXIARCH.md`.

### Harness Engineering / ハーネスエンジニアリング

v1.12.0は、単なる `axiarch-harness/` ディレクトリ追加ではなく、Axiarchにハーネスエンジニアリングを導入するリリースです。Execution Harnessは第4のルール層ではありません。Universal / Blueprint / Prompts の3層を、実行順序、監査Verdict、役割パス、証跡パケット、人間承認境界、任意のサブエージェント委任へ接続する運用工学として位置づけます。

v1.12.0 is not just the addition of an `axiarch-harness/` directory. It introduces Harness Engineering into Axiarch. The Execution Harness is not a fourth rule layer; it is the operational engineering that connects Universal / Blueprint / Prompts to execution order, audit verdicts, role passes, evidence packets, human approval boundaries, and optional subagent delegation.

### Added

- `AXIARCH.md` — 正本入口、優先順位、Native Language / bilingual governance、実行ライフサイクル、人間承認境界、サブエージェント任意利用を定義
- `axiarch-harness/{ja,en}/` — Execution Harness、Audit Gate、Role Pass、Evidence Packet、Human Approval Gate、Subagent Delegationの6プロトコルを追加
- Harness Engineering concept — 3層ガバナンスを実務タスクの実行・監査・証跡・承認フローへ変換する概念として明文化

### Changed

- Tool pointer files are now adapters only and no longer duplicate direct `INDEX.md` / `LOADING_PROTOCOL.md` loading instructions.
- `CLAUDE.md` is classified as a pointer file in the upgrade manifest and fallback registry; `.claude/settings.json` remains in the hook group.
- The `agent_hooks` upgrade group label now explicitly covers native agent config because it also owns optional Claude memory templates.
- The README, scripts README, Safe Upgrade prompts, shared Operations Blueprint, and health checks now state or verify that non-interactive `--apply --yes` is only for human-approved reviewed plans, matching the Human Approval Gate.
- `init.sh`, `axiarch-manifest.json`, `axiarch-scripts/axiarch-upgrade.sh`, hook reminders, task-state helpers, and health diagnostics now recognize `AXIARCH.md` and `axiarch-harness/`.
- `AXIARCH.md` is treated as `mixed` / `review` in the Safe Upgrade manifest because it contains adopter-owned `Project Native Language`; safe-only upgrades must not silently reset that project setting.
- `check-axiarch-health.sh` now verifies the `AXIARCH.md` mixed/review ownership boundary in both the manifest and embedded Safe Upgrade fallback defaults.
- `axiarch-rules/{ja,en}/INDEX.md`, `README.md`, `compliance_matrix.md`, `LOADING_PROTOCOL.md`, `blueprint/INDEX.md`, `blueprint/core/010_project_lessons_log.md`, and `universal/core/{000,100,200}_*.md` now refer to `AXIARCH.md` as the canonical governance and Project Native Language source, while preserving `AGENTS.md` as a legacy fallback or thin adapter.
- `axiarch-prompts/{ja,en}/` now instructs agents to load `AXIARCH.md` as the core protocol. Safe Upgrade prompts preserve `AGENTS.md` only as a legacy fallback and mixed-ownership adapter path.
- Safe Upgrade prompts now keep their top-level usage text, temporary-helper examples, and Hybrid Autonomous Boot Sequence aligned; they no longer describe the old standby-first flow while later requiring autonomous context loading.
- Single-language setup guidance now includes `axiarch-harness/{unused-lang}/` alongside `axiarch-rules/{unused-lang}/` and optional `axiarch-prompts/{unused-lang}/` so the new harness layer is not forgotten during intentional language pruning.
- `CRYSTALLIZATION_PROTOCOL.md`, Lessons Log cross-references, `INDEX.md` Antigravity pointer descriptions, and README pointer explanations now route through `AXIARCH.md` instead of treating `AGENTS.md` or direct `axiarch-rules/` links as the active entrypoint.
- `init.sh` and `axiarch-manifest.json` now use `1.12.0` for the finalized AXIARCH.md / harness release, default stable installs to `tags/v1.12.0`, allow explicit `AXIARCH_REF=heads/main` mainline installs, and gracefully fall back to the legacy AGENTS.md entrypoint when an older pinned tag does not contain `AXIARCH.md` or `axiarch-harness/`.
- `check-axiarch-health.sh` source release-file tracking now includes `AXIARCH.md` and the `axiarch-harness/` protocol files so new canonical-entry assets cannot be left as untracked working-tree files before commit or release.
- `AXIARCH.md`, `llms.txt`, and `llms-full.txt` now explicitly preserve former AGENTS protocol boundaries for Project Native Language, DB integrity, SSOT and branch discipline, self-completion, existing behavior protection, diff-based editing, task evidence, human approval, and crystallization.
- `init.sh` now preserves unselected native agent configs instead of deleting them during single-agent setup, so `.agents/`, `.cursor/`, `.claude/`, `.codex/`, `.github/copilot-instructions.md`, and `.windsurfrules` can safely coexist as adapter entrypoints unless the operator explicitly removes them.
- `init.sh` now writes the selected Project Native Language into the copied `AXIARCH.md`; legacy pinned releases without `AXIARCH.md` still fall back to configuring `AGENTS.md`.
- `init.sh` prerequisite checks now include the commands used by `AXIARCH.md` Project Native Language rewriting, and health diagnostics verify that installer boundary.
- Safe Upgrade prompts now keep the v1.11.2 multi-agent fix while adopting `AXIARCH.md`: they detect Google Antigravity through `.agents/rules/prompt_pointer.md`, detect Codex through `.codex/hooks.json`, infer `--agent all` when multiple agents are present, and `check-axiarch-health.sh` verifies those boundaries.
- `check-axiarch-health.sh` now verifies ja/en numbered-heading parity across `axiarch-rules/`, `axiarch-harness/`, and `axiarch-prompts/`, so one-language section compression or missing numbering aliases is caught before release.

### Compatibility

- `AGENTS.md` remains present for Codex and AGENTS.md-compatible tools, but it is now a compatibility adapter.
- Subagents are optional. If unavailable, the main agent performs the same role passes sequentially.
- Release finalization changes only release metadata and the installer default distribution ref; adopter compatibility remains preserved through the `AGENTS.md` adapter and legacy pinned-tag fallback.

---

## [1.11.2] — 2026-06-03

### Multi-Agent Detection Fix for Safe Upgrade / Safe Upgrade のマルチエージェント検出修正

`safe_upgrade_execute.md` の agent auto-detection が、Antigravity を **`.antigravity/`**（どの採用先にも生成されない誤った path）で検出しようとしていたため、Antigravity 採用先で永久に検出されず upgrade の選択肢に出ない不具合を修正。あわせて、複数 agent を併用するプロジェクト（例: codex+claude+antigravity の inucomi）で単一 agent を選ぶと他 agent の hook が更新計画から漏れて stale 化する構造的問題に対し、**併用検出時は `--agent all` を推奨**する設計へ改善した。

Fixes a bug where `safe_upgrade_execute.md` tried to detect Antigravity via `.antigravity/` — a path no adopter ever generates — so Antigravity adopters were never detected and never appeared as an upgrade choice. Also addresses the structural problem where, for multi-agent projects (e.g. inucomi running codex+claude+antigravity), selecting a single agent drops the other agents' hooks from the upgrade plan and lets them go stale, by recommending **`--agent all` when multiple agents are detected**.

### Fixed

- **Antigravity 検出シグナルの誤り** — `safe_upgrade_execute.md`（ja/en）の auto-detection が `.antigravity/` を見ていたのを、`init.sh` が実際に生成する代表ファイル **`.agents/rules/prompt_pointer.md`** に修正。codex は `.codex/`（ディレクトリ）から `.codex/hooks.json`（代表ファイル）へ統一し、claude（`.claude/settings.json`）と粒度を揃えた / Corrects the Antigravity detection signal from the non-existent `.antigravity/` to the `init.sh`-generated `.agents/rules/prompt_pointer.md`, and unifies all three agents to their representative generated file

### Changed

- **マルチエージェント併用の設計** — auto-detection は 3 代表ファイルを全確認して存在 agent を全列挙。1 つ検出→その agent / 2 つ以上検出（併用）→`--agent all`（単一指定は他 agent の hook を計画から落として stale 化させるため禁止）。`--safe-only` 下では未使用 agent（cursor/copilot/windsurf）の pointer は `add` 状態でも REVIEW 可視化のみで書込されないことを `path_status` + `execute_item` の挙動から確認・明文化。Phase 1 / Step 2 / Edge Cases の 3 箇所に併用ガイダンスを追加（ja/en）/ Redesigns multi-agent handling: enumerate all present agents; one → that agent, two+ → `--agent all`. Documents that `--safe-only` never writes unused-agent pointers

### Compatibility

- ✅ **後方互換 100%** — 単一 agent 採用先の挙動は不変（検出シグナルが正確化されただけ）。Safe Upgrade Wizard 本体（`axiarch-scripts/axiarch-upgrade.sh`）のロジック・フラグは不変。prompt 文言のみの改善 / Fully backward compatible; single-agent behavior unchanged, wizard logic untouched (prompt-text-only)
- ✅ **Universal Rules 不変** — 変更は `axiarch-prompts/develop/`（mutable layer）のみ。憲法改正なし / No constitution changes

### References

- 採用先実態: inucomi（codex + claude + antigravity 併用）での Antigravity 検出漏れ報告
- 挙動実証: `axiarch-upgrade.sh` `path_status`（source 有・target 無 = `add`）+ `execute_item`（safe-only で owner=axiarch policy=review は `REVIEW safe-only excluded`、書込なし）

---

## [1.11.1] — 2026-06-02

### Hybrid Autonomous Boot Sequence for Safe Upgrade / Safe Upgrade の自律実行ブート化

`axiarch-prompts/{ja,en}/develop/safe_upgrade_execute.md` の Boot Sequence を、user が 5 項目（アップグレード先 / エージェント / 言語 / 適用方針 / 任意層）を手動入力する旧 **Stop & Wait** モードから、AI が context（`.axiarch/version.json` / `AGENTS.md` の `Project Native Language` / `.claude/settings.json` / `axiarch-manifest.json`）から自律推定して進める **Hybrid Autonomous Execution** モードへ変更。dry-run 結果確認と apply 明示承認の 2 段安全フェンスで誤選択リスクを削減する。実採用先（chronoviq）での自律実行成功事例を規格化したもの。

Changes the `safe_upgrade_execute.md` Boot Sequence from the legacy **Stop & Wait** mode (which required users to manually input five items) to a **Hybrid Autonomous Execution** mode where the AI auto-detects context (`.axiarch/version.json`, `Project Native Language` in `AGENTS.md`, `.claude/settings.json`, `axiarch-manifest.json`). Two safety fences (dry-run review and explicit apply approval) reduce mis-selection risk. Standardizes the autonomous-execution success pattern observed in a real adopter project.

### Changed

- **`axiarch-prompts/{ja,en}/develop/safe_upgrade_execute.md` Boot Sequence** — 旧 Stop & Wait（5 項目手動入力）を廃止し、6 Step の Hybrid 構造（Step 1 Phase 0 即 context load → Step 2 Phase 1 自動推定 → Step 3 推定結果提示 + dry-run 承認 = 安全フェンス 1 → Step 4 dry-run 自律実行 → Step 5 dry-run 結果提示 + apply 承認 = 安全フェンス 2 → Step 6 apply 自律実行）へ書き換え。安全境界（apply / `--with-prompts` / mixed ownership 書込 / `git push` 等は明示承認必須、Phase 0/1/3 dry-run と health check は自律 OK）、Edge Cases（同 version スキップ / 複数版跨ぎ警告 / baseline 不在 / 複数 agent 検出 / release 取得失敗）、旧 Stop & Wait への明示 fallback を明文化 / Replaces the legacy Stop & Wait flow with a six-step Hybrid structure, documents the autonomous-execution safety boundary, edge cases, and an explicit fallback to the legacy mode (PR #43)

### Compatibility

- ✅ **後方互換 100%** — 旧 Stop & Wait モードは user 明示指示時の fallback として残存。Safe Upgrade Wizard 本体（`axiarch-scripts/axiarch-upgrade.sh`）のロジック・フラグは不変。prompt 文言のみの改善 / Fully backward compatible; legacy mode remains as an explicit fallback, and the Safe Upgrade Wizard logic is unchanged (prompt-text-only improvement)
- ✅ **Universal Rules 不変** — 変更は `axiarch-prompts/develop/`（mutable layer）のみ。憲法改正なし / No constitution changes

### References

- 実証元 / Source pattern: 採用先プロジェクト chronoviq の Safe Upgrade Wizard 経由 v1.11.0 自律適用（manifest 駆動 owner 判定 + dry-run → apply 2 段 + Project State 非破壊保持 + CI 全 PASS）

---

## [1.11.0] — 2026-05-18

### Native Task State Sync / ネイティブタスク状態同期

`task.md` / `implementation_plan.md` / `walkthrough.md` が長期セッションで古い内容を無制限に蓄積する問題に対し、3ファイルを「現在タスクのMarkdown証跡」として扱い、過去内容はarchive-before-refreshで退避するライフサイクルを追加。さらに、Markdown証跡だけではCodexやClaude Codeのネイティブなタスク・プラン表示欄が更新されないため、各ランタイムのネイティブツールを併用する責務を明文化。

Adds a lifecycle that treats `task.md` / `implementation_plan.md` / `walkthrough.md` as current-task Markdown evidence and archives previous content before refresh, addressing indefinite accumulation in long agent sessions. It also clarifies that Markdown evidence does not update Codex or Claude Code native task/plan panels by itself, so agents must update native runtime state in parallel.

### Added

- **`axiarch-scripts/axiarch-task-state.sh`** — `task.md` / `implementation_plan.md` / `walkthrough.md` を現在タスク用に生成し、変更済みの既存内容を `.axiarch/process-doc-history/` へ退避する補助スクリプトを追加。`AXIARCH_PROCESS_DOC_MODE=append` で従来追記運用を明示維持でき、`AXIARCH_PROCESS_DOC_ARCHIVE=0` と `AXIARCH_PROCESS_DOC_HISTORY_DIR` で退避挙動を調整可能。`AXIARCH_PROCESS_DOC_LANG=auto|ja|en` により、`AGENTS.md` の `Project Native Language` に合わせたテンプレート生成、または明示言語指定に対応 / Adds a helper that refreshes `task.md` / `implementation_plan.md` / `walkthrough.md` as current-task documents and archives changed previous content under `.axiarch/process-doc-history/`. `AXIARCH_PROCESS_DOC_MODE=append` explicitly preserves legacy append behavior; `AXIARCH_PROCESS_DOC_ARCHIVE=0` and `AXIARCH_PROCESS_DOC_HISTORY_DIR` tune archive behavior. `AXIARCH_PROCESS_DOC_LANG=auto|ja|en` generates templates in the `Project Native Language` from `AGENTS.md` or an explicit override
- **Native task-state contract** — Codexでは `update_plan` を併用し、作業中は `in_progress` を1件だけ維持する。Claude Codeでは `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` を優先し、古いSDK等でTask toolsが使えない場合のみ `TodoWrite` にフォールバックする責務をAGENTS/LOADING/README/llmsへ追加 / Adds the native task-state contract across AGENTS, LOADING, README, and llms: Codex uses `update_plan` with exactly one active `in_progress` step, while Claude Code prefers `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` and falls back to `TodoWrite` only in older runtimes without Task tools

### Changed

- **`axiarch-scripts/axiarch-init-task-md.sh`** — `task.md`単体のmissing-only bootstrapから、`axiarch-task-state.sh` 経由で3つの現在タスク文書をrefresh/archiveするSessionStart hookへ拡張。`additionalContext` にMarkdown証跡とネイティブタスク状態の責務分離を追加 / Extends the SessionStart hook from missing-only `task.md` bootstrap to three-document refresh/archive via `axiarch-task-state.sh`, and adds Markdown-vs-native task-state separation to `additionalContext`
- **`axiarch-scripts/axiarch-boot-reminder.sh`** — UserPromptSubmit reminderへ、Markdown証跡だけではネイティブUIが更新されないこと、Codex `update_plan` とClaude Code Task toolsを併用することを追加 / Adds reminder text clarifying that Markdown evidence alone does not update native UI, and that Codex `update_plan` plus Claude Code Task tools should be used when available
- **`axiarch-scripts/check-axiarch-health.sh`** — Check 12/15で `axiarch-task-state.sh` の配線、Project Native Language別テンプレート、`update_plan` / `TaskCreate` 語彙、README/llms/scripts README/LOADINGへのv1.11.0説明同期、release-critical追跡対象を検査 / Extends Check 12/15 to verify task-state helper wiring, Project Native Language templates, `update_plan` / `TaskCreate` wording, v1.11.0 doc parity across README, llms, scripts README, and LOADING, plus release-critical tracking
- **`init.sh` / `axiarch-manifest.json`** — 正式リリース版数を `1.11.0` へ更新し、`axiarch-task-state.sh` を配布後shell構文検証対象へ追加 / Updates release metadata to `1.11.0` and adds `axiarch-task-state.sh` to post-copy shell syntax validation
- **`.gitignore`** — `.axiarch/process-doc-history/` と `.axiarch/process-doc-state/` を追加し、現在タスク文書の退避・状態ファイルがリポジトリ管理対象へ混入しないようにした / Adds `.axiarch/process-doc-history/` and `.axiarch/process-doc-state/` so current-task archives and state hashes do not enter repository management

### Compatibility

- **後方互換性を維持** — 既定は現在タスク文書ローテーションだが、採用先が従来の追記運用を必要とする場合は `AXIARCH_PROCESS_DOC_MODE=append` で維持可能 / Backward compatible: current-task rotation is the default, while adopter projects that need legacy append behavior can set `AXIARCH_PROCESS_DOC_MODE=append`
- **ネイティブUI自動更新の誤認を回避** — AxiarchはMarkdown証跡を管理するが、Codex/Claude CodeのネイティブUIは各ランタイムのツール呼び出しがある場合のみ更新済みと扱う / Avoids overclaiming native UI automation: Axiarch manages Markdown evidence, but Codex/Claude Code native UI state is considered updated only when the relevant native tool has been called

## [1.10.0] — 2026-05-17

### Safe Upgrade Wizard / 安全アップグレード導線

既存プロジェクトにAxiarchの必要部分だけを移植できるように、Axiarch本体ファイル、Axiarch共有Blueprint、プロジェクト固有Blueprint、任意ファイルを分別するマニフェストと対話式アップグレード補助スクリプトを追加。

Added a manifest and interactive upgrade helper so adopter projects can merge only the needed Axiarch changes while separating Axiarch-shared Blueprint rules from project-owned Blueprint state.

### Added

- **`axiarch-manifest.json`** — Axiarch所有ファイル、Axiarch共有Blueprint、プロジェクト固有Blueprint、任意ファイル、本体リポジトリ専用ファイルの所有境界と既定更新方針を定義。Project Stateの広域globには `exclude` を持たせ、明示管理済みテンプレートや共有Blueprintを二重分類しない。READMEで採用先不要と説明するリポジトリ管理用ファイルとセットアップ用 `init.sh` も `source_docs` / `skip` として分類 / Defines ownership boundaries and default update policies for Axiarch-owned files, Axiarch-shared Blueprint rules, project-owned Blueprint state, optional files, and source-repository-only files. The broad Project State glob carries `exclude` entries so explicitly managed templates and shared Blueprint rules are not double-classified. Repository-management files described as not needed by adopter projects in the README and the setup installer `init.sh` are also classified as `source_docs` / `skip`
- **`axiarch-scripts/axiarch-upgrade.sh`** — `--dry-run` / `--safe-only` / `--interactive` / `--apply` に対応した Safe Upgrade Wizard。`axiarch-manifest.json` の `files` / `groups` / `exclude` を読み、グループごとに `preserve（保持・上書きしない）`、`show-diff（差分だけ表示）`、`update-all（すべて更新）`、`review-each（ファイルごとに確認）`、`skip（今回はスキップ）` を選択可能。default actionと固定候補が重複しないよう、対話選択肢は動的に表示。`jq` がない環境では内蔵既定リストへフォールバック / Adds a Safe Upgrade Wizard with dry-run, safe-only, interactive, and apply modes. It reads `files`, `groups`, and `exclude` from `axiarch-manifest.json`, supports bilingual group-level choices with deduplicated interactive action options, and falls back to embedded defaults when `jq` is unavailable
- **`axiarch-prompts/{ja,en}/develop/safe_upgrade_execute.md`** — 既存Axiarch採用プロジェクトでSafe Upgrade WizardをAIエージェントに実行させるための専用プロンプトを追加。直接ロード、dry-run first、Project State保持、source-only既定skipと明示選択、mixed ownershipレビュー、検証、報告を標準化 / Adds dedicated prompts for having AI agents execute the Safe Upgrade Wizard in existing Axiarch adopter projects, standardizing direct loading, dry-run first execution, Project State preservation, source-only default skip with explicit selection, mixed-ownership review, verification, and reporting
- **`axiarch-rules/{ja,en}/blueprint/operations/010_release_upgrade_operations.md`** — v1.9.0以降の実運用で発生したCHANGELOG整合、Safe Upgrade dry-run、interactive入力、local-onlyファイルレビュー、source-only既定skipと明示選択、対話選択肢重複排除の教訓を運用Blueprintへ昇華 / Crystallizes real v1.9.0+ operations lessons into the Operations Blueprint: CHANGELOG parity, Safe Upgrade dry-runs, interactive input, local-only file review, source-only default skip with explicit selection, and deduplicated interactive choices

### Changed

- **`init.sh`** — `AXIARCH_VERSION` を正式リリース用の `1.10.0` へ更新し、既定refを `tags/v1.10.0` に設定。`axiarch-manifest.json` と `axiarch-upgrade.sh` を配布対象および構文検証対象に追加し、導入メタデータとして `.axiarch/version.json` を作成。既存Axiarch導入先を検出した場合は通常インストール前にSafe Upgrade Wizardのdry-runへ誘導し、明示続行しない限りコピー前に停止する。古い採用先に `axiarch-upgrade.sh` が未導入の場合はタグ固定の一時ヘルパー取得手順を提示し、非対話EOF時も既定 `N` として安全に停止する。明示続行時も `axiarch-rules/` と `axiarch-prompts/` は内容コピーにし、同名ディレクトリの入れ子化を避ける。エージェント選択順を主対象の Codex / Claude Code / Antigravity に揃え、hook診断案内を Codex / Claude Code のhook導入時とその他の任意診断で分ける / Sets `AXIARCH_VERSION` to stable release version `1.10.0`, defaults the install ref to `tags/v1.10.0`, distributes the manifest and upgrade helper, validates the new script, writes `.axiarch/version.json`, detects existing Axiarch installations before full install, points operators to the Safe Upgrade Wizard dry-run, stops before copying unless explicitly continued, prints a tag-pinned temporary-helper bootstrap path when older adopters do not have `axiarch-upgrade.sh`, treats non-interactive EOF as safe default `N`, copies `axiarch-rules/` and `axiarch-prompts/` contents to avoid nested same-name directories, aligns the agent choice order to Codex / Claude Code / Antigravity, and separates hook diagnostics from optional diagnostics for non-hook setups
- **`axiarch-scripts/check-axiarch-health.sh`** — Axiarch本体リポジトリで `init.sh` / `axiarch-manifest.json` / `CHANGELOG.md` / README / llms のv1.10.0整合、Safe Upgrade Wizardのmanifest配線・exclude処理・source-only既定skipとinteractive明示override・対話選択肢重複排除・本体リポジトリ専用ファイル分類・`replace-if-local-unchanged` 実行時保護とreasonラベル・ファイル/ディレクトリ型不一致review・upgrade metadata版数正規化・fallback core Blueprint検出・任意prompt証跡、safe upgrade実行promptのREADME/llms/rules索引、Blueprint INDEXのリリース・アップグレード運用Blueprint登録と版数、README/llms/scripts READMEの `axiarch-scripts/` 必須/任意境界、v1.10.0中核ファイルのGit追跡状態を検査するリリース版メタデータチェックを追加。Claude Code / Codex hook設定が未導入のプロジェクトでは任意hook層として扱い、hook未導入のみで失敗にしない / Adds release metadata parity checks for v1.10.0 across `init.sh`, `axiarch-manifest.json`, `CHANGELOG.md`, README, and llms, plus Safe Upgrade Wizard manifest-wiring, exclude handling, source-only default skip with explicit interactive override, deduplicated interactive choices, source-repository-only file classification, `replace-if-local-unchanged` runtime protection with reason labels, file/directory type-conflict review logging, upgrade metadata version normalization, fallback core Blueprint discovery, optional prompt evidence hashing, safe-upgrade execution prompt indexing checks across README, llms, and rules indexes, Blueprint INDEX release-upgrade operations registration and version metadata, required/optional boundary checks for `axiarch-scripts/` in README, llms, and scripts README, and source release-file Git tracking in the Axiarch source repository; hook absence is treated as an optional hook layer when Claude Code / Codex hook settings are not installed
- **`axiarch-scripts/axiarch-upgrade.sh`** — 不正な `--agent` 値をエラー化し、dry-run中の3-way merge競合では `.axiarch/conflicts/` へ書き込まないよう修正。`--source` 指定時のupgrade metadataはsource manifestの `axiarchVersion` を採用し、`--to vX.Y.Z` や `--ref tags/vX.Y.Z` 由来のタグ接頭辞 `v` はmetadata上で正規化。`--interactive` のグループ選択で内部のグループ一覧とユーザー入力が同じstdinを奪い合わないよう、ループ入力を別FDへ分離し、default actionと固定候補が重複しないよう対話選択肢を動的に組み立てる。確認入力がEOFになった場合はdefault Nとしてdry-runへ戻す。source-onlyファイルは既定skipを維持しつつ、interactiveで明示的に `show-diff` / `review-each` / `update-all` を選んだ場合だけ選択を尊重する。ディレクトリ更新時はsource側に存在しないlocal-onlyファイルを自動削除せず、`STALE-LOCAL` として表示し、sourceとtargetのファイル/ディレクトリ型が異なる場合は自動削除・置換せず `TYPE-CONFLICT` としてreviewへ倒し、`--apply` 時のみupgrade reportへ永続化する。`replace-if-local-unchanged` はtarget欠落時またはbase一致時のみ自動更新し、baseなし差分、base欠落、base不一致はreason付きでreviewへ倒す。metadata JSON値をエスケープ。manifestが読めない場合のfallbackでも、Axiarch共有BlueprintをProject State preserveに飲ませずレビュー対象に含め、将来の `core/{NNN}_*.md` をProject Stateとして保持し、`--with-prompts` 適用時は `axiarch-prompts/` をhash証跡に含める / Rejects invalid `--agent` values, avoids writing `.axiarch/conflicts/` during dry-run merge conflicts, uses the source manifest `axiarchVersion` for upgrade metadata when `--source` is used, normalizes tag-style `v` prefixes from `--to vX.Y.Z` or `--ref tags/vX.Y.Z` in metadata, separates group-list iteration from user stdin so `--interactive` group choices can read operator input correctly, builds deduplicated interactive action options so the default action is not repeated in the fixed candidate list, treats EOF confirmations as default N and returns to dry-run behavior, keeps source-only files skipped by default while respecting explicit `show-diff`, `review-each`, or `update-all` selections in interactive mode, reports source-missing local-only files as `STALE-LOCAL` instead of deleting them automatically, routes file/directory type mismatches to `TYPE-CONFLICT` review instead of automatic deletion or replacement, persists review evidence to the upgrade report only in `--apply` mode, applies `replace-if-local-unchanged` automatically only when the target is missing or matches the base and otherwise falls back to review with a reason label, escapes metadata JSON values, keeps Axiarch-shared Blueprint rules reviewable even in manifest fallback mode, preserves future `core/{NNN}_*.md` files as Project State, and hashes `axiarch-prompts/` when prompts are applied
- **`README.md` / `axiarch-scripts/README.md` / `llms.txt` / `llms-full.txt` / `ROADMAP.md` / `axiarch-rules/{ja,en}/INDEX.md` / `axiarch-rules/{ja,en}/README.md` / `axiarch-rules/{ja,en}/blueprint/core/README.md`** — 既存プロジェクト向けの安全アップグレード導線、必須/任意の所有境界、v1.10.0タグ固定の導入・更新手順を明記。READMEのHook補強説明をCodex / Claude Code両対応へ揃え、Google Antigravityのみ実務検証済みとして扱う表記へ補正 / Documents the safe-upgrade path for adopter projects, required/optional ownership boundaries, and the v1.10.0 tag-pinned install and upgrade flow. Aligns the README hook-reinforcement explanation with both Codex and Claude Code, while keeping Google Antigravity as the only production-validated target
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md` / `CRYSTALLIZATION_PROTOCOL.md`** — `INDEX.md` 参照の曖昧さと `core/020_` 固定に見える採番説明を補正し、ロード証跡・昇華採番の整合を明確化 / Clarifies INDEX path references and numbering guidance so load evidence and crystallized-rule numbering do not imply ambiguous paths or reserved blank bands
- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`** — 旧 `scripts/check-git-config-clean.sh` 参照を配布実態の `axiarch-scripts/check-git-config-clean.sh` へ修正 / Updates legacy `scripts/check-git-config-clean.sh` references to the distributed `axiarch-scripts/check-git-config-clean.sh` path

### Compatibility

- **プロジェクト固有Blueprintを既定保持** — `blueprint/core/000_project_overview.md`、`blueprint/core/010_project_lessons_log.md`、`blueprint/*/[0-9][0-9][0-9]_*.md` は既定で上書きしない / Project-owned Blueprint files are preserved by default
- **必須構成は維持** — 実行時の最小必須構成は引き続き `AGENTS.md` + `axiarch-rules/`。`axiarch-manifest.json` と `axiarch-upgrade.sh` は安全アップグレード用途の推奨ファイル / Minimal runtime setup remains `AGENTS.md` plus `axiarch-rules/`; the manifest and upgrade script are recommended for safe upgrades

## [1.9.0] — 2026-05-15

### 🧠 Memory Persistence & Glob-Scoped Rules / Memory Persistence と Glob-Scoped Rules 初期実装

v1.9.0前の価値最大化コミット（`0489174`）と分離し、Tier 2候補のうち運用検証しやすい機能群を正式リリースとして追加。Hook補強の4層化、Memoryテンプレート、Cursor globs導線、shellcheck CI、配布後構文検証、Check 15を導入。

Separated from the pre-v1.9 value-maximization commit (`0489174`) and released the Tier-2 functionality that can be validated in real workflows. This release introduces four-layer hook reinforcement, memory template, Cursor globs entrypoint, shellcheck CI, post-copy syntax validation, and Check 15.

### Added

- **`axiarch-scripts/axiarch-diff-guard.sh`** — `PostToolUse` hook用の差分ガードを追加。`Edit` / `MultiEdit` / `Write` 後にgit diffの変更行数と変更ファイル数を測定し、閾値超過時に `warn` / `block` / `off` を選択可能 / Added a PostToolUse diff guard that measures changed lines/files after Edit, MultiEdit, and Write; supports warn, block, and off modes
- **`.claude/settings.json` / `.codex/hooks.json`** — `PostToolUse` hookを追加し、`axiarch-diff-guard.sh` を Edit / MultiEdit / Write に配線 / Added PostToolUse hook wiring for `axiarch-diff-guard.sh`
- **`.claude/memory/MEMORY.md`** — Claude Code向けの任意Memory Persistenceテンプレートを追加。上位ルールを置換せず、実際に発生した再発防止事項だけを短く記録する設計 / Added an optional Claude Code memory template that does not replace higher-priority rules and stores only short notes from actual recurring issues
- **`.cursor/rules/axiarch.mdc`** — `globs: "**/*"` を明示し、path-scoped rules の将来仕様として `paths:` frontmatter導線を追加 / Declared `globs: "**/*"` and documented future `paths:` frontmatter for path-scoped rules
- **`.github/workflows/lint.yml`** — ShellCheck jobを追加し、`init.sh` と `axiarch-scripts/*.sh` をCIで静的解析 / Added ShellCheck CI for `init.sh` and `axiarch-scripts/*.sh`

### Changed

- **`axiarch-scripts/check-axiarch-health.sh`** — 14段階診断から15段階診断へ拡張。Check 15でv1.9.0 diff guard配線を検査し、Axiarch本体リポジトリでのみREADME系反映も検査 / Extended health diagnostics from 14 to 15 stages; Check 15 verifies v1.9.0 diff guard wiring and checks README integration only in the Axiarch source repository
- **`init.sh`** — `AXIARCH_VERSION` を正式リリース用の `1.9.0` へ更新。正式版は `tags/v${AXIARCH_VERSION}` を既定refにし、`AXIARCH_REF` で固定タグ導入を明示可能にしたうえで、タグ固定時は導入対象ラベルとインストーラー版を分けて表示。配布後 `bash -n` 検証とClaude memoryテンプレートの非破壊コピーも追加 / Set `AXIARCH_VERSION` to stable release version `1.9.0`. Stable builds default to `tags/v${AXIARCH_VERSION}`, and `AXIARCH_REF` can explicitly pin a release tag; when a tag is pinned, the install target label is shown separately from the installer version. Also added post-copy `bash -n` validation and non-destructive Claude memory template copy
- **`README.md` / `axiarch-scripts/README.md` / `llms.txt` / `llms-full.txt` / `ROADMAP.md`** — 4 hooks、15-stage診断、Memory Persistence、Glob-Scoped Rules、diff guardの説明へ更新 / Updated docs for four hooks, 15-stage diagnostics, Memory Persistence, Glob-Scoped Rules, and diff guard

### Compatibility

- **後方互換性を維持** — hooks、scripts、memory、prompts、agent pointerは引き続き任意または条件付き。必須構成は `AGENTS.md` と `axiarch-rules/` のまま / Backward compatibility maintained. Hooks, scripts, memory, prompts, and agent pointers remain optional or conditional; the required minimal setup is still `AGENTS.md` plus `axiarch-rules/`
- **動作保証なしの範囲を維持** — Google Antigravity以外の実務検証は継続中。Codex / Claude Codeは主対象、Cursor / Copilot / Windsurfは拡張ポインター候補 / Practical validation remains ongoing outside Google Antigravity; Codex and Claude Code are primary targets, while Cursor, Copilot, and Windsurf remain extended pointer candidates

---

## [1.8.2] — 2026-05-12

### ⚙️ Native Codex Environment Integration / Codex 環境ネイティブ対応

AxiarchのHook補強機構（Hook Reinforcement Mechanism）全体を拡張し、Claude Code (`.claude/settings.json`) と同等に Codex (`.codex/hooks.json`) を第一級サポートとしてネイティブ統合。

Expanded the entire Axiarch Hook Reinforcement Mechanism to natively integrate Codex (`.codex/hooks.json`) as a first-class citizen alongside Claude Code (`.claude/settings.json`).

### Added

- **`init.sh` — Codex setup support** — `SETUP_CODEX` フラグを追加し、`.codex/hooks.json` の自動初期化・検証・クリーンアップ機構を実装 / Added `SETUP_CODEX` flag to implement automatic initialization, validation, and cleanup for `.codex/hooks.json`
- **`.gitignore` — Codex global ignore patterns** — `.codex/worktrees/`, `.codex/projects/`, `.codex/hooks.local.json` をグローバル無視リストに追加 / Added Codex-specific directories to the global ignore list

### Changed

- **`check-axiarch-health.sh` — Dynamic Hook Validation** — ハードコードされていた `.claude/settings.json` の参照を削除し、`.claude/settings.json` と `.codex/hooks.json` の両方を動的に検知してフックの検証を行えるように改修 / Refactored to dynamically detect and validate either `.claude/settings.json` or `.codex/hooks.json`
- **`check-git-config-clean.sh` — Stale Branch Detection** — ゾンビブランチの検出ロジック（正規表現）を拡張し、`claude` だけでなく `codex` のステイルブランチも正しくクリーンアップできるように変更 / Expanded stale branch detection regex to clean up both `claude` and `codex` stale branches
- **`axiarch-protect-antifull.sh` — Whitelist Support** — §6 全文上書き禁止ルールのホワイトリストとして、`.claude/axiarch-overwrite-allow.txt` と `.codex/axiarch-overwrite-allow.txt` の両方をサポート / Supported both `.claude` and `.codex` overwrite allow-lists for §6 Anti-Full-Overwrite rules
- **`axiarch-rules/*/LOADING_PROTOCOL.md`** — 採用先プロジェクトに配置される標準フック定義ファイルとして `.codex/hooks.json` を追記 / Documented `.codex/hooks.json` as a standard hook configuration in the governance protocol

### Compatibility

- ✅ **後方互換性を維持** — 既存の Claude Code 環境に対する意図的な挙動変更なし / Backward compatibility maintained; no intended changes to existing Claude Code behavior

---

## [1.8.1] — 2026-05-11

### 🩹 Check 4 Codex 互換性 + Check 13 quiet mode バグ修正 + docs 訂正 / Check 4 Codex Compatibility + Check 13 Quiet-Mode Fix + Docs Corrections

41–42 ラウンド調査で発見した診断バグ 2 件 + ドキュメント記述訂正 3 件を patch release として bundling。いずれも `axiarch-scripts/check-axiarch-health.sh` の診断精度またはドキュメント整合性に影響する。

Two diagnostic bug fixes + three documentation corrections discovered in the 41st–42nd-round audits, bundled as a patch release. Both affect the diagnostic accuracy of `axiarch-scripts/check-axiarch-health.sh`.

### Fixed

- **Check 4 — Codex ランタイム検出の追加** — OpenAI Codex 環境（`CODEX_THREAD_ID` / `CODEX_CI` 環境変数、または `__CFBundleIdentifier == com.openai.codex`）では Claude Code セッションログ（`.claude/projects/*.jsonl`）が存在しないため、Check 4 が常に `[FAIL] Hook never fired` を返していた false-negative bug を修正。Codex 検出時は `[PASS] Codex runtime detected — Claude Code hook firing history is not applicable` を返す / Added Codex runtime detection to Check 4: in Codex environments the Claude Code session log (`.claude/projects/*.jsonl`) does not exist, causing a false `[FAIL] Hook never fired`. Now returns `[PASS] Codex runtime detected — not applicable` when Codex env vars are detected

- **Check 13 — `--quiet` モード時の verbose 出力バグ修正** — `--quiet` / `-q` フラグを指定した場合でも、Check 13 の `printf '%b' "${SUBLIMATED_FOUND}"` と `print_info` 2行がターミナルに出力されていた bug を修正（`if ! "${QUIET_MODE}"; then ... fi` で正しく抑制）。CI / pre-commit 連携での不要出力を解消 / Fixed Check 13 verbose output in `--quiet` mode: `printf` and two `print_info` lines were executing unconditionally; now wrapped in `if ! "${QUIET_MODE}"; then` to correctly suppress output in silent mode

### Documentation Corrections (42nd-round audit)

- **`axiarch-scripts/README.md` JA概要 「外部検証可能な 8 領域」 → 「10 領域以上」** — v1.5.1 当時の 10-stage 計上時の列挙数がそのまま残存。v1.8.0 で 14-stage に展開されたため「10 領域以上」に訂正。v1.8.0 Check D Task Boundary Detection 追加の言及も併せ追記 / Fixed stale "8 領域" (8 verifiable areas) count from v1.5.1 era; updated to "10 領域以上" and added v1.8.0 Check D mention

- **`CHANGELOG.md` v1.6.0 Out of Scope — `v1.7.0 (Tier 2)` 行の `(Check 14)` → `(Check 15)` + バージョン訂正** — Check 14 は v1.8.0 で実装済みのため次の未実装候補は Check 15。併せて履歴記録内の古い Tier 2 / Tier 3 ラベルを当時の次期候補枠へ訂正。現在のロードマップでは採用先アップグレード課題を優先し、Safe Upgrade Wizard を v1.10.0、Static Lint を v1.11.0 に再配分 / Fixed stale version labels in v1.6.0 Out of Scope: `(Check 14)` → `(Check 15)` (Check 14 shipped in v1.8.0); old Tier-2 and Tier-3 labels were moved to the then-next candidate slots. The current roadmap prioritizes adopter-upgrade needs by assigning Safe Upgrade Wizard to v1.10.0 and Static Lint to v1.11.0

### Compatibility

- ✅ **後方互換性を維持** — pure bug fix のみ、機能変更ゼロ。Codex 以外の環境（Antigravity / Claude Code / Cursor / Copilot / Windsurf）では意図的な挙動変化なし / Backward compatibility maintained; pure bug fixes only, no functional changes. No intended impact on non-Codex environments
- ✅ **依存追加なし** — bash 環境変数参照のみ追加 / No new dependencies

### Diagnostic Outcome

- **Codex 環境 mock test**: `CODEX_THREAD_ID=test bash axiarch-scripts/check-axiarch-health.sh` → Check 4 が `[PASS] Codex runtime detected` を返すことを確認 ✅
- **`--quiet` モード修正**: sublimated files 存在プロジェクトで `bash axiarch-scripts/check-axiarch-health.sh --quiet` 実行 → Check 13 の verbose 出力が完全抑制されることを確認 ✅
- **axiarch repo against itself**: 全 14 段階 PASS（Check 4 は Codex 環境なしのため `.claude/projects/` 参照モードで PASS 維持）✅

---

## [1.8.0] — 2026-05-10

### 🚨 BREAKING: `scripts/` → `axiarch-scripts/` rename + v1.7.0 features bundled

採用先プロジェクトとの**名前空間衝突回避**のため、配布ディレクトリを rename（pure rename、機能変更ゼロ）。同時に v1.7.0 で予定していた Check D Task Boundary Detection / Claude Code 検証ログ拡充等の全 features を統合 release。

**Pure rename to avoid namespace collision** with adopter-project `scripts/` (critical risk: adopter `scripts/README.md` would be overwritten). All v1.7.0 features bundled.

### BREAKING

- **配布ディレクトリ**: `scripts/` → `axiarch-scripts/` rename（機能変更ゼロ）
- **Hook command paths**: `.claude/settings.json` の `command` を新 path に更新
- **採用先 migration 手順**:
  1. `git pull` で v1.8.0 取得
  2. `bash init.sh` 再実行 → `axiarch-scripts/` 配布 + `.claude/settings.json` 自動再配布（採用先カスタマイズがある場合は事前バックアップ推奨）
  3. 採用先で旧 `scripts/` 配下の axiarch ファイル（`axiarch-boot-reminder.sh` / `axiarch-protect-antifull.sh` / `axiarch-init-task-md.sh` / `check-axiarch-health.sh` / `check-git-config-clean.sh` / `README.md`）を手動削除推奨
- **後方互換 path 提供なし** — clean cut（symlink 互換実装は v2.0.0 Strategic で再検討候補、§Out of Scope 参照）

### Why BREAKING?

採用先プロジェクトは独自の `scripts/` ディレクトリを持つことが多く、特に **`scripts/README.md` 衝突**が致命的。OSS のベストプラクティス（`vendor/` / `node_modules/` 等の名前空間 prefix）に従い `axiarch-scripts/` で完全分離。

### Added (v1.7.0 features bundled)

- **Check D — Task Boundary Detection** (axiarch-scripts/axiarch-boot-reminder.sh): UserPromptSubmit hook の stdin から現プロンプト JSON を読み、whole-word match で domain keyword を抽出。**AGENTS §8.4 必須トリオ全 3 ファイル**（task.md / implementation_plan.md / walkthrough.md）を full-text grep して比較。新 keyword 検出時に `🚨 [VIOLATION-D]` flag + TTL bypass。AI の confirmation bias loophole リスクを機械的に検出しやすくする
- **Check 14** (axiarch-scripts/check-axiarch-health.sh): Check D wiring 確認（13-stage → 14-stage）
- **環境変数**: `AXIARCH_TASK_BOUNDARY_DETECT` / `AXIARCH_TASK_DOMAIN_KEYWORDS`
- **Claude Code 検証ログ拡充** — v1.4.0+ ネイティブ hook 統合 + axiarch 自身の開発で hook 補強モデルの検証材料を蓄積。現在の公開ステータスでは Google Antigravity のみを実務検証済みとし、Claude Code は主対象として扱う

### Changed (v1.7.0 features bundled)

- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md` Step 4** — Cross-Session Re-load Criteria に Check D 補足、「v1.8.0 改善」セクションで confirmation bias loophole リスクの軽減メカニズムを明文化
- **`axiarch-rules/{ja,en}/INDEX.md` directory tree** — `scripts/` → `axiarch-scripts/`
- **README.md / axiarch-scripts/README.md** — 14-stage / Check D / 新 env vars / 検証ステータス表 / 必須ファイル表 / hook補強セクションを全更新
- **ROADMAP.md** — v1.7.0 forecast を v1.8.0 として delivered 化、Tier 2 forecast を v1.9.0、Tier 3 を v1.10.0 に整理
- **init.sh** — `AXIARCH_VERSION` 1.7.0 → 1.8.0、配布ロジック `scripts/` → `axiarch-scripts/`
- **llms-full.txt / llms.txt** — Version 1.8.0、エージェント互換性表と検証ステータスを更新

### Compatibility

- 🚨 **BREAKING (major bump)**: 採用先で `bash scripts/check-axiarch-health.sh` 等を実行する CI / pre-commit hook / ドキュメント参照は `bash axiarch-scripts/check-axiarch-health.sh` に更新が必要
- ✅ **機能的後方互換**: 機能・env vars・hook 動作は v1.7.0 と同等（pure rename）
- ✅ **Universal Rules 不変**: `axiarch-rules/{ja,en}/universal/` 内の `scripts/` 言及は agent-agnostic 汎用例文として残す
- 📌 **アップグレード手順**: `git pull && bash init.sh` で `axiarch-scripts/` が自動配布

### Diagnostic Outcome

- **Mock test verification**: Check D の 3 process docs scan + whole-word match で全動作確認 ✅
- **rename 後の `bash axiarch-scripts/check-axiarch-health.sh`**: 全 14 段階 PASS ✅
- **採用先衝突回避**: 採用先独自の `scripts/` には影響なし（全 axiarch ファイル名は axiarch- prefix もしくは check-axiarch- / check-git-config- で衝突しない）

### References

- 採用先実運用フィードバック「同 session 内 task 切替で AI が rule 再 load を省略する」（v1.7.0 由来 Check D）
- 採用先設計レビュー「scripts/ → axiarch-scripts/ で名前空間衝突回避」（v1.8.0 BREAKING の動機）
- AGENTS.md §8.4 (Documentation Requirements) と Check D の整合
- Anthropic Claude Code Hooks: <https://code.claude.com/docs/en/hooks>

### Out of Scope（v1.9.0 / v1.11.0 / v2.0.0 に deferred — see ROADMAP）

- **v1.9.0 (Tier 2)**: PostToolUse + git diff verification / Cursor `globs:` adoption / Memory Persistence enhancement / Aider-style prompt-cache / shellcheck CI / Universal Rules footer cleanup / HealthCheck Workflow / Post-release README integration auto-verification (Check 15)
- **v1.11.0 (Tier 3)**: axiarch-doctor CI lint / IFEval-style auto-regression / Deliberative-Alignment forced Protocol Recall / AI Agent Compatibility Matrix
- **v2.0.0 (Strategic)**: AgentSpec-style DSL adoption / Multi-Agent Verification / Axiarch CLI / `decision: "block"` generalisation / `scripts/` ↔ `axiarch-scripts/` symlink 互換実装の再検討

---

## [1.7.0] — 2026-05-08 (内部開発のみ、独立 release はせず v1.8.0 に統合)

> **NOTE**: v1.7.0 was prepared but NOT released as a separate version; all v1.7.0 features were bundled into v1.8.0 along with the BREAKING `scripts/` → `axiarch-scripts/` rename. The original v1.7.0 development history is preserved in the git log (commits 770150b / f60ced8 / c6aee62 / eddeb01 / 69c44b8 / 8d94938).

### 🎯 Check D — Task Boundary Detection（タスク境界候補の検出）/ Reduces the "AI judges same-session, no re-load needed" risk

採用先実運用フィードバックで判明した重要な構造的欠陥を緩和する hot-fix release：v1.6.0 で導入した「Cross-Session Re-load Criteria」の **「同一 session 内タスク継続（タスクタイプ不変）→ 追加 load 不要」** 条項が、**「タスクタイプ不変」の判定を AI 自己判断に任せている**ため、confirmation bias で AI が「session 継続中だから rule 再 load 不要」と判断してサボる loophole を生んでいた。

This release mitigates a critical structural flaw discovered via adopter feedback: v1.6.0's Cross-Session Re-load Criteria included a **"same session, task continues (no type change) → no additional load required"** clause whose key — "task type unchanged" — was left to the AI's self-judgment. Confirmation bias led the AI to skip re-loading by judging "session is continuing." v1.7.0 reduces this risk by **mechanically detecting task-boundary candidates at the hook layer**.

### Added

- **`axiarch-scripts/axiarch-boot-reminder.sh` Check D — Task Boundary Detection**（v1.7.0+）— UserPromptSubmit hook の stdin から現プロンプト JSON を読み、domain keyword（security / architecture / ui_design / api / performance / push / commit / migration 等）を **whole-word match** (`grep -oiwE`) で抽出。**AGENTS §8.4 必須トリオ全 3 ファイル**（`task.md` / `implementation_plan.md` / `walkthrough.md`）を full-text grep し、既存 domain keyword を抽出（プラン側 / walkthrough 側に書かれた domain context も漏れなく捕捉）。現プロンプトに**新しい keyword が出現**したら `🚨 [VIOLATION-D]` flag + **TTL bypass**（短縮版抑制 + full reminder 再発火）。AI の「タスクタイプ不変」自己判断を機械的にバックアップする / Reads current-prompt JSON from UserPromptSubmit hook stdin; extracts domain keywords via whole-word match; full-text greps the AGENTS §8.4 mandatory trio (task.md / implementation_plan.md / walkthrough.md) — not just task.md — for previously-known keywords; on new-keyword detection, emits `🚨 [VIOLATION-D]` and bypasses TTL
- **`axiarch-scripts/check-axiarch-health.sh` Check 14 — Task Boundary Detection wiring 確認** — `axiarch-boot-reminder.sh` に Check D logic（VIOLATION-D + AXIARCH_TASK_BOUNDARY_DETECT env var）が含まれることを確認 / Verifies the reminder script contains the Check D logic
- **環境変数**: `AXIARCH_TASK_BOUNDARY_DETECT`（default `1`、`0` で disable）/ `AXIARCH_TASK_DOMAIN_KEYWORDS`（domain keyword 集合のオーバーライド）

### Changed

- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md` Step 4** — Cross-Session Re-load Criteria の「同一 session 内タスク継続」行に Check D 補足追加。「v1.8.0 改善 — Check D Task Boundary Detection」セクションで confirmation bias loophole リスクの軽減メカニズムを明文化（注: v1.7.0 で追加し v1.8.0 で release labelling に整合化）/ Step 4 updated: "task continues" row now references Check D as the mechanical backstop; new "v1.8.0 improvement" section documents the risk-reduction mechanism (originally added in v1.7.0, label aligned in v1.8.0)
- **`axiarch-scripts/check-axiarch-health.sh` ヘッダー** — 13-stage → 14-stage に拡張、Summary 出力に "Task Boundary" を追加
- **`init.sh`** — `AXIARCH_VERSION` 1.6.0 → 1.7.0
- **`llms-full.txt`** — Version 1.6.0 → 1.7.0
- **Claude Code 検証ログ拡充** — v1.4.0+ の `UserPromptSubmit` hook 導入 + v1.5.5+ `PreToolUse` 物理遮断 + v1.6.0+ Reminder TTL + v1.7.0+ Check D Task Boundary Detection をネイティブ統合し、本リポジトリで axiarch 開発自体における検証材料を蓄積。現在の公開ステータスでは Google Antigravity のみを実務検証済みとし、Claude Code は主対象として扱う / Claude Code validation evidence was expanded through first-class hook integration and axiarch's own development cycles. Current public status treats Google Antigravity as the only production-validated agent and Claude Code as a primary target.

### Compatibility

- ✅ **後方互換性を維持** — Check D は `AXIARCH_TASK_BOUNDARY_DETECT=0` で disable 可（v1.6.0 挙動再現）。stdin が空（hook 経由でない直接実行等）の場合 Check D は自動 skip
- ✅ **依存追加なし** — pure bash + grep + sed、`jq` は optional fallback あり
- ✅ **Domain keyword 集合は extensible** — `AXIARCH_TASK_DOMAIN_KEYWORDS` で採用先カスタマイズ可能
- 📌 **アップグレード手順** — `git pull && bash init.sh` 再実行で `axiarch-boot-reminder.sh` が更新される

### Diagnostic Outcome

- **Mock test verification**:
  - stdin 不在 → `[AXIARCH REMINDER]` short / `[AXIARCH BOOT]` full 動作維持 ✅
  - `{"prompt":"please review the security RLS policy and migration in supabase"}` → **VIOLATION-D 検出**（domains: migration, rls, security） ✅
  - `{"prompt":"hello how are you today"}` → VIOLATION-D 検出なし（casual prompt = no domain keyword） ✅
- **axiarch repo against itself**: 全 14 段階 PASS（Check 14 含む）

### References

- 採用先実運用フィードバック「同一 session 内でも実際タスクは異なるのに AI が rule 再 load を省略する」（v1.6.0 release 後の adopter report）
- v1.6.0 commit body の `LOADING_PROTOCOL.md §4 Cross-Session Re-load Criteria` の confirmation bias loophole
- Claude Code Hooks UserPromptSubmit input format: <https://code.claude.com/docs/en/hooks>

### Out of Scope（v1.9.0 / v1.11.0 / v2.0.0 に deferred — see ROADMAP）

- **v1.9.0 (Tier 2)**: PostToolUse + git diff verification / Cursor `globs:` adoption / Memory Persistence enhancement / Aider-style prompt-cache optimisation / shellcheck CI integration / `init.sh` post-distribution syntax validation / Universal Rules footer cleanup / HealthCheck Workflow / Post-release README integration auto-verification (Check 15)
- **v1.11.0 (Tier 3)**: axiarch-doctor CI lint mechanism / IFEval-style auto-regression suite / Deliberative-Alignment forced Protocol Recall / AI Agent Compatibility Matrix
- **v2.0.0 (Strategic)**: AgentSpec-style DSL adoption / Multi-Agent Verification / Axiarch CLI / `decision: "block"` generalisation

---

## [1.6.0] — 2026-05-08

### 🪶 Reminder TTL + Time-Axis Crystallization + Pre-commit Installer + Session Re-load Criteria + APPEND Guide / リマインダー TTL + 時間軸結晶化 + pre-commit installer + session 跨ぎ基準 + APPEND ガイド

実運用フィードバック（採用先プロジェクト「ガバナンス機能評価レポート」）の 5 項目改善を minor release として bundling。**「設計 vs 現実」の乖離（context budget / token cost / 既存 sublimated file 認識率 / stale lesson 放置）**を構造的に解消する。

Bundles five improvements driven by adopter-project feedback ("governance functional evaluation report"). Structurally resolves the design-vs-reality gap (context budget, token cost, sublimated-file recognition, stale-lesson neglect).

### Added

- **`axiarch-scripts/axiarch-boot-reminder.sh` Two-Stage Output (TTL)**（v1.6.0+）— First fire (or after TTL expires) returns the **full reminder** + writes timestamp; subsequent fires within TTL with no violations return a short-circuit `[AXIARCH REMINDER]` reminder. State file: `${TMPDIR}/axiarch-reminder-{project_hash}.timestamp`. TTL configurable via `AXIARCH_REMINDER_TTL_SECONDS` (default 1800 = 30 min; `0` disables). Token impact: ~24k cumulative → ~3k (87% reduction in long sessions) / TTL 二段階出力により長時間 session で token 約 87% 削減
- **`axiarch-scripts/axiarch-boot-reminder.sh` Check C — Stale Lesson Detection** — Any `core/010` lesson dated `>180 days` (configurable via `AXIARCH_LESSON_STALE_DAYS`) appends a `🚨 [VIOLATION-C]` flag, ensuring single-domain lessons do not get neglected indefinitely / 180 日以上経過の lesson 検出
- **`axiarch-scripts/check-axiarch-health.sh` Check 6 拡張 — CRYSTAL §5 Time-Axis Trigger** — Existing count threshold (3+ per domain, trigger (a)) now joined by **time-axis trigger (b)** detecting `[YYYY-MM-DD]` dated lessons older than threshold days. Surfaces stale-lesson backlog
- **`axiarch-scripts/check-axiarch-health.sh` Check 13 — Sublimated Files Index** — Lists existing `blueprint/{domain}/{NNN}_{topic}.md` files so the AI can prefer **APPEND to existing files** over new `core/010` entries (per CRYSTAL §3 SEARCH). Addresses inucomi-style "12 consecutive N/A" feedback where lessons fit existing file scope but get added to `core/010`
- **`axiarch-scripts/check-axiarch-health.sh --quiet` flag** — Silent mode for pre-commit / CI usage; suppresses verbose output, only error to stderr + exit code conveys result
- **`init.sh` Pre-commit Hook Installer (opt-in)** — New STEP 3.5 prompts `Install pre-commit hook? [y/N]`. When enabled: (a) detects existing lefthook / pre-commit-framework / husky and warns instead of overwriting, (b) appends axiarch block to existing `.git/hooks/pre-commit` or creates new file, (c) marker-based idempotency. Bypass per-commit via `AXIARCH_PRECOMMIT_SKIP=1`

### Changed

- **`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md` Step 5** — Replaced single "3+ count" trigger with **dual-trigger table** (count + time-axis), explicitly documenting why time-axis trigger matters for projects with comprehensive sublimated files
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md` Step 4** — Added **"Cross-Session Re-load Criteria"** section explicitly resolving the "full load = no laziness" vs "context budget reality" trade-off. Defines re-load scope per situation (new session / task type changed / continuing / long pause). Documents `task.md` load history as Single Source of Truth
- **`init.sh`** — `AXIARCH_VERSION` 1.5.5 → 1.6.0; new `select_precommit` + `install_precommit_hook` functions wired into `main()`
- **`llms-full.txt`** — Version 1.5.5 → 1.6.0

### Compatibility

- ✅ **後方互換性を維持** — TTL は `AXIARCH_REMINDER_TTL_SECONDS=0` で完全 disable 可（v1.5.5 挙動再現）。Check C は `AXIARCH_LESSON_STALE_DAYS=0` で disable 可。pre-commit installer は完全 opt-in
- ✅ **依存追加なし** — pure bash 実装、`shasum` は macOS / Linux 標準。`date -d` (GNU) と `date -j -f` (BSD) の dual-fallback
- ✅ **lefthook / pre-commit-framework / husky 既存環境を破壊しない** — 検出して warn のみ
- ✅ **既存 `.git/hooks/pre-commit` を上書きしない** — append + marker による idempotency
- 📌 **アップグレード手順** — `git pull && bash init.sh` 再実行（pre-commit installer は opt-in 質問あり）

### Diagnostic Outcome

- **Mock test verification**:
  - TTL 二段階：first fire = full / TTL 内 = short-circuit `[AXIARCH REMINDER]` / TTL 強制無効化 = full ✅
  - Check 6 time-axis: 180 日以下 lesson のみ → "Below time-axis threshold" PASS ✅
  - Check 13: axiarch 本体は sublimated file 不在 → "No sublimated files yet" 案内 ✅
  - `--quiet` mode: PASS 時完全 silent + exit 0 / 違反時 stderr only ✅
- **axiarch repo against itself**: 全 13 段階 PASS（Check 13 含む）

### References

- 採用先 「ガバナンス機能評価レポート」（実運用フィードバック）
- AGENTS.md §0 HIGHEST-PRIORITY RULE / §6 ANTI-FULL-OVERWRITE / §8 Process & Documentation / §9 Continuous Improvement
- v1.5.5 PreToolUse hook が本 release の implementation 中に**実機発火し作者の Write 操作を物理遮断した実証あり**（Edit による段階実装に切り替え）
- Anthropic Claude Code Hooks: <https://code.claude.com/docs/en/hooks>

### Out of Scope（次バージョン以降に deferred — see ROADMAP）

- **v1.9.0 (Tier 2)**: PostToolUse + git diff verification / Cursor `globs:` adoption / Memory Persistence enhancement / Aider-style prompt-cache optimisation / shellcheck CI / `init.sh` post-distribution syntax validation / Universal Rules footer cleanup / HealthCheck Workflow / Post-release README integration auto-verification (Check 15)
- **v1.11.0 (Tier 3)**: `axiarch-doctor` CI lint mechanism / IFEval-style auto-regression suite / Deliberative-Alignment forced Protocol Recall / AI Agent Compatibility Matrix
- **v2.0.0 (Strategic)**: AgentSpec-style DSL adoption / Multi-Agent Verification / Axiarch CLI / `decision: "block"` generalisation

---

## [1.5.5] — 2026-05-07

### 🚦 Physical Block + Tone Refactor + SessionStart Bootstrap / 物理遮断 + トーン リファクタ + セッション開始ブートストラップ

26 ラウンド徹底市場調査（4 並列 Agent: AI compliance frameworks / competitor tools / Claude Code official features / academic 2024-2026）の統合分析を踏まえ、**「Reminder → Physical Block」のパラダイムシフト**を実装。学術的に裏付けされた 3 改善を v1.5.5 patch として bundling：(1) `PreToolUse` hook で §6 ANTI-FULL-OVERWRITE を物理遮断、(2) `SessionStart` hook で task.md 自動ブートストラップ、(3) reminder 文を CAPS / 強調記号から事実陳述へリファクタ（9 protocols 反復構造は維持）。

Based on a 4-agent parallel market study (AI compliance frameworks / competitor tools / Claude Code official / academic 2024-2026), v1.5.5 implements the **"reminder → physical block" paradigm shift**. Three academically-backed improvements are bundled: (1) `PreToolUse` hook physically blocks §6 ANTI-FULL-OVERWRITE violations, (2) `SessionStart` hook auto-bootstraps task.md, (3) reminder text refactored from CAPS / emphasis markers to factual statements (repetition structure across 9 protocols preserved).

### Added

- **`axiarch-scripts/axiarch-protect-antifull.sh`**（新規）— PreToolUse hook の外出しスクリプト。`Write` tool 呼び出しを傍受し、対象が既存ファイルの場合 `decision: "block"` JSON + exit 2 で物理遮断。`.claude/axiarch-overwrite-allow.txt` で whitelist サポート / NEW: PreToolUse hook script that intercepts `Write` calls; blocks (decision:"block" JSON + exit 2) when the target file already exists. Whitelist via `.claude/axiarch-overwrite-allow.txt`
- **`axiarch-scripts/axiarch-init-task-md.sh`**（新規）— SessionStart hook の外出しスクリプト。会話開始時に task.md の存在を確認、無ければ load-history scaffold で自動生成。常に reminder を `additionalContext` で注入 / NEW: SessionStart hook script that checks for task.md, scaffolds it if missing (with load-history table stub), and always injects a reminder via `additionalContext`
- **`axiarch-scripts/check-axiarch-health.sh` Check 11 / Check 12 追加** — 12 段階診断に拡張。Check 11 = PreToolUse hook の配線確認、Check 12 = SessionStart hook の配線確認 / Diagnostic extended to 12 stages: Check 11 = PreToolUse wiring, Check 12 = SessionStart wiring

### Changed

- **`.claude/settings.json`** — 3 hook 配線（SessionStart / UserPromptSubmit / PreToolUse(Write matcher)）。SessionStart と PreToolUse が新規追加 / Three-hook wiring: SessionStart, UserPromptSubmit, PreToolUse with `Write` matcher
- **`axiarch-scripts/axiarch-boot-reminder.sh` reminder 文の事実陳述化リファクタ** — CAPS / `🚨【厳守命令】` / `No skipping` 等の強圧表現を排除し、`This project enforces axiarch governance` のような事実陳述に統一。Anthropic 公式ガイドおよび Robert Glaser 「Prompts as Programs in GPT-5」に基づく科学的最適化。9 protocols 反復構造は arXiv:2512.14982 の根拠で維持 / Reminder tone refactored from CAPS/imperative to factual statement per Anthropic guidance and Robert Glaser's "Prompts as Programs in GPT-5". Repetition structure preserved per arXiv:2512.14982 (Prompt Repetition Improves Non-Reasoning LLMs)
- **`init.sh`** — `AXIARCH_VERSION` 1.5.4 → 1.5.5
- **`llms-full.txt`** — Version 1.5.4 → 1.5.5

### Compatibility

- ✅ **後方互換性を維持** — 既存 hook (`UserPromptSubmit`) は維持、新 hook 追加のみ。fallback 採用先で新 hook が動かなくても既存挙動は変わらない
- ✅ **依存追加なし** — pure bash 実装、`jq` は optional（grep + sed フォールバック完備）
- ✅ **`.claude/axiarch-overwrite-allow.txt` で whitelist 拡張** — 自動生成 build artefact 等で正当な full-overwrite が必要な場合の escape hatch
- ⚠️ **採用先で `init.sh` 再実行が必要** — `chmod +x` で新 hook scripts に実行権限が付与される
- 📌 **アップグレード手順** — `git pull && bash init.sh` 再実行 OR 手動で `.claude/settings.json` + `axiarch-scripts/axiarch-{protect-antifull,init-task-md}.sh` をコピー + `chmod +x`

### Diagnostic Outcome

- **Mock test verification**:
  - 既存ファイルへの `Write` → JSON `{"decision":"block",...}` + stderr message + exit 2 で物理遮断 ✅
  - 新規ファイルへの `Write` → allow (exit 0) ✅
  - `Edit` tool → allow (exit 0)、Write 以外は無干渉 ✅
  - SessionStart hook → 正常 JSON 出力で additionalContext 注入 ✅
- **axiarch repo against itself**: 全 12 段階 PASS（Check 11/12 含む）
- **学術裏付けスコア**:
  - PreToolUse block: arXiv:2503.18666 (AgentSpec, ICSE'26) で 90%+ 阻止実証
  - SessionStart bootstrap: arXiv:2502.15851 (Control Illusion) の instruction-hierarchy 失敗を構造的回避
  - Tone refactor: Anthropic 公式 + Robert Glaser、9 protocols 反復は arXiv:2512.14982 で保持

### References

- 4-agent market research transcript（本リリース commit body 参照）
- arXiv:2503.18666 — AgentSpec: Customizable Runtime Enforcement for AI Agents (ICSE'26)
- arXiv:2502.15851 — Control Illusion: failed instruction hierarchies in LLMs
- arXiv:2512.14982 — Prompt Repetition Improves Non-Reasoning LLMs
- arXiv:2412.16339 — Deliberative Alignment (OpenAI)
- arXiv:2412.14093 — Alignment Faking (Anthropic)
- arXiv:2310.01798 — Huang et al.: LLMs Cannot Self-Correct Reasoning Yet
- Anthropic Claude Code Hooks: <https://code.claude.com/docs/en/hooks>

---

## [1.5.4] — 2026-05-06

### 🩹 健全性診断スクリプトの v1.5.3 互換性 patch / Health-Diagnostic Compatibility Patch for v1.5.3

v1.5.3 で `.claude/settings.json` の hook command を inline `printf JSON` から `bash "${CLAUDE_PROJECT_DIR:-.}/axiarch-scripts/axiarch-boot-reminder.sh"` に**外出し化**したことで、`axiarch-scripts/check-axiarch-health.sh` の Check 3 (`AXIARCH BOOT` marker grep) と Check 4 (`UserPromptSubmit hook success` grep) が**誤検出**を起こす状態になっていた。本 patch は両 check を v1.5.2/v1.5.3 双方の format に対応させる pure 互換性修正。

After v1.5.3 externalized the hook command, `axiarch-scripts/check-axiarch-health.sh` Check 3 (inline marker grep) and Check 4 (legacy `success` log grep) produced **false negatives** on freshly-installed v1.5.3 projects. This patch makes both checks compatible with both v1.5.2 (inline) and v1.5.3+ (externalized) formats.

### Fixed

- **Check 3 — `AXIARCH BOOT` marker detection** — Hook command が `axiarch-boot-reminder.sh` を呼ぶ場合、スクリプト本体に `AXIARCH BOOT` が含まれることを確認するフォールバック分岐を追加。inline 形式 (v1.4.0–v1.5.2) と externalized 形式 (v1.5.3+) の両方をパスできるようになった / Added fallback branch that inspects the externalized script for the `AXIARCH BOOT` literal when the hook command delegates to `axiarch-scripts/axiarch-boot-reminder.sh`
- **Check 4 — Session firing history grep pattern** — v1.5.2+ の transcript JSONL では hook 出力ラベルが `UserPromptSubmit hook success` から `UserPromptSubmit hook additional context` に変わっていたため、grep を `grep -cE "UserPromptSubmit hook (success|additional context)"` に拡張 / Expanded grep to match both legacy and current transcript labels (`success` ⇄ `additional context`)
- **`axiarch-scripts/axiarch-boot-reminder.sh` のコメントから version literal 除去** — `# Static base reminder (..., identical content to v1.5.1/v1.5.2)` は汎用ファイルへのバージョン記述ポリシー違反だったため version-free に書き換え / Removed `v1.5.1/v1.5.2` literal from the externalized reminder script's header comment to comply with the version-string-policy
- **`axiarch-scripts/check-axiarch-health.sh` の `print_info` ランタイム出力から version literal 除去** — Check 3 fail-path の helper メッセージから `(v1.5.3+ uses ...)` を削除（採用先のランタイム出力は version-free を厳守） / Removed `(v1.5.3+ ...)` literal from a runtime-visible `print_info` line in the diagnostic
- **`README.md` 必須ファイル表に `axiarch-boot-reminder.sh` 言及追加** — v1.5.3 で新規追加されたが必須ファイル表で言及漏れだった件を訂正 / Added the missing reference to `axiarch-boot-reminder.sh` in the required-files table
- **`axiarch-scripts/check-axiarch-health.sh` Check 3 の else 分岐に `EXIT_CODE=1` 追加（false-negative 修正）** — v1.5.1 で導入された Check 3 の else 分岐（hook command が `AXIARCH BOOT` literal も `axiarch-boot-reminder.sh` 文字列も含まない hook 完全破損状態）で `print_warn` だけ出力して `EXIT_CODE=1` を設定していなかった bug。CI 連携で false negative（hook 壊れているのに exit 0）になる致命的問題。18 ラウンド調査で発見・修正 / Critical false-negative fix: Check 3's else branch (hook command lacks both `AXIARCH BOOT` and `axiarch-boot-reminder.sh` literals — i.e. completely broken hook) was emitting `print_warn` without setting `EXIT_CODE=1`, causing CI integrations to falsely report success on a broken hook. Discovered in the 18th-round audit

### Changed

- **`init.sh`** — `AXIARCH_VERSION` 1.5.3 → 1.5.4
- **`llms-full.txt`** — Version 1.5.3 → 1.5.4
- **`axiarch-rules/{ja,en}/blueprint/core/010_project_lessons_log.md`** — Initial entry のみ保持（axiarch 本体は OSS template のため、axiarch 開発側で得た lesson は本ファイルに残さず CHANGELOG / ROADMAP / commit body に記録する方針）。v1.5.4 中間 commit で誤って開発側 lesson を結晶化した記述があったが本 release で訂正 / Kept the Initial entry only — axiarch is an OSS template, so lessons learned by axiarch maintainers are recorded in CHANGELOG / ROADMAP / commit bodies, not in this template file. An interim mistake (crystallizing a maintainer-side lesson here) was reverted in this release

### Compatibility

- ✅ **後方互換性を維持** — v1.4.0〜v1.5.2 の inline format も依然 PASS。配布済みスクリプトは `git pull && bash init.sh` で再配布可能
- ✅ **依存追加なし** — pure bash 修正のみ
- 📌 **アップグレード手順** — 採用先で `bash axiarch-scripts/check-axiarch-health.sh` を再実行し、Check 3/4 が PASS することを確認

### Diagnostic Outcome

- **v1.5.3 リグレッションの確認**: 本 axiarch リポジトリで Check 3 が「Hook command does not contain AXIARCH BOOT」、Check 4 が「Hook never fired」を誤検出。`bash axiarch-scripts/check-axiarch-health.sh` を実行し両 PASS 化を実証
- **設計反省**: hook command を externalize する変更時、診断スクリプトの grep 対象も同時更新する責務を見落としていた。今後は format 変更を伴う patch と diagnostic update をセットでリリースする運用に切り替え

### References

- v1.5.3 で外出し化した script: `axiarch-scripts/axiarch-boot-reminder.sh`
- v1.5.2 で format 変更された hook 出力ラベル: `additionalContext` (cf. <https://code.claude.com/docs/en/hooks#hookspecificoutput>)

---

## [1.5.3] — 2026-05-06

### 🛡️ 動的違反検出 reminder + v1.5.2 記述の honesty 修正 / Dynamic Violation-Detection Reminder + v1.5.2 Honesty Correction

v1.5.2 リリース後、作者から **「v1.5.2 で UI 汚染が十分に低減していない」「ルール厳守も強くなっていない」** との指摘。実態確認の結果、(1) 公式 docs の「more discretely」は format 改善程度で、system-reminder ラップ自体は残ることが判明、(2) v1.5.2 は**形式変更のみ**で AI 遵守強化はなされていなかった。

本 patch は (A) v1.5.2 の honest 化（ROADMAP 修正）と (B) **動的違反検出 reminder** で、AI が毎ターン**現在の違反状況**を自覚できる仕組みを実装。物理 block ではなく「警告強化」の方向で副作用最小化。

After v1.5.2, the author pointed out that (1) UI pollution had not been sufficiently reduced and (2) AI adherence was not strengthened. Investigation confirmed both: official docs' "more discretely" only means format improvement (the `<system-reminder>` wrap remains), and v1.5.2 changed format only, not adherence. This patch corrects v1.5.2 narrative honestly and adds a **dynamic violation-detection reminder** that surfaces current violations every turn.

### Added

- **`axiarch-scripts/axiarch-boot-reminder.sh`**（新規）— UserPromptSubmit hook の外出しスクリプト。毎ターン以下を動的検出し、違反時は reminder に 🚨 フラグを追記:
  - **Check A**: `task.md` にロード履歴（AGENTS.md / INDEX.md / LOADING_PROTOCOL.md 参照）が未記録
  - **Check B**: `axiarch-rules/{ja,en}/blueprint/core/010_project_lessons_log.md` で 3 件以上溜まったドメイン（CRYSTALLIZATION §5 違反）
  - JSON 出力は pure bash で `jq` 依存なし
  / NEW: Externalized hook script that dynamically appends 🚨 violation flags when (A) `task.md` lacks load history or (B) crystallization threshold is breached. Pure bash JSON output (no `jq`)

### Changed

- **`.claude/settings.json`** — `command` を inline `printf JSON` から `bash "${CLAUDE_PROJECT_DIR:-.}/axiarch-scripts/axiarch-boot-reminder.sh"` に簡素化。settings.json 自体がスリムに / Hook command externalized; settings.json itself becomes much slimmer
- **`ROADMAP.md` v1.5.2 記述を honest 化** — 「Plan mode 表示汚染を解消」「`<system-reminder>` でラップされない」が誤りだったため修正。実態は「format クリーン化（system-reminder ラップ自体は残る）」 / Honesty fix: removed overstated claims, clarified that `<system-reminder>` wrap remains
- **`init.sh`** — `AXIARCH_VERSION` 1.5.2 → 1.5.3
- **`llms-full.txt`** — Version 1.5.2 → 1.5.3

### Compatibility

- ✅ **後方互換性を維持** — フックメッセージのコア内容は v1.5.1 から変わらず（VIOLATION フラグは違反時のみ追記）
- ✅ **依存追加なし** — pure bash で JSON 構築、`jq` 不要
- ✅ **物理 block 不採用** — `decision: "block"` で prompt 遮断する選択肢もあったが、副作用が大きいため警告強化に留めた
- ⚠️ **採用先で `axiarch-boot-reminder.sh` の実行権限が必要** — `init.sh` の `chmod +x` ロジックで自動付与される
- 📌 **アップグレード手順** — `git pull && bash init.sh` 再実行、または手動で `.claude/settings.json` と `axiarch-scripts/axiarch-boot-reminder.sh` をコピー

### Diagnostic Outcome

- **v1.5.2 の効果評価**: format クリーン化のみ（success ラベル → additional context ラベル変更）。**Plan mode UI への表示自体は残る**（system-reminder ラップ仕様による）
- **v1.5.3 の遵守強化**: AI が毎ターン違反状況を自覚 → 静的 reminder 単独より遵守率向上が期待できる（物理強制ではないが「観測可能性」の段階的進化）
- **v1.6.0 候補**: `decision: "block"` による prompt-level 物理強制（ただし副作用大）

### References

- 公式 docs: [Claude Code Hooks](https://code.claude.com/docs/en/hooks) — `hookSpecificOutput.additionalContext` 仕様
- 関連: v1.5.2 の「discretely」誤解釈を訂正

---

## [1.5.2] — 2026-05-06

### 🪶 Hook Output 形式変更 — discrete injection で Plan mode 汚染解消 / Hook Output Format Switched to Discrete Injection

v1.5.1 リリース後、作者から **「プラン表示形式が汚くなる」「ロードしたルールがプラン・タスクに表示されない」** との指摘。3 並列調査の結果、**`echo` 出力（transcript 全表示）方式に起因する UI 汚染** と判明。公式 docs (code.claude.com/docs/en/hooks) 推奨の **`hookSpecificOutput.additionalContext` JSON 形式** に切り替え、reminder を context に discrete に注入することで解消。

After v1.5.1, the author reported "Plan display becomes ugly" and "loaded-rules disclosure mandate is being ignored in plans/tasks". A 3-parallel investigation pinpointed the root cause as **UI pollution from the `echo` (transcript-full-display) output format**. Switched to the official docs-recommended **`hookSpecificOutput.additionalContext` JSON format** for discrete context injection.

### Changed

- **`.claude/settings.json`** — フック `command` を `echo '...'` から `printf '%s' '{...hookSpecificOutput.additionalContext...}'` 形式に変更。公式仕様で「Wrapped in system reminders. The `additionalContext` field is added more **discretely**」と明記された推奨形式に準拠 / Switched the hook `command` from `echo` to `printf '%s' '{...hookSpecificOutput.additionalContext...}'` JSON form, the official-docs-recommended discrete-injection format
- **`init.sh`** — `AXIARCH_VERSION` 1.5.1 → 1.5.2 / Bumped version
- **`llms-full.txt`** — Version 1.5.1 → 1.5.2

### Compatibility

- ✅ **後方互換性を維持** — フックメッセージ内容は v1.5.1 と同等（形式のみ変更）。AI 遵守要求（task.md 記録義務 + CRYSTAL §5 遵守）は維持 / Backward compatibility maintained; reminder content is equivalent to v1.5.1, only the wire format changes
- ✅ **依存追加なし** — `printf` は POSIX 標準。`jq` 不要（v1.5.1 で追加した optional jq バリデーションも維持） / No new dependencies; `printf` is POSIX-standard, no `jq` required
- ✅ **Plan mode 汚染解消** — `additionalContext` は `<system-reminder>` ラップではなく context 直接注入。Plan files / transcript / UI の毎ターン reminder 表示が消える / Plan files / transcript / UI no longer show the bulky reminder text each turn
- ⚠️ **AI への visibility 維持** — context 直接注入のため、AI は同等に reminder を認識（公式 docs で確認済み）/ AI still sees the reminder via context injection
- 📌 **アップグレード手順** — `git pull` + `init.sh` 再実行 OR 手動で `.claude/settings.json` を上書き / Upgrade: `git pull && bash init.sh`, or manually overwrite `.claude/settings.json`

### References

- 公式 docs: [Claude Code Hooks](https://code.claude.com/docs/en/hooks) — `hookSpecificOutput.additionalContext` 仕様
- 関連 commit: v1.5.1（reminder 内容の本格強化）

---

## [1.5.1] — 2026-05-06

### 🛡️ Hook 効果最大化 + 結晶化プロトコル遵守強化 / Hook Efficacy Maximization + Crystallization Adherence Strengthening

v1.5.0 リリース後、作者から「フックが毎回動いていない気がする」「結晶化プロトコルも守られていない（3件以上溜まっても `core/010` に蓄積し続ける）」という 2 つの懸念。共通の真因は **AI 遵守ギャップ** — フックは技術的に発火し、プロトコルもテキストとして存在しているのに、AI が `task.md` 記録を怠り、「`core/010` に追記したから完了」と誤認して Step 5 (THRESHOLD CHECK) をスキップする。

本 patch は **「ドキュメント丸投げではなくツールで遵守を強制する」** 設計に転換：診断スクリプト `axiarch-scripts/check-axiarch-health.sh` を新規配布し、フック発火 / `task.md` 記録 / 結晶化閾値の 3 軸を一発検証可能に。フックメッセージ・CRYSTALLIZATION_PROTOCOL §5 自体も「追記 = 完了は誤認」を明示する形で強化。

After v1.5.0, the author raised two concerns: "the hook seems not to fire every time" and "the Crystallization Protocol is not enforced — lessons keep accumulating in `core/010` past the 3-lesson threshold". The common root cause is the **AI adherence gap** — the hook fires technically and the protocols exist as text, but the AI skips `task.md` logging and mistakes "appended to `core/010`" for completion, never executing Step 5 (THRESHOLD CHECK).

This patch shifts from "documentation hand-off" to **"tool-enforced adherence"**: a new diagnostic script `axiarch-scripts/check-axiarch-health.sh` provides one-shot verification across hook firing, `task.md` adherence, and crystallization threshold. The hook reminder and `CRYSTALLIZATION_PROTOCOL §5` itself are also strengthened to explicitly state "just appending is NOT completion".

### Added

- **`axiarch-scripts/check-axiarch-health.sh`**（新規）— **Axiarch 公式健全性診断ツール（全プロトコル監視）**。`bash axiarch-scripts/check-axiarch-health.sh` で **10 段階の遵守チェック** を一発実行：（1-4）Hook 関連（`.claude/settings.json` 存在・JSON 構文・hook 構造・発火履歴）/ （5）LOADING_PROTOCOL Step 4 遵守（`task.md` ロード履歴）/ （6）CRYSTALLIZATION_PROTOCOL §5 遵守（3件以上のドメイン検出）/ **（7）AGENTS.md §8 Process & Documentation（task.md / implementation_plan.md / walkthrough.md 存在）** / **（8）§1 Deployment Ban（force-push / 直 main commit 検出）** / **（9）§4 SSOT Sync（main 同期状態）** / **（10）§2 Language First（Project Native Language 整合性）**。検証困難な §0/§3/§5/§6/§7 は Out of Scope として明示。`init.sh` で自動配布 / NEW: Official Axiarch health diagnostic with **10-stage protocol-wide compliance check**. Covers hook firing, AI adherence, crystallization threshold, AGENTS §1/§2/§4/§8/§9 + LOADING_PROTOCOL. Surfaces which protocol needs attention at a glance. Out-of-scope protocols (§0/§3/§5/§6/§7) explicitly marked for manual review. Auto-distributed by `init.sh`
- **`axiarch-scripts/README.md`**（新規）— scripts/ ディレクトリの索引兼ガイド。各診断ツール（`check-axiarch-health.sh` / `check-git-config-clean.sh`）の目的・使い方・診断項目・推奨ワークフローをバイリンガルで記載。採用者が `axiarch-scripts/` 配下の存在意義を一発で把握できるようにする / NEW: `axiarch-scripts/` index & guide. Bilingual documentation of each diagnostic tool's purpose, usage, check items, and recommended workflow

### Changed

- **`.claude/settings.json`** — `UserPromptSubmit` フックの reminder 文言を強化:
  - **`task.md` 記録義務（AGENTS.md §8.4 準拠）** を追加 / `Record all loaded rule files in task.md per AGENTS.md §8.4`
  - **CRYSTALLIZATION_PROTOCOL Step 5 THRESHOLD CHECK の遵守義務** を追加。「追記 = 完了は誤認」を明示し、3件以上のドメインがあれば Blueprint 専用ファイルへの昇華まで完了させてからタスク完了を宣言する義務を AI に課す / Added mandatory `CRYSTALLIZATION_PROTOCOL §5 THRESHOLD CHECK` execution on task completion; "just appending to `core/010` is NOT completion"
- **`axiarch-rules/{ja,en}/CRYSTALLIZATION_PROTOCOL.md` §5** — 強い CAUTION ブロックを追加。「Step 4 (ACCUMULATE) は完了ではない」「タスク完了前に必ず Step 5 を実行せよ」「違反は `axiarch-scripts/check-axiarch-health.sh` Check 6 で検出可能」を明記 / Added a strong CAUTION block to §5 stating that Step 4 alone is not completion and that Step 5 MUST run before task completion; violations are externally detectable
- **`README.md`** — 「Hook Reinforcement Mechanism」サブセクション直下に **トラブルシュート章**（縮小版・約 10 行）を新設。`bash axiarch-scripts/check-axiarch-health.sh` への誘導、誤情報訂正（`permissions.allow Bash(echo *)` 不要）、公式 docs リンク / Added concise "Troubleshooting" subsection directing users to `axiarch-scripts/check-axiarch-health.sh`
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** — 「Hook補強機構」セクションに **診断ツール参照（v1.5.1+）** を追記（`axiarch-scripts/check-axiarch-health.sh` 案内、1 段落）/ Added one-paragraph reference to the diagnostic script
- **`init.sh`** — `AXIARCH_VERSION` 1.5.0 → 1.5.1。`.claude/settings.json` 配布直後に **`jq` による JSON 構文検証**（`jq` 不在時はスキップ、依存追加なし）。`axiarch-scripts/` 既存配布で `check-axiarch-health.sh` も自動配布対象 / Bumped version; added optional `jq` JSON validation post-copy; existing `axiarch-scripts/` distribution covers the new diagnostic
- **`llms-full.txt`** — Version 1.5.0 → 1.5.1

### Compatibility

- ✅ **後方互換性を維持** — 既存採用者は `git pull` + `init.sh` 再実行、または `.claude/settings.json` 手動上書きでアップグレード可能。フック message の文字数は約 600 → 約 1,534 文字（実測トークン換算: ~150 → ~380、**+153%**）に増えるが、プロンプトキャッシュ独立のため影響軽微（毎ターン system reminder として注入）/ Backward compatibility maintained; reminder grows from ~600 to ~1,534 chars (~150 → ~380 tokens, **+153%**), independent of prompt cache so impact remains negligible (injected as system reminder per turn)
- ✅ **Universal Rules 改訂なし** — `core_mindset.md` / `600_git_workflow.md` / `700_appstore_compliance.md` 等の憲法部分は変更なし / No constitutional changes
- ⚠️ **`task.md` の活用前提** — 既存 axiarch 採用者は `task.md` が `.gitignore` 対象（per-session 作業ドキュメント）であることが多い。AI 遵守確認時は手動で開いてロード履歴を確認する運用 / `task.md` is typically gitignored as per-session document; manually inspect for load logs

### Diagnostic Outcome (3 並列調査の結論 / 3-parallel investigation conclusions)

調査で**反証された**説：

- ❌ **JSON 構造誤り説** — 公式 hooks.md の必須ネスト構造に準拠（`{hooks: {UserPromptSubmit: [{hooks: [...]}]}}`）
- ❌ **Bash permission 不足説** — hook の `command` 型は harness が `child_process` で直接 spawn する経路で、`permissions.allow Bash(...)` の審査対象外。本セッション transcript で `hook success` 観測済みの事実が直接否定

採用された真因：

- ✅ **AI 遵守ギャップ** — フックは発火しているが、AI が reminder の指示（AGENTS.md / LOADING_PROTOCOL 暗黙実行・`task.md` 記録）をサボるケースで「動いていない感」が生じる
- ✅ **結晶化プロトコル違反パターン** — 子プロジェクト inucomi の Wave 1-15 実例：「`core/010` への追記 = 結晶化完了」と誤認し、3件以上のドメイン（セキュリティ 27件・パフォーマンス 6件・型安全 5件・a11y 4件・リファクタリング 4件・Server Action 3件 = 6 ドメイン違反）を Blueprint へ昇華せず放置。Step 5 (THRESHOLD CHECK) を一度も実行していなかった

### References

- 公式 docs: [Claude Code Hooks](https://code.claude.com/docs/en/hooks) / [Claude Code Permissions](https://code.claude.com/docs/en/permissions)

---

## [1.5.0] — 2026-05-06

### 🆕 Universal Rules 大規模拡充 + Hook 言語遵守強化 / Major Universal Rules Expansion + Hook Language Enforcement

axiarch v1.4.0 リリース後の累積改修を統合する minor bump。Universal Rules 6 ファイル（`core_mindset.md` / `510_aws_cloud.md` / `600_git_workflow.md` / `700_appstore_compliance.md` / `900_fundraising_ir.md` / `800_internationalization.md`）を 2026 Staff Engineer 基準で大規模拡充。`.claude/settings.json` の `UserPromptSubmit` フックには **Project Native Language 厳守** 指令を追加し、AI が日本語プロジェクトで英語見出し・要約を出すリスクを下げる。

Aggregates the cumulative refactors after the v1.4.0 release. Major expansion of 6 Universal Rule files (`core_mindset.md` / `510_aws_cloud.md` / `600_git_workflow.md` / `700_appstore_compliance.md` / `900_fundraising_ir.md` / `800_internationalization.md`) to 2026 Staff Engineer standards. Enhanced the `UserPromptSubmit` hook in `.claude/settings.json` with an explicit **Project Native Language adherence** directive that reduces the risk of English headings/summaries in Japanese-native projects.

### Added — Universal Rules 拡充（Constitution Amendment）

- **`axiarch-rules/{ja,en}/universal/core/000_core_mindset.md` Rev.14** — §1.14 Post-Quantum Readiness / §1.15 Regulatory Agility / §1.16 Developer Wellbeing & Sustainable Velocity / §1.17 Technology Governance（main の Rev.9 由来）+ §1.18 SBOM & Supply Chain Security / §1.19 AI-Native Test Strategy / §1.20 Evaluation-Driven Development / §1.21 Feature Flag & Progressive Delivery / §1.22 Platform Reliability Engineering / §1.23 Developer Experience as Product / §1.24 Responsible AI Disclosure / §1.25 Data Architecture Sovereignty / §1.26 API Design Governance / §1.27 Green Software Engineering / §1.28 Incident Response & Business Continuity / §1.29 AI Regulatory Compliance Governance / §1.30 Ethical Engineering & Societal Impact / §1.31 Type Safety as Foundation / §1.32 Compositional Architecture / §1.33 Inversion Thinking & Pre-Mortem / §1.34 YAGNI Discipline & Rule of Three / §1.35 Strong Opinions, Weakly Held / Disagree & Commit / §9.8 Model Governance / §9.9 Agentic Workflow Design Patterns / §9.10 AI Cost Governance / §9.11 Computer Use Agent Safety を追加 — 総 46 セクション / Total 46 sections
- **`axiarch-rules/{ja,en}/universal/engineering/510_aws_cloud.md`** — Primary Directive 0.9 Resilience & Chaos Engineering / 0.10 Observability-First / 0.11 Shared Responsibility & Compliance-by-Design / 0.12 Operational Excellence Culture を追加（Directive 0.1〜0.12 構成）/ Added 4 new directives
- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`** — 18 ルール / 5 Part → **45 ルール / 10 Part** に大規模拡充。§2.6 Merge Strategy / §2.7 Force-Push Protocol / §2.8 Commit Body & Trailers (AI Co-Authored-By) / §2.9 Fixup・Autosquash / §2.10 Conventional Commit Validation / Part 6 Branch Protection & Code Review (4 rules incl. §6.4 AI-Assisted PR Review) / Part 7 Tags, Releases & History (7 rules incl. §7.6 git maintenance) / Part 8 Repository Configuration & Assets (4 rules incl. §8.3 .git-blame-ignore-revs) / Part 9 Modern Tooling & Automation (5 rules incl. §9.4 Shallow Clone & Sparse Checkout) / Part 10 Anti-Pattern Catalog / Expanded from 18 rules / 5 Parts to 45 rules / 10 Parts
- **`axiarch-rules/{ja,en}/universal/product/700_appstore_compliance.md`** — 5 Part / 101 行 → **20 Part / 約 1,099 行**。Apple Privacy Stack（ATT・Privacy Manifests `PrivacyInfo.xcprivacy`・Required Reason API・Privacy Nutrition Labels）/ StoreKit 2 / Sign in with Apple / Account Deletion 5.1.1(v) / TestFlight・Phased Release・Expedited / Google Play AAB 必須化 / Play Integrity API / 子供向けアプリ（COPPA・GDPR-K）/ DMA Compliance / Generative AI App Compliance / Specialized Verticals（Health/Finance/Crypto/Games） / Expanded from 5 Parts / 101 lines to 20 Parts / ~1,099 lines
- **`axiarch-rules/{ja,en}/universal/product/900_fundraising_ir.md`** — 7 Part / 340 行 → **15 Part / 約 1,110 行**。Cap Table & ESOP 設計 / SAFE / Convertible Note / Bridge / KISS / Term Sheet 数学（Liquidation Preference・Anti-Dilution Full Ratchet vs Weighted Average）/ FEFTA・CFIUS・EU FDI Screening / MNPI / Tax Considerations（QSBS）/ IPO Preparation / M&A Exit / Founder Wellbeing / Investor Tech Stack / Anti-Pattern Catalog / Expanded from 7 Parts / 340 lines to 15 Parts / ~1,110 lines
- **`axiarch-rules/{ja,en}/universal/product/800_internationalization.md` v6.0 → v6.1** — 25 Part / 114 セクション → **29 Part / 133 セクション**。Part XXVI 2026 規制フロンティア（EU AI Act Article 50/13/11/52・India DPDP Schedule 1 22 言語・Saudi/UAE PDPL Arabic 義務・China PIPL/HK PDPO/Taiwan PDPA・LATAM/Africa: LGPD/LFPDPPP/POPIA/NDPA）/ Part XXVII 新興UXパラダイム（AR/XR・WebXR・Generative UI 多言語・CRDT Yjs/Automerge・Shadow DOM/Web Components 境界・Foldable/Wearable/CarPlay）/ Part XXVIII 翻訳品質フロンティア（MQM ASTM F2575 deep dive・Constrained Decoding・xCOMET-22/CometKiwi・Domain Adaptation・Translation Safety Classifiers）/ Part XXIX 危機対応・レジリエンス（多言語インシデント・緊急通信・TMSフェイルオーバー・多言語VDP）/ Expanded from 25 Parts / 114 sections to 29 Parts / 133 sections

### Changed

- **`.claude/settings.json`** — `UserPromptSubmit` フックの system reminder メッセージに `Output language MUST follow Project Native Language in AGENTS.md (headings, summaries, labels, lists, tables — all)` / `応答言語は AGENTS.md の Project Native Language に厳守（見出し・要約・ラベル・箇条書き・表すべて）` を追加。AI が日本語プロジェクトで英語見出し・要約・ラベルを出すサボりを物理的に防止 / Hook reminder now explicitly enforces `Project Native Language` adherence for all output structures, physically blocking the language-mixing failure mode
- **`axiarch-rules/{ja,en}/INDEX.md`** — 拡充された Universal Rules（000_core_mindset / 510_aws_cloud / 600_git_workflow / 700_appstore_compliance / 800_internationalization / 900_fundraising_ir）の説明欄を全件更新 / All affected INDEX entries updated
- **`init.sh`** — `AXIARCH_VERSION` 1.4.0 → 1.5.0 / Bumped version
- **`README.md`** — Version バッジは GitHub Releases 連動で自動更新 / Version badge auto-updates via GitHub Releases
- **`ROADMAP.md`** — 安定版 v1.4.0 → v1.5.0、JA/EN リリース履歴追記、旧「v1.5.0 検討中」セクションを v1.6.0 に繰り下げ / Stable bumped, history added, prior "v1.5.0 (under consideration)" section deferred to v1.6.0
- **`llms-full.txt`** — Version 1.4.0 → 1.5.0

### Compatibility

- ✅ **後方互換性を維持** — Universal Rules の拡充は既存ルール非破壊・純粋追補。既存採用者は `git pull` のみで取得可能 / Backward compatibility maintained: all expansions are additive; existing adopters obtain new rules via `git pull`
- ✅ **既存ファイルレイアウト変更なし** — `init.sh` / 配布物の構造は v1.4.0 と同一 / No layout changes; distribution structure identical to v1.4.0
- ⚠️ **トークンコスト** — Universal Rules 大規模拡充により、関連タスク（Git workflow / appstore / fundraising / i18n）でのロード時のトークン量が増加。`task.md` 記録義務 + LOADING_PROTOCOL の Step 2 自律選択により、必要セクションのみのオンデマンドロードを推奨 / Token cost rises during related-task loading; mitigate via on-demand section selection per LOADING_PROTOCOL Step 2
- ⚠️ **フックメッセージサイズ** — system reminder に約 60 トークン追加（前バージョン比 +75%）。プロンプトキャッシュとは独立だが影響軽微 / Hook reminder grows by ~60 tokens (+75% over prior); negligible impact independent of prompt cache
- 📌 **アップグレード手順** — `git pull` → `init.sh` 再実行（フックメッセージ更新を取得するため必須）/ Upgrade: `git pull` then re-run `init.sh` (mandatory to pick up the new hook reminder)

### References

- PR #25 — `feat: Universal core_mindset Rev.9 + AWS Cloud Directives 0.9-0.12`
- PR #26 — `feat: core_mindset Rev.14 (46 sections) + 600_git_workflow expansion (10 parts / 45 rules)`
- PR #27 — `feat: deep expansion of 700_appstore_compliance + 900_fundraising_ir + 800 v6.1 + hook language enforcement`

---

## [1.4.0] — 2026-05-04

### 🆕 Claude Code Hook Reinforcement Mechanism — UserPromptSubmit Hook / Claude Code Hook補強機構

Claude Code 採用プロジェクトに `UserPromptSubmit` フックを標準同梱し、AI のプロトコル遵守を物理的に強制する。`AGENTS.md` / `LOADING_PROTOCOL.md` が「指示書」止まりだった問題を解消し、軽い会話でもサボりを許さない設計へ転換。

Adds a standard `UserPromptSubmit` hook to Claude Code projects, physically enforcing AI protocol adherence. Closes the gap where `AGENTS.md` / `LOADING_PROTOCOL.md` were "instructions" without enforcement, so even casual prompts cannot bypass the protocol.

### Added

- **`.claude/settings.json`**（新規）— `UserPromptSubmit` フック定義。バイリンガル system reminder（en + ja）を**毎ユーザープロンプト送信時**に注入し、AI に AGENTS.md プロトコル＋LOADING_PROTOCOL の BOOT SEQUENCE 実行を強制 / NEW: `UserPromptSubmit` hook with bilingual system reminder injected on every prompt, compelling AI to execute AGENTS.md + LOADING_PROTOCOL BOOT SEQUENCE
- **`axiarch-rules/{ja,en}/LOADING_PROTOCOL.md`** — 「🛡️ Hook補強機構（ENFORCEMENT MECHANISM）」セクションを BOOT SEQUENCE 直後に追加。フック削除を「憲法改正」レベルと明記 / Added "🛡️ Hook Reinforcement Mechanism" section right after BOOT SEQUENCE; declares hook removal as a constitution-amending change
- **`README.md`** — Quick Start に「Claude Code Hook補強機構 / Hook Reinforcement Mechanism (v1.4.0+)」サブセクション、必須ファイル表に `.claude/settings.json` 行追加 / New "Hook Reinforcement Mechanism" subsection in Quick Start; new row in Required Files table

### Changed — Universal Constitution（憲法改正）

- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`** §5.1 — `.gitignore` 例示を `.claude/` 全無視 → `.claude/worktrees/` / `.claude/projects/` / `.claude/settings.local.json` の3項目に細分化（**汎用的な Claude Code best practice として記述、Axiarch 固有要素は含めず**）。Universal Rule の修正は AGENTS.md §5「既存機能保護プロトコル」例外条項に基づきユーザー明示承認の上で実施 / Refined `.gitignore` example in §5.1 from blanket `.claude/` ignore to granular `worktrees/` / `projects/` / `settings.local.json` (described as **generic Claude Code best practice; intentionally omits Axiarch-specific framework details**). Constitutional amendment performed under the §5 exception clause with explicit user approval
- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`** メタデータ — `Last Updated: 2026-05-03 (v1.3.2)` → `2026-05-04 (v1.4.0)` / Metadata bump

### Changed

- **`CLAUDE.md`** — 行 3 の `@AGENTS.md` import を削除。フック経由の Read ロード（`view_file` 履歴付与・`task.md` 記録発火）に統一し、Anti-Laziness Rule との整合を確保 / Removed `@AGENTS.md` import on line 3; unified loading via the hook-driven Read flow (preserves `view_file` history and triggers `task.md` recording), aligning with the Anti-Laziness Rule
- **`.gitignore`** — `.claude/` 全無視を `.claude/worktrees/` / `.claude/projects/` / `.claude/settings.local.json` の3項目に分解。`.claude/settings.json`（チーム共有設定）をコミット可能に / Refined: now ignores only worktrees/projects/local settings, allowing `.claude/settings.json` (team-shared config) to be committed
- **`init.sh`** — `AXIARCH_VERSION` 1.3.2 → 1.4.0 / `SETUP_CLAUDE` 分岐で `.claude/settings.json` を配布。**非 Claude Code エージェント選択時の cleanup は `.claude/settings.json`（Axiarch 配布物）のみ削除し、ユーザーの `worktrees/` / `projects/` / `settings.local.json` 等のセッションデータは温存**（`.claude/` フォルダは中身が空のときのみ rmdir）/ Bumped version; `SETUP_CLAUDE` now distributes `.claude/settings.json`; non-Claude-Code cleanup removes only the Axiarch-distributed `.claude/settings.json` and preserves user session data (`worktrees/` / `projects/` / `settings.local.json`); `.claude/` directory is rmdir'd only if empty
- **`README.md`** — Agent-Specific Setup 表 Step 3 を「`CLAUDE.md` + `.claude/settings.json` 配置」に更新、Step 2 コード例に `.claude/settings.json` コピー手順追加 / Updated Agent-Specific Setup table Step 3 and Step 2 manual-copy code block
- **`ROADMAP.md`** — 安定版 v1.3.2 → v1.4.0、JA/EN リリース履歴追記 / Stable version updated, history entries added
- **`llms-full.txt`** — Version 1.3.2 → 1.4.0

### Compatibility

- ✅ **後方互換性を維持** — 既存 v1.3.x 採用プロジェクトは `.claude/settings.json` 不在でも従来通り動作（フックなし、AI 自律遵守モード）/ Backward compatibility maintained: existing v1.3.x adopters work without the hook (autonomous-enforcement mode)
- ✅ **Claude Code 限定機能** — Antigravity / Codex / Cursor / Copilot / Windsurf には影響なし（各自が固有のロード機構を持つため）/ Claude Code-only feature; no impact on other agents (each has its own native loading mechanism)
- ⚠️ **`@AGENTS.md` import 削除の影響** — Claude Code はフック経由で AGENTS.md を Read するため挙動は強化される（`view_file` 履歴付与・`task.md` 記録発火）。挙動の劣化なし / Removing `@AGENTS.md` strengthens behavior: hook drives explicit Read, populating `view_file` history and triggering `task.md` recording. No regression
- ⚠️ **トークンコスト** — 毎プロンプトに ~80 トークンの system reminder 追加。プロンプトキャッシュとは独立だが影響無視可能 / Adds ~80 tokens per prompt as a system reminder; independent of prompt cache but negligible impact
- 📌 **アップグレード手順** — `git pull` → `init.sh` 再実行 OR 手動で `.claude/settings.json` を配置 / Upgrade: `git pull` then re-run `init.sh`, or manually place `.claude/settings.json`

### References

- 議論の出典: inucomi（子プロジェクト）でユーザーと検討 / Discussion origin: inucomi child-project session

---

## [1.3.2] — 2026-05-03

### 🆕 Universal Engineering 600 新設 + Git Workflow Refactor + Worktree Hygiene Protocol / Universal Engineering 600 + Git Workflow Refactor + Worktree Hygiene Protocol

axiarch を採用する全プロジェクトに Git Workflow と `.git/config` 健全性管理を恒常的に提供する Universal ルールを追加。`axiarch-scripts/check-git-config-clean.sh` を OSS 採用者全員へ配布。`engineering/000` Part X の pure-git workflow を新ファイル `engineering/600_git_workflow.md` に集約（YAGNI 原則に基づく構造正規化）。

Adds a Universal rule providing Git Workflow and `.git/config` integrity management to all axiarch-adopting projects. Distributes `axiarch-scripts/check-git-config-clean.sh` to OSS adopters. Consolidates pure-git workflow from `engineering/000` Part X into the new `engineering/600_git_workflow.md` file (YAGNI-based structural normalization).

### Added

- **`axiarch-rules/{ja,en}/universal/engineering/600_git_workflow.md`**（新規 Universal Rule）— **5パート・18ルール**: Trunk-Based Development (§1) / Commit & PR Standards (§2) / Branch Hygiene Mandate (§3) / **Worktree Hygiene Protocol (§4)** — `[extensions] worktreeConfig = true` 残留問題（Antigravity の Go ベース language server クラッシュ・`ECONNREFUSED 127.0.0.1:50347`）の検出・修復・予防 / Repository Hygiene & Config Integrity (§5)。クロスリファレンス（security/operations/quality 等）・逆引き索引付き / **NEW Universal Rule** with 5 parts, 18 rules covering daily Git workflow including the **Worktree Hygiene Protocol** that documents the `worktreeConfig` residue problem (Antigravity Go-based language server crash) detection/repair/prevention
- **`axiarch-scripts/check-git-config-clean.sh`** — `.git/config` の自動検出・修復スクリプト（`--fix` / `--quiet` / `--full-clean` モード対応、現在ブランチ自動除外）/ Auto-detection & repair script for `.git/config` with `--fix`, `--quiet`, `--full-clean` modes (auto-excludes current branch)
- **`init.sh`** に `axiarch-scripts/` ディレクトリ配布ロジック追加 — axiarch 採用と同時に `check-git-config-clean.sh` が自動配布される / Added `axiarch-scripts/` distribution logic so adopters automatically receive `check-git-config-clean.sh`

### Changed — Universal Engineering Restructure

- **`engineering/000_engineering_standards.md`** Part X 構造変更:
    - **§10.0 Trunk Based Development → 600 §1 へ移動** / Moved to 600 §1
    - **§10.1 Commit & PR Standards → 部分移動**: Conventional Commits / Atomic Commits / PR Template / 100行ルール / Husky / lint-staged / Branch Hygiene を 600 §2 へ移動。**残置**: CI Timeout / Red Button Checklist / Omnichannel Check / Deployment Safety Protocol / Security secrets / Lockfile Regen / Connection Verification（§10.1 を **CI/Deployment Safety Standards** に改題） / Partial migration: pure-git items moved to 600 §2; CI/deploy items remain (renamed to "CI/Deployment Safety Standards")
    - **§10.3 The Branch Hygiene Mandate → 600 §3 へ移動** / Moved to 600 §3
    - **§10.2 IPv6 / §10.4 Migration Immutability / §10.5 Version Alignment / §10.6 Zod Nullable** は暫定的に Part X に残置（v1.4.x 以降に `engineering/200_supabase_architecture.md` または `engineering/300_web_frontend.md` への再配置を検討）/ §10.2 IPv6 / §10.4 Migration / §10.5 Version Alignment / §10.6 Zod Nullable transitionally retained in Part X (relocation candidates for v1.4.x+)
    - **Part X タイトル変更**: 「Git とバージョン管理」→「**CI/Deploy & 補助規約**」 / Part X title changed from "Git & Version Control" to "**CI/Deploy & Auxiliary Standards**"
    - 上部 overview テーブル更新: `§10.0–§10.6 / 7 ルール` → `§10.1, §10.2, §10.4–§10.6 / 5 ルール`、合計 147 → 145 / Top overview table updated

### Changed — Documentation & Index

- **`axiarch-rules/{ja,en}/INDEX.md`** — engineering 一覧に 600 を追加 / Added 600 entry to engineering listing
- **`README.md`** — Universal Rules バッジ `38_files` → `39_files` / Engineering ファイル数 9 → 10 / Universal Rules count badge `38_files` → `39_files`, Engineering file count 9 → 10
- **`llms-full.txt`** — engineering count 9 → 10 / Version: 1.3.1 → 1.3.2
- **`ROADMAP.md`** — 安定版 v1.3.1 → v1.3.2、JA/EN 両セクションにリリース履歴追加 / Stable version updated, history entries added
- **`init.sh`** — AXIARCH_VERSION 1.3.0 → 1.3.2

### Compatibility

- ✅ **後方互換性を維持** — 既存採用プロジェクトは pull するだけで新ルールと script を取得 / Backward compatibility maintained — existing adopters just `git pull`
- ✅ **誰にとっても無害** — Claude Code 単体 / Antigravity 単体 / 並行使用、3シナリオ全てで Pareto-improvement / Pareto-improvement across all three scenarios (Claude Code only / Antigravity only / parallel use)
- ⚠️ **構造的注記**: `engineering/000` Part X の §10.0 / §10.3 は削除されました。外部ドキュメントから §10.0 / §10.3 への直接参照がある場合、`600_git_workflow.md` §1 / §3 へ更新してください / §10.0 / §10.3 in `engineering/000` Part X have been removed. Update any external references to point to `600_git_workflow.md` §1 / §3
- 📌 **将来の課題**: Part X §10.4 / §10.5 / §10.6 は本来ドメイン固有のため `engineering/200_supabase_architecture.md` または `engineering/300_web_frontend.md` への移動候補（v1.4.x で再配置検討）/ §10.4 / §10.5 / §10.6 are domain-specific and candidates for relocation in v1.4.x

### References

- Antigravity recurrence first detected: 2026-04-29 (inucomi project) / Resolved: 2026-05-03 with cross-project lesson crystallization to axiarch Universal
- Related lesson source: `inucomi` project commit `c649896e` (Blueprint level)

---

## [1.3.1] — 2026-05-03

### ✨ Claude Code `@import` 統合 / Claude Code `@import` Integration

### Added

- **`CLAUDE.md`** — `@AGENTS.md` import 構文を追加。Claude Code 起動時に AGENTS.md（最上位プロトコル・9プロトコル）全文が system prompt へ自動 inline され、BOOT SEQUENCE PROTOCOL の初動遵守を補強。AI の自律的な Read tool 実行だけに依存しない形で初動プロトコルを参照しやすくする / Added `@AGENTS.md` import syntax. AGENTS.md (Top-Level Protocol / 9 protocols) is now auto-inlined into the system prompt at Claude Code session start, reinforcing BOOT SEQUENCE PROTOCOL without relying only on the AI to autonomously read it. Reference: <https://code.claude.com/docs/en/memory.md#import-additional-files>

### Compatibility

- 後方互換性を維持。Claude Code 専用機能のため、他エージェント（Cursor / Copilot / Windsurf / Antigravity / Codex）には影響なし / Backward compatibility maintained. Claude Code-specific feature — no effect on other agents
- トークン消費: 新規セッション開始時のみ +約 8K tokens（メッセージ毎の追加消費なし） / +~8K tokens at session start only (zero per-message overhead)

---

## [1.3.0] — 2026-04-30

### 🏗️ バイリンガル構造リアーキテクチャ / Bilingual Directory Re-Architecture

ディレクトリ構造を「言語ファースト」に全面移行。全ポインター・プロンプト・設定ファイルのクロスリファレンスを同期更新。156ファイル変更。

Directory structure fully migrated to "Language-First" layout. All pointer, prompt, and config file cross-references synchronized. 156 files changed.

### Changed — Directory Structure (Breaking)

- **`axiarch-rules/` ディレクトリ構造の全面再編** — 旧 `axiarch-rules/universal/{ja,en}/` → 新 `axiarch-rules/{ja,en}/universal/`、旧 `axiarch-rules/blueprint/{ja,en}/` → 新 `axiarch-rules/{ja,en}/blueprint/` へ移行。言語選択時のディレクトリ削除が `rm -rf axiarch-rules/en` の1コマンドで完了するシンプルな構造に / Restructured from `axiarch-rules/universal/{lang}/` to `axiarch-rules/{lang}/universal/`. Language cleanup now requires a single `rm -rf` command
- **`axiarch-rules/*.md` → `axiarch-rules/{ja,en}/*.md`** — `INDEX.md`, `LOADING_PROTOCOL.md`, `CRYSTALLIZATION_PROTOCOL.md`, `README.md`, `compliance_matrix.md` を各言語フォルダ直下に移動。言語ごとの完全自己完結を実現 / Moved infrastructure files into each language folder for full self-containment

### Added

- **`CLAUDE.md`** — Claude Code固有のポインターファイル（独立Markdown）を新規追加。旧シムリンク方式から独立ポインターファイルに変更 / Added Claude Code-specific pointer file (independent Markdown). Replaced former symlink approach with standalone pointer file
- **OpenAI Codex サポート / OpenAI Codex Support** — OpenAI Codex が `AGENTS.md` をネイティブに読み込む特性に基づき、互換性リストに公式追加。追加のポインターファイル不要で自動動作する旨をドキュメント（`README.md`, `ROADMAP.md`, `llms.txt`, `llms-full.txt`）および `init.sh` に反映 / Officially added OpenAI Codex to the compatibility list as it natively supports `AGENTS.md`. Updated documentation and `init.sh` to reflect that it requires no additional pointer files

### Changed — Cross-Reference Updates (46 files)

- **`AGENTS.md`** — 全パス参照を新構造（`{lang}/universal/`, `{lang}/blueprint/`）に更新 / All path references updated to new structure
- **`README.md`** — Claude Code記述を「シムリンク」→「ポインターファイル」に修正、ディレクトリ構造図を新構造に更新 / Claude Code description corrected from "symlink" to "pointer file", directory structure diagram updated
- **ポインターファイル 5種** — `.agents/rules/prompt_pointer.md`, `.cursor/rules/axiarch.mdc`, `CLAUDE.md`, `.windsurfrules`, `.github/copilot-instructions.md` を新構造に同期 / All 5 pointer files synchronized to new structure
- **`axiarch-prompts/` 全16本 × 2言語** — プロンプト内のパス参照を新構造に更新 / All prompt path references updated
- **`init.sh`** — 新ディレクトリ構造に対応するようセットアップスクリプトを更新 / Setup script updated for new directory structure
- **`.github/CODEOWNERS`** — パス定義を新構造に更新 / Path definitions updated
- **`.github/workflows/lint.yml`** — 対称性チェックのパスを新構造に更新 / Symmetry check paths updated
- **`.github/PULL_REQUEST_TEMPLATE.md`** — バイリンガル要件の記述を新構造に更新 / Bilingual requirement description updated
- **`.github/ISSUE_TEMPLATE/bug_report.yml`** — パス参照を新構造に更新 / Path references updated
- **`CONTRIBUTING.md`** — パス表記を新構造に更新 / Path notation updated
- **`llms.txt`** — Claude Code記述を「symlink」→「reads CLAUDE.md pointer file」に修正 / Claude Code description corrected
- **`llms-full.txt`** — バージョン表記を1.3.0に更新、Claude Code記述を「symlink」→「pointer file」に修正 / Version updated to 1.3.0, Claude Code description corrected

---

## [1.2.0] — 2026-04-29

### 🏛️ Universal Rules v2.0 大規模ブラッシュアップ / Blueprint 構造正規化

60ファイル変更、59,670行追加の大規模アップデート。全19 Universal Rules を2026 Staff Engineer ガバナンス基準に準拠する網羅的フレームワークへ拡張。Blueprint を YAGNI 原則に基づき正規化。

60 files changed, 59,670 insertions. All 19 Universal Rules expanded to comprehensive frameworks aligned with 2026 Staff Engineer governance standards. Blueprint normalized based on YAGNI principle.

### Changed — Universal Rules (19 files × 2 languages = 38 files)

- **`product/400_pricing_strategy.md`** — 17パート・180+ルールの包括的フレームワークへ拡張。AI-Native Monetization（Agentic ROI・Edge AI・Consumption-Based Commitment）、Quantum-Safe Pricing、Vertical AI Compliance、Green AI Pricing、Sovereign AI Pricing を統合 / Expanded to 17-part, 180+ rule framework with AI-Native Monetization, Quantum-Safe Pricing, and global regulatory alignment
- **`product/500_growth_marketing.md`** — 23パート・120+セクションの v3.0 へ拡張。AI-Native Growth、Community-Led Growth、Paid Acquisition Governance、Growth FinOps、Zero-Party Data Strategy、ASO、EU AI Act 透明性プロトコルを統合 / Expanded to 23-part v3.0 with AI-Native Growth, CLG, and Privacy-First protocols
- **`product/600_brand_strategy.md`** — 22パート・120+セクションの v2.0 へ拡張。Brand Flywheel、Golden Dataset Protocol、AI Brand Drift Detection、Multi-Agent Orchestration、BrandSOC、Sonic & Sensory Branding、Spatial Computing、Web3、Brand CI/CD を統合 / Expanded to 22-part v2.0 with AI-Native Brand Governance
- **`product/300_revenue_monetization.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`product/000_product_strategy.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`product/100_market_validation.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`product/200_go_to_market.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`security/000_security_privacy.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`security/200_oss_compliance.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`security/300_ip_due_diligence.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`quality/000_qa_testing.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`ai/000_ai_engineering.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`design/000_design_ux.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`engineering/000_engineering_standards.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`engineering/300_web_frontend.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`operations/100_sales_bizdev.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`operations/200_hr_organization.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`operations/600_cloud_finops.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards
- **`operations/700_partnership_ecosystem.md`** — 2026基準への網羅的ブラッシュアップ / Comprehensive brushup to 2026 standards

### Changed — Blueprint Structure Normalization

- **Blueprint README.md (14 files)** — JA/EN 各7ドメインフォルダの README.md に YAGNI 原則・結晶化プロトコルの説明を追加。「初期状態では空であることが正しい設計」を明示 / Added YAGNI principle and crystallization protocol explanation to all 14 domain folder READMEs
- **`axiarch-rules/INDEX.md`** — Universal Rules 概要を v2.0 に同期 / Synced Universal Rules summaries to v2.0
- **`axiarch-rules/blueprint/{ja,en}/INDEX.md`** — Blueprint INDEX を構造正規化に同期 / Synced Blueprint INDEX to structural normalization

### Changed — Documentation & Metadata

- **`ROADMAP.md`** — v1.1.0/v1.2.0 リリース履歴追加、安定版表示を v1.2.0 に更新、将来版を v1.3.0 に繰り上げ / Added v1.1.0/v1.2.0 release history, updated stable version, bumped future version to v1.3.0
- **`llms-full.txt`** — バージョン表記を 1.2.0 に更新 / Updated version to 1.2.0
- **`SECURITY.md`** — セキュリティポリシー更新 / Security policy update

### Added

- **`.github/dependabot.yml`** — GitHub Actions の依存関係自動更新設定 / Dependabot configuration for GitHub Actions dependency updates

---

## [1.1.0] — 2026-04-12

### ✨ Design & UX Strategy v3.0 / AGENTS.md Protocol 6 追加

### Added

- **AGENTS.md §6: Anti-Full-Overwrite Protocol** — 既存ファイルの全文上書き（`write_to_file(Overwrite: true)` 相当）を原則禁止する新プロトコル。差分編集（`replace_file_content` / `multi_replace_file_content`）を義務化 / New protocol prohibiting full-file overwrite of existing files by default. Mandates diff-based editing.
- **`.github/workflows/release.yml`** — PRマージ時にCHANGELOG.mdからバージョンを自動検出し、タグ作成→GitHub Release生成まで一気通貫で自動実行するCI/CDワークフロー / Auto-detect version from CHANGELOG.md on PR merge, create tag & GitHub Release automatically

### Changed

- **`universal/{ja,en}/design/000_design_ux.md`** — 25パート完成版 v3.0 にリファクタリング / Refactored to 25-part complete edition v3.0
  - 新規5パート追加: §21 Calm UI, §22 Voice UI, §23 Design System as a Product, §24 WCAG 3.0前方互換性, §25 Design FinOps
  - 技術固有ルール（React/Hydration）を `engineering/` へ委譲
  - EU Digital Fairness Act (DFA) 追加、アンチパターン 30→35選に拡張
  - JA/EN完全構造同期（§25, ###96, 1046行）
- **AGENTS.md** — §5.1→§6昇格、全セクション番号リナンバー（§6→§7, §7→§8, §8→§9） / Section renumbering: Anti-Full-Overwrite promoted to §6, subsequent sections renumbered
- **`axiarch-rules/INDEX.md`** — Design UX概要文を25パート完成版に同期 / Design UX summary synced to 25-part edition
- **`axiarch-rules/LOADING_PROTOCOL.md`** — §7→§8 参照更新 / Reference updated §7→§8
- **`axiarch-rules/CRYSTALLIZATION_PROTOCOL.md`** — §8→§9 参照更新 / Reference updated §8→§9
- **`blueprint/{ja,en}/core/010_project_lessons_log.md`** — §8→§9 参照更新 / Reference updated §8→§9
- **`ROADMAP.md`** — 8プロトコル→9プロトコル / 8 protocols → 9 protocols
- **`llms-full.txt`** — Protocol 6追加、Protocol 7-9リナンバー、Design概要更新 / Protocol 6 added, 7-9 renumbered, Design summary updated

---

## [1.0.0] — 2026-04-10

### 🎉 Initial Public Release

**Axiarch（アクシアーク）** — 憲法駆動型 AIエージェントガバナンスフレームワーク初回公開リリース。

**Axiarch (AX-ee-ark)** — Constitution-Driven AI Agent Governance Framework, initial public release.

### Added

- **AGENTS.md** — AI行動憲法（9プロトコル定義） / AI Behavior Constitution (9 protocols)
- **Universal Rules** — 38ファイル × 2言語（JA/EN）、2,500以上の憲法基準 / 38 files × 2 languages, 2,500+ constitution standards
  - 000: Core & Mindset
  - 100–150: Product & Business Strategy
  - 200: Design & UX
  - 300–361: Engineering (Standards, API, Supabase, Web, CMS, Flutter, Native, Firebase, AWS)
  - 400–401: AI & Data
  - 500–530: Operations & Reliability
  - 600–603: Security & Legal
  - 700–720: QA & FinOps
  - 800–802: Global & Governance
- **Blueprint Templates** — プロジェクト固有テンプレート / Project-specific templates
  - `core/000_project_overview.md` — プロジェクト概要 / Project overview
  - `core/010_project_lessons_log.md` — 教訓ログ / Lessons log
  - `core/998_feature_spec_template.md` — 機能仕様テンプレート / feature spec template
  - `core/999_project_specific_template.md` — プロジェクト固有ルール / Project-specific rules
- **LOADING_PROTOCOL.md** — 5ステップのルールロード手順 / 5-step rule loading protocol
- **CRYSTALLIZATION_PROTOCOL.md** — 教訓の自動結晶化プロトコル / Lesson auto-crystallization protocol
- **INDEX.md** — 全ルールの詳細索引 / Detailed index of all rules
- **compliance_matrix.md** — 要件対照表 / Compliance matrix
- **`init.sh`** — インタラクティブなセットアップスクリプト。言語・エージェント選択→ファイルコピー→次のステップ案内まで自動化 / Interactive setup script automating language/agent selection, file copy, and next-step guidance
- **`.github/CODEOWNERS`** — 最上位プロトコル・Universal Rules・Blueprint・プロンプト集の責任範囲を区分したコードオーナー定義 / Code owner definitions with responsibility boundaries
- **`.github/workflows/lint.yml`** — Markdownリント + JA/EN対称性をすべてのPR/pushで自動検証するGitHub Actions CI / GitHub Actions CI: Markdown lint + JA/EN symmetry validation
- **`llms.txt`** — AI検索エンジン向けに構造化されたプロジェクトサマリー（GEO対応） / Structured project summary for AI search engine optimization (GEO)
- **`llms-full.txt`** — AI検索エンジン向け完全仕様書（詳細版） / Full specification document for AI search engines (detailed version)
- **GitHub Discussions** — Q&A・ユースケース共有のコミュニティ基盤 / Community foundation for Q&A and use case sharing
- **`question.yml`** — Q&A用 Issue テンプレート / Q&A issue template
- **Prompt Library (`axiarch-prompts/`)** — 16本 × 2言語（JA/EN）の再利用可能プロンプトテンプレート / 16 templates × 2 languages (JA/EN), reusable prompt library
  - `develop/` — 開発・実行系 4本 / Development & execution (4 prompts): `feature_development`, `refactoring_audit`, `push_execute`, `ci_fix`
  - `audit/` — 品質・整合性監査系 5本 / Quality & integrity auditing (5 prompts): `fullstack_qa_audit`, `api_architecture_audit`, `data_integrity_audit`, `system_integrity_audit`, `deep_optimization_audit`
  - `govern/` — コンプライアンス・ガバナンス系 5本 / Compliance & governance (5 prompts): `compliance_inspector_audit`, `constitution_compliance_audit`, `governance_auditor`, `blueprint_governance_audit`, `localization_audit`
  - `operate/` — インシデント・参入系 2本 / Incident response & onboarding (2 prompts): `onboarding_audit`, `incident_response`
- **`axiarch-prompts/README.md`** — ユースケース別フローチャート・重複解消マトリクス・複合利用ガイドを含む包括的なプロンプト選択ガイド / Comprehensive prompt selection guide with use-case flowchart and compound usage guide

### Background

実際のプロダクション開発でのAI支援開発（Google Antigravity）を通じた数百セッションの実践知見から構築。

Built from hundreds of AI-assisted development sessions on Google Antigravity during real production development.

[Unreleased]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.15.0...HEAD
[1.15.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.14.0...v1.15.0
[1.14.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.13.1...v1.14.0
[1.13.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.13.0...v1.13.1
[1.13.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.12.1...v1.13.0
[1.12.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.12.0...v1.12.1
[1.12.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.11.2...v1.12.0
[1.11.2]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.11.1...v1.11.2
[1.11.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.11.0...v1.11.1
[1.11.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.10.0...v1.11.0
[1.10.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.9.0...v1.10.0
[1.9.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.8.2...v1.9.0
[1.8.2]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.8.1...v1.8.2
[1.8.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.8.0...v1.8.1
[1.8.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.6.0...v1.8.0
[1.7.0]: https://github.com/hiroyuki-miyauchi/axiarch/blob/main/CHANGELOG.md#170--2026-05-08-内部開発のみ独立-release-はせず-v180-に統合
[1.6.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.5...v1.6.0
[1.5.5]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.4...v1.5.5
[1.5.4]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.3...v1.5.4
[1.5.3]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.2...v1.5.3
[1.5.2]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.1...v1.5.2
[1.5.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.5.0...v1.5.1
[1.5.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.3.2...v1.4.0
[1.3.2]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/hiroyuki-miyauchi/axiarch/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/hiroyuki-miyauchi/axiarch/releases/tag/v1.0.0
