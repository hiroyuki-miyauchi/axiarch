# 40. Operational Rules (Development Cycle)

### 1.1. Phase 1: Planning & Design (The "Blueprint")
*   **Goal**: *何を*作るか、*なぜ*作るかを曖昧さゼロで定義する。
*   **Steps**:
    1.  **Prompt Engineering**: オーナーがゴールを定義するプロンプトを発行する。
    2.  **Trend Scouting (Crucial)**: AI/チームは、機能に関連する**最新のUI/UXトレンド**（Mobbin/Awwwards）と**技術アップデート**（Google I/O, WWDC）をリサーチする。
    3.  **Spec Definition**: `implementation_plan.md`を作成/更新する。
    4.  **Approval**: オーナーが計画をレビューし承認する。**承認があるまでコードは書かない。**   *Check*: この変更はNorth Star Metricに寄与するか？ セキュリティリスクはないか？

# 40. 開発運用ワークフロー (Operations & Workflow - Agile)

## 1. アジャイル開発プロセス (Agile Development Process)
*   **スプリント (Sprints)**:
    *   **期間**: 原則として **1週間** または **2週間** のスプリントを採用します。短期間で反復（Iterate）し、フィードバックループを高速化します。
    *   **ゴール**: 各スプリントには必ず明確な「ゴール（達成目標）」を設定します（例: 「決済機能を完了し、課金テストを通過する」）。
*   **セレモニー (Ceremonies)**:
    *   **デイリースタンドアップ (Daily Standup)**: 毎朝、テキストベース（Slack）で「昨日やったこと」「今日やること」「ブロッカー（障害）」を共有します。会議は行いません。
    *   **レトロスペクティブ (Retrospective)**: スプリント終了時に、「KPT（Keep, Problem, Try）」を用いて振り返りを行い、プロセスを継続的に改善します。

## 2. タスク管理 (Task Management)
*   **GitHub Projects**:
    *   **一元管理**: 全てのタスクはGitHub Issuesとして起票し、Projects（カンバンボード）でステータスを管理します。
    *   **ステータス定義**:
        *   `Backlog`: 未着手のタスク。
        *   `Todo`: 今スプリントでやるタスク。
        *   `In Progress`: 現在作業中のタスク（WIP制限: 1人2つまで）。
        *   `In Review`: PRレビュー待ち。
        *   `Done`: マージされ、デプロイされた状態。
*   **イシューテンプレート (Issue Template)**:
    *   タスクの曖昧さを排除するため、テンプレート（概要、受入条件、技術的メモ）の使用を強制します。

## 3. ドキュメンテーション (Documentation - "Docs as Code")
*   **コードとしてのドキュメント (Docs as Code)**:
    *   仕様書や設計図は、WordやExcelではなく、Markdownファイルとしてリポジトリ内で管理します。コードと同じライフサイクルで更新します。
*   **ADR (Architecture Decision Records)**:
    *   重要な技術的決定（なぜそのライブラリを選んだか、なぜそのアーキテクチャにしたか）は、**ADR** として記録に残します。後から参加したメンバーが「なぜ」を理解できるようにします。

## 4. コミュニケーション (Communication)
*   **非同期コミュニケーション (Async First)**:
    *   シリコンバレー標準の「非同期」を基本とします。即レスを期待せず、ドキュメントベースで情報を共有します。
    *   「会議」は最終手段です。テキストで解決できることはテキストで解決します。大限活用し、ボイラープレート記述を自動化し、本質的なロジックに集中する。

## 3. Phase 3: Verification & Cleanup
*   **User Perspective Testing**:
    *   開発者としてではなく、「初めて使う一般消費者」として厳しく動作確認を行う（UI/UXチェック）。
*   **Cleanup**:
    *   デバッグログ、一時ファイル、コメントアウトされたコードは徹底的に削除する。
*   **Documentation**:
    *   変更内容、API仕様、運用手順をドキュメント化し、ナレッジを蓄積する。
