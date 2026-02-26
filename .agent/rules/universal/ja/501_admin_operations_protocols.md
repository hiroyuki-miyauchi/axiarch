# 50. 管理運用と内部ツール (Admin Operations & Internal Tools)

## 8. 管理運用プロトコル (Admin Operations Protocols)

### 8.1. The Admin Hygiene Protocol (No English in UI)
*   **Law**: 「管理画面だから英語でいい」という甘えは、非エンジニア（運用担当者）の生産性を著しく低下させます。
*   **Action**:
    *   **Full Localization**: ボタンラベル、エラーメッセージ、ログのアクション名に至るまで、画面上に表示される全てのテキストは日本語でなければなりません。
    *   **Mapping**: Enum型やシステム識別子は、必ず表示用の定数マップ（例: `AUDIT_ACTION_LABEL`）を通して表示してください。生の値（`create_post`）を表示することは禁止です。

### 8.2. The System Transparency Protocol (Tech Stack Sync)
*   **Context**: 技術構成がブラックボックス化すると、非エンジニア（経営陣・運用者）との共通認識がズレ、誤った意思決定を招きます。
*   **Law**: 技術スタックに変更があった場合（DB変更、新AIモデル導入等）は、必ずダッシュボード上の `src/components/admin/dashboard/tech-stack-card.tsx` を即座に更新し、実態と同期させてください。技術構成がブラックボックス化することは許されません。



### 8.3. The Explicit Explanation Protocol (Zero Jargon)
*   **Law**: 開発者にとっての「常識（UUID, CPM, MRR）」は、運用者にとっては「謎の記号」です。これらに説明がないことはツールとしての敗北です。
*   **Action**:
    *   **Zero Jargon**: 管理画面上の全ての専門用語・指標・計算値には、必ず `Info` アイコンと `Tooltip` を付与し、「それが何であり、どう計算され、ビジネスにどう影響するか」をド素人でも分かる言葉で解説してください。
    *   **No Assumptions**: 「見ればわかる」という推測を禁止します。全ての数値には定義が必要です。新しいダッシュボードや指標を追加する際は、Tooltipの実装完了をもって「完成」と見なします。

### 8.4. The Data Seeding & Caching Protocol
*   **Law**: キャッシュキーの陳腐化や、CLI結果（"Up to date"）への過信は、本番環境でのデータ不整合（マスターデータ欠損等）を招きます。
*   **Action**:
    *   **Versioning**: マスターデータのキャッシュキーには、データの量や質が変わる際にバージョンサフィックス（`_v2`等）を付与し、物理的にキャッシュを無効化してください。
    *   **Verification**: 本番同期後は、必ずアプリケーション経由でデータ件数が期待通りか確認する手順を必須とします。

### 8.5. The Label Mapping Protocol (ラベルマッピング義務)
*   **Law**: システム内部キー（Enum値、ステータスコード、アクション名等）をUIにそのまま表示することは、非エンジニアの運用者にとって「暗号」であり、ツールとしての敗北です。
*   **Action**:
    1.  **Display Map**: 全てのEnum値・システム識別子に対して、表示用の定数マップ（例: `STATUS_LABEL_MAP: Record<Status, string>`）を定義し、UIからはこのマップを経由してラベルを取得してください。
    2.  **Fallback**: マップに存在しない値（将来の拡張等）が渡された場合は、生のキーをフォールバックとして表示しつつ、Loggerに警告を出力してください。これにより「未翻訳」状態を即座に検知できます。
    3.  **Localization Ready**: ラベルマップはプロジェクト設定言語で記述し、将来の多言語対応時にi18nキーへの置き換えが容易な設計にしてください。
*   **Scope**: ボタンラベル、テーブルのカラムヘッダー、監査ログのアクション名、通知メッセージの全てに適用します。
