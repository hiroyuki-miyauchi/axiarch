# LOADING_PROTOCOL.md — ルールロード手順書

> **このファイルはルールロードの詳細手順を定義する。`AXIARCH.md` から参照される。**

> Universal Rules はプロジェクトで使う可能性のある技術・運用領域を横断する基準ルール集です。AIは LOADING_PROTOCOL に従い、タスクに必要なファイルのみを選択的にロードします。使わない技術のルールは任意の参照対象であり、将来採用時や未知の技術に直面したときの品質底上げを支える補助資産として扱います。

---

## 🚨 初動プロトコル（BOOT SEQUENCE PROTOCOL）🚨

会話の開始時（新規チャット、またはコンテキストリセット後）は、**必ず以下の3原則に従い、ルールの実際のロードが完了するまで作業を開始してはならない。**

1. **Stop & Wait**: いきなり修正や監査を始めないこと。ルールを先に読み込み、理解してから行動する。

2. **No Hallucination（幻覚の禁止）**: ユーザーから明確なコードやファイル構成が提示される**前に**、推測で勝手に「ロード済みルール一覧」「プロジェクト構成」「技術スタック概要」などを生成して出力することを**固く禁ずる**。実際にファイルを読み込む前のいかなる「事前知識の提示」もハルシネーション（幻覚）と見なす。

3. **Exact Match Only**: 余計なテキストや独自の解釈は一切追加せず、実際にツールで読み込んだ内容「のみ」を根拠として用いること。

---

## 🛡️ Hook補強機構（HOOK REINFORCEMENT MECHANISM）🛡️

**Claude Code または Codex の hook 構成を採用するプロジェクトには、`.claude/settings.json` または `.codex/hooks.json` に 4 種類のフックが配置される**：

| フック / Hook | 発火タイミング | 役割 | 外出しスクリプト |
|:--|:--|:--|:--|
| `SessionStart` | 会話開始時 | `task.md` / `implementation_plan.md` / `walkthrough.md` を現在タスク用に自動ブートストラップし、`AXIARCH.md` reminder を注入。既存内容は `axiarch-task-state.sh` により `.axiarch/process-doc-history/` へ退避 | `axiarch-scripts/axiarch-init-task-md.sh` + `axiarch-scripts/axiarch-task-state.sh` |
| `UserPromptSubmit` | 毎ユーザープロンプト送信時 | system reminder（事実陳述 + 動的違反検出）注入で `AXIARCH.md` / BOOT SEQUENCE 暗黙実行を継続補強 | `axiarch-scripts/axiarch-boot-reminder.sh` |
| `PreToolUse` (matcher: `Write`) | `Write` tool 呼び出し直前 | 対応環境で既存ファイルへの全面書き換えを遮断（§6 ANTI-FULL-OVERWRITE）。`.claude/axiarch-overwrite-allow.txt` または `.codex/axiarch-overwrite-allow.txt` で whitelist 可 | `axiarch-scripts/axiarch-protect-antifull.sh` |
| `PostToolUse` (matcher: `Edit` / `MultiEdit` / `Write`) | ファイル編集後 | git diffの変更行数・変更ファイル数を測定し、閾値超過時に warn / block | `axiarch-scripts/axiarch-diff-guard.sh` |

**この 4 フックの削除・無効化は「憲法改正」レベルの破壊的変更**であり、オーナーの明示的承認が必要である。特に `PreToolUse` は **Reminder に加えて Physical Block も使う** 補強機構（参考: arXiv:2503.18666 AgentSpec、arXiv:2502.15851 Control Illusion）であり、reminder のみでは防ぎきれない §6 違反のリスクを下げる。

フックが配置されていない環境では、AI 自身が自律的に上記 BOOT SEQUENCE 3 原則を遵守すること。

> Antigravity / Cursor / Copilot / Windsurf は固有のロード機構またはポインター機構（例: Antigravity は `.agents/rules/` 自動読み込み）を持つため、Claude Code / Codex 用の本フック群は標準必須ではない。主対象の Google Antigravity・OpenAI Codex・Claude Code は、いずれも実運用（ドッグフーディング）で稼働を確認済みである。Antigravity を最初の実証対象とし、Codex・Claude Code も本リポジトリ自体の開発を含む実運用で継続使用している。ただし、全環境での動作保証まではしない。Cursor / Copilot / Windsurf は拡張ポインターのみで動作保証しない。

