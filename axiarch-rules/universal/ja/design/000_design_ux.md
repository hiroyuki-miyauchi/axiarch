# 20. デザインとUX戦略 (Design & UX Strategy)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-04-19 (Rev 4)

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「デザインは装飾ではない — 品質に対するユーザーの最初で最後の印象である。」
> すべてのデザイン判断は一貫性・アクセシビリティ・感動を優先しなければならない。
> **一貫性 > アクセシビリティ > 感動 > 美学 > 開発速度** の優先順位を厳守せよ。
> この文書はデザインとUX戦略に関するすべての設計判断の最上位基準である。
> **37パート構成（§1〜§37）。**

---

## 目次

| Part | トピック | セクション |
|------|---------|-----------|
| I | デザイン哲学 | §1 |
| II | デザインエンジニアリング | §2 |
| III | コンポーネント実装ガイドライン | §3 |
| IV | パフォーマンスアニメーション | §4 |
| V | アダプタビリティとフォルダブル | §5 |
| VI | アクセシビリティとインクルージョン | §6 |
| VII | ユーザー主権 & Ethical UX | §7 |
| VIII | ツールとワークフロー | §8 |
| IX | AI UX戦略 | §9 |
| X | ユーザーオンボーディングとガイダンス | §10 |
| XI | セーフティUIプロトコル | §11 |
| XII | おもてなしUX | §12 |
| XIII | Design Ops & ツール | §13 |
| XIV | インタラクションセーフティプロトコル | §14 |
| XV | ローカライゼーションと国際化 | §15 |
| XVI | モーション・トークン・アーキテクチャ | §16 |
| XVII | パフォーマンスUX | §17 |
| XVIII | Spatial Computing & XR UX | §18 |
| XIX | UXリサーチ & 計測 | §19 |
| XX | 成熟度モデル & アンチパターン | §20 |
| XXI | デザインシステム・ガバナンス | §21 |
| XXII | データ可視化 & 情報アーキテクチャ | §22 |
| XXIII | AI生成UIガバナンス | §23 |
| XXIV | クロスプラットフォーム・トークン連携 | §24 |
| XXV | サステナビリティ & グリーンUX | §25 |
| XXVI | ニューロダイバーシティ & インクルーシブUX | §26 |
| XXVII | デジタルウェルビーイング & エシカルデジタルデザイン | §27 |
| XXVIII | Voice & Conversational UX | §28 |
| XXIX | アダプティブ & パーソナライゼーションUX | §29 |
| XXX | Design Tokens 2.0 / Figma Variables 進化形 | §30 |
| XXXI | エッジ & オフラインファーストデザイン | §31 |
| XXXII | ゲーミフィケーション設計ガバナンス | §32 |
| XXXIII | デザインQA & ビジュアルリグレッション | §33 |
| XXXIV | バイオメトリクス & 認証UX | §34 |
| XXXV | コンテンツセーフティ & トラストデザイン | §35 |
| XXXVI | リアルタイム協働編集UX | §36 |
| XXXVII | プラットフォームエンジニアリング & Design System Ops | §37 |

---

> [!WARNING]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: UI/UXの不統一は「プロ意識の欠如」である。
> - **Action**: 「この画面だけボタンが左にある」「ここだけ削除フローが違う」といった些細なズレを許容してはならない。全体の調和（Harmony）を乱す要素は、機能していようとバグである。
> - **Target**: 特に「削除」「保存」「認証」などのクリティカルなフローにおいては、ユーザーのメンタルモデルを守るため、鉄の統一（Iron Consistency）を維持せよ。


## 1. デザイン哲学 (Philosophy: "Silicon Valley Excellence & Google First")

### 1.1. 圧倒的な「Wow」体験 (The "Wow" Factor - Delight)
-   **必須要件 (Mandate)**: すべてのインタラクションは「生きている」と感じさせなければなりません。静的な画面ではなく、**動的な体験**を構築します。
-   **Google標準 (Google Standard)**: **Material Design 3 (Material You)** およびその進化形である **"Expressive"** (2025+) をベースラインとして採用します。
-   **Apple標準 (Apple Standard)**: iOSにおいては、**Human Interface Guidelines (HIG)** を尊重します。Material Designを無理やり適用せず、プラットフォーム固有の操作感（Platform Fidelity）を維持します（例: スイッチ、ピッカー）。
-   **差別化 (Differentiation)**: Googleのシステムを使用しつつ、**高精度のモーション**、**カスタムシェーダー**、**大胆なタイポグラフィ**によって差別化し、「シリコンバレーのプレミアム感」を演出します。
-   **The Typography Localization Protocol (Readability First)**:
    -   **Font Fallback Stack**: Webフォント（例: Noto Sans JP, Inter）を使用する際は、必ずOS標準フォント（例: Hiragino Kaku Gothic, Meiryo, システムのsans-serif）をフォールバックとして指定してください。
    -   **Line Height for CJK**: 日本語・中国語など文字密度が高い言語では、`line-height` を広め（`1.6 - 1.8`）に設定し、可読性を確保してください。
    -   **Letter Spacing**: 太字見出しには `letter-spacing: wider` を適用し、文字の詰まりを解消することを推奨します。

### 1.2. トレンドスカウティング・プロトコル (Trend Scouting Protocol)
*あらゆる*デザインタスク（単一のコンポーネントであっても）の前に、以下の「スカウティング・ループ」を義務付けます：
1.  **リーダー分析 (Analyze Leaders)**: **Mobbin** (iOS/Androidのフロー)、**Awwwards** (Webトレンド)、**Google Design** (最新仕様) を確認します。
2.  **解剖 (Deconstruct)**: トップティアのアプリがなぜ「心地よい」のかを解剖します（例：「このモーダルのバウンスが遊び心を演出している」）。
3.  **適用 (Apply)**: その「感覚（Soul）」を我々のコンテキストに適応させます。**盲目的にコピーするのではなく、インタラクションの「魂」を盗みます。**
4.  **AI活用 (AI Leverage)**: 生成AIを使用して、標準的なUIコンポーネントの「未来的」なバリエーションをブレインストーミングします。

### 1.3. The Realism Mandate (Anti-Haribote / Truth in Design)
-   **Law**: DBスキーマに存在しないデータ（将来のカラム、架空のステータス）をデザインカンプに描くことを禁止します。
-   **Action**: デザイナーはFigmaを描く前に、必ずバックエンドエンジニアと **DBスキーマ（ER図）** を合意してください。「なんとなくJSONで持たせる予定」という曖昧なデータは、必ずUIの実装時に破綻します。
-   **Motto**: "No Schema, No Pixel." (スキーマなき場所にピクセルなし)

## 2. デザインエンジニアリング (Design Engineering)

### 2.1. デザイン・トークン (Design Tokens)
-   **Single Source of Truth**: 色、スペーシング、タイポグラフィ、シャドウ、角丸、モーションなどの全てのデザイン値は、FigmaのVariablesで定義し、コード（CSS Variables / Design Token JSON）と100%同期させます。
-   **ハードコード禁止**: `px` や `#hex` を直接コードに書くことは**厳禁**です。必ずトークン（例: `color-primary-500`, `spacing-4`）を使用します。
-   **W3C DTCG準拠 (W3C Design Tokens Community Group)**:
    -   **規格**: **W3C DTCG Specification 2025.10 (Stable)** に準拠し、以下の原則を遵守します。
    -   **JSON形式**: `.tokens.json` を標準トークン定義形式とします。
    -   **エイリアス/参照 (Alias / Reference)**: トークン参照（`{color.primary.500}`）を活用し、変更の伝播を一元化します。
    -   **型安全性 (Type Safety)**: 各トークンに型（`color`, `dimension`, `duration`, `cubicBezier` 等）を明示的に指定します。
    -   **マルチブランド/マルチテーマ**: 単一のトークン定義から複数ブランド・複数テーマ（light/dark/high-contrast）を生成できる構造を維持します。
    -   **トークンパイプライン**: Figma → JSON → Style Dictionary（または同等ツール）→ プラットフォームコード（CSS/Swift/Kotlin/Dart）の自動変換パイプラインを構築します。
-   **トークン階層設計 (Token Hierarchy)**:
    1.  **Global Tokens (Primitive)**: 生の値（`blue-500: #3B82F6`, `space-4: 16px`）
    2.  **Semantic Tokens (Alias)**: 意味ある参照（`color-primary: {blue-500}`, `color-error: {red-500}`）
    3.  **Component Tokens**: コンポーネント固有の値（`button-bg-primary: {color-primary}`）
-   **命名規則**: `{category}-{property}-{variant}-{state}` 形式で標準化します。
    -   例: `color-text-primary-default`, `spacing-padding-card-sm`
-   **Dynamic Theme**: テーマ設定はRuntime（例: `RootLayout`）でDBまたは設定から取得し、CSS変数として注入します。ユーザーがOS設定自動追従と手動選択の両方でダーク/ライトモードを切り替えられるようにします。
-   **CSS Color Module 4対応**:
    -   モダン色空間（**Display P3**, **Oklch**）の採用を推奨します。`oklch()` は知覚的均一性（Perceptual Uniformity）が高く、プログラマティックな色操作に最適です。
    -   **フォールバック**: P3/Oklch非対応ブラウザ向けに `@supports (color: oklch(0 0 0))` でプログレッシブエンハンスメントを実装します。
-   **The Locale Format Mandate (Date/Currency/Number)**:
    -   **Law**: 日付、通貨、数値のフォーマットは**ロケール依存**です。特定の形式（例: `MM/DD/YYYY`）をハードコードすることを禁止します。
    -   **Action**:
        1. **Date Library**: `date-fns` や `Intl.DateTimeFormat` を使用する際は、必ず対象ロケールを明示的に指定してください。
        2. **Currency**: 通貨記号と桁区切りは `Intl.NumberFormat` を使用し、ロケールに応じた正しい形式で表示してください。
        3. **Consistency**: アプリケーション全体で統一されたロケール設定を維持し、混在を防いでください。
        4. **Form Field Order Locale Compliance**: 個人情報フォーム（氏名、住所等）のフィールド順序はロケールの慣習に従ってください。氏名の姓・名の順序、住所の大小順序（例: 日本は「姓→名」「都道府県→番地」、欧米は「First→Last」「番地→州」）が異なります。ロケールと異なる順序の強制は禁止です。
-   **Dark Mode & テーマ戦略 (Dark Mode & Theme Strategy)**:
    -   **CSS Variable Separation**: 全UIカラーはCSS変数（`hsl(var(--...))` または `oklch(var(--...))` トークン）で定義し、ライト/ダーク/ハイコントラストモードの切替がCSS変数の上書きのみで完結する設計を維持してください。
    -   **反転禁止**: ダークモードは単純な色反転ではありません。背景コントラスト、エレベーション表現（ダーク背景では影の代わりにサーフェス明度差を使用）、彩度調整を独立して設計してください。
    -   **High-Contrast Mode**: 将来的にWCAG AAA（7:1）を満たすハイコントラストテーマを提供できる設計を維持してください。
    -   **Semantic Token Mandate**: ハードコードされた色値（`#ffffff`, `bg-white` 等）の使用を禁止し、セマンティックトークン（`bg-background`, `text-foreground`）を使用してください。
    -   **ロールベースの命名**: 色は「見た目」ではなく「役割」で命名してください。`blue-500` ではなく `color-primary` を使用します。
    -   **Loading State Unification (ローディング状態の統一)**: データ取得中のローディング表示は以下に統一してください：ページレベルは `loading.tsx` による Suspense Boundary + Skeleton、コンポーネントレベルは `<Skeleton />` コンポーネント、アクションレベルはボタンの `disabled` + スピナーアイコン。ローディング表示なしの「真っ白画面」はUXの致命的欠陥として扱います。

## 3. コンポーネント実装ガイド (Component Guidelines)
### 3.1. Implementation Patterns
-   **Skeleton Loader**:
    -   データ読み込み中（Suspense）は、スピナーではなく **Skeleton Screen** (`<Skeleton />`) を使用し、レイアウトシフト（CLS）を低減します。
-   **Feedback Hierarchy**:
    -   **Toast**: 成功・通知（非同期）。
    -   **Inline Alert**: 文脈依存のエラー。
-   **Toast Promise Standard (Async Feedback Lifecycle)**:
    -   **Law**: 非同期処理（保存・削除・送信等）において、Loading→Success→Errorのフィードバックサイクルを手動で管理することはバグの温床です。
    -   **Action**: Toastライブラリの `promise` 機能（例: `sonner.promise()`）を使用し、処理中・成功・失敗の3状態を自動的に表示してください。ユーザーは「処理中」であることを視覚的に認識し、完了または失敗の結果を確実に受け取れなければなりません。
-   **Z-Index Stratification (The Layering Law)**:
    -   **Overlay (10000)**: Select, Popover, Tooltip, Calendar 等。常に最前面。
    -   **Modal (9999)**: Dialog, Sheet 等。
    -   **Menu (1000)**: Navigation Drawer 等。
    -   **Action**: 恣意的な `z-50` 等のマジックナンバーは禁止し、この階層構造を厳守してください。
-   **Optimistic UI (楽観的更新)**:
    -   いいね等の軽量アクションは、サーバー応答を待たずに即座に表示更新し、ネイティブアプリ並みの応答速度をもたらします。
-   **The Sortable Table Standard**:
    -   **Law**: 管理画面の一覧テーブル（ユーザー、商品、ログ等）において、「項目の並び替え（Sort）ができない」状態は、業務ツールとして不完全（Incomplete）です。
    -   **Action**: 必ず `SortableTableHead` コンポーネントを使用し、ヘッダークリックによるサーバーサイドソート（`sortBy`, `sortOrder`）を標準機能として実装してください。矢印アイコンの挙動やパラメータ名は全機能で統一を義務付けます。
-   **The Carousel Standardization Protocol (カルーセル標準化)**:
    -   **Law**: カルーセル（スライダー）の自作はタッチ操作やアクセシビリティ（A11y）面で不具合を招きやすいため、検証済みライブラリの使用を義務付けます。
    -   **Synced Sliders**: サムネイル付きスライダー（Main + Thumbs）を実装する際は、自前のState同期ではなく、ライブラリネイティブの連動機能を使用してください。
    -   **A11y**: 必ず `navigation`（矢印）と `pagination`（ドット）を有効化し、キーボード操作に対応させてください。
-   **The Native Input Prohibition (ネイティブフォーム要素禁止)**:
    -   **Law**: デザイン済みUIにおけるブラウザネイティブの入力フォーム（`<input type="date">`, `<input type="time">`, `<input type="color">` 等）の使用を禁止します。ブラウザ間で見た目と挙動が異なり、デザインの一貫性を破壊します。
    -   **Action**: 日付選択には `Popover + Calendar` コンポーネント、時刻選択にはカスタム `Select`、色選択にはカスタムカラーピッカーを使用してください。
    -   **Modal Scale**: 複雑な設定を扱うモーダルには十分な幅（例: `max-w-4xl` 以上または `80vw`）を確保し、窘屈さを排除してください。
-   **The Editor Preview Protocol (エディタ内プレビュー義務)**:
    -   **Law**: リッチコンテンツエディタ（ブロックエディタ等）内でのメディア埋め込み（動画、地図等）の表示において、URLテキストやアイコンのみを表示することを禁止します。
    -   **Action**: エディタの拡張機能（NodeView等）を使用し、実際のプレビュー（iframe等）をエディタ内に表示してください。公開後のレイアウトを編集中に正確に把握できる「True WYSIWYG」を実現してください。
-   **The Headless UI Architecture (UIとロジックの分離義務)**:
    -   **Law**: UIコンポーネントは「データの表示」と「イベントの発火」のみに専念し、ビジネスロジック（データフェッチ、状態計算、バリデーション等）を内部に持たせてはなりません。
    -   **Anti-Pattern**: コンポーネント内で直接 `fetch` を行ったり、特定ページのDOM構造に依存したステート管理を行うことは、再利用性と移植性を破壊する設計違反です。
    -   **Goal**: UIコンポーネントは、将来的に別のプラットフォーム（React Native等）へ移植する際に、ロジックを修正せず「表示層」だけ交換すれば動く状態を維持してください。
-   **The Modal Standard Architecture (ポータル & Close UX)**:
    -   **Law**: すべてのモーダルはDOM最上位へレンダリングされる `Portal` パターンを使用しなければなりません。親要素の `overflow: hidden` や `z-index` の制約によるクリッピングを抑制します。
    -   **Close Button**: モーダルの閉じるボタンは、右上に統一された視覚デザイン（円形背景付き等）で配置し、プロジェクト全体で一貫させてください。閉じる手段が不明瞭なモーダルはUXの欠陥です。
-   **The Mobile Media Upload Protocol (モバイルメディアアップロード対応)**:
    -   **Law**: モバイルデバイスの標準撮影形式（例: iOSのHEIC/HEIF）はブラウザで直接表示できないことが多いため、ファイルアップロード機能を備えるコンポーネントでは、これらの形式への対応を考慮してください。
    -   **Action**: サーバー負荷軽減のため、アップロード前にクライアントサイドで汎用フォーマット（JPEG/PNG/WebP）への自動変換を推奨します。ユーザーに手動変換を要求することは、モバイルUXの敗北です。

### 3.2. フロントエンド統合プロトコル（Universal原則）
-   **ライフサイクルルール遵守**: UIコンポーネントは、フレームワーク固有のライフサイクル規約（副作用の適切な管理、安全な状態更新タイミング等）を厳守しなければなりません。フレームワーク固有の実装詳細は技術スタック別ルールを参照してください。
-   **Hydration安全性（サーバー/クライアント一貫性）**: SSRとクライアントサイドハイドレーションの初期状態の不一致はUX障害（フリッカー、レイアウトシフト、非インタラクティブ状態）を引き起こします。やむを得ない差異要素（タイムスタンプ、乱数等）を除き、SSR/CSRで一貫した設計を維持してください。
-   **条件付きレンダリング優先（非表示より除去）**: 表示頻度が低い大規模UIツリー（ドロワー、ダイアログ、メガメニュー等）は `display:none` 隠蔽ではなく、**条件付きレンダリング**（表示フラグが `false` の時にDOMから除外）を使用し、メモリとレンダリングリソースを解放してください。
-   **Ghost Dimension防止**: 初期状態で非表示の要素内でサイズ依存の初期化（カルーセル、マップ、チャート等）を行う場合は、要素が可視化された瞬間に `resize` を明示的に発火させるか再マウントを強制し、「Ghost Dimension（レイアウト崩れ）」を防いでください。
-   **インタラクティブ要素のネスト禁止**: インタラクティブ要素のネスト（例: `<a>` 内に `<a>` や `<button>`）はHTML仕様違反です。カード全体をリンクにしたい場合は、絶対配置オーバーレイリンク手法を使用してください。
-   **クロスリファレンス**: Reactのフックス順序、Hydration Mismatch対処、SSRとCSRの整合設計等のフレームワーク固有の実装詳細は `engineering/300_web_frontend.md` を参照してください。
### 3.3. Layout Architecture
-   **The Single Container Protocol**:
    -   Layoutがコンテナ (`container`) を提供する場合、Page側での再定義（二重パディング）を厳禁とします。
    -   **Baseline Harmony (Filter Alignment Protocol)**:
        -   **Law**: ラベル付きの `Input` と `Button` を横並びにする際、`items-center` で中央揃えにすることを禁止します。
        -   **Action**: 必ず **`items-end`** を使用し、ラベルの高さを考慮した「下端（Baseline）揃え」を徹底してください。これにより、ピクセルパーフェクトな視覚的一貫性を保証します。`items-center` はラベルと入力の境界をあやふやにし、デザインの品位を損なう「素人仕事」とみなされます。

    -   **The Natural Scrolling Protocol (Rule 12.6)**:
        -   **Law**: `h-screen` と `overflow-y-auto` を無計画にネストさせ、二重スクロールバーを発生させることは UX の敗北です。
        -   **Action**: スクロールコンテナは画面内に**ただ一つ**（通常は `body` またはメインレイアウト）であることを原則とします。部分スクロールが必要な場合は、必ず `dvh` (Dynamic Viewport Height) を考慮し、Mobile Safari でのアドレスバー挙動を検証してください。

    -   **The Any-Screen Typography Protocol (Adaptive Scaling)**:
        -   **Law**: 固定の `text-3xl` 等の指定は、大画面では貧弱に、小画面では暴力的に働きます。
        -   **Action**: 
            1. **Adaptive Base**: 文字サイズは必ずモバイル基準（`text-xl`）から書き始め、`sm:` や `lg:` などのブレークポイントで最適化（Scaling）を行うことを義務付けます。
            2. **Visual Hierarchy**: 画面サイズが変わっても「情報の重要度（Hierarchy）」が維持されるよう、見出しと本文のコントラスト比を適切に管理してください。

    -   **The Fragmented UI Protocol (Consistency Mandate)**:
        -   **Law**: 「似ているが違う」は最悪です。UIコンポーネント（パンくず、見出し、ボタン等すべて）は、**その配置コンテキスト（Wrapper/Layout）まで含めて** 標準化しなければなりません。
        -   **Action**: ページごとのアドホックなCSS調整（「ここだけ少し背景色を変える」「マージンを足す」）を禁止します。サイト全体で一つの「正解（Gold Standard）」を定め、全てのページをそれに準拠させてください。

    -   **The Action Placement Standard (アクション配置基準)**:
        -   **Law**: 「追加」「保存」等の主要アクションボタンの配置がページによって異なると、ユーザーの視線移動コストが増大します。
        -   **Action**: セクションに対する主操作（例: 「追加」「保存」）は、必ず**セクションヘッダーの右端**（`flex justify-between items-center`）に配置してください。コンテンツの途中や最下部に埋もれさせてはなりません。

    -   **The Breadcrumb Priority Protocol (パンくずリスト最上部配置)**:
        -   **Law**: パンくずリスト（Breadcrumbs）は「現在地を知るための命綱」であり、**必ずページの最上部**に配置しなければなりません。
        -   **Mobile**: モバイル画面では、パンくずとアクションボタンを**縦積み（Stack）**に分離し、パンくずを上段に配置してください。横並びにしてパンくずが隠れたり横スクロールを強要する配置は禁止です。
        -   **Visibility**: パンくずのテキストは `overflow-x-auto` で溢れを処理しつつ、可能な限りファーストビューで視認できるようにしてください。

    -   **The Sub-Page Header Consistency (サブページヘッダー統一)**:
        -   **Law**: 一覧ページと登録・詳細ページは、同一のヘッダー構造（アイコン + タイトル + 説明文）を持ち、視覚的な一貫性を保たなければなりません。
        -   **Action**: 新規登録ページや編集ページであっても、親ページと同様のブランディングヘッダーとナビゲーションを配置してください。フォームのみの簡素なページは、ユーザーに「別のサイトに来た」印象を与えます。

