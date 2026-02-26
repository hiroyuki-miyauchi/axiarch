# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 2.1. The Component-DTO Interface Protocol (Interface First)
*   **Law**: UIコンポーネント（特に共有Widget）のProps定義に、生のデータベース型（`Row`）を使用してはなりません。これはバックエンドスキーマとUIを密結合させ、再利用性を殺します。
*   **Action**: 必ず `StoreDTO` や `ArticleDTO` などの **DTO Interface** に依存させ、実装詳細（配列インデックス等）をコンポーネント内部に隠蔽してください。
    *   **The Async-UI Boundary Protocol (Client/Server Separation)**:
        *   **Law**: UIコンポーネント（特に Client Component）は、データフェッチを行う Async Server Component を直接インポートしてはなりません。これはビルドエラーや不可解なランタイムクラッシュ、およびシリアライズエラーの原因となります。
        *   **Action**: `JsonLd` や `Analytics` のようなデータロジックを持つコンポーネントは、必ず `layout.tsx` や `page.tsx` の最上位（Server Context）でレンダリングし、`children` パターン等を用いて UI と物理的に分離してください。