### 🧭 ネイティブタスク・プラン状態同期（v1.11.0+）

`task.md` / `implementation_plan.md` / `walkthrough.md` は、現在タスクのMarkdown証跡であり、CodexやClaude Codeの独自タスク・プラン表示欄を自動更新するものではない。Axiarchはこの2つを分離して扱う。

| 層 | 責務 |
|:--|:--|
| Markdown証跡 | ロード履歴、計画、変更確認を永続的に残す。新規セッション時は `axiarch-task-state.sh` が過去内容を `.axiarch/process-doc-history/` へ退避し、`Project Native Language` に合わせた現在タスク用テンプレートへ更新する |
| ネイティブ状態 | エージェントUIのタスク・プラン表示。Codexでは `update_plan`、Claude Codeでは `TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` を使って、作業中に逐次更新する |

運用原則:

1. Codexでは複数ステップの作業を開始した時点で `update_plan` を呼び、作業中は `in_progress` を1件だけ維持する。
2. Claude CodeではTask toolsが使える場合、`TaskCreate` / `TaskUpdate` / `TaskList` / `TaskGet` を優先する。古いSDKや非interactive実行でTask toolsがない場合のみ `TodoWrite` にフォールバックする。
3. Markdownファイルを書いたことをもって、ネイティブUIが更新されたと表現してはならない。ネイティブUI更新は該当ツール呼び出しが行われた場合のみ完了とみなす。
4. `AXIARCH_PROCESS_DOC_MODE=append` が明示されていない限り、3ファイルは現在タスク用として扱い、過去内容の無制限追記を避ける。テンプレート言語は既定で `AXIARCH.md` の `Project Native Language` から判定し、旧導入先では `AGENTS.md` をフォールバックとして参照する。必要な場合だけ `AXIARCH_PROCESS_DOC_LANG=ja|en` で明示する。

### 🔍 フック診断

「フックが動いていない気がする」場合は **`bash axiarch-scripts/check-axiarch-health.sh`** を実行せよ。4 フックすべての配線確認（Check 3 = UserPromptSubmit / Check 11 = PreToolUse / Check 12 = SessionStart / Check 15 = v1.9+ integration）に加え、Axiarch本体ではv1.10.0以降のリリースメタデータ整合、ROADMAP Current Stable・正規AI-facing header・CHANGELOG compare ref・GitHub Actions immutable SHAの厳密一致と日英完了release entry、Safe Upgrade Wizard manifest配線・exclude処理・source-only既定skipとinteractive明示override・対話選択肢重複排除・本体リポジトリ専用ファイル分類・`replace-if-local-unchanged` 実行時保護・型不一致review・upgrade metadata版数正規化・fallback core Blueprint検出・任意prompt証跡、Blueprint INDEXの共有Operations登録と版数、safe upgrade promptのREADME/llms/rules索引、README/llms/scripts READMEの `axiarch-scripts/` 必須/任意境界、Claude Memory正本境界、Check 16 の Language First / Execution Harness / 読み取り専用委任境界も確認する 16 段階の標準診断ツール（`init.sh` 経由で自動配布）。詳細は `README.md` の「Hook補強機構」章を参照。

---

## Step 1: タスク分類

ユーザーの指示を読み、以下のタスクタイプに分類せよ。複数該当する場合は全て選択する。

| タスクタイプ | 判定基準 |
|:----------------------|:------------|
| `security` | セキュリティ、認証、認可、RLS、暗号化、脆弱性、監査 |
| `architecture` | 設計、アーキテクチャ、DB設計、マイグレーション、インフラ |
| `performance` | パフォーマンス、最適化、SRE、モニタリング、キャッシュ |
| `ui_design` | UI、UX、デザインシステム、レイアウト、アクセシビリティ |
| `api` | API設計、エンドポイント、スキーマ、バリデーション |
| `i18n` | 国際化、ローカライゼーション、翻訳 |
| `finops` | コスト最適化、課金、FinOps |
| `testing` | テスト、品質保証、E2E、ユニットテスト |
| `other` | 上記に該当しない一般的なタスク |

---

## Step 2: INDEX起点のファイル特定

