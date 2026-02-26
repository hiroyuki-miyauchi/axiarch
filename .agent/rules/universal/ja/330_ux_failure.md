# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 12.0. The Lazy Redirect Anti-Pattern (UX Failure)
*   **Law**: 処理完了後やエラー時に、ユーザーへのフィードバック（Toast/通知）なしに `redirect()` で画面を強制遷移させる行為は、UX上の「無責任な放置」であり禁止します。
*   **Action**: ユーザーは「何が起きたか」を知る権利があります。リダイレクトは「リソースの場所が変わった」場合のみ使用し、状態通知には必ず Toast または Flash Message を併用してください。

### 12.1. The Client DB Access Prohibition (Proxy Action Mandate)
*   **Ref**: クライアントサイドからの直接DBアクセス禁止に関する詳細は、アーキテクチャ憲法 300番台（Engineering） の Rule 13.2 を参照し、これを厳守してください。
*   **Law**: Client Component で `supabase.from()` を直接呼び出すことは、RLSポリシーの潜在的脆弱性と、DTO（Mapper）を介さない生データの肥大化を招くため禁止します。
*   **Action**: クエリは必ず Server Action（`src/lib/actions`）を経由する「Proxyパターン」を実装し、クライアントには必要最小限の正規化されたデータ（DTO）のみを返却してください。

### 12.2. The Anchor Tag Nesting Prohibition (aタグ入れ子禁止)
*   **Law**: `<a>` タグ（`Link` コンポーネント含む）の中に別の `<a>` タグを含めることは、ブラウザによる DOM の自動分離を招き、Next.js の Hydration Mismatch を引き起こす HTML 仕様違反です。
*   **Prohibition**: 「見た目だけで動くからOK」という妥録は許されません。ブラウザはネストされた `<a>` を自動的に外側へ押し出すため、サーバーとクライアントのDOMが物理的に一致しなくなります。
*   **Action**: カード全体をクリック可能にする場合、以下のパターンで回避してください：
    1.  **Overlay Pattern**: カードを `relative` にし、メインリンクを `::before` 疑似要素等で `absolute inset-0` に広げ、内部のサブリンクは `relative z-10` で前面に出す。
    2.  **Separate Pattern**: タイトルや画像のみをリンクにし、ネストを物理的に避ける。

### 12.3. The Server-Side DOM Prohibition (No jsdom)
*   **Law**: Server Component (Node.js/Edge) 環境において、`document` や `window` などのブラウザ固有オブジェクトにアクセスすることは**最高度の禁止事項**です。`jsdom` 等のポリフィル導入は、サーバーサイド設計の敗北を意味します。
*   **Action**: サーバーサイドでの HTML 解析・サニタイズには、軽量な `xss` ライブラリ、または `cheerio` (解析が必要な場合) を使用してください。`isomorphic-dompurify` 等の「ブラウザ依存ラッパー」の使用も、副作用が不明瞭なため原則禁止します。

### 12.5. The Recursive Rendering Ban (Depth Safety)
*   **Law**: コンポーネントツリー内での、終了条件（Base Case）が不明確な「自己再帰レンダリング」を禁止します。
*   **Action**: コメントのツリー表示などの再帰構造が必要な場合は、必ず **`maxDepth`** を Props として定義し、それを超える場合は「もっと見る」ボタンやフラット表示に切り替えてください。

### 12.6. The Double Scrollbar Prohibition (UX Integrity)
*   **Law**: `h-screen` と `overflow-y-auto` を無計画にネストさせ、画面上に二重のスクロールバーを発生させることは、UXの敗北です。
*   **Action**: スクロールコンテナは画面内に**ただ一つ**（通常は `body` またはメインレイアウト）であることを原則とします。部分スクロールが必要な場合は、必ず `dvh` (Dynamic Viewport Height) を考慮し、Mobile Safari での挙動を検証してください。

### 12.7. The Metadata Obligation (Page Title Protocol)
*   **Law**: ページタイトルが「undefined」やサイト名のみになることは、ユーザーの信頼を損なう品質欠陥です。
*   **Action**: すべての `page.tsx` において、必ず `export const metadata: Metadata` を定義してください。ビルド前のセルフチェックとして、ブラウザタブのタイトル目視を確認項目に含めてください。

### 13.0. The Security & Performance Boundary
*   **The Next.js 15 Async API Protocol**:
    *   **Law**: Next.js 15 以降、`params`, `searchParams`, `headers`, `cookies`, `draftMode` は Awaitable (Promise) です。
    *   **Action**: これらを参照する際は必ず `await` するか、Reactの `use()` フックを用いて展開してください。非同期処理を怠ると、本番環境でのみ発生する「値の欠損」や「無限レンダリング」の直接原因となります。
*   **The Frictionless Security UI Protocol (Design Handshake)**:
    *   **Law**: セキュリティ機能（Turnstile/OTP）は、ユーザーの「目的達成」を阻害しない形でのみ実装してください。
    *   **Action**:
        *   **Draft Save Exemption**: 下書き保存などの「日常操作」では、TurnstileやOTPを要求しないでください（600番台（Security & Privacy） Rule 8.6参照）。
        *   **Physical Lock UI**: セキュリティチェック中（Turnstile回転中）は、送信ボタンを `disabled` ではなく `loading` 状態にし、進行中であることを明示してください。