### 3.4. モーションとジェスチャー (Motion & Gestures - The "Soul")
-   **物理ベース (Physics-Based)**: すべてのアニメーションは**スプリング物理**（剛性/減衰）を使用します。要素は弾み、伸び、わずかに潰れるべきです。
-   **ジェスチャー (Swipe First)**:
    -   **ナビゲーション (Navigation)**: 「スワイプバック」を普遍的にサポートします。
    -   **アクション (Actions)**: リスト項目には**Swipe-to-Action**（アーカイブ、削除など）を使用します。
    -   **感触 (Feel)**: ジェスチャーは指の動きに 1:1 で追従しなければなりません。ラグは厳禁です。

### 3.5. 五感のデザイン (Multi-Sensory Design)
-   **ハプティクス (Haptics)**:
    -   **触覚フィードバック**: 成功（Success）、失敗（Error）、選択（Selection）、衝突（Impact）の各イベントに対して、iOS/Androidのネイティブハプティクスパターンを割り当てます。
    -   **繊細さ**: 「ブブッ」という不快な振動ではなく、「コツッ」「コンッ」という繊細で高級感のあるフィードバックを追求します。
-   **ソニック・ブランディング (Sonic Branding)**:
    -   **サウンドロゴ**: アプリ起動時や重要な達成時（コンバージョン）には、ブランドを象徴する短いサウンド（サウンドロゴ）を再生し、記憶に残る体験を作ります。
    -   **UIサウンド**: ボタン押下やトグル切り替えにも、邪魔にならない微細なサウンド（Click, Pop）を付与します（設定でOFF可能にする）。

## 4. パフォーマンス・アニメーション (Performance Animation)
-   **60fps (120fps) ターゲット**:
    -   アニメーションは常に60fps（可能なら120fps）を維持しなければなりません。
    -   **GPU最適化**: `transform` と `opacity` プロパティのみをアニメーションさせます。`width`, `height`, `top`, `left` のアニメーションはレイアウト再計算（Reflow）を引き起こすため禁止します。
    -   **Will-Change**: 必要な場合のみ `will-change` プロパティを使用し、ブラウザにヒントを与えますが、乱用は避けます（メモリ消費増大のため）。

## 5. 適応性とフォルダブル (Adaptability & Foldables)

### 5.1. ユニバーサル・レスポンシブ (Universal Responsiveness)
-   **ルール**: 「モバイルファースト」は死語です。我々は **"Any-Screen"**（あらゆる画面）のためにデザインします。
-   **フォルダブル (Foldables)**:
    -   **ヒンジ認識 (Hinge Awareness)**: UIはヒンジを認識し、賢く分割されなければなりません（テーブルトップモード）。
    -   **連続性 (Continuity)**: 折りたたみ/展開時に、状態（State）は完全に保持されなければなりません。
-   **大画面 (Large Screens)**: **Canonical Layouts**（リスト詳細、サポートペイン、フィード）を使用し、余白を有効活用します。単にモバイルUIを「引き伸ばす」ことは禁止します。
-   **The CSS Containment Protocol (Whitespace Glitch Prevention)**:
    -   **Context**: アコーディオン展開時等に、スクロール計算が狂い膨大な余白（Whitespace）が発生することがあります。
    -   **Action**: `overflow-y-auto` を持つコンテナには `style={{ contain: 'layout' }}` を付与し、子要素のレイアウト変動がコンテナ外に影響しないよう制限してください。
-   **The Universal Beauty Protocol (Responsive Verification Mandate)**:
    -   **Law**: 「PCで動くからOK」は、レスポンシブデザインの不備を隠蔽する壽由話であり、放置された変更は「未完成」とみなします。
    -   **Action**: 全ての機能追加・UI実装において、以下の3環境での「美しさ」と「機能性」を確認・保証することを**最重要義務**とします。
        1.  **SP (Mobile)**: 縦持ち (Width < 640px)
        2.  **Tablet**: 縦持ち・横持ち (Width 768px ～ 1280px) ※特にiPad縦での崩れに注意。
        3.  **PC (Desktop)**: フルサイズ (Width > 1280px)
    -   **Checklist**:
        -   要素が重なっていないか？（Overlap）
        -   文字が小さすぎる、または大きすぎて溢れていないか？（Scaling）
        -   タッチ操作（Touch）とマウス操作（Hover）の両方が快適か？
        -   特定のデバイス幅（768px～1024pxの中間域）でレイアウトが破綻していないか？


## 6. アクセシビリティと包括性 (Accessibility & Inclusivity)
-   **WCAG 2.2 AA基準 (WCAG 2.2 AA Standard)**:
    -   **準拠基準**: **WCAG 2.2 Level AA** + **EN 301 549**（EAA技術基準）を最低ベースラインとします。
    -   **コントラスト (Contrast)**: テキストと背景のコントラスト比は最低 **4.5:1** を確保します（WCAG 1.4.3）。
    -   **大きなテキスト (Large Text)**: 18px以上（または太字14px以上）のテキストの場合は **3:1以上** で可とします。
    -   **UIコンポーネント (UI Components)**: ボタン等の操作要素の境界線やアイコンも、背景との **3:1以上** のコントラスト比を確保してください（WCAG 1.4.11）。
    -   **スケーリング (Scale)**: フォントサイズはユーザー設定（Dynamic Type / Text Scaling）に追従しなければなりません。
-   **ターゲットサイズ (Target Size - WCAG 2.2 新基準)**:
    -   **最小ターゲットサイズ**: すべてのインタラクティブ要素は最低 **24x24 CSS px** のターゲットサイズを確保します（WCAG 2.2 2.5.8）。
    -   **推奨サイズ**: **44x44dp (iOS HIG)** / **48x48dp (Material Design)** を推奨します。
    -   **到達性 (Reachability)**: 頻繁に使用するアクションは画面下部（親指の届く範囲）に配置します。
    -   **The Fat Finger Protocol (Label Wrapping)**:
        -   **Law**: チェックボックスやラジオボタンを単体で配置することを禁止します。
        -   **Action**: 必ず `<label>` タグ（または `shadcn/ui` の `Label` コンポーネント）でテキストごとラップし、タッチ有効領域を最大化してください。「文字を押しても反応しない」はバグです。
-   **セマンティクス (Semantics)**:
    -   すべてのカスタムコンポーネントには、スクリーンリーダー（TalkBack/VoiceOver）用の適切なセマンティックラベルを付与します。画像には必ず `alt` テキストを設定します。
-   **Image Alt Text Protocol (画像代替テキスト基準)**:
    -   **コンテンツ画像**: 画像の内容を正確に伝える `alt` 属性を付与してください（例: `alt="製品の外観写真"`）。
    -   **装飾画像**: 純粋に装飾目的の画像は `alt=""` とし、スクリーンリーダーに無視させてください。
    -   **省略禁止**: `alt` 属性の省略（`undefined` になる）は厳禁です。必ず空文字（`""`）か具体的テキストを指定してください。
-   **A11y Legal Defense (ADA/EAA Compliance)**:
    -   **Risk**: アクセシビリティ対応不足は、米国障害者法 (ADA Title III)、欧州アクセシビリティ法 (EAA、2025年6月施行)、障害者差別解消法（日本）に基づく訴訟リスクを生じます。
    -   **Mandate**: `aria-label` の欠如、コントラスト比不足は「バグ」ではなく「法的瑕疵」として扱います。
-   **Focus Appearance (WCAG 2.2 新基準)**:
    -   **フォーカスインジケータ**: キーボードナビゲーション時のフォーカスインジケータは、明確なコントラストとサイズ要件を満たさなければなりません（WCAG 2.2 2.4.13）。
    -   **Focus Not Obscured**: フォーカスされた要素が固定ヘッダーやフローティングポップアップの背後に隠れてはなりません（WCAG 2.2 2.4.11）。
-   **Accessible Authentication (WCAG 2.2 新基準)**:
    -   **Law**: 認証フローでは、パスワードの再入力、複雑なロジックパズル、情報の記憶等の複雑な認知タスクを強制してはなりません（WCAG 2.2 3.3.8）。
    -   **Action**: Passkeys（FIDO2）、ソーシャルログイン、パスワードマネージャーの自動入力を優先してください。
-   **A11y Zero Tolerance CI (Build Gate)**:
    -   **Mandate**: `axe-core` または `pa11y-ci` をCIパイプラインに組み込み、レベル `critical` および `serious` の違反が1つでも検出された場合、**ビルドを強制失敗**させます。
    -   **Exemption**: UIライブラリ内部の修正不可能な外部要因に限り、理由を文書化した上で例外リスト（Ignore Config）への追加を許可します。
-   **Non-Color Indication Protocol (色に依存しない情報伝達)**:
    -   **Law**: エラー表示や重要情報は、**色だけ**に依存してはなりません。色覚多様性を持つユーザーが情報を見落とします。
    -   **Action**: 必ずアイコン（⚠️、✅、❌）やテキスト（「必須」「エラー」「成功」）を**併用**し、色＋アイコン＋テキストの**三重伝達**を標準としてください。
-   **Font Size & Zoom Protocol (フォントサイズとズーム)**:
    -   **Minimum Body Text Size**: 本文テキストの最小フォントサイズは **16px** とします。これを下回るフォントサイズは可読性を損なうため、補足テキストやキャプション等に限定してください。
    -   **rem Mandate**: `font-size` は `rem` 単位で指定し、ユーザーのブラウザ設定を尊重します。`px` 固定は `:root` レベルのみ許可します。
    -   **Zoom Resilience**: ブラウザのズーム機能（**200%**）でレイアウトが崩れないように設計してください。コンテンツの切れや重なりはバグとして扱います。
-   **Tab Order Protocol (キーボードナビゲーション順序)**:
    -   **Law**: DOM順序とタブ順序を一致させます。`tabindex` の正値（例: `tabindex="5"`）は**禁止**です。
    -   **Allowed**: `tabindex="0"`（自然なタブ順に追加）と `tabindex="-1"`（プログラムからのフォーカスのみ）のみ許可します。
    -   **Escape Key**: モーダルやドロップダウンは `Escape` キーで閉じられなければなりません。
-   **Skip Link Protocol (スキップナビゲーション)**:
    -   **Mandate**: ページの冒頭に **「メインコンテンツへスキップ」** リンクを実装してください。
    -   **Implementation**: 通常は非表示、フォーカス時のみ可視化する `sr-only` + `:focus` パターンを使用します。
-   **ARIA Attributes Standard (ARIA属性基準)**:
    -   **aria-live**: 動的に変化するコンテンツ（トースト通知、カウントダウン等）には `aria-live="polite"` を設定し、スクリーンリーダーに変更を通知します。
    -   **aria-expanded / aria-controls**: アコーディオンやドロップダウンには、開閉状態を示す `aria-expanded` と制御対象を示す `aria-controls` を設定します。
    -   **First Rule of ARIA**: セマンティックHTMLで十分な場合はARIAを使わないでください。過剰なARIAはかえって混乱を招きます。
-   **Label Association Protocol (ラベル関連付け)**:
    -   **Mandate**: すべての入力フィールドに `<label>` を `htmlFor` 属性で関連付けてください。
    -   **Placeholder-Only Prohibition**: `placeholder` をラベルの代替にすることは厳禁です。プレースホルダーはフォーカス時に消えるため、ユーザーが入力の目的を見失います。
-   **Error Notification Protocol (フォームエラー通知)**:
    -   **Mandate**: フォームエラーは `aria-live="assertive"` で即座にスクリーンリーダーに通知します。
    -   **Association**: エラーメッセージはフィールドの直下に配置し、`aria-describedby` でフィールドと関連付けてください。
    -   **Clarity**: エラーメッセージは「どのフィールド」に不備があるかを**明確に**示さなければなりません。
-   **Required Fields Protocol (必須フィールド明示)**:
    -   **ARIA**: 必須フィールドには `aria-required="true"` を設定します。
    -   **Visual**: 視覚的にも「必須」ラベルまたは `*` マーク + テキストで明示してください（色だけに依存しない: Non-Color Indication Protocol準拠）。
-   **Lighthouse Score Gate (品質ゲート)**:
    -   **Mandate**: Lighthouse Accessibility Score **90点以上** を**デプロイ要件**とします。90点未満のページはバグとして扱います。
    -   **Manual Testing**: 定期的にキーボードのみでのサイト操作テスト、スクリーンリーダー（VoiceOver / NVDA）での読み上げ確認、および200%ズームテストを実施してください。
-   **Color Vision Simulation Test (色覚多様性検証)**:
    -   **Mandate**: 色を情報伝達に使用するUIコンポーネント（ステータスバッジ、チャート、エラー表示等）の新規作成・変更時に、以下の色覚シミュレーションでの視認性確認を義務付けます。
        -   1型色覚 (Protanopia): 赤の知覚困難
        -   2型色覚 (Deuteranopia): 緑の知覚困難
        -   3型色覚 (Tritanopia): 青の知覚困難
    -   **Tools**: 開発段階では Chrome DevTools の「Rendering > Emulate vision deficiencies」、デザイン段階では Figma の `Able` または `Stark` プラグインを使用してください。
    -   **PR Review Gate**: 色による情報伝達を含むUIコンポーネントのPRでは、レビュアーが上記ツールでの確認結果をコメントに記載することを推奨します。
-   **Media Accessibility Protocol (動画・音声アクセシビリティ)**:
    -   **Subtitles**: 動画コンテンツには、ターゲットロケールの言語による字幕付与を必須とします。
    -   **Transcript**: 音声のみのコンテンツにはテキスト書き起こしを提供してください。
    -   **Auto-Play Ban**: 音声付きメディアの自動再生は禁止します。ユーザーの明示的操作（クリック/タップ）でのみ再生を開始してください（WCAG 1.4.2準拠）。
-   **Semantic HTML Standard (セマンティックHTML基準)**:
    -   **Law**: `div` / `span` を多用する「div地獄」を避け、適切なHTML要素を使い分けてください。
    -   **Elements**:
        -   `<button>`: クリック可能なアクション（`<div onClick>` は禁止）
        -   `<a>`: ナビゲーション（ページ遷移、外部リンク）
        -   `<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`: ページ構造のランドマーク
        -   `<article>`, `<section>`: コンテンツの意味的な区切り
    -   **Landmark Completeness**: `<main>` はページごとに1つだけ配置し、`<nav>` にはナビゲーションメニューを必ず含めてください。
-   **Locale-Aware Screen Reader Testing (ロケール対応読み上げテスト)**:
    -   **Context**: スクリーンリーダーの読み上げ挙動はロケールによって異なります（例: 漢字の読み間違い、通貨記号の読み上げ方、住所フォーマット順序等）。
    -   **Mandate**: 新規ページ・主要UIコンポーネントのリリース前に、ターゲットロケールの言語設定でVoiceOver（iOS/macOS）またはNVDA（Windows）による読み上げテストを実施してください。
    -   **Checklist**: ボタン読み上げ（操作がターゲット言語で伝わること）、フォームラベル（入力目的がターゲット言語で読み上げられること）、エラーメッセージ（`aria-live` での即時通知）、数値・通貨（自然な読み上げ）を確認項目としてください。

## 7. ユーザー主権 & Ethical UX (User Sovereignty & Ethical UX)
-   **データ所有権 (Data Ownership)**:
    -   ユーザーは自分のデータを完全にコントロールできる権利を持ちます。「エクスポート」「完全削除」はわかりやすい場所に配置します。
-   **ダークパターンの完全禁止 (Dark Pattern Complete Ban)**:
    -   **Law**: ダークパターンは「デザイン最適化」ではなく**「法的リスク」**として扱います。
    -   **規制環境**:
        -   **FTC（米国）**: Section 5 + Negative Option Ruleでの執行強化。Click-to-Cancel義務。
        -   **DSA（EU）**: ユーザーの自律を歪めるまたは制限する操作的インターフェースの禁止（グローバル年間売上の最大6%の罰金）。
        -   **CPRA/CCPA（カリフォルニア）**: ダークパターンを通じて得た同意の明示的な禁止。
    -   **具体的禁止事項**:
        -   **Confirmshaming**: 辞退ボタンに罪悪感を誘発する表現（「いいえ、品質は気にしません」）
        -   **Roach Motel**: 登録は簡単だが退会は困難
        -   **Hidden Costs**: 最終購入時に発覚する追加料金
        -   **Pre-checked Boxes**: デフォルトでチェック済みのオプトイン
        -   **Forced Continuity**: 明示的通知なしの無料トライアル後自動課金
        -   **Trick Questions**: 二重否定や混乱を招く表現
    -   **対称性原則 (Symmetry Principle)**: 退会/オプトアウトのフローは、登録/オプトインのフローと同等の容易さで設計しなければなりません。
-   **透明性 (Transparency)**:
    -   AIの判断根拠や、なぜそのコンテンツが表示されたかをユーザーが理解できるようにします（Explainable AI）。
    -   アルゴリズムによる推薦には「なぜこれが表示されていますか？」の説明を提供してください。
-   **同意とプライバシーUX (Consent & Privacy UX)**:
    -   **粒度別同意 (Granular Consent)**: カテゴリ別（必須/分析/マーケティング）で同意を取得してください。「全て許可」ボタンだけでは不十分です。
    -   **撤回可能 (Revocable)**: 同意はいつでも容易に撤回できなければなりません。
    -   **平易な言葉 (Plain Language)**: プライバシーポリシーの要約は法律用語ではなく、ユーザーが理解できる平易な言葉で提示してください。

## 8. ツールとワークフロー (Tools & Workflow)
-   **Figma**: 信頼できる唯一の情報源（Source of Truth）。正確なトークンのハンドオフにはDev Modeを使用します。
-   **Rive / Lottie**: コードベースのアニメーションが複雑すぎる場合は、**Rive**（ステートマシン付きベクターアニメーション）を使用します。
-   **インクルーシブ・コピーライティング (Inclusive Copywriting)**:
    -   性別、人種、年齢、能力に関わらず、誰もが排除されない言葉選び（Inclusive Language）を行います。

## 9. AI UX戦略 (AI UX Strategy)
-   **AI UX哲学 (AI UX Philosophy)**:
    -   **Law**: AIは「ツール」ではなく「協力者」として設計します。透明性・制御性・安全性の3原則を優先します。
-   **AIインタラクションパターン（5類型）**:
    -   **Chat**: テキストベースの対話。検索・Q&A・カジュアルな問い合わせに適します。
    -   **Copilot**: 作業画面のサイドパネルアシスタント。ユーザーのコンテキストを理解しリアルタイムで支援。
        -   *Assistive*: サイドパネルでの継続的タスク支援
        -   *Immersive*: フルスクリーンのデータ集約型AIワークスペース
        -   *Embedded*: インラインの最小限トリガー（「書き直す」「要約」ボタン等）
    -   **Agent**: 自律的なマルチステップタスク実行。ユーザーが目標を定義し、AIが計画・実行。
    -   **Ambient**: バックグラウンドでインテリジェントに動作し、必要時のみプロアクティブに表面化。
    -   **Proactive**: ユーザーの行動パターンに基づき予測・提案。