`axiarch-rules/{lang}/INDEX.md` を読み、ルール全体の構成を把握する。

### 階級別スキャンとロード

| 階級 | 対象 | 性質 |
|:------------|:-------------|:---------|
| **Class S（Universal）** | `axiarch-rules/{lang}/universal/` | プロジェクトを超えた普遍的ルール。Read-Only。 |
| **Class A（Blueprint）** | `axiarch-rules/{lang}/blueprint/` | プロジェクト固有の仕様・設計・教訓。更新可能。**基本フォルダ構成は「初期フォルダ」であり、閉じた集合ではない。** 既存フォルダに分類できない新ドメインがある場合は、ユーザー承認のうえで新規フォルダを追加できる（AIは提案までで、独断作成は禁止）。その前提のうえで、初期フォルダは次の8つ: **`core/`**（概要・教訓インデックス・テンプレート）・`security/`（セキュリティ）・`engineering/`（エンジニアリング）・`design/`（デザイン）・`quality/`（QA・テスト）・`operations/`（運用）・`product/`（ビジネス）・`ai/`（AI）。内容に応じて以下の4カテゴリにロード分類される：① **Project Overview**（`core/000_project_overview.md`）、② **Lessons Index**（`core/010_project_lessons_log.md` + 各ドメインフォルダ内の `{NNN}_{topic}.md` 形式の昇華ファイル。初期フォルダ対応表を優先し、必要時はユーザー承認済みフォルダも含めて自律判断）、③ **Domain Rules**（各ドメインのルールファイル）、④ **Templates**（`core/` 等のテンプレートファイル） |

Step 1で特定したタスクタイプに対応するINDEX.mdのカテゴリから、ロードすべきファイルを列挙せよ。

> ⚠️ **重要**: INDEX.mdを読むのは「ロード候補リストの作成」のみ。実際の**ファイル**内容の取得（ロード）は必ず Step 3 で行う。INDEX.md だけ読んで「把握しました」はロード完了とみなしてはならない。

### タスクタイプ → フォルダ 対応表

| タスクタイプ | Universal フォルダ | Blueprint フォルダ (初期対応。新設はユーザー提案・承認後) |
|:----------------------|:----------------|:----------------|
| `security` | `security/` | `security/` |
| `architecture` | `engineering/` | `engineering/` |
| `performance` | `engineering/` + `operations/` | `engineering/` + `operations/` |
| `ui_design` | `design/` | `design/` |
| `api` | `engineering/` | `engineering/` |
| `i18n` | `product/` (国際化・翻訳ルールを参照) | `product/` |
| `finops` | `operations/` (FinOps・クラウドコストルールを参照) | `operations/` |
| `testing` | `quality/` | `quality/` |
| `other` | —（タスク内容に応じて自律判断） | `core/`（Project Overview + Lessons を必ずロード） |

---

## Step 3: ファイル読み込み

**Step 2で特定した各ファイルを直接開き**、ファイル冒頭の目次またはファイル末尾のAppendix（逆引き索引）からタスクに関連するセクションを自律選択してロードすること。

### 🚨【厳守命令】手抜き（サボり）と幻覚の絶対禁止 🚨

- INDEX.mdの要約や概要だけで「読んだ」と見なすことは**一切禁止**する。
- 「ファイルを直接開く」とは、`view_file`等のツールでファイルの内容を**実際に取得完了すること**を意味する。
- **🚨 ロード完了主張の禁止（ハルシネーション対策）**: ツールがファイル内容を返し、AIがそれを完全に読み終える**前**に、「把握しました」「読み込み完了しました」「ロード済みです」など、実ロード完了を示すテキストをユーザーへ先行して出力することは**ハルシネーション（幻覚）であり、いかなる場合も絶対禁止**とする。進行状況を述べる場合も、実際に読んだ内容と一致する範囲に限定し、ロード済み証跡として扱ってはならない。
- 上記は自律ロード・ユーザー指示によるロードを問わず、**全てのルールファイル参照時に強制適用**される。

### 大規模ファイル対応

1,000行以上の大規模ルールファイルは、ファイル末尾のAppendix（逆引き索引）またはファイル冒頭の目次を先に参照し、タスクに関連するセクションのみを行番号指定で自律選択してロードすること。