*   **CSP Worker Integrity (blob: permission)**:
    *   **Context**: `heic2any` や高性能な画像圧縮ライブラリは、内部で `Web Worker` を生成し `blob:` URLを使用する場合があります。これがブロックされると処理がハングアップします。
    *   **Action**: Middleware の CSP 設定に必ず `worker-src 'self' blob:;` を含め、画像処理プロセスの可用性を保証してください。

### 14.1. The Form DefaultValues Completeness Mandate (フォーム初期値完全性義務)
*   **Law**: React Hook Form（またはそれに類するフォームライブラリ）で `useForm` を使用する際、`defaultValues` には**使用する全てのフィールドを明示的に設定**しなければなりません。
*   **Reason**: `Controller` や `useController` で `name` を指定したフィールドが `defaultValues` に存在しない場合、DBからデータが正しく返されても、UIが空の状態でレンダリングされます（「DB成功なのにUIが空」問題）。
*   **Action**:
    1.  **Exhaustive Default**: フォームで使用する全フィールドを `defaultValues` に列挙してください。新フィールド追加時は**必ず `defaultValues` にも追加**してください。
    2.  **Checklist**: フィールド追加時は以下を全て確認: Schema定義 + `defaultValues` + Controller/register + `setValue`呼び出し箇所 + `useFieldArray`使用箇所。
    3.  **Zod Sync**: Zod Schemaに定義されている全フィールドが `defaultValues` にも含まれていることを体系的に比較・検証してください。
*   **Diagnostic**: 「DB書き込み成功 + DB読み取り成功」なのにUIが空 → **`defaultValues` の欠落を疑え**。

### 14.2. The Production Build Verification Protocol (本番ビルド検証義務)
*   **Law**: 開発サーバー (`npm run dev`) が動作することは、コードが正しいことを意味しません。**`npm run build` が Exit 0 で通過するまで、そのコードは「存在しない」ものとみなしてください。**
*   **Action**:
    1.  **Local Build**: コミット前に必ずローカルで `npm run build` を実行し、成功を確認してください。
    2.  **SSG Awareness**: 静的生成（SSG）ページで `cookies()` 等の動的APIをインポートすると、開発時は動作するが本番ビルドで "Dynamic server usage" エラーになります。動的依存を分離してください。
    3.  **Phantom File**: ビルドエラーが「存在しないファイル」を示す場合、re-export や動的インポートで隠蔽された実体ファイルを `grep` で特定してください。
*   **Rationale**: 開発サーバーはHot Module Replacementにより型エラーやインポートエラーを隠蔽します。ビルドのみが真実です。

### 14.3. The Non-Blocking Edge Processing Protocol (Edge非同期処理義務)
*   **Law**: Edge Middleware やAPI Route において、分析ログや使用量計測などの「メインレスポンスに関係ないDB書き込み」を `await` でブロックすることは、ユーザーへのレスポンス遅延を招く行為であり禁止します。
*   **Action**:
    1.  **waitUntil**: サイドエフェクト（ログ記録、計測、通知）は `event.waitUntil()` または同等のメカニズムでバックグラウンド処理化してください。
    2.  **Fire-and-Forget**: レスポンスに影響しない処理を `await` する正当な理由がない限り、非同期で発火してください。
    3.  **Error Isolation**: バックグラウンド処理のエラーがメインレスポンスに影響しないよう、try-catchで隔離してください。
*   **Outcome**: ユーザーが体感するレスポンスタイム（TTFB）を最小化し、副次的な処理は裏側で完了させます。

### 14.4. The LCP & Lazy Loading Performance Protocol (ファーストビュー最適化義務)
*   **Law**: ファーストビュー（Above the Fold）の最重要要素の描画速度と、それ以外の遅延読み込みを全ページに適用します。
*   **Action**:
    1.  **LCP Priority**: ビューポート内の最重要要素（ヒーロー画像、メインサムネイル等）には `priority` 属性および `fetchPriority="high"` を付与してください。
    2.  **CLS Prevention**: 画像・動画には固定の `aspect-ratio` またはスケルトンによる領域確保を義務付け、レイアウトシフト（CLS）をゼロにしてください。
    3.  **Lazy Everything Else**: ファーストビュー以外の全ての画像、動画、高負荷コンポーネント（マップ、SNS埋め込み等）は `loading="lazy"` または `next/dynamic` による遅延読み込みを徹底してください。
    4.  **Heavy Library Decoupling**: 50KB超の重量ライブラリ（リッチエディタ、スライダー等）は `dynamic import` で遅延読み込みし、初期バンドルサイズを最小化してください。
    5.  **Incremental Loading**: 大量リストの初期読み込みは10〜12件に制限し、「もっと見る」やインクリメンタルスクロールで追加取得してください。

*   **Ref**: クライアントサイドからの直接DBアクセス禁止に関する詳細は、アーキテクチャ憲法 `30_engineering_general.md` の Rule 13.2 を参照し、これを厳守してください。

        *   **Draft Save Exemption**: 下書き保存などの「日常操作」では、TurnstileやOTPを要求しないでください（`60_security_privacy.md` Rule 8.6参照）。