-   **Agentic AI UXパターン**:
    -   **Intent Preview**: アクション実行前に計画プレビューを表示し、ユーザーが承認・編集・拒否できるようにします。
    -   **Autonomy Dial**: AIの自律性レベルをユーザーが調整できるようにします（「提案のみ」「承認後実行」「完全自律」）。
    -   **Explainable Rationale**: AIの判断根拠と信頼度を透明に表示します。ブラックボックス出力は禁止です。
    -   **Action Audit & Recovery**: 全ての自律アクションをログし、容易な「元に戻す」/「ロールバック」機能を提供します。
-   **Generative UI (GenUI)**:
    -   **動的コンポーネント選択**: AIが事前定義されたブランドUIコンポーネントライブラリから適切なコンポーネントを選択し、ライブデータを注入します。
    -   **アダプティブレイアウト**: ユーザーの現在のタスクや履歴に基づきUIを動的に再構成します。
    -   **コンテキスチュアルアシスタンス**: 関連コンテキストでのみ表示されるサーフェス（サイドパネル、ツールチップ、埋め込みオーバーレイ）。チャット疲労を防止します。
-   **ストリーミング・ファースト (Streaming First)**:
    -   AIの生成待ち時間は「体感ゼロ」でなければなりません。完了を待たず1トークンずつリアルタイムに表示します。
    -   ユーザーのアクション（送信ボタン押下等）に対してはAIの処理を待たず即座にUIを反応させます。
-   **透明性 (Transparency)**:
    -   AIが「考えている」状態（Thinking...）と「書いている」状態（Generating...）を視覚的に区別します。
    -   **AIコンテンツの判別**: AI生成コンテンツと人間が作成したコンテンツを視覚的に差別化します（グローエフェクト、専用アイコン等）。
    -   **信頼度シグナル**: AIの信頼度をユーザーに伝えるメカニズムを設計します。
-   **AI失敗ハンドリング (AI Failure Handling)**:
    -   AIエラーの優雅なリカバリーパスを設計します。修正・再生成・比較のUIパターンを提供します。
    -   **Human-in-the-Loop**: Copilot体験では、AI出力を常に「提案」として扱います。ユーザーが最終判断権を持つ設計を維持します。
-   **The Quota Framing Protocol (制限表現の心理学)**:
    -   **Law**: AI生成やAPI利用回数などの利用制限（Quota）を表示する際、「ケチで制限している」と感じさせる文言を禁止します。
    -   **NG**: 「回数制限に達しました」「利用制限オーバーです」
    -   **OK**: 「今月のAI生成パワーを使い切りました。プランをアップグレードして上限を解放しますか？」

-   **MCP (Model Context Protocol) UX統合プロトコル**:
    -   **背景**: Anthropicが2024年に公開したMCP（現在はオープンスタンダード）は、AIエージェントと外部ツール/データソースを標準化されたインターフェースで接続する仕組みです。アプリが外部MCPサーバーに接続する際、適切なUIガバナンスが必須となります。
    -   **ツール参照透明性 (Tool Call Transparency)**: AIエージェントが外部ツール（ファイル操作、API呼び出し、DBアクセス等）を呼び出す際は、UI上で「どのツールを何の目的で呼び出そうとしているか」をユーザーに展示してください。
    -   **パーミッションUI (Permission UI)**: MCPサーバーへの接続権限は、初回接続時にユーザーが明示的に承認できるUIを提供してください。OAuthスコープと同等の粒度で「読み取り専用」「書き込み許可」等を選択可能にすることを推奨します。
    -   **アクションログUI (Action Log UI)**: MCPを通じてエージェントが実行したすべてのアクション（ファイル作成・削除・API呼び出し等）は、人間が読めるログとしてUI上に表示し、ユーザーがレビュー・取り消せる設計を維持してください（§9の「Action Audit & Recovery」と統合）。
    -   **スコープ最小化 (Minimal Scope Principle)**: MCPサーバーへのアクセス権限は、タスク完了に必要な最小限に限定してください。「全権限」の取得は禁止し、タスクが完了したらセッションを破棄する設計を推奨します。
-   **マルチモーダルAI UX (Multimodal AI UX)**:
    -   **モーダリティ切替表示**: テキスト・画像・音声・動画など複数のモーダリティを処理するAIを使用する場合、「AIが現在何を処理しているか」（どのモーダリティを認識中か）をUIに表示してください。
    -   **モーダリティ卖返しUI**: 画像・音声・テキストの各モーダリティの入力に対して、ユーザーが個別に確認・プレビューを削除できる「モーダリティ個別確認UI」を提供することを推奨します。

## 10. ユーザーオンボーディングとガイド (User Onboarding & Guidance)
-   **コーチマーク (Coach Marks)**:
    -   **コンテキスト重視**: ユーザーが初めてその画面を訪れた時、または新しい機能が追加された時のみ表示します。
    -   **UIパターン**: 添付画像のように、対象の要素（ボタン等）をハイライトし、吹き出し（Tooltip）で簡潔な説明とアクション（「記録」など）を提示します。
    -   **スキップ可能**: ユーザーが強制的にチュートリアルを見せられるストレスを避けるため、必ず「スキップ」または「閉じる」手段を提供します。
-   **The Feature Tab Protocol (機能タブナビゲーション)**:
    -   **Law**: 関連する機能群（例: プロフィール管理、設定画面等）を構成するページ間では、共通のタブナビゲーションを配置し、ユーザーが迷わず機能間を行き来できるようにしてください。
    -   **Disabled State**: 前提条件（例: 初回登録未完了等）を満たさない場合、関連タブは非表示ではなく **非活性（Disabled / Opacity低下）** とし、機能の存在自体は認知させてください（ディスカバラビリティの確保）。
    -   **Active State**: 現在のコンテキストに応じたタブを強調表示してください。サブリソース（新規作成画面等）で直接対応するタブがない場合は、親カテゴリのタブを維持するか全て非選択としてください。

-   **機能発見 (Feature Discovery)**:
    -   **プログレッシブ・ディスクロージャー**: 全ての機能を一度に説明せず、ユーザーの習熟度に合わせて徐々に高度な機能を提示します。
    -   **エンプティステート (Empty States)**: データがない状態（Zero Data）を「エラー」ではなく「オンボーディングの機会」と捉えます。「記録がありません」だけでなく、「最初の記録を追加しましょう」という明確なCall to Action (CTA) を配置します。
-   **一般消費者視点 (General Consumer Perspective)**:
    -   **専門用語禁止**: UI上のテキストには「データベース」「同期」「API」などの技術用語を一切使用しません。「保存」「更新」「連携」など、誰でもわかる言葉を選びます。
    -   **直感性**: 「説明書を読まなくても使える」をゴールとします。アイコンには必ずラベルを併記し、意味の曖昧さをなくします。
    -   **Focus Ring Protocol (Rule 0.99: Accessibility Sight)**:
        -   **Law**: フォーカス状態（Tabキー操作等）が視覚的に認識できないUIは、キーボードユーザーにとって「暗闇の迷路」であり、アクセシビリティ上の敗北です。
        -   **Action**: ブラウザ標準のフォーカスリングを消去（`outline-none`）した場合は、必ず代替となる**高コントラストなフォーカスリング**（例: `ring-2 ring-primary ring-offset-2`）を再定義してください。「見えないフォーカス（Invisible Focus）」はバグとして扱います。
    -   **Micro-Interaction Standards**:
        -   **Cursor Affordance Mandate**: クリックでアクションが発生する全ての要素（カード、デイトピッカー、カスタム入力欄等）には、ホバー時に必ず **`cursor-pointer`** を適用し、アフォーダンスを明確にしてください。
        -   **Hover State Fidelity**: インタラクティブなカードには、ホバー時に背景色の微変やわずかな浮浮（`shadow-md`）を付与し、その要素が「反応する」ことをユーザーの潜在意識に伝えなさい。
        -   **Clipboard Interaction Protocol (Copy Feedback)**: URLやコードの「コピー」アクション成功時は、必ず **トースト通知** または **アイコン変化（チェックマーク等）** を即座に表示し、ユーザーに成功を明示してください。`navigator.clipboard` が失敗する環境（非HTTPS等）では、テキスト選択状態にして手動コピーを促すフォールバックを実装します。
        -   **Input Reflection Protocol (Real-time Label Sync)**: アコーディオン等の開閉UIにおいて、内部の入力フィールド（`name`, `title`等）の変更は、親コンポーネント（リストビューやアコーディオンヘッダー）に**リアルタイムで反映**させなければなりません。「保存するまでタイトルが変わらない」挙動は、管理画面においてはUXの遅延（ラグ）として認知されます。
    -   **Code Input Standard (Rule 14.12)**:
        -   **Law**: HTML/CSS/JSON等のコード編集が必要な箇所で、生の `textarea` を使用することは、シンタックスハイライトがなくミスを誘発し、品質を著しく損なうため厳禁です。
        -   **Action**: 必ず `react-simple-code-editor` (+ `prismjs`) などのエディタコンポーネントを使用し、プロフェッショナルな品質を提供してください。生の `Textarea` の使用は未完成とみなします。
    -   **The Microcopy Quality Protocol (Kindness First)**:
        -   **Law (No Blame)**: エラーメッセージはユーザーを「責める」のではなく「助ける」文言にしてください。
            -   **NG**: "不正な入力です (Invalid Input)"
            -   **OK**: "メールアドレスの形式で入力してください" / "半角英数字のみ使用できます"
        -   **Law (Safety Warning)**: 削除確認などの危険操作では、**不可逆性を強調する言葉**（「この操作は取り消せません」）を赤色UIと共に添えてください。
        -   **Law (Error 2-Sentence Rule)**: エラーメッセージは「**何が起きたか**」+「**どうすればよいか**」の**2文構成を必須**としてください。原因だけ伝えて解決策を示さないエラーメッセージは不完全です。
        -   **Law (Positive Framing)**: 否定形より**肯定形**を優先してください。ユーザーに「できない」ではなく「こうすればできる」を伝えます。
        -   **Law (Action-Oriented Button Labels)**: ボタンのラベルは裸の名詞（例:「保存」「送信」）よりも、意図するアクションを明示する**動詞形**（例:「保存する」「送信する」「内容を確認する」）を推奨します。ユーザーの行動意欲を促し、CV率の向上に寄与します。
        -   **Law (Debug Artifact Display Ban)**: ランタイムのデバッグ値（`null`, `undefined`, `NaN`）、スタックトレース、生のDBエラーメッセージがUI上に表示されることは**厳禁**です。これらはユーザーに「壊れている」印象を与える重大なUX欠陥です。必ずError BoundaryやフォールバックUIで捕捉し、ユーザーには理解可能なメッセージを表示してください。
    -   **The Explicit Explanation Protocol (Zero Jargon / Tooltip Mandate)**:
        -   **Law**: 開発者にとっての「常識（API, Webhook, MRR等）」は、ユーザーにとっては「謎の記号」です。これらに説明がないことは、ツールとしての敗北を意味します。
        -   **Action**: 
            1. **No Jargon**: UI上のテキストには極力専門用語を使用せず、誰でもわかる言葉を選びます。
            2. **Tooltip Mandate**: どうしても専門用語や計算値（MRR等）が必要な場合は、必ず **`Info` アイコンと `Tooltip`** を付与し、「それが何であり、どう計算され、ビジネスにどう影響するか」を非エンジニアの言葉で解説してください。
            3. **Completion**: Tooltipの実装完了をもって、その機能の「完成」とみなします。

## 11. 安全なUIプロトコル (Safety UI Protocols)
-   **No Native Popups**:
    -   `window.alert`, `confirm`, `prompt` の使用を禁止します。スレッドをブロックしUXを損なうため、必ず `Dialog` コンポーネントを使用します。
-   **Destructive Actions**:
    -   **Magic Word**: データの完全削除など、取り返しのつかない操作には、「OK」ボタンではなく、「delete」等の**マジックワード入力**を求める確認ダイアログを実装します。
-   **Dirty Check**:
    -   未保存の変更がある状態での離脱に対し、「変更が失われます」という警告を表示します。
-   **Loading Lock Protocol (Double-Submit Prevention)**:
    -   **Law**: フォーム送信中や非同期処理中にボタンが押せる状態を放置することは、データの二重登録やRace Conditionの原因となり厳禁です。
    -   **Action**: 処理中 (`isLoading`) はボタンを `disabled` 属性で無効化し、視覚的にもグレーアウトまたはスピナーを表示してください。重大な副作用を伴うアクションでは `pointer-events-none` を併用し、物理的なクリックを遮断します。
-   **Responsive Action Button Protocol**:
    -   **Mobile**: 重要なアクションボタン（登録、保存、購入等）は `w-full`（画面幅いっぱい）で押しやすくします。
    -   **Desktop**: `w-auto` かつ十分な最小幅を確保し、**中央配置** とします。PCで `w-full` にして間延びさせることは禁止です。
    -   **Affordance**: 影 (`shadow-md`) やホバーエフェクトを付与し、「押せる感」を演出します。
-   **Rich Selection Protocol (リッチ選択UI)**:
    -   **Law**: 従来の小さなラジオボタンやチェックボックスの単体使用は、タッチデバイスでのヒットエリアが不十分であり、選択状態の視認性も低いため、重要な選択UIでの使用を原則禁止します。
    -   **Standard**: 大きなヒットエリア、明確なボーダー、選択時の色変化（背景色・ボーダー色の変化）、およびアイコンによる視覚補助を備えた**カード型選択UI（Selectable Card Grid）**を標準としてください。
    -   **Implementation**: ネイティブのラジオ/チェック要素はスクリーンリーダー用に `sr-only` で隠し、隣接するラベル要素を `peer-data-[state=checked]:` 等でスタイリングする手法を推奨します。

## 12. おもてなしUX (Omotenashi UX - Japanese Hospitality)
-   **気が利く (Kigakiku - Anticipatory Design)**:
    -   **先回り**: ユーザーが困る前に、ニーズを先読みして解決策を提示します。
    -   **例**: フォーム入力でエラーが出た瞬間、単に赤くするのではなく、「全角になっています。半角に修正しますか？」と修正ボタンを提示します。
    -   **Input Normalization（入力寛容の原則）**: ユーザーが不正確な形式（全角数字、全角スペース等）で入力した場合、バリデーションエラーで弾くのではなく、`onChange` または `onBlur` で**静かに自動変換（Normalize）**して受け入れてください。`String.normalize('NFKC')` 等を活用し、ユーザーの入力負担を最小化します。
    -   **Locale-Specific Input Assistance（ロケール特化入力補助）**: ロケール固有のデータ入力（住所、氏名等）では、**ロケール特化の入力補助機能**（例: 郵便番号からの住所自動補完、読み仮名自動生成、電話番号フォーマット等）を実装し、ユーザーの入力負担を軽減することを推奨します。自動補完後も手動修正を可能とし、ユーザーの制御権を保障してください。
-   **間 (Ma - Negative Space)**:
    -   **余白の美学**: シリコンバレーの「情報の密度」と、日本の「間（余白）」を融合させます。余白は単なるスペースではなく、ユーザーに「思考の時間」を与えるための機能です。
-   **相槌 (Aizuchi - Reassuring Feedback)**:
    -   **反応**: ユーザーのあらゆるアクション（タップ、スクロール、入力）に対して、視覚的または触覚的（Haptics）な「相槌」を返します。「あなたの操作は正しく伝わっていますよ」という安心感を常に与え続けます。
-   **The Graceful Error Recovery Protocol (謝罪と導線の義務)**:
    -   **Law**: 予期せぬエラー発生時には、事実を伝えるだけでなく、ユーザーへの共感を表現し、**次にユーザーが取るべきアクション**（再読込、ホームに戻る、問い合わせる等）の導線ボタンを必ず添えてください。
    -   **Action**: エラーページやエラーモーダルには、原因の簡潔な説明と共に、最低1つの回復アクションボタンを配置してください。「行き止まり（Dead End）」のエラー画面は、ユーザーの離脱を加速させるUXの敗北です。
-   **Error Page Design Protocol (エラーページ設計基準)**:
    -   **Law**: エラーページはユーザーが最も不安を感じる瞬間です。離脱を防ぎ信頼を維持するための設計基準を以下に定めます。
    -   **Design Principles**:
        1.  ブランドロゴとカラースキームを維持する（白紙ページ禁止）
        2.  イラストまたはアイコンで視覚的に状況を伝える
        3.  次のアクションを明確に3つ以内提示する（例: 「トップに戻る」「検索する」「お問い合わせ」）
    -   **HTTP Status Compliance**: エラーページは正しいHTTPステータスコードを返してください。200で返すことは禁止です。404ページには `<meta name="robots" content="noindex">` を必須とします。
    -   **Prohibited**: スタックトレースやデバッグ情報の表示、ユーザーを責めるような文言（「あなたの操作に問題があります」等）は厳禁です。
-   **The Ghost Content Protocol (Time-Gated SEO / 公開予約コンテンツの隔離)**:
    -   **Context**: 公開予約（published_at > NOW()）されたコンテンツは、サーバー上に存在するが、一般ユーザーおよび検索エンジンには「存在しないもの」として振る舞わなければなりません。
    -   **Action**:
        1.  **404 Mock**: 一般ユーザーからのアクセスに対しては、通常の404エラーと同一のUI・ステータスコードを返し、コンテンツの存在を推測させないでください。
        2.  **NoIndex Guard**: 万が一URLが漏洩した場合に備え、未公開状態のページには `<meta name="robots" content="noindex, nofollow" />` を強制挿入してください。

## 13. デザインOpsとツール連携 (Design Ops & Tools)
-   **デザインシステム (Design System)**:
    -   **Single Source of Truth**: Figma上のデザインシステム（Styles, Variables, Components）を唯一の正解とします。コード（Tailwind Config）は常にFigmaに従属します。
-   **ツール連携プロトコル (Tool Usage Protocol)**:
    -   **Figma (UI/UX)**: エンジニアは必ず **Dev Mode** を使用してプロパティを確認します。目分量での実装は厳禁です。
    -   **Adobe Creative Cloud**: ロゴや複雑なグラフィックにはPhotoshop/Illustratorを使用し、SVGまたはWebPとしてFigmaに配置します。
    -   **Canva**: OGPや社内資料などの「非プロダクトUI」にはCanvaを積極的に使用し、テンプレート化して効率化します。
-   **ハンドオフ (Hand-off)**:
    -   **ステータス管理**: Figma上の各フレームには「Draft」「Ready for Dev」「Shipped」のステータスを明記します。
    -   **エクスポート**: 画像は原則として **WebP** または **SVG** でエクスポートします。PNG/JPGは特別な理由がない限り使用しません。



## 14. インタラクション安全プロトコル (Interaction Safety Protocols)

### 14.1. The Responsive Safety Protocol (No-Trap Mandate)
-   **Law**: PCとSPではインタラクションの物理法則が異なります。
-   **Action**:
    1.  **SP (Drawer Safety)**: Drawer内のスクロール領域には `data-vaul-no-drag` を付与し、誤閉鎖を低減します。
    2.  **PC (Viewport Safety)**: Popover等の浮動要素には必ず `max-height` を設定し、画面外へのはみ出しを低減します。
    3.  **Responsive Split**: モバイルでは `Drawer`、PCでは `Popover` を使い分ける実装を標準とします。
    4.  **iOS Input Zoom Defense (iOSズーム防止)**: iOS Safariでは入力フィールドの `font-size` が **16px未満** の場合、フォーカス時に自動ズームインしUXを損ないます。モバイルビューにおける `input`, `textarea`, `select` の `font-size` は **16px (`text-base`)** 以上を強制してください。

### 14.2. The Mobile Click/Tap Fix
-   **Law**: モバイル上のPopover等は、フォーカス制御の競合によりタップイベントを拾えない場合があります。
-   **Action**: インタラクティブ要素（リスト項目等）には `pointer-events-auto` を強制し、`onClick` / `onMouseDown` / `onPointerUp` などの多重バインディングでイベント発火を保証します。
-   **Combobox Interaction Protocol**:
    -   **Stable IDs**: 仮想リスト（CMDK等）の `value` 属性には、必ず一意かつ不変な **ASCII文字列**（ID等）を使用してください。日本語を使用すると選択ロジック（フィルタリング）が誤動作します。
    -   **Searchability**: 日本語での検索が必要な場合は、`keywords` プロパティ（配列）を明示的に指定して検索性を担保します。

### 14.3. The Z-Index Stratification Protocol
-   **Law**: Z-Indexの戦いに終止符を打ちます。
    -   **Level 4 (Max)**: `z-[10000]` - Overlay Components (Select, Popover, Tooltip, Calendar) ※Modalより上
    -   **Level 3**: `z-[9999]` - Dialog / Modal
    -   **Level 2**: `z-[1000]` - Full Screen UI (Mobile Menu, Drawer)
    -   **Level 1**: `z-50` - Fixed Header, Floating Buttons
    -   **Level 0**: `z-0` ~ `z-40` - Page Content
-   **Action**: 恣意的な `z-100` などのマジックナンバーを禁止します。この階層構造を厳守してください。

