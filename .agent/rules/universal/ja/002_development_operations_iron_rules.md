# 00. コア・フィロソフィーとマインドセット (Core Philosophy & Mindset)

> [!CRITICAL]
> **Supreme Law Declaration (最高法規宣言)**
>
> 1.  本ドキュメント群 (`.agent/rules/universal/*.md`) は、本プロジェクトの開発・運用・ビジネスにおける**最高法規**です。
> 2.  本憲法に違反するコード、設計、運用判断は、いかなる理由があっても**却下（Reject）**されます。
> 3.  全開発者（AI Agentを含む）は、タスク開始前に本憲法を確認し、遵守する義務を負います。

> [!IMPORTANT]
> **絶対的な基盤 (Absolute Foundation)**
> この「Core Philosophy」は、Google Antigravityの全ての活動における憲法であり、例外は認められません。
> 我々は「シリコンバレーの超優秀なエリートチーム」として振る舞い、世界最高水準の成果のみを追求します。

## 7. 開発・運用の鉄則 (Development & Operations Iron Rules)
*   **最新情報の確認**: 開発時は毎回、各ライブラリ、OS、APIの最新公式ドキュメントを確認します。古い知識での実装は罪です。
*   **実機テスト**: シミュレーターだけでなく、必ず実機（スマホ）での動作確認、TestFlight等を用いたベータテストを想定します。
    *   地図や動画の埋め込みは、iframeコードの貼り付けではなく、専用フィールド（住所入力、YouTube ID入力）を用意し、フロントエンド側で安全にタグを生成します。
    *   **The Explicit Explanation Protocol (No-Expert Bias / 専門用語の追放)**:
        *   **Law**: 開発者にとっての「常識（Input Price, CPM, MRR等）」は、ユーザーにとっては「謎の記号」です。これらに説明がないことは、ツールとしての敗北を意味します。
        *   **Action**: 管理画面上の全ての専門用語・指標・計算値には、必ず `Info` アイコンと `Tooltip` を付与し、「それが何であり、どう計算され、ビジネスにどう影響するか」をド素人でもわかる言葉で解説してください。
        *   **Zero Jargon**: 「見ればわかる」という推測を禁止します。全ての数値や状態には明確な定義とヘルプが必要です。
        *   **Completion**: Tooltipの実装完了をもって、その機能の「完成」とみなします。
    *   **Code Input Standard**:
        *   **Law**: HTML/CSS/JSON等のコード編集が必要な箇所で、生の `textarea` を使用することは、シンタックスハイライトがなくミスを誘発し、品質を著しく損なうため厳禁です。
        *   **Action**: 必ず `react-simple-code-editor` (+ `prismjs`) などのエディタコンポーネントを使用し、プロフェッショナルな品質を提供してください。生の `Textarea` の使用は未完成とみなします。
    *   **The Zero Yapping Protocol (Professionalism)**:
        *   **Law**: AIは「申し訳ありません」「理解しました」「以下がコードです」といった無駄な前置き（Yapping）を一切排除し、成果物のみを即座に出力してください。
        *   **Attitude**: 言い訳（Excuses）は不要です。ミスがあれば無言で修正し、正しいコードを提示することが唯一の謝罪です。
    *   **The Sortable Table Standard**:
        *   **Law**: 管理画面の一覧テーブル（ユーザー、商品、ログ等）において、「ソートできない」状態はツールとして不完全です。
        *   **Action**: 必ず `SortableTableHead` コンポーネントを使用し、ヘッダークリックによるサーバーサイドソート（`sortBy`, `sortOrder`）を実装することを標準機能としてください。
    *   **The Implicit Neutrality**: AI は「見ればわかる」という推測を禁止します。全ての数値や状態には明確な定義とヘルプが必要です。
    *   **クリーンアップ**: 不要なコード、コメント、ファイルは即座に削除します。ゴミを残さない。
    *   **The Architectural Preservation Protocol (Code Sanctuary)**:
        *   **Context**: 自動リファクタリングや掃除タスクによる、重要コア機能の誤削除（Friendly Fire）を防ぐ必要があります。
        *   **Action**: プロジェクトの中核機能（Core Features）を構成するファイルには、先頭に `@preservation_level CRITICAL` ヘッダーを付与することを最高義務とします。
        *   **Prohibition**: このマークがあるファイルに対し、AIは独断での削除・移動・破壊的変更を行ってはなりません。変更が必要な場合は、必ずユーザーに「このファイルを変更しますか？」と確認し、明示的承認を得るプロセスを必須とします。
        *   **Document Asset Protection (ドキュメント資産保護)**: プロジェクトの教訓ログ、仕様書（Blueprint）、ルール定義ファイル等のドキュメント資産は、整理・統合の名目での「物理削除」や「過度な要約による情報喪失」を禁止します。変更は常に「追記（Append）」または「修正（Amend）」のみで行い、既存の知見や教訓を消失させないことを義務付けます。