例：
- 認証関連タスク → 対象ファイルの目次/索引から「OAuth」「JWT」「MFA」のセクションを特定 → 該当セクションのみロード
- コスト最適化タスク → 索引から「FinOps」「料金」のセクションを特定 → 2〜3セクションのみロード

### クロスリファレンス

読み込んだファイル内に関連ルールへのリンクがあり、現在のタスクに関連する場合は、そのリンク先も追加で読むこと。

---

## Step 4: 自己検証（省略不可）

**ルールロード完了後、以下の自己検証チェックリストをtask.mdに記録せよ。1つでも「該当するのにロードしていない」項目があれば、作業を中断して追加ロードせよ。**

```markdown
## ロード自己検証

- タスク: [1行で記述]
- タスクタイプ: [security / architecture / performance / ui_design / api / i18n / finops / testing / other]
- ロードしたファイル:
  - [ ] [ファイルパス] — ロードしたセクション: [§XX, §YY]
  - [ ] [ファイルパス] — ロードしたセクション: [§XX]
- ロードしなかったが関連しうるファイル: [ある場合はファイル名と理由]
```

> **ロード完了の定義**: 以下の条件の全てを満たすこと。
> 1. `blueprint/core/000_project_overview.md` が `view_file` で直接開かれていること（タスクタイプ `other` または**初回ロード**時は必須。他タスクタイプでもロードを推奨）。**「初回ロード」とは、会話開始後（新規チャット/コンテキストリセット後）の最初のルールロードを指す。**
> 2. Step 1 で特定したタスクタイプに対応するドメインルールファイルが `view_file` で直接開かれていること。
> 3. ロードしたファイルのリストが task.md に記録されていること。
>
> ①②③ のいずれかでも欠けていれば、作業を中断して追加ロードすること。
> ※ `000_project_overview.md` がテンプレート初期状態の場合（`[Project Name]` が未記入）、ロードは完了とみなすが、ユーザーに設定を促すこと。

### Session 跨ぎ時の Re-load 判定基準（v1.6.0+）

「全文 load = サボり禁止」の原則と「context budget の現実的制約」のトレードオフを明示的に解消するための判定基準。

| 状況 | Re-load 範囲 | 根拠 |
|:--|:--|:--|
| **新規 session（新規チャット/コンテキストリセット直後）** | full BOOT SEQUENCE 必須（Step 1-4 すべて）+ `task.md` ロード履歴の検証 | memory 継承不能、AXIARCH.md / LOADING_PROTOCOL のロード履歴記録義務 |
| **同一 session 内タスク切替（タスクタイプ変更あり）** | 新タスクタイプに対応する追加ドメインファイルのみ load。既 load 済の Universal Rules / Blueprint は再 load 不要 | `axiarch-rules/{lang}/INDEX.md` → タスクタイプ → 対応フォルダ の関係は不変 |
| **同一 session 内タスク継続（タスクタイプ不変）** | 追加 load 不要。既 load context を継続使用。**ただし v1.8.0+ Check D（Task Boundary Detection）が AI 自己判断をバックアップ** — `axiarch-boot-reminder.sh` が現プロンプト domain keyword と task.md ロード履歴を機械比較し、新 keyword 検出時に full reminder + 🚨 [VIOLATION-D] を発火 | YAGNI 原則 + context budget 保護 + Check D による confirmation bias リスク低減 |
| **長時間 session 中断後再開（compaction trigger 等）** | `task.md` ロード履歴と現在の会話コンテキストを照合し、実ロード済みと判断できないファイルは再 load。ただし `[AXIARCH BOOT]` reminder の TTL 期限切れ時（v1.6.0+ default 30 分）は full re-verification | `axiarch-boot-reminder.sh` TTL state、Memory in LLMs 系の serial position effect 対策 |

> **判定の運用原則**:
> - **task.md のロード履歴はロード候補と証跡の Single Source of Truth として参照**する。ただし、履歴に file 名があるだけで現在のAIが内容を把握済みとは見なさない。現在コンテキスト上で実ロード済みと説明できない場合は再 load 必須。
> - 「session 跨ぎ後の memory 継承による省略」は、同一作業継続でロード済み証跡と現在コンテキストの対応が明確な場合に限り許容する。**省略した事実と根拠を task.md に明示的に記録**する（例: 「Continued from prior session; AXIARCH.md / axiarch-rules/{lang}/INDEX.md re-verification skipped because loaded content remains available in current context per LOADING_PROTOCOL Step 4 session-continuation rule」）。
> - **疑わしい時は full re-load**。context budget の節約より、ハルシネーションリスク低減が優先（AXIARCH.md / LOADING_PROTOCOL のBOOT SEQUENCE）。