### 14.4. The Drag & Drop Safety Protocol (DnD安全基準)
-   **Portal Rendering (Clipping Defense)**: `DragOverlay` は `createPortal` を使用して `document.body` 直下にレンダリングし、親要素の `overflow: hidden` によるクリッピングを防止してください。
-   **Context Isolation**: 1ページに複数のDnD領域がある場合、`DndContext` を分離するか一意なIDを付与し、領域間の干渉を防いでください。
-   **DragOverlay Input Ban**: `DragOverlay` 内にフォーム入力要素（`input`, `textarea`）をそのままレンダリングすることを禁止します。フォームライブラリ（React Hook Form等）が同一 `name` の入力欄を2つと誤認し、バリデーション不具合を招きます。Overlay描画時は Read-Only のJSXを返す `isOverlay` プロパティ分岐を実装してください。
-   **Accordion Handling**: Accordion を含む要素をドラッグする場合、Overlay内では強制的に全閉（`defaultValue={[]}`）とし、巨大な要素が画面を占有するのを防いでください。

### 14.5. The Auto-Save Protocol (自動保存基準)
-   **Scope**: 管理画面や長文入力を伴うフォーム（記事・設定・コンテンツ編集等）には、auto-save機能の実装を推奨します。
-   **Hook Strategy**: 標準化された `useAutoSave` フックを用い、debounce（2秒以上）による下書き保存を実装してください。
-   **Passive Restoration**: ページロード時に下書きが存在する場合、自動適用せず「下書きが見つかりました」通知を表示し、ユーザーに復元の選択権を与えてください。
-   **Hygiene**: フォーム正常送信時には `clearDraft()` を呼び出し、ローカルストレージをクリーンアップしてください。
-   **Roadmap**: 将来的にはサーバーサイド下書き保存へ移行し、デバイス間のコンティニュイティ（途中再開）を実現することを推奨します。
-   **The Public Form Persistence Protocol (公開フォーム入力保持)**:
    -   **Context**: エンドユーザー向けフォーム（問い合わせ、登録等）で入力中にブラウザが閉じた場合、全入力が失われるのはUXの損失です。
    -   **Action**: 公開フォームにおいても、`localStorage` または `sessionStorage` を活用した入力データの一時保持を推奨します。次回訪問時に復元を提案し、ユーザーの再入力負担を軽減してください。

### 14.6. The Hard Session Refresh Protocol (認証状態変更時のハードリロード)
-   **Context**: Server ActionやAPIでセッションCookie（ログイン、権限変更等）を更新しても、SPA遷移（クライアントサイドルーティング）だけではMiddlewareやServer Componentに即座に反映されない場合があります。
-   **Action**: 認証状態や重要な権限の変更時（Login / Logout / 権限昇格等）は、`window.location.reload()` または `window.location.href` による**ハードリフレッシュ**を使用し、最新のCookie状態でサーバーにアクセスさせてください。
-   **Rationale**: クライアントサイドルーティングによるソフトナビゲーションでは、Cookie/Session の変更がMiddlewareに反映されず、権限不整合によるエラー画面やセキュリティホールの原因となります。リロードによる一瞬の白画面は、権限不整合よりも遥かに軽微なUXコストです。

### 14.7. The Offline Resilience Protocol (ネットワーク不安定時の防御)
-   **Context**: ネットワークが不安定な環境（モバイル回線、電車移動中等）でアプリが「白い画面」で停止することは、ユーザー体験の致命的欠陥です。
-   **Action**:
    1.  **Component-Level Recovery**: データ取得ライブラリ（SWR, React Query等）の `onError` をハンドリングし、グローバルなError Boundaryが発火する前に、コンポーネントレベルで「再読み込みボタン」付きのスケルトンまたはエラーメッセージを表示してください。
    2.  **Online Status Watch**: `navigator.onLine` を監視し、オフライン検知時はフォーム送信ボタンを `disabled` にしてデータ損失を防いでください。ユーザーに「現在オフラインです」と明示するバナーの表示を推奨します。

## 15. ローカライゼーションと国際化 (Localization & Internationalization)

### 15.1. The Localization Completeness Protocol（ローカライゼーション完全性）
-   **Law**: ターゲットロケールの言語に翻訳されていないUI文字列（ボタンラベル、プレースホルダー、トースト通知、バリデーションメッセージ、空状態テキスト、ツールチップ等）の残存は**「バグ」**として扱います。
-   **Scope**: 以下の箇所を重点スキャン対象とします：
    1.  **静的UI**: ボタンラベル、見出し、メニュー項目
    2.  **プレースホルダー**: 入力例は具体的かつロケールに適した形式で記述
    3.  **トースト・アラート**: 成功/エラーの通知文
    4.  **バリデーションメッセージ**: フレームワーク/ライブラリのデフォルトメッセージ（Zod等の `message` パラメータで上書き）
    5.  **日時・通貨**: ロケール準拠のフォーマット（§2.1 Locale Format Mandate参照）
    6.  **管理画面**: 管理者も対象ロケールの言語話者である。管理画面の英語ラベル残存も例外なくバグとする
    7.  **自動送信メール・通知**: 件名から署名まで対象言語で自然な文面であること
-   **Exception**: 固有名詞（Google, LINE, Instagram等）、カタカナ化/翻訳が不自然な技術用語（URL, ID, API等）は許容します。
-   **Internal Value Display Guard**: DB値・内部定数・enumの文字列値をUIに直接表示することを禁止します。必ずマッピング辞書またはラベルプロパティを経由してターゲット言語に変換してください。
-   **Scan Protocol**: PRレビュー時に、UIファイル（`.tsx` 等）内の文字列リテラルがローカライズされているかを確認項目に含めてください。可能であればCIスクリプトによる自動検出を構築してください。

### 15.2. The Error Message UX Standard（エラーメッセージUX基準）
-   **Law**: エラーメッセージは以下の品質基準を満たさなければなりません。
-   **2-Sentence Rule**: エラーメッセージは「**何が起きたか**」+「**次にどうすればよいか**」の2文構成を必須とします。原因のみ報告し解決策を示さないメッセージは不完全です。
-   **No Tech-Speak**: `null`, `undefined`, `NaN`, `UUID`, スタックトレース、DB固有エラーメッセージ等の技術用語・デバッグ情報をUIに表示することを物理的に禁止します。常にError Boundaryまたはフォールバックでキャッチし、ユーザーが理解できるメッセージに変換してください。
-   **Empathy First**: エラーメッセージはユーザーを「責める」のではなく「助ける」文言にしてください。否定形より肯定形を優先します。
-   **Positive Framing**: 「〜できません」ではなく「〜してから再度お試しください」のように達成方法を示してください。
-   **Graceful Recovery**: エラー画面・エラーモーダルには、原因の簡潔な説明に加え、**最低1つの復旧アクションボタン**（再読込、ホームに戻る、問い合わせる等）を必ず配置してください。行き止まりのエラー画面はUX上の致命的欠陥です。

### 15.3. The IME/Input Method Handling Protocol（入力メソッド対応）
-   **Context**: CJK言語圏（日本語、中国語、韓国語等）ではIME（Input Method Editor）を介した入力が一般的であり、`onChange` イベントの発火タイミングが直接入力と異なります。
-   **Composition Event Handling**:
    -   検索バーや即時フィルタリングUIでは、IME変換確定前（Composition中）にリクエストが飛ばないよう、`compositionstart` / `compositionend` イベントを適切にハンドリングしてください。
    -   入力フォームの実装・改修時は、以下の3パターンでのテストを推奨します。
        1.  **IME ON（変換あり）**: 変換候補選択→確定の一連操作
        2.  **IME OFF（直接入力）**: 英数字やURLの直接入力
        3.  **混合入力**: ターゲット言語と英数字が混在するケース
-   **Input Normalization（文字正規化）**: ユーザーが全角数字や全角スペース等を入力した場合、バリデーションエラーで弾くのではなく、`onChange` または `onBlur` で **`String.normalize('NFKC')`** 等を用いて静かに半角に自動変換してください。ユーザーの入力負担を最小化する「寛容な入力」が原則です。

### 15.4. The i18n Readiness Protocol（国際化準備基準）
-   **Context**: 現在は単一言語でも、将来の多言語展開に備えて翻訳可能なアーキテクチャを維持することが重要です。
-   **Design Principles**:
    1.  **文字列のリソース集約**: UIテキストを可能な限り定数ファイルまたは辞書オブジェクトに集約し、コンポーネント内のハードコードを最小化してください。
    2.  **Intl API活用**: 日付・通貨・数値のフォーマットには `Intl.DateTimeFormat`, `Intl.NumberFormat` を使用し、ロケール切替可能な状態を維持してください。
    3.  **翻訳キー設計**: 将来のi18n導入に備え、翻訳キーは機能/ページごとにnamespace分割（例: `common.save`, `auth.login`, `error.network`）し、最大3階層とする設計を推奨します。
    4.  **過剰投資の禁止**: 需要が確認される前のi18nライブラリ先行導入や翻訳版UI作成は禁止します。
-   **Trigger Conditions**: 以下のいずれかを満たした場合に多言語対応プロジェクトを正式開始してください：
    -   海外からのアクセスが全体の **10%以上**
    -   海外パートナーからの提携オファー
    -   ビジネス戦略としての海外展開決定

### 15.5. The Error Message Catalog Protocol（エラーメッセージカタログ管理）
-   **Law**: エラーメッセージを各コンポーネントやアクション内でアドホックに記述することを禁止します。
-   **SSOT**: エラーメッセージは定数ファイル（例: `error-messages.ts`）に一元管理（Single Source of Truth）し、カテゴリ別にネスト構造で管理してください。
-   **Quality Standard**:
    | 要素 | 基準 |
    |:----|:-----|
    | **語調** | ターゲットロケールの標準的な丁寧表現で統一 |
    | **技術用語** | 一切露出させない（`UUID`, `500`, `null` 等は禁止） |
    | **未翻訳文字列** | 一切不可（§15.1 Localization Completeness参照） |
    | **次のアクション** | 可能な限り解決策を提示 |
-   **Fallback**: カタログに該当エラーがない場合は汎用フォールバックメッセージを表示してください。

### 15.6. The Accessible Native Language Label Protocol（アクセシビリティラベル母国語化）
-   **Law**: `aria-label` はスクリーンリーダーが読み上げるテキストであり、**ユーザーの耳に届く情報**です。開発者向け属性ではありません。
-   **Mandate**: ユーザー向けUI要素の `aria-label` は、原則として**ターゲットロケールの言語**で記述してください。
-   **Exception**: ブランド名やカタカナ化が自然な技術用語（PDF等）は混在を許容します。
-   **Cross-Reference**: §6 (Accessibility & Inclusivity) の aria-label 関連ルール

---

## 16. モーション・トークン・アーキテクチャ (Motion Token Architecture)

### 16.1. モーション・デザイン・トークン義務 (Motion Design Token Mandate)
-   **Law**: モーション設計はDesign Tokenとして構造化しなければなりません。以下のトークンカテゴリを定義してください。
-   **Duration**:
    -   `motion.duration.instant: 100ms`
    -   `motion.duration.fast: 150ms`
    -   `motion.duration.normal: 250ms`
    -   `motion.duration.slow: 400ms`
    -   `motion.duration.complex: 600ms`
-   **Easing**:
    -   `motion.easing.standard: cubic-bezier(0.4, 0, 0.2, 1)`
    -   `motion.easing.decelerate: cubic-bezier(0, 0, 0.2, 1)`
    -   `motion.easing.accelerate: cubic-bezier(0.4, 0, 1, 1)`
    -   `motion.easing.spring: cubic-bezier(0.175, 0.885, 0.32, 1.275)`
-   **Properties**: `motion.property.enter`, `motion.property.exit`, `motion.property.hover`, `motion.property.expand`
-   **クロスプラットフォーム一貫性**: トークンを通じてWeb / iOS / Android / Flutterで同一のモーション体験を保証します。

### 16.2. prefers-reduced-motion 準拠
-   **Law**: 前庭障害や高いモーション感度を持つユーザーへの配慮は**法的義務**です（EAA/WCAG 2.2 2.3.3）。
-   **Action**:
    1. すべてのアニメーションに `prefers-reduced-motion: reduce` メディアクエリで代替挙動を定義してください。
    2. Reduced Motionモードでは即時遷移（`duration: 0ms`）またはクロスフェード（`opacity` のみ）に切り替えます。
    3. **Essential Motion例外**: コンテンツ理解に不可欠なアニメーション（プログレスバー等）は完全無効化ではなく減速にとどめてください。

---

## 17. パフォーマンスUX (Performance UX)

### 17.1. 知覚パフォーマンス (Perceived Performance)
-   **Law**: 「ユーザーが感じる速さ」は実際の速度よりも重要です。
-   **Skeleton > Spinner**: ローディング中はスピナーよりSkeletonを使用してコンテンツの形状をプレビューします。
-   **Optimistic UI**: 軽量アクションではサーバー応答前にUIを更新します。
-   **即時フィードバック**: ボタン押下時は100ms以内に視覚的フィードバックを保証します。

### 17.2. Core Web Vitals (CWV) 意識
-   **LCP** (Largest Contentful Paint): 最大のファーストビュー要素を**2.5秒以内**に表示。
    -   **設計アクション**: ヒーロー画像を `<link rel="preload">` で先読みし、WebP / AVIF形式に最適化する。
-   **INP** (Interaction to Next Paint): インタラクションから次の描画まで**200ms以下**。（2024年3月に FID を正式置き換え。）
    -   **200msバジェット内訳**: **入力遅延 ≤ 50ms**（軽量なイベントハンドラ）＋ **処理時間 ≤ 100ms**（レンダリング処理を最小化）＋ **表示遅延 ≤ 50ms**（ペイント最適化）。
    -   **Long Task分割**: 50msを超えるタスクは `setTimeout` / `requestIdleCallback` で分割し、メインスレッドを開放してください。
        ```javascript
        // Long Taskを分割するScheduler APIパターン（Chrome 115+ stable）
        async function processHeavyTask(items) {
          for (const item of items) {
            await scheduler.yield(); // メインスレッドを明け渡す
            processItem(item);
          }
        }
        // フォールバック: setTimeout(0) による分割
        function yieldToMain() {
          return new Promise(resolve => setTimeout(resolve, 0));
        }
        ```
    -   **アニメーション保護**: 「INP改善のためアニメーションを削除する」ことを禁止します。GPUコンポジットレイヤー（`transform`/`opacity`）を活用し、モーションを犠牲にせずメインスレッドを解放してください。
    -   **React 19 Compiler / PPR対応**: React 19 CompilerによるAuto-Memoization、Next.js 15+のPartial Prerendering（PPR）を活用し、インタラクティブ要素のハイドレーション優先度を最適化してください。静的シェルを即時返却し、動的コンテンツをストリームで差し込む設計がINP改善に直結します。
-   **CLS** (Cumulative Layout Shift): レイアウトシフトを**0.1以下**に維持。
    -   **設計アクション**: 画像・動画・広告枠に明示的な `width`/`height` を指定し、`font-display: optional` または `swap` を使用します。
-   **TTFB** (Time to First Byte): サーバー応答時間の目標は**800ms以内**。CDNエッジキャッシュとSSGを優先します。
-   **設計への影響**: 画像/フォントの遅延読み込み、適切なサイジング、`font-display: swap` をデザイン段階から計画してください。

### 17.3. Progressive Enhancement
-   JavaScriptなしでもコア機能が動作する設計を維持してください（実行可能な範囲で）。
-   エンハンスメント（アニメーション、インタラクション）は段階的に追加します。

---

## 18. Spatial Computing & XR UX

### 18.1. 空間デザイン原則 (Spatial Design Principles)
-   **Depth as Hierarchy**: 3D空間では距離が階層ツールとなります。ユーザーに近い要素ほどアクティブ/重要に感じます。
-   **Ergonomic Zones**: インタラクティブ要素は自然な到達範囲内に配置し、ユーザーの疲労を防止します。
-   **Grounding Effect**: UIを物理世界にアンカーし、モーション酔いや認知負荷を軽減します。

### 18.2. マルチモーダル入力デザイン (Multimodal Input Design)
-   **Eye Tracking**: 「視線は新しいホバー」。アイトラッキング + ジェスチャー入力の組み合わせを設計します。
-   **Gesture Input**: 確認アクションにはサブトルなジェスチャー（ピンチ、タップ）を活用します。
-   **Voice Input**: 複雑なコマンドやナビゲーションには音声を活用します。
-   **Input Agnostic**: 入力方法に依存しない設計。視線・手・声・コントローラーは相互交換可能であるべきです。

### 18.3. ボリュメトリック・デザインシステム (Volumetric Design System)
-   フラットなデザインシステムから「空間デザインシステム」への長期的な拡張を計画します。
-   コンポーネントが3D空間でどう振る舞うかを定義します（壁面アンカー vs 空中浮遊、視線反応 vs タッチ反応）。

### 18.4. visionOS / HIG (Apple) 準拠
-   **Windowing & Volumes**: Shared Spaceでのウィンドウベース体験を優先します。
-   **Materials**: Liquid Glass等のシステムマテリアルを使用して環境との調和を維持します。
-   **Spatial Audio**: UIフィードバックとしてのSpatial Audioを計画します。
-   **Comfort & Safety**: ユーザーが没入状態から容易に離脱できることを保証します。

---

## 19. UXリサーチ & 計測 (UX Research & Measurement)

### 19.1. UXリサーチ手法 (UX Research Methods)
-   **定量手法**: A/Bテスト、ファネル分析、ヒートマップ、タスク完了率、エラー率。
-   **定性手法**: ユーザーインタビュー、ユーザビリティテスト（モデレート/アンモデレート）、日記調査、カードソート。
-   **Continuous Discovery**: Teresa TorresのOpportunity Solution Treeを活用した継続的な仮説検証。

### 19.2. UX KPIs
-   **NPS (Net Promoter Score)**: ユーザー推奨度測定。
-   **SUS (System Usability Scale)**: 標準化されたユーザビリティスコア。
-   **Task Success Rate**: タスク完了率。
-   **Time on Task**: タスク完了時間。
-   **Error Rate**: エラー発生率。
-   **CSAT (Customer Satisfaction Score)**: 顧客満足度。

### 19.3. デザインレビュープロセス (Design Review Process)
-   **ヒューリスティック評価**: NielsenのUsability Heuristics 10項目に基づく定期的な専門家レビュー。
-   **アクセシビリティ監査**: §6のCI Gate に加え、四半期ごとの手動A11y監査を義務付けます。
-   **競合分析**: 四半期ごとの競合プロダクトのUX分析。

### 19.4. AI拡張UXリサーチ (AI-Augmented UX Research)
-   **AI支援定性分析 (AI-Assisted Qualitative Analysis)**:
    -   **インタビュー書き起こし**: AI要約ツール（例: Otter.ai, Dovetail, Grain）を活用し、ユーザーインタビューの書き起こしとテーマ抽出を自動化してください。ただし**インサイトの検証は必ず人間が実施**してください。
    -   **パターン検出**: 大量の定性データ（NPSフリーテキスト、アプリレビュー等）へのAIベースの感情分析・テーマ分類を適用し、優先課題の発見を加速してください。
-   **合成ユーザビリティテスト (Synthetic Usability Testing)**:
    -   **Law**: AIシミュレーションベースの合成ユーザーテストは「補助ツール」であり、実ユーザーテストを**代替してはならない**。
    -   **許可される使途**: 実ユーザーテスト前のプレスクリーニングとして、プロトタイプの大まかな問題発見にのみ使用可能。
-   **行動分析の倫理 (Behavioral Analytics Ethics)**:
    -   AIベースのユーザー行動予測・セグメンテーションは、プライバシーポリシーで開示し、オプトアウト可能な設計を義務付けます（§7 Ethical UX準拠）。
-   **UXデータ品質ゲート (UX Data Quality Gate)**:
    -   A/Bテストは最低 **p<0.05 の統計的有意水準** を達成するのに十分なサンプルサイズで実施してください。少数サンプルによる意思決定は禁止です。
    -   **ノベルティ効果対策**: 「ノベルティ効果」のバイアスを排除するため、A/Bテストは最低**2週間**実施してください。

---

## 20. 成熟度モデル & アンチパターン (Maturity Model & Anti-Patterns)

### 20.1. UXデザイン成熟度モデル（5段階）

| レベル | 名称 | 特徴 |
|--------|------|------|
| L1 | Ad-hoc | デザインシステムなし。個人の判断でUI作成。一貫性ゼロ。 |
| L2 | Emerging | 基本的なカラーパレットとタイポグラフィが定義済み。一部コンポーネント再利用。 |
| L3 | Structured | Design Token定義済み。Figma-Code同期パイプライン稼働。WCAG AA準拠。A11y CIゲート。 |
| L4 | Integrated | W3C DTCG準拠トークン。Motion Token Architecture。Agentic AI UX実装。継続的UXリサーチ。 |
| L5 | Optimized | 全プラットフォームで一貫したデザイン体験。Spatial Computing対応。データ駆動UX最適化。Design System as a Product。 |

### 20.2. アンチパターン・カタログ（50選）

