# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

## 3. フォームとバリデーション (Forms & Validation)
*   **ライブラリ選定**:
    *   **React Hook Form**: 非制御コンポーネントベースで、再レンダリングを最小限に抑えます。
    *   **Zod**: スキーマ駆動開発を行います。バリデーションロジックはUIから分離し、Zodスキーマとして定義します。
*   **The Atomic Tabbed Form Protocol (God Component Resolution)**:
    *   **Law**: 関連項目が **5つ以上**、またはファイルが **500行** を超えるフォームは、必ず**タブ分割アーキテクチャ**を適用し、子コンポーネントに分離してください。単一の巨大フォームコンポーネント（God Component）は、保守性・テスタビリティ・パフォーマンスの全てを破壊します。
    *   **Action**: 分割後の子コンポーネントは `useFormContext` を使用してルートフォームの状態にアクセスしてください。初期化責任（`defaultValues`）はルートコンポーネントに留めます。
*   **バリデーション**:
    *   **The External Link Protocol (Context Aware)**:
        *   **Law**: 外部サイトへのリンクは、ユーザーのワークフローを中断させないために `target="_blank"` を**推奨**します。
        *   **Exception**: ただし、認証フロー（OAuth）や決済画面への遷移など、文脈的に「移動」が正しい場合はこの限りではありません。一律強制ではなく、ユーザー体験（戻ってくる必要があるか？）に基づいて判断してください。
    *   **クライアントサイド**: 必須入力、文字数、メール形式などは、サーバー送信前にリアルタイムでフィードバックします。
    *   **The Anti-Spam Shield (Bot Protection)**:
        *   **Law**: お問い合わせ、会員登録、口コミ投稿などの公開フォームには、必ず `Cloudflare Turnstile` または `reCAPTCHA` によるBot対策を実装してください。スパムによるDB汚染は、後処理で莫大なコストを発生させます。
    *   **Media Interaction (Crop UI)**: 画像アップロード時、サーバー側での自動トリミング（Center Crop）は禁止です。必ず `react-easy-crop` 等のUIを提供し、ユーザー自身がトリミング範囲を決定できるフローを実装します。
    *   **The iPhone Support Mandate (HEIC Conversion)**:
        *   **Context**: iPhoneの標準写真フォーマット(`.HEIC`)はWebで表示できません。
        *   **Action**: クライアントサイドで `heic2any` 等を使用して **JPEG/PNG に自動変換** してからアップロードすることを義務付けます。未変換のファイルをサーバーに送信してはなりません。また、CSP設定で `worker-src blob:` を許可してください。
    *   **The Worker CSP Protocol**:
        *   **Context**: 画像処理（`heic2any`）や圧縮ライブラリは、内部でWeb Worker (`blob:`) を使用します。厳格なCSP下ではこれがブロックされ、処理がハングアップします。
        *   **Action**: `middleware.ts` のCSP設定において、`worker-src 'self' blob:;` を明示的に許可してください。`script-src` だけでは不十分です。
    *   **Filename Sanitization**: 日本語ファイル名はトラブルの元となるため、アップロード時にクライアントサイドでローマ字変換（`wanakana`）を行います。
    *   **型安全性**: ZodからTypeScriptの型を推論（`z.infer`）し、フォームデータとAPIリクエストの型不一致を根絶します。
    *   **The No-Any Protocol (Resolvers)**: `react-hook-form` と `zodResolver` の型不整合に対し、`as any` を使うことは厳禁です。どうしても必要な場合は `as unknown as Resolver<Schema>` のような安全なキャスト（Safe Casting）を行い、意図を明示してください。
    *   **The Input Mode Mandate (Keyboard Optimization)**:
        *   **Law**: 数値専用フィールド（電話番号、郵便番号、クレジットカード番号等）には、必ず `inputMode` 属性 (`numeric`, `tel`, `email`) を設定し、モバイルデバイスで最適なキーボードが自動表示されるようにしてください。
        *   **Outcome**: ユーザーに手動でキーボード切替を強いる負担を排除します。
    *   **The Input Normalization Protocol (NFKC)**:
        *   **Law**: ユーザーが全角数字（１２３）や全角スペースを入力した場合、バリデーションエラーで弾くのではなく、**`onChange` または `onBlur` で半角に自動変換（Normalize）** して受け入れてください。
        *   **Implementation**: `String.normalize('NFKC')` を使用し、ユーザーにストレスを与えない「おもてなし」設計を採用します。
    *   **The IME Composition Guard (CJK入力安全化)**:
        *   **Law**: CJK言語圏（日本語・中国語・韓国語）のIME入力では、変換確定前（Composition中）に `onChange` イベントが発火し、検索リクエストの暴発や入力値の破壊を引き起こす場合があります。
        *   **Action**: リアルタイム検索やオートコンプリート等の即時反応型入力では、`compositionstart` / `compositionend` イベントを監視し、Composition中はアクションの発火を抑制してください。