> **本基準が解決する問題（v1.6.0 改善背景）**:
> 「全 30+ ファイル毎セッション load = context 破綻、現実的妥協で部分 load」という従来の運用乖離を、明示的な「省略可能な範囲」のルール化により緩和する。reminder TTL（`axiarch-boot-reminder.sh`）と組み合わせることで、token cost を約 87% 削減しつつ遵守率を維持しやすくする。

> **v1.8.0 改善 — Check D Task Boundary Detection**:
> 採用先フィードバックで「同一 session 内でも実際のタスクは異なるのに、AI が『session 継続中だから rule 再 load 不要』と判断してサボる」問題が判明（confirmation bias）。v1.8.0 で `axiarch-boot-reminder.sh` に Check D を追加：
>
> 1. UserPromptSubmit hook の stdin から現プロンプト JSON を読む
> 2. プロンプト内の domain keyword（security / architecture / ui_design / api / performance / push / commit / migration 等）を whole-word match (`grep -oiwE`) で抽出
> 3. **AXIARCH現在タスク必須トリオ全 3 ファイル**（`task.md` / `implementation_plan.md` / `walkthrough.md`）を full-text grep し、既存 domain keyword を抽出。プラン側に書かれた domain context も漏れなく捕捉
> 4. **差異検出時**: `🚨 [VIOLATION-D]` flag + **TTL bypass**（短縮版を抑制し full reminder を再発火）
>
> これにより AI の「タスクタイプ不変」自己判断だけに依存せず、**hook 側で task boundary 候補を検出**して rule 再 load を促す構造になる。`AXIARCH_TASK_BOUNDARY_DETECT=0` で無効化可能（採用先カスタマイズ用）。`AXIARCH_TASK_DOMAIN_KEYWORDS` で keyword 集合をオーバーライド可能。
>
> **3 ファイル全検査の意義**: domain context は `task.md` のロード履歴だけでなく、`implementation_plan.md` の方針記述や `walkthrough.md` の差分 narrative にも書かれる。task.md だけ参照すると、プラン側に明確に書かれた domain を見落として false positive が頻発する。3 ファイル全部を「タスク文脈の確認対象」とすることで、AI が現実に管理しているタスク context をミラーリングする。

---

## Step 5: 作業開始

**上記Step 1–4が完了するまで、コードの修正や分析を開始してはならない。**

---

## ✅ 正しいロード行動の例

### 例1: セキュリティ強化タスク

⬇️ ユーザー指示: 「RLSポリシーを見直して」

1. **タスク分類**: `security` + `architecture`
2. **INDEX.md読み込み** → Security & Privacy カテゴリ + Architecture カテゴリを特定
3. **セキュリティルールファイルを直接開く** → 目次から §12 (RLS) と §24 (DBセキュリティ) を特定 → ロード
4. **アーキテクチャルールファイルを直接開く** → RLS関連セクションをロード
5. **task.md にロード自己検証を記録**
6. **作業開始**

### 例2: UI改善タスク

⬇️ ユーザー指示: 「ダッシュボードのレイアウトを修正して」

1. **タスク分類**: `ui_design`
2. **INDEX.md読み込み** → Design & UX カテゴリを特定
3. **デザインルールファイルを直接開く** → 目次からレイアウト/レスポンシブ関連セクションをロード
4. **Blueprint読み込み** → プロジェクトのデザインシステム定義をロード
5. **task.md にロード自己検証を記録**
6. **作業開始**

### ❌ 間違った行動の例

```
1. INDEX.md を読む → 「セキュリティ系ファイルがあるな」
2. 教訓ログを読む
3. 「把握しました。RLSポリシーを確認します」
   ← ⚠️ セキュリティルールファイルを開いていない！
4. 自分の知識だけで修正を開始
   ← ❌ サボり確定。Step 3–4を完全にスキップしている。
```