| # | アンチパターン | 影響 |
|---|-------------|------|
| 1 | ハードコードされた色 | テーマ切替不可。ダークモード対応困難。 |
| 2 | Div地獄 | A11y破壊。スクリーンリーダー使用不可。 |
| 3 | Z-indexマジックナンバー | レイヤー競合。UI要素の不可視。 |
| 4 | スピナー依存 | CLS悪化。体感速度低下。 |
| 5 | 色のみの情報伝達 | 色覚多様性ユーザーの情報喪失。法的リスク。 |
| 6 | ネイティブdate/time入力 | クロスブラウザ不整合。デザイン一貫性破壊。 |
| 7 | ラベルなし入力 | A11yバグ。スクリーンリーダー使用不可。 |
| 8 | 二重スクロール | モバイルUX破壊。コンテンツ到達不能。 |
| 9 | `alt`属性欠如 | A11y法的瑕疵。SEOペナルティ。 |
| 10 | UI上の技術用語 | ユーザー離脱。サポートコスト増大。 |
| 11 | フォーカスリング除去 | キーボードユーザー操作不能。法的リスク。 |
| 12 | Modal Escape未対応 | A11yバグ。ユーザー閉じ込め。 |
| 13 | Placeholder-onlyラベル | 入力時の目的喪失。A11y違反。 |
| 14 | 行き止まりエラー画面 | 100%離脱。信頼破壊。 |
| 15 | ダークパターン使用 | 法的リスク（FTC/DSA/CPRA罰金）。ブランド毀損。 |
| 16 | 固定フォントサイズ(px) | ユーザー設定無視。A11y違反。 |
| 17 | 二重送信防止なし | データ重複。Race Condition。 |
| 18 | DnDクリッピング | ドラッグ要素不可視。操作不能。 |
| 19 | カスタムカルーセル | タッチ問題。A11y非準拠。 |
| 20 | 場当たりアニメーション | 一貫性なし。パフォーマンス低下。prefers-reduced-motion無視。 |
| 21 | Headless UI違反 | コンポーネント再利用不可。プラットフォーム移植困難。 |
| 22 | レスポンシブ未検証 | モバイル/タブレットでのUI崩壊。 |
| 23 | エラーメッセージ散在 | 翻訳漏れ。トーン不統一。保守困難。 |
| 24 | IME非対応検索 | CJK言語ユーザーの検索失敗。 |
| 25 | 200%ズームテスト未実施 | コンテンツ切れ。A11y違反。 |
| 26 | 非対称同意UX | 規制違反（CPRA/DSA）。罰金リスク。 |
| 27 | prefers-reduced-motion無視 | 前庭障害ユーザーの健康被害。EAA違反。 |
| 28 | 不透明なAI出力 | ユーザー不信。EU AI Act違反リスク。 |
| 29 | スキーマなし設計 | 実装時の破綻確定。手戻りコスト増大。 |
| 30 | Design Tokenなし | テーマ切替不可。マルチプラットフォーム展開阻害。 |
| 31 | AI生成UIの無検証リリース | 壊れたアクセシビリティ・不整合デザインの流入。 |
| 32 | データ可視化の色のみ区分 | 色覚多様性ユーザーの情報喪失。法的リスク。 |
| 33 | Novelty Effectを無視したA/Bテスト終了 | 誤った意思決定。ROI算出ミス。 |
| 34 | デザインシステムの未バージョン管理 | 破壊的変更の無管理流入。レグレッション多発。 |
| 35 | 高ビットレート依存エフェクト | 省電力モード/低速回線での体験破綻。Green UX違反。 |
| 36 | ADHD/認知配慮なし設計 | 認知過負荷。タスク完了率低下。インクルージョン違反。 |
| 37 | 自動通知・プッシュ濫用 | ユーザーバーンアウト。アプリ削除リスク増大。 |
| 38 | スクリーンタイム操作設計 | 依存誘導。規制リスク（DSA/英国オンライン安全法）。ブランド毀損。 |
| 39 | VUI/音声UIのフォールバックなし | 音声認識失敗時のデッドエンド。A11y違反。 |
| 40 | パーソナライゼーションの透明性欠如 | ユーザー不信。フィルターバブル。EU AI Act違反リスク。 |
| 41 | トークンScopingなし（グローバル汚染） | テーマ衝突。コンポーネント隔離不可。大規模運用崩壊。 |
| 42 | オフライン時の無告知エラー | データ損失。ユーザーフラストレーション。離脱率増大。 |
| 43 | 音声UIのプライバシー表示なし | 常時リスニング疑惑。規制リスク（GDPR/CCPA）。 |
| 44 | パーソナライゼーションのオプトアウト非提供 | 規制違反（GDPR Art.21/DSA）。ユーザー信頼喪失。 |
| 45 | Service Worker未更新による古UI配信 | キャッシュ汚染。本番バグ想定外長期化。 |
| 46 | 音声コマンドのジェンダー・文化バイアス | 特定ユーザー層での認識率低下。インクルージョン違反。 |
| 47 | パスキー/生体認証UIの欠如 | 旧来パスワード強制継続。フィッシングリスク継続。WCAG 3.3.8違反。 |
| 48 | AI/ユーザー生成コンテンツの信頼表示欠如 | EU DSA Art.16 違反リスク。偽情報拡散。ブランド毀損。 |
| 49 | リアルタイム協働UXのConflict表示なし | データ上書き・損失。ユーザー間の不信。 |
| 50 | デザインシステムのFigma-Code同期自動化なし | Token Driftの常態化。デザインと実装の乖離による品質劣化。 |

---

## 21. デザインシステム・ガバナンス (Design System Governance)

### 21.1. Design System as a Product（DSaaP）
-   **戦略的位置付け**: デザインシステムは「ライブラリ」ではなく**製品（Product）**として運用します。専任のPM/DXエンジニアを配置し、ロードマップ・バックログ・リリースサイクルを管理してください。
-   **SLA定義**: デザインシステムへのバグ報告には対応SLAを設定してください（例: Critical=24h, Major=1week, Minor=1month）。
-   **内部顧客**: プロダクトチームはデザインシステムの「顧客」です。利用者のフィードバックを定期的に収集し（例: 四半期ごとのサーベイ）、投資対効果を可視化してください。

### 21.2. Contribution Model（コントリビューションモデル）
-   **Closed Model（閉鎖型）**: コアチームのみが変更を加えられる。品質は高いが速度が遅い。小規模チーム向き。
-   **Federated Model（連邦型）**: 明確なContribution GuidelinesのもとでプロダクトチームがPRを提出可能。品質ゲート（レビュー・CI）を必須化する。**推奨モデル**。
-   **Open Model（開放型）**: 大規模組織向き。専任のDesign System Teamが「門番」として最終承認権を持つ。
-   **Governance Gate（品質ゲート）**: いずれのモデルでも、以下のゲートを通過したコンポーネントのみリリースを許可してください。
    1. Figmaのデザインレビュー承認
    2. アクセシビリティ（WCAG AA）合格
    3. Jest/Storybookユニットテスト通過（カバレッジ80%以上）
    4. クロスブラウザ・クロスデバイス検証完了

### 21.3. バージョニング & 廃止管理（Versioning & Deprecation）
-   **SemVer準拠**: コンポーネントライブラリは `MAJOR.MINOR.PATCH` のSemantic Version管理を義務付けます。
    -   **MAJOR**: 破壊的変更（APIシグネチャ変更、コンポーネント削除）
    -   **MINOR**: 後方互換の機能追加
    -   **PATCH**: バグ修正
-   **廃止プロセス（Deprecation Protocol）**:
    1. コンポーネントに `@deprecated` タグと後継コンポーネントへのマイグレーションガイドを付与
    2. 最低**2 MINORバージョン**（または3ヶ月）の非推奨期間を設ける
    3. 利用チームへの事前通知（Deprecation Notice）を必須とする
    4. 廃止後はスタブを残さず削除し、バンドルサイズを最適化する
-   **Breaking Change Policy**: MAJORバージョンアップ時はマイグレーションスクリプト（codemods）の提供を推奨します。

### 21.4. デザインシステム計測 (Design System Metrics)
-   **採用率（Adoption Rate）**: 全UIコンポーネントの何%がデザインシステムのコンポーネントで構成されているかを計測。目標: **85%以上**。
-   **コンポーネント健全性スコア（Component Health Score）**: テストカバレッジ×アクセシビリティスコア×Figma同期率の複合指標。
-   **Time-to-Ship削減**: デザインシステム採用前後での新機能の実装工数を比較し、ROIを可視化してください。

---

## 22. データ可視化 & 情報アーキテクチャ (Data Visualization & IA)

### 22.1. データ可視化設計原則 (Data Visualization Principles)
-   **目的優先（Purpose First）**: グラフの種類は「見た目の美しさ」ではなく「伝えたいメッセージ」から選択してください。
    | 目的 | 推奨チャートタイプ |
    |------|----------------|
    | 変化（時系列） | 折れ線グラフ、エリアチャート |
    | 比較 | 棒グラフ（水平/垂直）、グループ棒グラフ |
    | 割合・構成 | 積み上げ棒グラフ（円グラフより推奨）|
    | 相関 | 散布図、バブルチャート |
    | 分布 | ヒストグラム、箱ひげ図、ヴァイオリン図 |
    | 地理的データ | コロプレスマップ、プロポーショナルシンボルマップ |
-   **データインク比（Data-Ink Ratio）**: Tufteの原則に従い、不必要な装飾（3D効果、過剰なグリッド線、グラデーション）を排除し、データ自体にフォーカスを当ててください。
-   **ゼロライン遵守**: 棒グラフのY軸は必ず0から開始してください。切り捨ては誇張を生み、情報の歪曲です。

### 22.2. チャートアクセシビリティ（Chart Accessibility）
-   **色のみ禁止**: チャートのデータ系列は、色に加えてパターン（ハッチング）、マーカー形状（●■▲）、ラベルを組み合わせて区別してください。
-   **テキスト代替**: すべてのチャートに `aria-label` または `<title>`/`<desc>` タグでデータの要約を提供してください。
    ```html
    <!-- SVGチャートの例 -->
    <svg role="img" aria-labelledby="chart-title chart-desc">
      <title id="chart-title">月次売上推移（2025年）</title>
      <desc id="chart-desc">2025年1月から12月の月次売上。最高は8月の120万円、最低は2月の45万円。</desc>
    </svg>
    ```
-   **データテーブル提供**: 複雑なチャートには、同等データをHTMLテーブルで提供するか、ダウンロード可能なCSVを用意してください。
-   **インタラクティブ対応**: キーボードでデータポイントをナビゲート可能にし（矢印キー）、選択時の値を `aria-live` で読み上げてください。

### 22.3. 情報アーキテクチャ（Information Architecture）
-   **IA設計の5原則（Rosenfeld/Morville）**:
    1. **組織化**: コンテンツを論理的グループに分類する（ユーザーのメンタルモデルに準拠）
    2. **ラベリング**: 一貫した用語体系（§10 Zero Jargon準拠）
    3. **ナビゲーション**: 現在地・行き先・戻り先を常に明確に
    4. **検索**: ファセット検索・オートコンプリートを最優先
    5. **発見**: プログレッシブ・ディスクロージャーで高度機能への誘導
-   **Card Sorting（カードソーティング）**: 新しいナビゲーション構造の設計時は、ユーザーによるオープン/クローズドカードソーティングを実施し、ユーザーのメンタルモデルを検証してください。
-   **Tree Testing（ツリーテスト）**: ナビゲーション最終案で、ユーザーが目的のコンテンツに到達できる率（Task Success Rate）を計測してください。目標: **80%以上**。

### 22.4. ダッシュボード設計基準 (Dashboard Design Standards)
-   **情報密度階層**: ダッシュボードは3層で設計してください。
    1. **Layer 1 (Summary / KPI)**: 最重要指標を最上部に。一目でビジネス状態を把握できること。
    2. **Layer 2 (Analysis / Trend)**: 詳細グラフと期間比較。
    3. **Layer 3 (Detail / Drill-down)**: 個別レコードとRaw Data。
-   **認知負荷の制限**: 1ダッシュボード画面に表示するチャート数は**7±2個以内**を推奨します（Miller's Law）。
-   **リアルタイム更新**: データが自動更新される場合、更新インジケーター（「最終更新: XX秒前」）を表示し、ユーザーがデータの鮮度を把握できるようにしてください。

---

## 23. AI生成UIガバナンス (AI-Generated UI Governance)

### 23.1. Vibe Coding時代の品質ゲート (Quality Gate for AI-Generated Code)
-   **背景**: LLMやAIコーディングアシスタント（GitHub Copilot, Cursor, Gemini等）によるUI生成が普及した結果、見た目は動作するが**アクセシビリティ・セキュリティ・設計整合性**を欠いたコードがコードベースに混入するリスクが急増しています。
-   **AI生成UIの必須レビュー項目**:
    1. **A11y**: axe-core / Lighthouse でAAレベル違反がないか
    2. **デザイントークン整合**: ハードコードされた色値・スペーシング値が混入していないか
    3. **コンポーネント重複**: 既存のデザインシステムコンポーネントで代替可能でないか
    4. **TypeScript型安全**: `any` / `unknown` の無制限使用がないか
    5. **セキュリティ**: innerHTML、dangerouslySetInnerHTML の不正使用がないか
-   **Self-Serve Checklist**: AI生成のUIコードをPRに含める際は、上記5項目を起票者自身が確認し、PR説明にチェック結果を記載することを義務付けます。

### 23.2. AI生成コンテンツの視覚的区別 (AI Content Disclosure)
-   **法的背景**: EU AI Act（2024年施行）は、AIが生成したテキスト・画像・音声・動画の開示を義務付けています（第50条）。
-   **開示UI標準**:
    -   AI生成コンテンツには専用バッジ（例: ✨ AI生成）を表示してください。
    -   **グローエフェクト**: 微細なグラデーション背景（例: `linear-gradient(135deg, #667eea22, #764ba222)`）でAIコンテンツを視覚的に区別します。
    -   **編集可能であることの明示**: ユーザーが生成内容を編集・削除できる場合は、そのアクションを明確なUIで提供してください。
-   **人間監修ラベル**: 「AI生成後、専門家がレビュー済み」等のラベルは信頼性向上に有効です。ただし虚偽の「人間監修」ラベルは厳禁です。

### 23.3. プロンプトインジェクション対策 (Prompt Injection Defense in UI)
-   **リスク**: ユーザー入力がAIへのプロンプトに直接連結される場合、悪意あるユーザーがプロンプトを操作し、意図しない動作を引き起こす可能性があります。
-   **UI層の対策**:
    -   入力フィールドに文字数制限（`maxLength`）と文字種制限を実装してください。
    -   ユーザー入力と内部プロンプトのコンテキストを明確に分離し、UI上で混同を防いでください。
    -   不審な入力（過剰な特殊文字、長大なテキスト等）にはUI層でのバリデーションを実施してください。

---

## 24. クロスプラットフォーム・トークン連携 (Cross-Platform Token Federation)

### 24.1. Universal Token Pipeline（ユニバーサルトークンパイプライン）
-   **目標**: 1つのデザイントークン定義（W3C DTCG形式）から、**Web・iOS・Android・Flutter・Electron**すべてのプラットフォームのコードを自動生成し、デザインの一貫性を保証します。
-   **推奨パイプライン**:
    ```
    Figma Variables
        ↓（Figma Variables Plugin または手動エクスポート）
    tokens.json（W3C DTCG形式 / Style Dictionary互換）
        ↓（Style Dictionary / Theo / Token Transformer）
    ├── CSS Custom Properties（Web）
    ├── Swift Package（iOS: UIColor, Font, Spacing）
    ├── Kotlin Object（Android: Color, Dimension）
    └── Dart Package（Flutter: ThemeData）
    ```
-   **CI自動化**: トークン定義ファイルのPRマージ時に、上記の全プラットフォームコードを自動生成・コミットするCIパイプラインを構築してください。

### 24.2. Platform-Specific Token Overrides（プラットフォーム固有上書き）
-   **Tier 1 (Global)**: 全プラットフォーム共通の基本値（色、スペーシング基準値）
-   **Tier 2 (Platform)**: プラットフォーム固有の上書き（例: iOSのDynamic Type、AndroidのMaterial Dynamic Color）
-   **Tier 3 (Component)**: コンポーネントレベルの専用トークン
-   **禁止事項**: Tier 1の定義をプラットフォームコードで直接上書きすることは禁止します。必ずTier 2のPlatform Overrideファイルを作成し、変更の追跡可能性を維持してください。

### 24.3. Token Drift 検出（トークン乖離の自動検出）
-   **Token Drift**: コードと（Figma等の）デザイン定義が乖離した状態を指します。デザインシステムの品質劣化の主要因です。
-   **自動検出**: PRレビュー時に、実装コードのトークン値とFigma/tokens.jsonの定義を自動比較し、乖離を検出・報告するCIスクリプトの導入を推奨します。
-   **週次同期**: 週1回のToken Drift Reportを生成し、デザインとエンジニアリングの両チームがレビューするサイクルを設けてください。

---

## 25. サステナビリティ & グリーンUX (Sustainability & Green UX)

### 25.1. デジタルカーボンフットプリント (Digital Carbon Footprint)
-   **背景**: 世界のICT産業はCO2排出量の約4%を占め、航空業界と同等です。UIデザインの選択が実際のエネルギー消費に影響します。
-   **計測ツール**: Website Carbon Calculator、Ecograder、Sustainablewebを活用し、ページのCO2排出量を定量的に把握してください。
-   **目標**: 新規ページのCO2排出量は **0.5g CO2/ページビュー以下** を目標基準とします（グローバル中央値: 約0.8g）。

### 25.2. エコフレンドリーUI設計（Eco-Friendly UI Design）
-   **ダークモードの消費電力**: OLEDディスプレイにおいて、真黒（#000000）背景は最大60%の省電力効果があります。ダークモードはUX施策と同時にGreen施策でもあります。
    -   **Pure Black Option**: ダークモードのバリエーションとして `#000000` ベースの「Pure Black」テーマオプションの提供を推奨します。
-   **アニメーションの省電力設計**:
    -   `prefers-reduced-motion` 対応は法的義務（§16.2）であると同時に省電力対応でもあります。
    -   不必要な無限ループアニメーション（ローディング以外）を廃止してください。
-   **画像・動画最適化**:
    -   AVIFを最優先フォーマットとし（WebP比30%削減）、フォールバックでWebPを使用してください。
    -   動画は自動再生禁止（§6 Auto-Play Ban準拠）。ユーザー起動型のみ許可。
    -   `loading="lazy"` によるオフスクリーン画像の遅延読み込みを全画像で標準化してください。
-   **フォントの軽量化**:
    -   Webフォントは使用する文字範囲のみ含む `unicode-range` でサブセット化してください。
    -   可能な限りシステムフォントスタック（System Font Stack）を優先してください。

### 25.3. Carbon-Aware UX（カーボンアウェアUX）
-   **概念**: 電力グリッドのカーボン強度（g CO2eq/kWh）がリアルタイムで変動することを利用し、再生可能エネルギーが多い時間帯に重処理をスケジュールする設計アプローチです。
-   **適用場面**:
    -   大規模バッチ処理（AI学習、動画エンコード等）を低カーボン時間帯にスケジュールするUIを提供してください。
    -   「グリーンモード」として、カーボン強度が低い時間帯には高品質レンダリングを、高い時間帯にはデータ圧縮モードに自動切替する機能を検討してください。
-   **API**: Electricity Maps API、WattTime API等を活用し、カーボン強度データを取得してください。

### 25.4. Sustainable Design Ops（持続可能なDesign Ops）
-   **廃棄コンポーネントの削除**: 使用されていない非推奨コンポーネントはバンドルから除外し、ユーザーのダウンロードサイズを削減してください。
-   **Third-Party Script Audit**: サードパーティスクリプト（アナリティクス、広告、チャットウィジェット等）は定期的に監査し、不要なものは削除してください。各スクリプトのCO2コストと業務価値を天秤にかけた判断を行ってください。
-   **ページ重量バジェット（Performance Budget）**:
    | リソース種別 | 予算上限 |
    |------------|--------|
    | HTML | 50KB |
    | CSS（圧縮後） | 100KB |
    | JS（圧縮後） | 300KB |
    | 画像（総計） | 500KB |
    | Webフォント | 100KB |
    - 予算超過はCI/CDビルドゲートで検出・警告してください（Bundlesize, Lighthouse CI等）。

---

## 26. ニューロダイバーシティ & インクルーシブUX (Neurodiversity & Inclusive UX)

### 26.1. ニューロダイバーシティ設計原則
-   **背景**: ADHD、ASD（自閉スペクトラム症）、ディスレクシア（読み書き障害）、感覚処理障害などのニューロダイバーシティを持つユーザーは、人口の約15〜20%を占めると推計されています（WHO）。これらのユーザーへの配慮はアクセシビリティの義務であり、同時に全ユーザーの体験を改善します（**障害の社会モデル**）。
-   **ADHD-Friendly Design（注意欠如多動症配慮設計）**:
    -   **認知負荷削減**: 1画面あたりの情報量を最小化し、プログレッシブ・ディスクロージャーで段階的に提示してください。
    -   **視覚的焦点ガイド**: 重要なCTAやフォームに視覚的「焦点強調」（境界強調、カラーハイライト）を付与し、注意の誘導を補助してください。
    -   **作業の分割**: 長いフォームやタスクは複数ステップに分割し、各ステップの完了を明示的にフィードバックしてください。
    -   **自動保存の強制**: 入力途中での離脱を考慮し、§14.5 Auto-Save Protocolを遵守してください。
    -   **通知の最小化**: 作業中の割り込み通知は最小限にしてください（通知設定の粒度別制御を提供）。
