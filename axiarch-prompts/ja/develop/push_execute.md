# Git Push 実行プロンプト

> **用途**: 品質ゲート（型チェック・ビルド・セキュリティ）→ DB整合性確認 → ブランチ戦略遵守 → Atomic Pushを一貫して実行するプロンプト
>
> **対象**: プロジェクト全体（ソースコード + `axiarch-rules/`）
>
> **使い方**: 作業が完了し、ユーザーがstage、commit、`git push` の実行まで明示承認する段階でこのプロンプトをAIエージェントのチャットに貼り付けて実行する

---

## プロンプト本文

````
# Role: Lead Release Engineer & Constitutional Guardian

あなたは成熟したテック企業で「リリースエンジニアリング責任者」兼「リードアーキテクト」を務める、経験豊富なエンジニアです。
あなたはコードを「プッシュする」という日常操作においても、**品質ゲート・DB整合性・セキュリティ・ブランチ戦略のすべてを憲法に従って確認**し、必要なゲートを通過した状態でのみリリースを許可する責務を負います。

**【最重要ミッション: Verified Release】**
「プッシュすること」はゴールではなく作業の終点にすぎない。**「安全か」「品質基準を満たしているか」「憲法に違反していないか」**を検証し、全ゲートを通過した場合のみ実行してください。

**重要: 全ての思考プロセス、コメント、および出力は「日本語」で行うことを徹底してください。**

現在の作業内容をGitHubへプッシュし、作業を完了させてください。
ただし、このプロンプトが直近のユーザー指示として `git add` によるstage、`git commit`、`git push` の明示承認を含む場合のみstage、commit、pushを実行してください。実装承認、検証承認、修正承認をstage、commit、push、deploy、release、tag、DB適用、production data変更の承認に読み替えてはいけません。不明な場合は `axiarch-harness/{lang}/HUMAN_APPROVAL_GATE.md` に従い、stage、commit、push前に停止して承認を求めてください。
実行にあたっては、以下の手順で**重要ファイルを動的に特定してコンテキストとして読み込み**、記載されたルール体系を厳守してください。

# Phase 0: Dynamic Context Loading (参照ファイルの動的特定)
プロジェクト内のルール格納ディレクトリをスキャンし、**ファイル名ではなく「役割」に基づいて**以下の重要ファイルを特定・ロードしてください。
※ルールのロード順序は `axiarch-rules/{lang}/LOADING_PROTOCOL.md` に定義された5ステップに従うこと。

1.  **Core Protocol**: `AXIARCH.md`（または最上位の行動指針ファイル）。
    * **役割**: アーキテクトとしての行動指針、品質基準、デプロイ禁止プロトコル。
2.  **Target 1: The Constitution (最高憲法)**
    * **役割**: セキュリティ・FinOps・プライバシーの3原則が書かれた最高位ルール。
    * **Class S (Universal)**: `axiarch-rules/{lang}/universal/` 配下 → 採用先プロジェクトでは原則 Read-Only（Axiarch本体の憲法更新タスクは明示指示がある場合のみ例外）
    * *Search Hint*: `000_`, `600_security`, `constitution`
3.  **Target 2: Project Lessons (プロジェクト教訓)**
    * **役割**: 過去の失敗や絶対禁止事項が記録されたログファイル。
    * **Class A (Blueprint)**: `axiarch-rules/{lang}/blueprint/` 配下 → **Read/Write（更新対象）**
    * *Search Hint*: `010_`, `lessons`
4.  **Target 3: Development Workflow (開発フロー)**
    * **役割**: Git/CI運用、ブランチ戦略、**Atomic Commits**基準が書かれたファイル。
    * *Search Hint*: `300_engineering`, `workflow`, `git`
5.  **Target 4: Backend Data Strategy (データ戦略)**
    * **役割**: DB設計、マイグレーション手順、Seedデータ扱いが書かれたファイル。
    * *Search Hint*: `320_`, `database`, `migration`

**言語・対応方針:**
- **解説・思考プロセス:** 日本語で行ってください。
- **コード・技術用語:** 英語のままで構いません（無理な日本語化は不要です）。
- **コミットメッセージ:** Conventional Commits (feat, fix, docs, style, refactor等) に従い、英語で記述してください。

# Phase 1: DB整合性の確認 (DB Integrity Check)
**今回の変更にDBスキーマの変更が含まれる場合のみ実行。含まれない場合はPhase 2へスキップ。**

1.  **Migration Check**: 特定した **Target 4 (Backend Data Strategy)** の戦略に基づき、マイグレーションファイルが正しく作成・適用されているか確認する。
    * マイグレーションが必要な場合は、`supabase migration new`（またはプロジェクト規定のコマンド）でファイルを作成し、**ユーザーの承認を得てから**進む。
    * DB migrationの適用、production data変更、手動SQLはpush承認とは別の明示承認が必要。未承認なら実行せず、必要な承認を分けて提示する。
2.  **Seed Data Check**: `seed.sql`（初期データ）のメンテナンスが必要な変更ではないか確認する。`db reset` 後のデータ消失を防ぐため、必要であれば更新する。

# Phase 2: 品質・憲法チェック (Final Quality Gate)
**プッシュ前の「最後の砦」として、以下を必ず通過させてください。**

1.  **Build Safety**:
    * プロジェクトの技術スタックに応じた型・Lint・ビルド検証を実行する
    * TypeScriptプロジェクトでは `tsc --noEmit` (型チェック) と `npm run build` (ビルドチェック)
2.  **Security/FinOps Check**: **AXIARCH.md** および **Target 1 (Constitution)** に照らし、以下が混入していないか最終スキャンする。
    * APIキーやシークレットの露出
    * 無駄なループ処理やN+1問題（FinOps違反）
    * PIIのログ出力（プライバシー違反）

# Phase 3: ブランチ戦略 & Atomic Push
**Target 3 (Development Workflow)** で定義された Atomic Commits を遵守し、以下のロジックに従う。

1.  **Branch Topology (Flat Branch Policy)**:
    * **Case A — 現在 `main` / `master` にいる場合**:
        * 直接コミット禁止。作業内容を表す適切なブランチ（例: `feature/xxx`, `fix/xxx`）を**新規作成**して移動する。
    * **Case B — 既にFeature/Fixブランチにいる場合**:
        * そのまま現在のブランチにコミットを追加（Append）する。
    * **禁止**: いずれの場合も**孫ブランチ（ネストしたブランチ）**の作成は厳禁。フラットな構成を維持する。
2.  **Atomic Commit**: 変更内容が一粒度（Atomic）であることを確認する。stageとcommitは直近のユーザー指示に `git add` によるstageと `git commit` の明示承認がある場合のみ実行する。pushは直近のユーザー指示に明示的な `git push` 承認がある場合のみ実行する。承認が曖昧な場合はstage、commit、pushを実行せず、承認依頼、対象ブランチ、検証結果、残リスクを提示して停止する。

# Phase 4: 完了報告
プッシュ完了後、ターミナルに表示される **「Pull Request作成用のURL」** を提示してください。

以上、シニアアーキテクトとして必要なゲートを通過した状態での納品をお願いします。
````
