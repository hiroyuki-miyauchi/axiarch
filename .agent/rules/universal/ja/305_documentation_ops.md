# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

## 11. ドキュメント運用 (Documentation Ops)
*   **Living Documentation**:
    *   **Mermaid.js**: アーキテクチャ図は画像ではなくコード（Mermaid）で管理し、陳腐化を防ぎます。
    *   **ADR**: 技術的な意思決定は `docs/adr` にMarkdownで記録します。
*   **The Live Docs Requirement (DX)**:
    *   **Visibility**: APIエンドポイント定義は `/api/docs` 等で Swagger UI や ReDoc を通じて常時可視化されなければなりません。隠されたAPIは負債です。
    *   **Sync**: 実装とドキュメントの乖離は許されません。tsoa, Swagger JSDoc, または AIによる自動解析を用い、コードベースから自動生成または動的配信される仕組み（Live Docs）を維持してください。
*   **Docs as Code**:
    *   ドキュメントはコードと等価であり、Gitで管理し、PRレビューの対象とします。ドキュメント更新なきコード変更はマージ禁止です。
*   **鮮度維持**:
    *   リンク切れチェックを自動化し、主要ルールは四半期ごとに見直します。

## 12. エンジニアリング品質プロトコル (Engineering Quality Protocols)

### 12.1. The Zero-Warning Lint Protocol
*   **Law**: 「Warningなら無視しても動く」という甘えは品質低下の元です。CI全通過の真の意味は、警告数0です。
*   **Action**: `npm run lint` の結果は、必ず警告数0（Zero Warnings）でなければなりません。未使用変数は即座に削除してください。

### 12.2. The Clean Import Protocol
*   **Law**: `import` ステートメントは必ずファイルの最上部（Top-Level）に記述してください。
*   **Action**: 関数や制御フロー内でのインポートは厳禁です。どんなに急いでいても、インポートはファイルの先頭に移動させてください。

### 12.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: 開発者の「常識」はユーザーの「専門用語」です。
*   **Action**: 管理画面上の専門用語や指標には必ず `Tooltip` を付与し、「それが何であり、ビジネスにどう影響するか」を素人の言葉で解説してください。

### 12.4. Localization First Protocol
*   **Action**: エラーメッセージやバリデーションメッセージは、全て（Zodカスタムエラー等も含め）日本語化してください。

### 12.5. The Recursive Logic Ban (Infinite Recursion Shield)
*   **Law**: コンポーネントツリーやビジネスロジック内での、終了条件が不明確な「深い再帰処理（Deep Recursion）」を禁止します。
*   **Reason**: スタックオーバーフローを引き起こすだけでなく、不注意な実装（useEffect等との組み合わせ）により無限DB読み込みを誘発し、クラウド破産を招くためです。
*   **Action**: 再帰的な構造（木構造の表示等）を扱う場合は、必ず **Depth Limit (最大深度)** を定数（例: `MAX_DEPTH = 5`）として定義し、それを超える場合は例外をスローするか、フラットなデータ構造への変換（Normalization）を検討してください。