-   **ASD-Friendly Design（自閉スペクトラム症配慮設計）**:
    -   **一貫性の絶対遵守**: 画面ごとのUIパターン変動はASDユーザーに強いストレスを与えます。§20.0 The Consistency Mandateを最大限に徹底してください。
    -   **曖昧な表現の排除**: アイコンのみのボタン、文脈依存の省略語、暗黙的な操作手順を排除し、ラベルと明示的な説明を常に提供してください。
    -   **感覚刺激の制御**: 自動再生動画、点滅する要素、強烈なパーティクルエフェクトを排除してください。ユーザーが感覚的な刺激量を調整できる設定を提供することを推奨します。
-   **Dyslexia-Friendly Design（ディスレクシア配慮設計）**:
    -   **フォント選択**: ディスレクシアフレンドリーなフォント（OpenDyslexicなど）への切替オプション、または可読性が高い一般フォント（Inter, Atkinson Hyperlegible等）をデフォルトとして採用してください。
    -   **文字間隔と行間**: `letter-spacing: 0.05em` 以上、`line-height: 1.6` 以上を本文のベースラインとしてください（§1.1 Typography Localization Protocol準拠）。
    -   **テキストの左揃え**: ジャスティファイ（両端揃え）は単語間スペースが不均一になりディスレクシアユーザーの読み取りを困難にします。**テキストは必ず左揃え（`text-left`）**としてください。
    -   **コントラストの選択肢**: 純白背景（#FFFFFF）は一部のディスレクシアユーザーにとって眩しすぎます。「ソフトホワイト」（例: `#FAF9F6`）や「ペーパー」テーマを提供することを推奨します。

### 26.2. 認知アクセシビリティ（Cognitive Accessibility）
-   **COGA（Cognitive and Learning Disabilities Accessibility Task Force）準拠**: W3C COGAのガイドライン（WCAG 2.1/2.2に組み込み予定）に従い、以下を実施してください。
    -   **認識可能なパターン**: 業界標準のUIパターン（ハンバーガーメニュー、検索アイコン等）を使用し、認知的馴染みを活用する。
    -   **エラー防止**: フォーム送信前の確認画面、入力制約の事前明示（文字数制限、許可される文字種等）を提供する。
    -   **タイムアウトの警告**: セッションタイムアウト前に少なくとも**20秒前**に警告し、延長オプションを提供する（WCAG 2.2 2.2.6）。
    -   **シンプルなナビゲーション**: ナビゲーション構造は3クリック以内で主要機能に到達できる深さを維持する。
-   **Reading Level**: ユーザー向けUI文言は中学生（日本語: 中学1年相当）が理解できる難易度に抑えてください。Flesch-KincaidやJIS規格での文章難易度確認を推奨します。

### 26.3. Inclusive Language Protocol（インクルーシブ言語基準）
-   **過去の禁止**: 障がいを否定的に表現する旧来の言葉（「ハンディキャップ」「患者扱い」等）を使用しないでください。
-   **Person-First / Identity-First の選択**: 「障がいのある人（Person-First）」か「障がい者（Identity-First）」かはコミュニティの選好に従ってください。どちらかに統一する前にユーザーリサーチを実施することを推奨します。
-   **ジェンダーニュートラル言語**: 特定の性別を前提とした表現（「彼は」「男性ユーザー」等）を避け、「ユーザーは」「担当者は」等の性別中立表現を使用してください。
-   **文化的配慮**: 色・記号・イラストの文化的意味合いは地域によって異なります（例: 白は日本では喪を意味する場合がある）。グローバル展開時はアイコン・カラー・イラストの文化検証を実施してください。

---

## 27. デジタルウェルビーイング & エシカルデジタルデザイン (Digital Wellbeing & Ethical Digital Design)

### 27.1. デジタルウェルビーイング設計原則
-   **背景**: 2025年以降、英国オンライン安全法（Online Safety Act）、EU DSA（デジタルサービス法）、米国CHILDSプロポーザル等によって、特に未成年者への「設計による操作（Design-based Manipulation）」が規制対象となっています。ウェルビーイング設計は倫理的義務であると同時に法的リスク管理です。
-   **Screen Time Respect Protocol（スクリーンタイム尊重）**:
    -   **自然な終了点の設計**: コンテンツ終端（記事の末尾、動画の終わり）に明示的な「終了点」を設計してください。無限スクロール・自動再生の連鎖は、設計上の依存誘導と見なされる可能性があります。
    -   **休憩リマインダー**: 長時間利用が想定されるアプリ（ゲーム、SNS、学習アプリ等）は、一定時間（例: 60分）後に任意の休憩リマインダーを表示する機能の提供を推奨します。設定でOFF可能にしてください。
    -   **利用時間の可視化**: ユーザーが自分のアプリ利用時間を把握・制御できるダッシュボードの提供を推奨します。
-   **Anti-Addiction Pattern Checklist（依存誘導防止）**:
    -   **禁止**: 無制限の無限スクロール（終端なし）
    -   **禁止**: ソーシャル比較を過度に促す通知（「○○さんがあなたより多く達成しました」）
    -   **禁止**: バッジ・ストリーク（連続記録）を失うことへの恐怖を煽るUX（Loss Aversion Exploitation）
    -   **禁止**: 未成年ユーザーへのターゲット型広告・プロファイリング
    -   **推奨**: 「今日はここで終わりにしますか？」等の穏やかな離脱誘導

### 27.2. 脆弱なユーザーへの配慮（Vulnerable User Protection）
-   **年齢確認 & 年齢適切なコンテンツ**: 年齢制限コンテンツ（アルコール、賭博、成人向け等）には適切な年齢確認UIを実装し、未成年者へのアクセスを防いでください。
-   **メンタルヘルス配慮**: 自傷・自殺に関連するトピックを扱うコンテンツには、セーフメッセージングガイドライン（WHOガイドライン）に従い、危機サポートリソース（緊急連絡先等）を常に提供してください。
-   **ギャンブル類似UX禁止**: ランダム報酬メカニズム（ガチャ、ルートボックス等）を導入する場合は：
    1. 確率を明示する（多くの規制で義務化）
    2. 月次支出上限（Spending Cap）設定機能を提供する
    3. 未成年ユーザーへの提供を禁止する

### 27.3. プライバシー・バイ・デザイン（Privacy by Design in UX）
-   **データ最小化のUX表現**: ユーザーに収集するデータの最小限化を説明する「なぜこのデータが必要か」インラインテキストを収集ポイントに配置してください。
-   **同意疲れ防止（Consent Fatigue Prevention）**: 同意バナーやポップアップを乱発しないでください。必須の同意のみ求め、任意の項目は設定画面に集約することを推奨します。
-   **データ削除のUX**: アカウント削除・データ削除フローは：
    1. 見つけやすい場所（設定 > アカウント等）に配置する
    2. 2クリック以内で開始できるようにする
    3. 削除完了まで30日以内（GDPR準拠）の進捗をユーザーが追跡できるようにする
-   **クロスリファレンス**: §7 (User Sovereignty & Ethical UX)、`security/100_data_governance.md`

### 27.4. エシカルAI & アルゴリズム透明性（Ethical AI & Algorithmic Transparency）
-   **アルゴリズム推薦の透明化**: レコメンデーション（コンテンツ推薦、検索順位等）の根拠をユーザーが理解・制御できるUI（「なぜこれが表示されるか」「表示頻度を下げる」）を提供してください。
-   **バイアス開示**: AIが人の判断に影響する場面（採用スクリーニング、信用スコア等）では、AIシステムの訓練データやモデルのバイアスリスクをユーザーに開示する義務があります（EU AI Act Art. 13準拠）。
-   **Human Override（人間による上書き権）**: 重大な意思決定（保険拒否、ローン審査、採用不合格等）においては、AIによる自動決定に対してユーザーが人間によるレビューを要求できる権利（EU AI Act Art. 14準拠）をUIで明示してください。

---

## 28. Voice & Conversational UX

### 28.1. VUI設計原則（Voice UI Design Principles）
-   **背景**: スマートスピーカー、音声アシスタント（Siri, Google Assistant, Alexa）、車載UI、XRヘッドセット、そしてLLMベースの会話AIの急拡大により、**音声がプライマリUIとなる文脈が主流化**しています。2026年以降、VUI設計は「追加機能」ではなくコア設計領域です。
-   **Voice-First vs. Voice-Enhanced**:
    -   **Voice-First**: 音声が唯一のインターフェース（スマートスピーカー、車載）。視覚UIなし。
    -   **Voice-Enhanced**: 既存GUIに音声を追加する形式（モバイルアプリの音声コマンド、Webサイトの読み上げ）。§6の視覚アクセシビリティと共存させてください。
-   **3段階フィードバック原則（VUI Feedback Triad）**:
    1. **受領確認（Acknowledgment）**: ユーザーの音声入力を認識したことを即座に伝える（例: 「わかりました」「少々お待ちください」）。
    2. **進行状況（Progress）**: 処理が長引く場合は定期的に状況を伝える（例: 「検索中です...」）。
    3. **結果（Result）**: 簡潔かつアクション可能な形で結果を返す。
-   **会話設計の7原則**:
    1. **簡潔性**: 音声応答は視覚応答より短く。1つの応答で最大3つの選択肢。
    2. **文脈保持**: 前の発言の文脈を記憶し、同じ情報を繰り返し求めない。
    3. **自然言語の許容**: ユーザーの言葉の言い回しのゆらぎを許容する（「キャンセル」「やめる」「止めて」を同義として認識）。
    4. **Graceful Fallback**: 認識失敗時は謝罪→聞き返す→代替手段を提示の3ステップで対処する。
    5. **Initiative Balance**: 全会話をAI主導にせず、ユーザーが主導権を持てる「Open Prompt」を設計する。
    6. **エラー防止**: 重要なアクション（削除、購入）は音声確認（「本当に削除してよいですか？」）を必須とする。
    7. **Exit path**: 任意のタイミングで会話を終了できるコマンド（「キャンセル」「終了」「ヘルプ」）を常にサポートする。

### 28.2. 音声アクセシビリティ（Voice Accessibility）
-   **WCAG 2.2 + Voice Guidelines**: 音声UIもWCAG 2.2の理解可能性（Understandable）・操作性（Operable）の原則を満たす必要があります。
-   **STT/TTS品質基準**:
    -   **STT（Speech-to-Text）**: ターゲットロケールの訛り・方言・ノイズ環境での認識精度を定期的に計測してください。目標: **主要ユースケースで認識精度95%以上**。
    -   **TTS（Text-to-Speech）**: 自然な抑揚と速度（150〜160 wpm）で読み上げ、固有名詞や略語の発音をカスタマイズできるSSML（Speech Synthesis Markup Language）をサポートしてください。
-   **多言語・多方言対応**: 日本語の場合、関西弁や東北弁のゆらぎを許容するか、または丁寧に標準語での再入力を促す設計を選択してください。硬直した方言非対応は離脱を招きます。
-   **ノイズキャンセリングUX**: 高騒音環境（公共交通機関等）でのVUI利用を考慮し、Push-to-Talk UI（ボタンを押している間のみ録音）をフォールバックとして提供してください。

### 28.3. プライバシーと同意（Voice Privacy & Consent）
-   **常時リスニング禁止のデフォルト**: Wake Word以外での録音は禁止します。デフォルトはPush-to-Talk またはエクスプリシットな起動操作を推奨します。
-   **録音状態の視覚表示**: マイクがアクティブな場合は、視覚インジケーター（赤い点滅、マイクアイコン）を必ず表示してください。ユーザーが「聞かれている」かどうか認識できない設計は厳禁です。
-   **音声データ保持ポリシーの開示**: 音声録音の保持期間・用途・第三者共有について、収集時点でユーザーに平易な言葉で説明してください。GDPR/CCPAへの準拠を確認してください。
-   **データ削除UI**: ユーザーが音声履歴を削除できる明確なUIを設定の目立つ場所に配置してください（§27.3 データ削除UX準拠）。

### 28.4. マルチモーダル統合（Voice + Visual Integration）
-   **Voice + Screen協調設計**: 音声コマンドの結果を視覚UIに反映する際は、音声応答→画面更新の間を100ms以内にしてください（知覚パフォーマンスの維持、§17.1準拠）。
-   **Handoff Protocol**: 音声入力途中でユーザーがタッチ操作に切り替えた場合、入力内容を失わずシームレスに引き続けられる「モダリティハンドオフ」を設計してください。
-   **コンテキスト共有**: 音声で「これを削除して」と言った場合、「これ」が画面上のフォーカス要素を指すことをシステムが正確に理解できるコンテキストリンク機能を実装してください。

---

## 29. アダプティブ & パーソナライゼーションUX (Adaptive & Personalization UX)

### 29.1. パーソナライゼーションの倫理的設計原則
-   **背景**: 2026年以降、AIによる超個別化（Hyper-Personalization）は競合優位性の最前線です。しかし、**フィルターバブル・プライバシー侵害・偏見の強化・依存誘導**のリスクも増大しています。以下の原則はその均衡を保つための設計判断基準です。
-   **倫理的パーソナライゼーション4原則**:
    1. **透明性（Transparency）**: パーソナライゼーションが機能していることをユーザーが認知できる（「あなたの好みに合わせて表示中」等）。
    2. **制御性（Controllability）**: ユーザーがパーソナライゼーションの強度を調節、または完全に無効化できる。
    3. **多様性（Diversity）**: フィルターバブル（同質コンテンツへの閉じ込め）を防ぐため、意図的に多様なコンテンツを含める「Serendipity Injection」を設計に組み込む。
    4. **説明可能性（Explainability）**: 「なぜこれが表示されているか」をユーザーが確認できる機能を提供する（§7 Transparency準拠）。

### 29.2. コンテキスト適応UIパターン（Context-Adaptive UI Patterns）
-   **時間帯適応（Time-of-Day Adaptation）**: ユーザーの利用時間帯に応じてUIを適応させます。
    -   朝: 要約・概要優先のダイジェストビュー
    -   夜: コントラスト低下・暖色系への自動シフト（Blue Light Reduction）
-   **利用頻度適応（Frequency-Based Adaptation）**: 頻繁に使う機能をUI上で優先表示し、稀にしか使わない機能を段階的に簡略化します（Progressive Disclosure適応版）。
-   **デバイス文脈適応（Device Context Adaptation）**: 
    -   モバイル: 片手操作最適化レイアウトに自動切替
    -   デスクトップ: キーボードショートカット・密度の高いプロフェッショナルビューへ拡張
    -   XR/Spatial: UIを空間にアンカー（§18準拠）
-   **接続環境適応（Network-Aware Design）**: 接続品質に応じてはダイナミックに画像・動画品質を下げ、低負荷モードに切り替えるアダプティブサービングを実装してください。
    ```javascript
    // Network Information API（実装参考）
    const connection = navigator.connection;
    if (connection.effectiveType === '2g' || connection.saveData) {
      // 低品質モードに切替: 画像圧縮率上昇、動画無効化
      setQualityMode('low');
    }
    ```

### 29.3. パーソナライゼーションのプライバシー設計
-   **データ最小化の義務**: パーソナライゼーションに必要なデータは最小限です。フルユーザープロファイルを構築する目的で過剰収集することを禁止します。
-   **オンデバイス推論の優先（On-Device Inference First）**: プライバシー保護の観点から、データをサーバーに送らずデバイス上のモデルで推論するアーキテクチャを優先して検討してください（Core ML, TensorFlow Lite等）。
-   **オプトアウトUI義務**: GDPRアート21（異議申し立て権）に基づき、ユーザーがパーソナライゼーション処理に異議を申し立て、中止を要求できるUIを設定画面の目立つ場所に配置してください。
-   **A/Bテストの倫理的境界**: 同一ユーザーグループ内でのパーソナライゼーション実験（A/Bテスト）はIRB（倫理審査）相当の基準で設計し、特に価格差別・脆弱なユーザーへの影響を事前評価してください。

### 29.4. アダプティブデザインの技術ガバナンス
-   **Feature Flag統合**: パーソナライゼーション機能はFeature Flag（LaunchDarkly等）で制御し、問題発生時に即座にグローバルロールバックできる設計を維持してください。
-   **モデルドリフト監視**: パーソナライゼーションモデルの推薦精度は定期的にモニタリングし、精度が閾値（例: CTR低下20%以上）を下回った場合に自動アラートを発火させてください。
-   **グループフェアネス検証**: パーソナライゼーションの結果が特定の人口統計グループ（性別、年齢、民族等）に対して不公平な差異を生んでいないかを四半期ごとに検証してください。

---

## 30. Design Tokens 2.0 / Figma Variables 進化形 (Advanced Token Architecture)

> [!NOTE]
> このセクションは§2（Design Tokens基礎）の上位拡張です。§2の基本原則を前提として、2025年以降のエンタープライズ規模での高度なトークン管理を扱います。

### 30.1. Figma Variables 2.0 & DTCG Modes（スコープとモード）
-   **Scoping（スコープ）**: Figma Variables の「Scope」機能を使い、各トークンが適用可能なプロパティを制限してください。色トークンをスペーシングに誤用するリスクを設計時点で排除します。
    ```
    color-primary: scope=[Fill, Stroke]（NOT spacing, NOT font-size）
    spacing-4: scope=[Gap, Padding, Margin]（NOT color）
    ```
-   **Modes（モード）**: W3C DTCGの「$theme」概念を実装し、単一のトークン定義から複数モードを生成します。
    ```json
    {
      "color-bg-surface": {
        "$type": "color",
        "$value": "oklch(98% 0 0)",
        "$modes": {
          "dark": "oklch(10% 0 0)",
          "high-contrast": "oklch(100% 0 0)",
          "pure-black": "oklch(0% 0 0)"
        }
      }
    }
    ```
-   **Nested Modes（モードの入れ子）**: ブランドモード × テーマモードの組み合わせを管理してください。
    ```
    Brand A / Light → Brand A / Dark
    Brand B / Light → Brand B / Dark
    ```

### 30.2. コンポーネント隔離トークン（Component-Scoped Tokens）
-   **問題**: グローバルトークンのみでは、コンポーネントAのスタイル変更がコンポーネントBに意図せず波及する「グローバル汚染」が発生します。
-   **解決策 — コンポーネントローカルトークン**:
    ```css
    /* コンポーネント固有トークンをCSS変数のネームスペースで隔離 */
    .c-button {
      --c-button-bg: var(--color-primary);
      --c-button-fg: var(--color-on-primary);
      --c-button-radius: var(--radius-md);
      background: var(--c-button-bg);
      color: var(--c-button-fg);
      border-radius: var(--c-button-radius);
    }
    /* コンポーネントのバリアント上書きはローカルトークンのみを変更 */
    .c-button--danger {
      --c-button-bg: var(--color-error);
    }
    ```
-   **命名規則**: コンポーネントローカルトークンは `--c-{component}-{property}` で統一し、グローバルトークン（`--color-*`）と明確に区別してください。

### 30.3. エンタープライズ・マルチブランドトークン管理
-   **ブランド階層設計**:
    ```
    Tier 0: Primitive Tokens（生の値：blue-500, space-4）
    Tier 1: Global Semantic Tokens（color-primary）← ブランド共通
    Tier 2: Brand Tokens（brand-a-color-primary）← ブランド固有上書き
    Tier 3: Component Tokens（button-bg）← コンポーネント固有
    ```
-   **トークンライブラリのNPMパッケージ化**: エンタープライズ規模では、トークン定義をNPMプライベートパッケージとして公開し、全プロダクトが `@company/tokens` をインポートする形で共有してください。バージョン管理でSemVerを適用します（§21.3準拠）。
-   **Token Diff PR Automation**: GitHub Actionsで、`tokens.json` の変更PRに自動でトークン差分レポート（追加・変更・削除のサマリー）をコメントするワークフローを構築してください。

### 30.4. ランタイムトークン注入（Runtime Token Injection）
-   **動的テナント対応**: SaaSやマルチテナントアプリでは、テナントごとのブランドカラーをDBから取得し、CSSカスタムプロパティとして `<style>` タグに動的注入してください。
    ```typescript
    // サーバーサイドでのトークン注入例（Next.js App Router）
    async function RootLayout({ children }) {
      const tenant = await getCurrentTenant();
      const tokens = tenant.brandTokens; // { primaryColor: 'oklch(55% 0.2 250)' }
      return (
        <html>
          <head>
            <style>{`:root { --color-primary: ${tokens.primaryColor}; }`}</style>
          </head>
          <body>{children}</body>
        </html>
      );
    }
    ```
-   **CSP対応**: `<style>` の動的注入はContent Security Policiyのstyle-src違反になる場合があります。Nonceベースのスタイル注入またはCSS Variables via `element.style.setProperty()` を代替として検討してください。