### 3.3. Auto-Save & Data Persistence Protocol
*   **Mandatory Scope**: 管理画面の記事、設定、長文入力フォームには **自動保存機能** が必須です（Data Loss Zero Tolerance）。
*   **Implementation Standard**:
    *   **Hook Strategy**: 標準化された `useAutoSave` フックを使用し、入力停止から一定時間後（例: 2000ms）にローカルストレージへ保存します。
    *   **Passive Restoration**: ページロード時に下書きを勝手に復元せず、**「下書きがあります」という通知（バナー）** を出し、ユーザーが選択できる仕様にします。
    *   **Hygiene**: 正常送信（Submit）完了時には、必ずローカルストレージをクリア (`clearDraft`) し、古いデータの残留を防ぎます。
*   **The iOS Input Zoom Defense (Mobile UX Guard)**:
    *   **Problem**: iOS Safariでは、入力フィールドのフォントサイズが **16px未満** の場合、フォーカス時に自動的にズームインし、UXを著しく損なう。
    *   **Mandate**: モバイルビューにおける `input`, `textarea`, `select` の `font-size` は、必ず **16px (`text-base`) 以上** を設定してください。
    *   **Technique**: `text-base` をモバイルで使用し、デスクトップでは `md:text-sm` で切り替える実装を標準とします。

### 3.4. The Dynamic Form Engine Protocol (動的フォームランナー)
*   **Law**: 問い合わせフォームや申請フォームを固定のReactコンポーネント（`ContactForm.tsx`）としてハードコードすることは、ビジネス要件の変更にデプロイが必要となるため禁止します。
*   **Action**:
    1.  **Schema-Driven Rendering**: フォームの構造（フィールド名、型、バリデーション）は、DBテーブル（例: `inquiry_forms`, `form_fields`）またはJSONスキーマで定義し、UIは動的にレンダリングします。
    2.  **Field Type Registry**: テキスト、セレクト、日付、ファイルアップロード等の入力タイプを標準レジストリとして定義し、スキーマから参照できるようにします。
    3.  **Spam Protection**: 全ての公開フォームには **Cloudflare Turnstile** または同等のBot対策を必須とします。

## 4. PWAとクロスプラットフォーム (PWA & Cross-Platform)
*   **PWA (Progressive Web App)**:
    *   **インストール可能**: `manifest.json` を適切に設定し、ホーム画面への追加を可能にします。
    *   **オフライン対応**: Service Workerを使用して、オフラインでも主要機能（閲覧済みコンテンツ等）が動作するように設計します。
*   **Deep Linking**:
    *   **Smart App Banners**: モバイルブラウザで表示された際、ネイティブアプリがインストールされていればアプリを開き、なければストアへ誘導するバナーを実装します。

*   **Server Actions Protocol**:
    *   **The 'use server' Mandate**:
        *   **Law**: Server Actionsを定義するファイルは、必ずファイルの先頭行に `'use server'` を記述しなければなりません。関数単位ではなくファイル単位での宣言を基本とし、Server/Clientの境界漏れ（Leak）を防ぎます。
*   **Hard Session Refresh Protocol (Cookie Sync)**:
    *   **Context**: Server ActionでセッションCookieを更新しても、SPA遷移だけではMiddlewareやServer Componentに即座に反映されない場合があります。
    *   **Mandate**: 認証状態や重要権限の変更時（Login/Logout等）は、`window.location.reload()` でハードリフレッシュし、最新のCookie状態でサーバーにアクセスさせてください。権限不整合によるエラー画面の方がUXを損なうため、一瞬の白画面は許容します。
