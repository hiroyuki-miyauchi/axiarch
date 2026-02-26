# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

## 1. モダンWebアーキテクチャ (Modern Web Architecture)
*   **Next.js & React Server Components (RSC)**:
    *   **デフォルト**: 原則として **App Router** を使用し、可能な限りサーバーコンポーネント（RSC）でレンダリングします。これにより、クライアントに送信するJavaScript量を劇的に削減します。
    *   **データ取得**: データフェッチはサーバーサイドで行い、ウォーターフォール問題を回避します。
    *   **The Server-Only Import Protocol (Bundle Protection)**:
        *   **Law**: サーバー専用ファイル（`lib/api/*`, `lib/actions/*` 等）には、必ず `import 'server-only'` を記述してください。
        *   **Outcome**: 誤ってクライアントコンポーネントからインポートされた場合、ビルド時にエラーとなり、機密ロジックやAPI Keyのクライアントバンドルへの混入を物理的に防ぎます。
*   **エッジコンピューティング (Edge Computing)**:
    *   **ミドルウェア**: 認証チェックやジオロケーションによるリダイレクトは、**Edge Middleware** で実行し、レイテンシを最小化します。
    *   **The Middleware Lightweight Protocol (Performance Guard)**:
        *   **Law**: `middleware.ts` は軽量に保ち、静的アセット（`/_next/static/*`, `/favicon.ico`, `/robots.txt` 等）へのアクセスを処理対象から除外してください。
        *   **Action**: `matcher` 設定を使用して、処理対象をAPI Routes (`/api/*`) とページルート (`/(routes)/*`) に限定します。
        *   **Prohibition**: Middleware内での重いDB呼び出しや外部API呼び出しは、レイテンシ増大の原因となるため禁止します。
*   **ディレクトリ構成 (Directory Ontology)**:
    *   **src/app**: ルーティング定義のみ。ロジックは持ちません。
    *   **src/lib/actions**: Server Actions（データの正門）。
    *   **src/components**: UIパーツ。`ui` (Generic) と `features` (Specific) を分離します。
    *   **The Static Page Prohibition (No Hardcoding)**:
        *   **Law**: 利用規約、プライバシーポリシー等のコンテンツ主体ページを `src/app/(public)/terms/page.tsx` としてハードコードすることを禁止します。必ずHeadless CMSから配信し、動的ルーティングで処理してください。
    *   **The Anti-Haribote UI Protocol (Realism Mandate)**:
        *   **Law**: DBスキーマに存在しない「将来のカラム」や「JSON内の曖昧なデータ」を、あたかも正規化されたデータであるかのように扱うUI実装を禁止します。UIとデータは不可分の原子（Atom）です。
        *   **Action**: 必要なデータがあれば、まずバックエンド憲法に従って正規化されたカラムを追加してから、UIを実装してください。「とりあえずJSON」は技術的負債への招待状です。
*   **設定管理 (Site Settings Architecture)**:
    *   **Runtime Injection**: テーマカラー等の設定は、ビルド時ではなく実行時（RootLayout）にDBから取得し、CSS変数として注入します。これにより、再ビルドなしでデザイン変更を反映させます。
    *   **The Env Validation Protocol (Fail Fast)**:
        *   **Law**: `process.env` を直接使用禁止とし、`t3-env` や `zod` を用いて、ビルド時（または起動時）に環境変数の型と存在を検証してください。
        *   **Outcome**: 必要なキーが不足している場合、アプリは起動してはなりません（クラッシュさせる）。
*   **Global Expansion Protocol**:
    *   **Sub-Directory Strategy**: 言語ごとにユニークなURL (`/en/stores/tokyo`) を持ちます。クエリパラメータやCookieによる言語切り替えはSEO上禁止とします。
    *   **Universal Time**: DBはUTCで保存し、表示時にユーザーのブラウザロケールに合わせて現地時間に変換します。サーバーサイド(JST)決め打ちは禁止です。
    *   **The Freshness Obligation (SDK Modernization)**:
        *   **Law**: AI, Auth, Payment等の外部サービスSDKは進化が速く、古いバージョンは突然機能不全に陥ります（例: Geminiモデル廃止）。
        *   **Action**: 新規実装時は必ず `npm i package@latest` で最新版を使用し、不具合発生時は「まずアップデート」を第一の解決策として検討してください。「最新版を使うこと」は開発ポリシーの義務です。