---

## 31. エッジ & オフラインファーストデザイン (Edge & Offline-First Design)

### 31.1. オフラインファースト設計哲学
-   **背景**: 世界の約40億人が低速・不安定なモバイル回線（2G/3G）を使用しています。「常時接続前提」のUIはグローバルプロダクトとして失格です。オフラインファーストは倫理的かつビジネス的な優先事項です。
-   **オフラインファーストの4段階**:
    | レベル | 対応内容 | 目標状態 |
    |--------|----------|----------|
    | L0 | オフライン時の無告知クラッシュ | ❌ 禁止 |
    | L1 | オフライン検知 + ユーザー通知 | ✅ 最低基準 |
    | L2 | キャッシュからの読み取り（読み取り専用オフライン） | ✅ 推奨 |
    | L3 | オフライン書き込み + 接続回復時の自動同期（Background Sync） | ✅ 最高水準 |
-   **設計原則**:
    -   ネットワークは「あれば早い、なくても動く」ものとして設計する。
    -   データ操作はローカルを正とし、サーバーとの同期は非同期で実施する（Offline-first CRDT思想）。
    -   「現在の接続状態」をユーザーが常に認識できる非侵入型UIを提供する。

### 31.2. Service Worker設計ガバナンス
-   **キャッシュ戦略の選択**:
    | 戦略 | 適用シーン | 説明 |
    |------|----------|------|
    | Cache First | 静的アセット（CSS/JS/Font/Icon） | キャッシュ優先。ネットワーク到達不可時のフォールバック。 |
    | Network First | APIレスポンス、動的コンテンツ | ネットワーク優先。失敗時にキャッシュを使用。 |
    | Stale While Revalidate | ニュースフィード、商品一覧 | キャッシュを即時返却しつつバックグラウンドでネットワーク更新。 |
    | Network Only | 支払い・認証・セキュリティ敏感処理 | キャッシュ禁止。常にネットワーク経由。 |
-   **Service Worker更新ガバナンス**:
    -   **更新検出UI**: 新バージョンのService Workerが待機状態になったら、ユーザーに「新しいバージョンが利用可能です。更新しますか？」バナーを表示し、`skipWaiting()` をユーザー操作でトリガーしてください。
    -   **強制更新禁止**: バックグラウンドでのサイレント自動更新（ユーザー操作中の`skipWaiting()` 自動実行）はデータ損失の原因となるため禁止します。
    -   **バージョン管理**: Service Workerのバージョンをキャッシュ名に含めてください（例: `cache-v1.2.3`）。バージョンアップ時の古いキャッシュ削除（`caches.delete()`）を必ず実装してください。

### 31.3. Background Sync & Push UX
-   **Background Sync（バックグラウンド同期）**:
    -   オフライン中にユーザーが実行したアクション（フォーム送信、データ更新等）をIndexedDBにキューイングし、接続回復時に自動送信してください。
    -   送信成功時はToast通知で「登録が完了しました（オフライン時に記録されていました）」のようにユーザーに結果を報告してください。
    -   送信失敗（409 Conflictなど）時は、ユーザーに選択肢（「ローカルで上書き」「サーバー版を採用」「手動マージ」）を提示し、意思決定権を与えてください。
-   **Web Push Notifications ガバナンス**:
    -   **Permission Request Timing**: `DOMContentLoaded` 直後の通知許可リクエストは、ユーザーに文脈がなく拒否率が90%以上になります。必ずユーザーが価値を理解した後（初回主要アクション完了後、または「通知設定」ページ）でリクエストしてください。
    -   **通知頻度の上限**: 1日あたりの送信通知は最大**3件以内**を推奨します（§27.1 Anti-Addiction Pattern準拠）。
    -   **通知の関連性スコア**: 送信前に「このユーザーにとって今これは関連性が高いか？」をモデルで評価し、関連性スコアが閾値を超えた場合のみ送信するプッシュスコアリングを実装してください。

### 31.4. IndexedDB & ローカルデータ設計
-   **スキーマバージョン管理**: IndexedDBのスキーマ変更（Object Storeの追加・削除・インデックス変更）は必ずバージョン番号（`onupgradeneeded`）で管理してください。スキーママイグレーション失敗はデータ喪失の原因です。
-   **ライブラリ推奨**: 生のIndexedDB APIは複雑でエラーが多いため、`Dexie.js` または `idb` を使用してください。TypeScriptの型安全性も確保できます。
    ```typescript
    // Dexie.jsの使用例
    import Dexie from 'dexie';
    const db = new Dexie('MyApp');
    db.version(1).stores({ drafts: '++id, createdAt, syncStatus' });
    db.version(2).stores({ drafts: '++id, createdAt, syncStatus, priority' });
    // v2でpriorityフィールドを追加（自動マイグレーション）
    ```
-   **ストレージクォータ管理**: `navigator.storage.estimate()` でローカルストレージ使用量を監視し、85%超過時にユーザーに通知・古いキャッシュクリーンアップを促してください。
-   **機密データのローカル保存禁止**: パスワード、クレジットカード番号、セキュリティトークン等の機密情報をIndexedDB/localStorageに保存することを禁止します（§6 セキュリティルール準拠。`security/000_security_privacy.md` 参照）。

---

## 32. ゲーミフィケーション設計ガバナンス (Gamification Design Governance)

> [!WARNING]
> ゲーミフィケーションは「エンゲージメント向上ツール」と同時に「依存誘導ツール」になり得ます。以下のルールは両者の均衡を守るための設計判断基準です。

### 32.1. ゲーミフィケーション設計原則

-   **目的の明確化（Purpose-Driven Gamification）**: ゲーミフィケーション要素（バッジ、ポイント、ランキング、ストリーク等）を導入する前に、「何の行動変容を促すのか」を明確に定義してください。「なんとなくエンゲージメントを上げる」目的での導入は禁止します。
-   **行動科学的基盤（Behavioral Science Foundation）**:
    -   **内発的動機の保護**: 外部報酬（ポイント、バッジ）は短期的なエンゲージメントを高めますが、過剰依存すると内発的動機（「楽しいから使う」）を失わせます（**アンダーマイニング効果**）。本質的価値のある行動にのみ報酬を付与してください。
    -   **変動率スケジュール（Variable Ratio Schedule）の禁止**: ランダム報酬（ガチャ等）の実装は§27.2（Gambling-Like UX Prohibition）に従い厳格に管理してください。
    -   **マイルストーン型報酬の推奨**: 「達成したことの記念」として明確な節目に報酬を付与する設計を推奨します。偶発的な報酬ではなく、意味のある進捗の可視化として機能させてください。

### 32.2. ゲームメカニクス実装ガイドライン

-   **バッジ設計（Badge Design）**:
    -   **希少性の担保**: バッジが簡単に取得できすぎると価値を失います。一方、難しすぎると離脱を招きます。取得率の目標は**上位20〜40%のユーザー**が到達できるバランスを推奨します。
    -   **意味のある達成**: バッジは「実際に意味のある行動の記念」であるべきです。単なるログイン回数等の自動付与は価値を失います。
    -   **オプトアウト提供**: バッジ通知やランキング参加を望まないユーザーへのオプトアウト設定を提供してください。
    -   **アクセシビリティ**: バッジ画像には `alt` テキストを付与し、バッジの意味をスクリーンリーダーが正確に伝えられるようにしてください。

-   **ポイント / 通貨設計（Points / Currency Design）**:
    -   **透明な換算率**: ポイントと実際の価値（円、特典）の換算率を明確に表示してください。「なんとなく貯まる」ポイントはユーザーの信頼を損ないます。
    -   **有効期限UXの配慮**: ポイント有効期限が迫っている場合は、消費を促すが**不安を煽らない**通知設計を心がけてください（Loss Aversion Exploitationとの境界線を守ること）。
    -   **未成年ユーザーへの課金制限**: ポイント購入機能がある場合、未成年ユーザーへの購入上限を設定し、保護者の同意フローを実装してください。

-   **ランキング設計（Leaderboard Design）**:
    -   **相対比較の倫理**: グローバルランキングは「他者との比較」を強制し、下位ユーザーに不快感を与えます。**ローカルランキング（友人のみ）**や**自己比較（先週の自分との比較）**を優先して検討してください。
    -   **プライバシー**: ランキングへの掲載はデフォルトOFF（オプトイン形式）を推奨します。
    -   **競争と協力のバランス**: 協力型ゲーミフィケーション（チームチャレンジ等）は競争型より社会的分裂リスクが低く、コミュニティ形成に有効です。

-   **ストリーク / 継続記録（Streak Design）**:
    -   **喪失回避の悪用禁止（§27.1 Anti-Addiction Patternとの連携）**: ストリーク喪失への過度な恐怖をデザインの核にすることを禁止します。「今日もできた」ポジティブ強化を基調とし、「失うと全部無駄になる」という脅迫的誘導は排除してください。
    -   **ストリーク保護機能**: 旅行や体調不良等のやむを得ない事情でストリークが途切れた場合に、「ストリークシールド」等の保護機能を提供することを推奨します。過度なペナルティはウェルビーイングに悪影響です。

### 32.3. ゲーミフィケーションの計測と倫理監査

-   **計測指標（KPIs）**:
    | 指標 | 目的 | 注意事項 |
    |------|------|---------|
    | タスク完了率 | 行動変容成否の判定 | 主目的 |
    | セッション時間 | エンゲージメント測定 | 過剰増加は依存の兆候 |
    | オプトアウト率 | ゲーミフィケーション拒否率 | 高い場合は設計見直しシグナル |
    | NPS（推奨度） | 全体満足度 | ゲーミフィケーション導入前後で比較 |

-   **倫理監査（Quarterly Ethics Audit）**: 四半期ごとに以下を確認してください。
    1.  **依存指標**: DAU/MAU比率が設計意図を超えて急上昇していないか
    2.  **脆弱ユーザー影響**: 未成年ユーザーの課金額・利用時間に異常な集中がないか
    3.  **規制準拠**: DSA・UK Online Safety Act・日本景品表示法等への適合性
    4.  **ダークパターン検証**: §7のダークパターン禁止リストとの整合性

---

## 33. デザインQA & ビジュアルリグレッション (Design QA & Visual Regression)

> [!NOTE]
> ビジュアルリグレッション防止は「品質の守護」です。このセクションは、デザインシステムの変更がUIに意図しない破壊的影響を与えないことを自動・継続的に保証するための体制を定義します。

### 33.1. ビジュアルリグレッションテスト体制

-   **Law**: コンポーネントの変更・トークンの更新・ライブラリアップグレードが、既存UIに意図しない見た目の変化（リグレッション）をもたらすことは「サイレントバグ」の最悪形態です。レビュアーが気づけない変化が本番に入り込みます。ビジュアルリグレッションテストはCI必須項目とします。
-   **推奨ツール**:
    | ツール | 特徴 | 推奨使途 |
    |--------|------|---------|
    | **Chromatic** | Storybook統合。クラウドベースのビジュアルdiff。SaaSプロジェクト向け。 | メインストリーム推奨 |
    | **Percy** (BrowserStack) | クロスブラウザ対応強力。エンタープライズ向け。 | ブラウザ互換性重視プロジェクト |
    | **Playwright + pixelmatch** | E2Eスクリーンショット比較。自社インフラで完結。コスト重視。 | オープンソース志向プロジェクト |
    | **Backstop.js** | シンプルなセットアップ。ページレベルの比較。 | レガシープロジェクトへの後付け |

-   **CIパイプライン統合**:
    ```yaml
    # GitHub Actions: ビジュアルリグレッション実行例（Chromatic）
    - name: Run Chromatic Visual Testing
      uses: chromaui/action@v11
      with:
        projectToken: ${{ secrets.CHROMATIC_PROJECT_TOKEN }}
        exitOnceUploaded: false
        onlyChanged: true  # 変更ファイルに関連するStoriesのみ
        autoAcceptChanges: false  # 必ず人間のレビューを要求
    ```

### 33.2. Storybook設計ガバナンス

-   **Story作成義務（Story Coverage Mandate）**:
    -   すべての新規UIコンポーネントには、最低限以下のStoryを作成してください。
        1.  **Default**: デフォルト状態
        2.  **Loading**: データ取得中のスケルトン/スピナー状態
        3.  **Error**: エラー状態（エラーメッセージ・リカバリーUI）
        4.  **Empty**: 空データ状態（§10 エンプティステート準拠）
        5.  **Dark Mode**: ダークテーマ（`globals.theme: 'dark'`）
        6.  **Mobile (375px)**: モバイル幅でのレイアウト
    -   **A11y Addon義務**: `@storybook/addon-a11y` を全プロジェクトに導入し、各Story実行時にaxe-coreによるアクセシビリティチェックを自動実施してください。
    -   **Token Coverage**: Design Tokenを使用するコンポーネントは、Token値違反（ハードコード値）をStorybookのargsと合わせてドキュメント化してください。

-   **Story品質ゲート**:
    ```typescript
    // Storybookのmeta定義における必須フィールド
    const meta: Meta<typeof Button> = {
      title: 'UI/Button',
      component: Button,
      tags: ['autodocs'],          // 自動ドキュメント生成
      parameters: {
        a11y: { disable: false },  // A11yチェックを必ず有効化
        chromatic: {
          modes: {                 // Chromaticのモード対応
            light: { theme: 'light' },
            dark: { theme: 'dark' },
          },
        },
      },
      argTypes: {
        // すべてのPropsを明示的に定義（ドキュメント品質確保）
      },
    };
    ```

### 33.3. デザインQAプロセス

-   **デザインQAフェーズの義務化**: 新機能・UI変更のリリースフローに**デザインQAフェーズ**を必須ステップとして組み込んでください。
    ```
    設計（Figma）
        ↓
    実装（Code）
        ↓
    【デザインQA】← ここが必須
      ├── Figmaのデザインとの目視比較（Dev Mode活用）
      ├── ビジュアルリグレッションテスト承認（Chromatic等）
      ├── A11y自動チェック（axe-core CI）
      └── 3環境のレスポンシブ確認（§5.1 Universal Beauty Protocol）
        ↓
    ステージング確認
        ↓
    本番リリース
    ```

-   **Design Review Checklist（PRマージ前の確認項目）**:
    | チェック項目 | 担当 | 検証方法 |
    |------------|------|---------|
    | Figmaデザインと実装の一致 | デザイナー or フロントエンドエンジニア | Figma Dev Mode + ブラウザ比較 |
    | ビジュアルリグレッションなし | CI自動 + レビュアー承認 | Chromatic / Percy |
    | A11y違反なし（critical/serious） | CI自動 | axe-core / Lighthouse |
    | デザイントークン準拠 | CI自動 | Token Drift Checker（§24.3） |
    | ダークモード表示確認 | 実装者 + レビュアー | Storybook / DevTools |
    | モバイル（375px）表示確認 | 実装者 | DevTools / 実機 |

-   **ピクセルパーフェクトの定義**: 完全なピクセル一致（100%）を要求することは非現実的です。以下の許容基準を設けてください。
    -   **許容差**: フォントレンダリングの差異（OS/ブラウザ間）: ±1px
    -   **許容差**: アンチエイリアス処理による色差: 5%以内の輝度差
    -   **不許容**: スペーシングの差異、色の明示的な変化、要素の位置ずれ（2px以上）

### 33.4. Storybook-Driven Development（SDD）

-   **SDD推奨**: 新規コンポーネントの実装は、ページ組み込み前にStorybookで先に開発するアプローチ（Storybook-Driven Development）を推奨します。
    -   **メリット**: コンポーネントが独立して即時確認可能。A11yチェックが早期適用。デザイナーとのフィードバックループが高速。
    -   **ワークフロー**:
        1. Figmaでデザイン確認
        2. Storybookでコンポーネント実装（モック/MSW使用）
        3. デザイナーによるStorybookレビュー承認
        4. ページへの組み込み
        5. Chromaticでのビジュアルリグレッション承認

---


## 34. バイオメトリクス & 認証UX (Biometrics & Authentication UX)

> [!IMPORTANT]
> パスキー・生体認証は「フリクションレス認証の黄金標準」です。2026年以降、FIDO2/WebAuthn対応は新規プロダクトの必須要件です。

### 34.1. パスキー（FIDO2/WebAuthn）UX設計原則

-   **背景**: Apple・Google・Microsoftがプラットフォーム全域でパスキー対応を完了（2023年〜）し、2026年現在、パスキーは「パスワードの後継標準」として主要ブラウザ・OS全てでサポートされています。WCAG 2.2 3.3.8（Accessible Authentication）上、複雑な認知タスクを要求しない認証方式の採用は**法的義務**です。
-   **Passkey-First 設計原則**:
    1.  **登録フローUX**: 初回ログイン成功後または登録完了直後に「パスキーを設定しますか？」のバナーを表示し、ユーザーを安全な認証方式へ積極的に誘導してください。
    2.  **認証トリガーUI**: パスキー認証のボタンラベルは「顔認証でログイン」「指紋認証でログイン」等、**生体認証の種類を明示**してください。「パスキーでログイン」という汎用ラベルでも可。
    3.  **フォールバック保証**: デバイスがパスキー非対応の場合・認証失敗の場合は、SMS OTP・メールOTP・パスワードへの明確な代替手段を常に提示してください。
    4.  **クロスデバイス対応**: QRコードを使ったCTAP2（Cross-Device Authentication）対応 UIを実装し、PCブラウザでもスマートフォンのパスキーで認証できる体験を提供してください。

    ```typescript
    // WebAuthn 認証フロー実装例（最小構成）
    async function authenticateWithPasskey() {
      const options = await fetchAuthenticationOptions(); // サーバーからチャレンジ取得
      try {
        const credential = await navigator.credentials.get({
          publicKey: options,
        });
        await verifyCredential(credential); // サーバーサイド検証
      } catch (err) {
        if (err.name === 'NotAllowedError') {
          // ユーザーキャンセル → 代替手段へ誘導（エラー表示しない）
          showAlternativeLoginOptions();
        } else {
          showFriendlyError('認証に問題が発生しました。別の方法でお試しください。');
        }
      }
    }
    ```

-   **パスキー登録UX設計**:
    -   登録確認画面では「このデバイスにパスキーが保存されます」という**保存場所の明示**を行い、ユーザーの安心感を担保してください。
    -   マルチデバイス環境対応として、登録済みパスキーの一覧表示・削除・デバイス別管理UIをアカウント設定に配置してください。
    -   **デバイス紛失シナリオ**: デバイス紛失時のアカウント回復フロー（バックアップコード、メール/SMS認証への切替）を事前に提供し、ユーザーがロックアウトされないよう設計してください。

### 34.2. 生体認証（Biometric Authentication）UX

-   **プラットフォームAPI活用**: Face ID/Touch ID（iOS）、指紋認証/顔認証（Android）はプラットフォームネイティブのAPIを最大活用し、カスタム実装を避けてください。ネイティブAPIは適切なプライバシー処理・OSレベルのセキュリティが保証されています。
-   **認証状態の明確な表示**:
    -   認証中（スキャン中）: アニメーション付きの明確なインジケーター
    -   認証成功: 即座の成功フィードバック（ハプティクス + 画面遷移）
    -   認証失敗: 残り試行回数の明示 + 代替手段への誘導
-   **プライバシー表明**: 「生体データはデバイス内に保存され、サーバーに送信されることはありません」という明示的なUI表示を提供し、ユーザーの不安を払拭してください。
-   **条件付き認証（Conditional UI）**: HTML `autocomplete="username webauthn"` を使い、フォームフォーカス時にパスキー候補をオートコンプリートに自動表示する**Conditional UI**を実装してください。

    ```html
    <!-- Conditional UI実装例 -->
    <input
      type="email"
      autocomplete="username webauthn"
      placeholder="メールアドレス"
    />
    ```

### 34.3. 多要素認証（MFA）UX

-   **2段階認証UI標準**:
    -   TOTP（認証アプリ）入力: 6桁コードの入力欄は `inputmode="numeric"` + `autocomplete="one-time-code"` を設定し、iOSのSMS自動補完・Autofillに対応させてください。
    -   SMS OTP: OTP送信後は「送信済みアイコン + 残り有効時間カウントダウン」を表示し、ユーザーの不安を軽減してください。
    -   **認証コードの自動フォーカス**: OTP入力欄は自動フォーカスし、物理キーボード・IMEの介入を最小化してください。
-   **Remember This Device UX**: 「このデバイスを30日間信頼する」オプションは、ユーザーが明示的にチェックした場合のみ有効化してください（Pre-checked禁止: §7 Dark Pattern Ban準拠）。
-   **Cross-Reference**: §6（認証アクセシビリティ）、`security/000_security_privacy.md`

---

## 35. コンテンツセーフティ & トラストデザイン (Content Safety & Trust Design)

> [!WARNING]
> EU DSA（デジタルサービス法）・英国オンライン安全法は、プラットフォームに「違法コンテンツへの対応UI」を義務付けています。コンテンツ信頼設計はコンプライアンス要件です。

### 35.1. コンテンツ報告・フラグUI（EU DSA Art.16 準拠）

-   **違法コンテンツ報告UI（義務）**: EU DSA Art.16が施行されるプラットフォーム（大規模オンラインプラットフォーム）では、全てのユーザー生成コンテンツに**「報告（フラグ）」ボタン**を提供することが法律上義務です。
    -   **Report Flow設計**:
        1.  報告理由のカテゴリ選択（スパム / ハラスメント / 誤情報 / 違法コンテンツ / 著作権侵害 等）
        2.  任意の追記テキスト欄
        3.  送信確認 + 「報告を受け付けました。対応状況はここで確認できます」リンク
    -   **レスポンスUX**: 報告後は「通報ID」を発行し、ユーザーが対応ステータスを追跡できる**透明性ダッシュボード**を提供することを推奨します。
-   **コンテンツモデレーション結果のUX**:
    -   コンテンツが削除・非表示になった場合、投稿者に「削除理由」と「異議申し立て手段」を通知してください（EU DSA Art.17 準拠）。
    -   異議申し立てフローは、報告フローと同等の容易さで設計してください（§7 対称性原則準拠）。

### 35.2. 信頼シグナルデザイン（Trust Signal Design）

-   **コンテンツ信頼階層**:
    | コンテンツタイプ | 信頼シグナル設計 |
    |----------------|--------------|
    | 公式・認証アカウント | 認証バッジ（✓）+ ホバーツールチップで認証理由を説明 |
    | AI生成コンテンツ | 専用バッジ（§23準拠）+ グローエフェクト |
    | ユーザー生成コンテンツ | 報告ボタン常時表示 + コミュニティガイドライン遵守表示 |
    | 機密/センシティブコンテンツ | コンテンツウォーニング（続きを見るには確認）デザイン |
    | 誤情報判定済みコンテンツ | 「レビュー済み」ラベル + ファクトチェック機関リンク |

-   **著者信頼度表示**: ユーザープロフィールに「アカウント作成日」「投稿履歴サマリー」等の文脈情報を表示する**コンテキストカード**の提供を推奨します（プライバシー設定でON/OFF可能）。
-   **シェア前ファクトチェック促進**: 外部リンク共有時に「この記事は2週間以上前に公開されています。最新の情報を確認しましたか？」等の**摩擦点（Friction Nudge）**を設計し、誤情報の拡散を抑制してください。

### 35.3. センシティブコンテンツUX（Safe Messaging Design）

-   **コンテンツウォーニングパターン**:
    -   グラフィックな暴力・自傷・性的コンテンツには、コンテンツが展開されるまで**ブラーオーバーレイ + 警告テキスト + 「表示する」ボタン**を配置してください。
    -   `aria-hidden="true"` でスクリーンリーダーからウォーニング後コンテンツを隠し、確認操作後に公開する設計を採用してください。
-   **メンタルヘルス関連コンテンツ**: 自傷・自殺関連のキーワードを含む検索・投稿に対して、**セーフメッセージングガイドライン（WHO準拠）**に基づく危機リソースを自動表示してください（§27.2準拠）。
-   **年齢確認UX（Age Gate）**:
    -   年齢制限コンテンツのAge Gateは、生年月日直接入力方式（`YYYY/MM/DD`）を推奨します。クリックスルー型（「18歳以上です」ボタンのみ）は規制上無効と見なされます。
    -   Age Gate通過後はセッション中は再表示しない（UXペナルティ回避）ただしキャッシュしないこと。

### 35.4. コンテンツ整合性とプロバナンス（Content Integrity & Provenance）

-   **C2PA（Content Credentials）対応**: Adobe/Microsoftらが推進するC2PA（Coalition for Content Provenance and Authenticity）標準に準拠し、画像・動画のメタデータとして制作者・ツール情報を埋め込む**Content Credentials UI**の将来的な採用を計画してください。
-   **ウォーターマーキングUX**: AI生成画像・動画には、ステガノグラフィー型の不可視ウォーターマーク（Google SynthID等）の適用を推奨します。ユーザー向けには「AI生成」バッジで明示（§23準拠）、機械検出向けには不可視ウォーターマークで二重担保を設計してください。
-   **Cross-Reference**: §23（AI生成UIガバナンス）、§27（デジタルウェルビーイング）、`security/100_data_governance.md`

---

## 36. リアルタイム協働編集UX (Real-Time Collaboration UX)

> [!NOTE]
> Figma / Linear / Notion / Google Docs型のリアルタイム共同編集は、2026年以降のSaaS製品の「デフォルト体験」です。CRDT技術の成熟により実装障壁は下がったが、UX設計の複雑性は増しています。

### 36.1. プレゼンス設計（Presence Indicators）

-   **Awareness UI（認知設計）**: リアルタイムコラボレーション環境では、「誰が今ここにいるか」をユーザーが常に認識できる**Presence UI**が必須です。
    -   **ユーザーカーソル**: 別ユーザーのカーソル位置をリアルタイム表示します。カーソルにはアバター + 氏名を付与してください。色はユーザーごとに自動割り当て（Design Token: `--c-user-{index}-color`）し、最大同時表示人数を8名以内に制限することを推奨します。
    -   **見ているエリアの表示**: 「Aさんがセクション3を閲覧中」等のFocus Indicatorを提供することで、作業の重複を防いでください。
    -   **Active User List**: 現在セッションに参加しているユーザーのアバター一覧を常時表示してください。オフラインになったユーザーはグレーアウトで区別してください。
-   **プレゼンスのプライバシー設定**: 「現在の作業状況を他のユーザーに表示しない（ゴーストモード）」オプションを提供してください。デフォルトはON（共有）ですが、プライバシー設定から変更可能にしてください。

### 36.2. コンフリクト解決UX（Conflict Resolution UX）

-   **CRDT（Conflict-free Replicated Data Type）ベースのUI設計**: CRDTを採用している場合、多くの競合は自動マージされますが、セマンティックな競合（同一フィールドへの同時編集等）は発生します。
    -   **自動マージの透明性**: 自動マージが行われた場合、「変更が統合されました」のさりげないトースト通知を表示してください。マージがどのように行われたかを確認できる**変更履歴UI**へのリンクを提供することを推奨します。
    -   **競合検知時のUI**:
        ```
        ┌─────────────────────────────────────────┐
        │ ⚠️  競合が検出されました                   │
        │                                         │
        │ あなたの変更         Aさんの変更          │
        │ [タスク優先度: 高]   [タスク優先度: 中]   │
        │                                         │
        │ [自分の変更を使用]   [Aさんの変更を使用]  │
        │ [手動マージ...]                          │
        └─────────────────────────────────────────┘
        ```
    -   ユーザーに「どちらを採用するか」の**3択（自分の版 / 相手の版 / 手動マージ）**を常に提供し、データ損失ゼロを保証してください。
-   **楽観的更新とロールバック**: ユーザーの操作は即座にローカルに反映し（Optimistic UI）、サーバー同期失敗時には操作を**Undoキュー**から自動復元してください。

### 36.3. 変更履歴・バージョンUX（Version History UX）

-   **Undo/Redo のスコープ設計**: マルチユーザー環境でのUndo/Redoは「自分の操作のみ取り消す」がユーザーの直感に合います。他のユーザーの操作を巻き込むグローバルUndoは禁止してください。
-   **バージョンスナップショットUI**:
    -   **自動スナップショット**: 重要な変更（大量削除・構造変更等）の前には自動でスナップショットを作成してください。
    -   **名前付きバージョン**: ユーザーが手動でバージョン名を付与できる機能を提供し、「昨日の夕方の状態に戻す」といった自然な復元操作を可能にしてください。
    -   **差分ビュー**: バージョン間の変更をDiff形式（追加: 緑/削除: 赤）で視覚的に比較できるUIを提供してください。
-   **変更貢献の可視化**: 各コンテンツ要素に「誰がいつ変更したか」を表示する**Blame機能**（Git blameと同様の概念）を提供することで、チームの説明責任（Accountability）を向上させてください。

### 36.4. コメント & フィードバックシステムUX

-   **コンテキストコメント**: コメントは「ページ全体」ではなく「特定の要素・テキスト範囲」に紐付けられる**インラインコメント**が推奨です（Google Docs型）。
-   **スレッドUX**:
    -   コメントは返信スレッドでネスト可能にし、最大深度は3階層を目安とします（無制限ネストは認知過負荷を引き起こします）。
    -   スレッドの**Resolve（解決済み）機能**を提供し、解決済みコメントはデフォルト折りたたみで保持してください（履歴として参照可能）。
-   **通知設計**: コメントへの返信・メンション（@mention）通知は、**リアルタイムプッシュ**で配信しつつ、集計された「ダイジェスト通知」（1時間ごと等）のオプションも提供してください（通知疲れ防止: §27.1準拠）。
-   **Cross-Reference**: §14（インタラクション安全プロトコル）、§19（UXリサーチ）

---

## 37. プラットフォームエンジニアリング & Design System Ops (Platform Engineering & Design System Ops)

> [!NOTE]
> デザインシステムの運用を「手動作業」から「自動化されたパイプライン」へ進化させることが、2026年以降のDesign Ops成熟度L5の必要条件です。

### 37.1. Figma REST API & デザイン自動化

-   **Figma REST API活用シナリオ**:
    -   **Token Extraction**: Figma VariablesをFigma REST APIで定期的に取得し、W3C DTCG形式の`tokens.json`として自動コミットするBotを構築してください（手動エクスポートを排除）。
    -   **デザイン品質レポート**: コンポーネントの使用統計・バリアブル適用状況・未定義スタイルの検出を自動生成するチェックレポートを構築してください。
    -   **デザイン-実装乖離検出**: Figmaのコンポーネント仕様とStorybookのコンポーネントProps定義を自動比較し、乖離をSlack/GitHubに定期報告するワークフローを設計してください。

    ```typescript
    // Figma REST API: Variables取得例
    const response = await fetch(
      `https://api.figma.com/v1/files/${FILE_ID}/variables/local`,
      { headers: { 'X-Figma-Token': FIGMA_TOKEN } }
    );
    const { variables, variableCollections } = await response.json();
    // W3C DTCG形式に変換 → tokens.jsonに書き出し
    ```

-   **デザインスプリントの自動化**:
    -   Figmaのフレームステータス（Draft/Ready/Shipped）変更をWebhookで検知し、**自動的にJira/LinearのチケットステータスをUpdate**するGitHub Actions / Make(旧Integromat)ワークフローの構築を推奨します。

### 37.2. Internal Developer Portal (IDP) & デザインシステム統合

-   **背景**: Platform Engineering（内部開発プラットフォーム: IDP）の普及により、Backstage等のIDPとデザインシステムを統合することで「コンポーネントカタログ → Storybook → Figma Spec」をシングルソースで探索できる**統合デベロッパーポータル**の構築が実現可能になりました。
-   **カタログ統合設計**:
    -   Backstage（または同等のIDP）にデザインシステムプラグインを統合し、**コンポーネント名 → Storybook URL → Figma Frame URL → npm パッケージバージョン**を一元参照できるカタログを構築してください。
    -   コンポーネントの**READMEと利用統計**（プロジェクト横断での使用数・バージョン分布）をカタログに表示し、未使用コンポーネントの廃止判断を自動化してください。
-   **ゴールデンパス（Golden Path）定義**: IDPを通じて、新規コンポーネント追加・既存コンポーネント更新・デプレケーションの「承認ずみのステップバイステップフロー（Golden Path）」を定義し、ガバナンスの一貫性を担保してください。

### 37.3. デザインシステムの継続的インテグレーション高度化

-   **Progressive Design CI**:
    ```yaml
    # GitHub Actions: 高度化されたDesign System CI例
    name: Design System CI
    on: [push, pull_request]
    jobs:
      token-validation:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v4
          - name: Validate W3C DTCG Token Schema
            run: npx @tokens-studio/sd-transforms validate tokens.json
          - name: Check Token Drift vs Figma
            run: node scripts/token-drift-check.js
            env:
              FIGMA_TOKEN: ${{ secrets.FIGMA_TOKEN }}
      component-quality:
        runs-on: ubuntu-latest
        steps:
          - name: Storybook Build
            run: npm run build-storybook
          - name: A11y Test (axe-core)
            run: npx storybook test --coverage
          - name: Visual Regression (Chromatic)
            uses: chromaui/action@v11
            with:
              projectToken: ${{ secrets.CHROMATIC_TOKEN }}
    ```

-   **スナップショットテストからビジュアルテストへの移行**: `jest-snapshot` の DOM スナップショットはメンテナンスコストが高く、実際の見た目の変化を検出しません。Chromatic/Percy等のビジュアルリグレッションに完全移行することを推奨します。

### 37.4. デザインシステムのモニタリング & 観測可能性

-   **Design System Observability**:
    -   **Adoption Analytics**: コンポーネントライブラリの各コンポーネントが実プロジェクトで何回・何バージョン使用されているかを追跡する**使用率ダッシュボード**を構築してください。
    -   **破壊的変更の影響評価**: MAJORバージョンリリース前に、`semver-diff`ツールや依存グラフ分析で影響を受けるプロジェクト数を事前計算し、リリースリスクを可視化してください。
    -   **エラー率トラッキング**: Sentry等のエラートラッキングツールのエラーをコンポーネント単位で分類し、「このコンポーネントは本番で◯件のエラーを引き起こしている」を健全性スコア（§21.4準拠）に統合してください。

-   **SLO（Service Level Objective）定義**:
    | SLO指標 | 目標値 |
    |--------|-------|
    | Storyboook Build Time | ≤ 5分 |
    | Visual Regression Review Time | ≤ 24時間 |
    | Critical A11y Bug Fix Time | ≤ 24時間 |
    | Token Drift Detection to Fix | ≤ 1週間 |
    | MAJOR Breaking Change Deprecation Notice Lead Time | ≥ 3ヶ月 |

-   **Cross-Reference**: §21（デザインシステムガバナンス）、§24（クロスプラットフォーム・トークン連携）、§33（デザインQA & ビジュアルリグレッション）、`engineering/000_engineering_standards.md`

---

## Appendix A: 逆引き索引

| キーワード | セクション | 関連ルール |
|-----------|----------|-----------|
| Material Design / Expressive / HIG | §1 | `engineering/300_web_frontend`, `engineering/400_mobile_flutter` |
| デザイントークン / W3C DTCG / CSS | §2 | `engineering/300_web_frontend`, `engineering/000_engineering_standards` |
| タイポグラフィ / CJK / Font | §1.1, §3.3 | `product/800_internationalization` |
| カラー / ダークモード / P3 / Oklch | §2.1 | `engineering/300_web_frontend` |
| レスポンシブ / フォルダブル / Any-Screen | §5 | `engineering/400_mobile_flutter`, `engineering/410_native_platforms` |
| コンポーネント / Headless UI / Skeleton | §3 | `engineering/300_web_frontend` |
| フィードバック / Toast / Z-Index | §3.1, §14.3 | `engineering/300_web_frontend` |
| アニメーション / Motion Token / 60fps | §4, §16 | `engineering/300_web_frontend`, `engineering/400_mobile_flutter` |
| ハプティクス / サウンド | §3.5 | `engineering/400_mobile_flutter`, `engineering/410_native_platforms` |
| アクセシビリティ / WCAG 2.2 / EAA | §6 | `engineering/300_web_frontend`, `engineering/400_mobile_flutter`, `security/100_data_governance` |
| フォーム / IME / 入力 | §14.1, §14.2, §15.3 | `engineering/300_web_frontend` |
| ナビゲーション / パンくず / タブ | §3.3, §10 | `engineering/300_web_frontend` |
| エラー / リカバリー / エラーカタログ | §12, §15.2, §15.5 | `engineering/300_web_frontend`, `operations/300_customer_experience` |
| セーフティUI / 破壊的操作 / DnD | §11, §14.4 | `security/000_security_privacy` |
| オンボーディング / エンプティステート | §10 | `product/500_growth_marketing`, `operations/300_customer_experience` |
| マイクロコピー / ライティング / Tooltip | §10 | `product/600_brand_strategy` |
| AI UX / Agentic / GenUI / Copilot | §9 | `ai/000_ai_engineering` |
| MCP / ツール参照透明性 / パーミッションUI | §9 | `ai/000_ai_engineering`, `security/000_security_privacy` |
| マルチモーダルAI UX / モーダリティ状態表示 | §9 | `ai/000_ai_engineering` |
| ユーザー主権 / ダークパターン / Ethical UX | §7 | `security/100_data_governance`, `product/000_product_strategy` |
| おもてなし / 先回り / ロケールフォーマット | §12 | `product/800_internationalization` |
| i18n / ローカライゼーション | §15 | `product/800_internationalization`, `core/200_language_protocol` |
| パフォーマンスUX / CWV / 知覚 | §17 | `engineering/000_engineering_standards`, `operations/400_site_reliability` |
| Spatial Computing / XR / visionOS | §18 | `engineering/410_native_platforms` |
| UXリサーチ / 計測 / NPS | §19 | `ai/100_data_analytics`, `product/100_market_validation` |
| AI拡張UXリサーチ / 合成テスト / 行動分析倫理 | §19.4 | `ai/100_data_analytics`, `ai/000_ai_engineering` |
| 成熟度モデル / アンチパターン | §20 | すべてのルール（共通） |
| デザインシステムガバナンス / DSaaP / SemVer | §21 | `engineering/000_engineering_standards` |
| データ可視化 / チャートA11y / IA | §22 | `ai/100_data_analytics`, `engineering/300_web_frontend` |
| AI生成UI / Vibe Coding / EU AI Act開示 | §23 | `ai/000_ai_engineering`, `security/000_security_privacy` |
| クロスプラットフォーム / Token Pipeline / Token Drift | §24 | `engineering/400_mobile_flutter`, `engineering/410_native_platforms` |
| サステナビリティ / Green UX / Carbon-Aware | §25 | `operations/400_site_reliability` |
| ニューロダイバーシティ / ADHD / 認知アクセシビリティ | §26 | `security/100_data_governance`, `product/000_product_strategy` |
| デジタルウェルビーイング / エシカルデザイン / スクリーンタイム | §27 | `security/100_data_governance`, `product/000_product_strategy` |
| Voice UX / VUI / 音声アクセシビリティ / STT/TTS | §28 | `ai/000_ai_engineering`, `engineering/410_native_platforms` |
| パーソナライゼーション / フィルターバブル / 文脈適応 | §29 | `ai/100_data_analytics`, `security/100_data_governance`, `product/000_product_strategy` |
| Design Tokens 2.0 / Modes / Scoping / マルチブランド | §30 | `engineering/300_web_frontend`, `engineering/000_engineering_standards` |
| オフラインファースト / Service Worker / Background Sync / IndexedDB | §31 | `engineering/300_web_frontend`, `operations/400_site_reliability` |
| ゲーミフィケーション / ゲームメカニクス / ポイント / バッジ / 倫理 | §32 | `product/000_product_strategy`, `security/100_data_governance` |
| ビジュアルリグレッション / Design QA / Storybook / Chromatic / CI | §33 | `engineering/000_engineering_standards`, `engineering/300_web_frontend` |
| パスキー / FIDO2 / WebAuthn / 生体認証 / Conditional UI | §34 | `security/000_security_privacy` |
| コンテンツセーフティ / DSA Art.16 / 信頼シグナル / Age Gate / C2PA | §35 | `security/100_data_governance`, `product/000_product_strategy` |
| リアルタイム協働 / CRDT / コンフリクト解決 / プレゼンス | §36 | `engineering/000_engineering_standards`, `engineering/300_web_frontend` |
| プラットフォームエンジニアリング / IDP / Figma API / Design System CI / SLO | §37 | `engineering/000_engineering_standards` |

---

> **Cross-Reference（技術スタック固有ルール参照）**
> 本ファイル（§1〜§37）は技術スタック非依存のUniversal デザイン・UX原則を定義します。フレームワーク固有の実装詳細については以下を参照してください：
> - **Web（React/Next.js等）**: `engineering/300_web_frontend.md` — Hooks順序・Hydration Mismatch・suppressHydrationWarning・Server Component境界・Hard Session Refresh
> - **Mobile (Flutter)**: `engineering/400_mobile_flutter.md` — WidgetライフサイクルとPlatform固有UI
> - **Native (Kotlin/Swift)**: `engineering/410_native_platforms.md` — HIG/Material固有実装・ハプティクスAPI
> - **AI/ML**: `ai/000_ai_engineering.md` — GenAI品質保証・EU AI Act詳細コンプライアンス・Voice AI統合
> - **データ分析**: `ai/100_data_analytics.md` — 計測・A/Bテスト詳細手法・パーソナライゼーションモデル
> - **国際化**: `product/800_internationalization.md` — i18nライブラリ選定・翻訳ワークフロー
> - **Site Reliability**: `operations/400_site_reliability.md` — Service Worker監視・オフラインメトリクス
> - **プロダクト戦略**: `product/000_product_strategy.md` — ゲーミフィケーション倫理・依存設計リスク
> - **エンジニアリング標準**: `engineering/000_engineering_standards.md` — ビジュアルリグレッション自動化・CI品質ゲート
