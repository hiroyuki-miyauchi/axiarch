# 20. デザインとUX戦略 (Design & UX Strategy)

> [!CRITICAL]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: UI/UXの不統一は「プロ意識の欠如」である。
> - **Action**: 「この画面だけボタンが左にある」「ここだけ削除フローが違う」といった些細なズレを許容してはならない。全体の調和（Harmony）を乱す要素は、機能していようとバグである。
> - **Target**: 特に「削除」「保存」「認証」などのクリティカルなフローにおいては、ユーザーのメンタルモデルを守るため、鉄の統一（Iron Consistency）を維持せよ。


## 1. デザイン哲学 (Philosophy: "Silicon Valley Excellence & Google First")

### 1.1. 圧倒的な「Wow」体験 (The "Wow" Factor - Delight)
*   **必須要件 (Mandate)**: すべてのインタラクションは「生きている」と感じさせなければなりません。静的な画面ではなく、**動的な体験**を構築します。
*   **Google標準 (Google Standard)**: **Material Design 3 (Material You)** およびその進化形である **"Expressive"** (2025+) をベースラインとして採用します。
*   **Apple標準 (Apple Standard)**: iOSにおいては、**Human Interface Guidelines (HIG)** を尊重します。Material Designを無理やり適用せず、プラットフォーム固有の操作感（Platform Fidelity）を維持します（例: スイッチ、ピッカー）。
*   **差別化 (Differentiation)**: Googleのシステムを使用しつつ、**高精度のモーション**、**カスタムシェーダー**、**大胆なタイポグラフィ**によって差別化し、「シリコンバレーのプレミアム感」を演出します。
*   **The Typography Localization Protocol (Readability First)**:
    *   **Font Fallback Stack**: Webフォント（例: Noto Sans JP, Inter）を使用する際は、必ずOS標準フォント（例: Hiragino Kaku Gothic, Meiryo, システムのsans-serif）をフォールバックとして指定してください。
    *   **Line Height for CJK**: 日本語・中国語など文字密度が高い言語では、`line-height` を広め（`1.6 - 1.8`）に設定し、可読性を確保してください。
    *   **Letter Spacing**: 太字見出しには `letter-spacing: wider` を適用し、文字の詰まりを解消することを推奨します。

### 1.2. トレンドスカウティング・プロトコル (Trend Scouting Protocol)
*あらゆる*デザインタスク（単一のコンポーネントであっても）の前に、以下の「スカウティング・ループ」を義務付けます：
1.  **リーダー分析 (Analyze Leaders)**: **Mobbin** (iOS/Androidのフロー)、**Awwwards** (Webトレンド)、**Google Design** (最新仕様) を確認します。
2.  **解剖 (Deconstruct)**: トップティアのアプリがなぜ「心地よい」のかを解剖します（例：「このモーダルのバウンスが遊び心を演出している」）。
3.  **適用 (Apply)**: その「感覚（Soul）」を我々のコンテキストに適応させます。**盲目的にコピーするのではなく、インタラクションの「魂」を盗みます。**
4.  **AI活用 (AI Leverage)**: 生成AIを使用して、標準的なUIコンポーネントの「未来的」なバリエーションをブレインストーミングします。

### 1.3. The Realism Mandate (Anti-Haribote / Truth in Design)
*   **Law**: DBスキーマに存在しないデータ（将来のカラム、架空のステータス）をデザインカンプに描くことを禁止します。
*   **Action**: デザイナーはFigmaを描く前に、必ずバックエンドエンジニアと **DBスキーマ（ER図）** を合意してください。「なんとなくJSONで持たせる予定」という曖昧なデータは、必ずUIの実装時に破綻します。
*   **Motto**: "No Schema, No Pixel." (スキーマなき場所にピクセルなし)

## 2. デザインエンジニアリング (Design Engineering)

### 2.1. デザイン・トークン (Design Tokens)
*   **Single Source of Truth**: 色、スペーシング、タイポグラフィ、シャドウ、角丸などの全てのデザイン値は、FigmaのVariablesで定義し、コード（Tailwind Config / CSS Variables）と100%同期させます。
*   **ハードコード禁止**: `px` や `#hex` を直接コードに書くことは**厳禁**です。必ずトークン（例: `color-primary-500`, `spacing-4`）を使用します。
*   **Dynamic Theme**: テーマ設定 (`site_settings`) は、Runtime (`RootLayout`) でDBから取得し、CSS変数として注入します。
*   **The Locale Format Mandate (Date/Currency/Number)**:
    *   **Law**: 日付、通貨、数値のフォーマットは**ロケール依存**です。特定の形式（例: `MM/DD/YYYY`）をハードコードすることを禁止します。
    *   **Action**:
        1. **Date Library**: `date-fns` や `Intl.DateTimeFormat` を使用する際は、必ず対象ロケールを明示的に指定してください。
        2. **Currency**: 通貨記号と桁区切りは `Intl.NumberFormat` を使用し、ロケールに応じた正しい形式で表示してください。
        3. **Consistency**: アプリケーション全体で統一されたロケール設定を維持し、混在を防いでください。

## 3. コンポーネント実装ガイド (Component Guidelines)
### 3.1. Implementation Patterns
*   **Skeleton Loader**:
    *   データ読み込み中（Suspense）は、スピナーではなく **Skeleton Screen** (`<Skeleton />`) を使用し、レイアウトシフト（CLS）を防ぎます。
*   **Feedback Hierarchy**:
    *   **Toast**: 成功・通知（非同期）。
    *   **Inline Alert**: 文脈依存のエラー。
*   **Toast Promise Standard (Async Feedback Lifecycle)**:
    *   **Law**: 非同期処理（保存・削除・送信等）において、Loading→Success→Errorのフィードバックサイクルを手動で管理することはバグの温床です。
    *   **Action**: Toastライブラリの `promise` 機能（例: `sonner.promise()`）を使用し、処理中・成功・失敗の3状態を自動的に表示してください。ユーザーは「処理中」であることを視覚的に認識し、完了または失敗の結果を確実に受け取れなければなりません。
*   **Z-Index Stratification (The Layering Law)**:
    *   **Overlay (10000)**: Select, Popover, Tooltip, Calendar 等。常に最前面。
    *   **Modal (9999)**: Dialog, Sheet 等。
    *   **Menu (1000)**: Navigation Drawer 等。
    *   **Action**: 恣意的な `z-50` 等のマジックナンバーは禁止し、この階層構造を厳守してください。
*   **Optimistic UI (楽観的更新)**:
    *   いいね等の軽量アクションは、サーバー応答を待たずに即座に表示更新し、ネイティブアプリ並みの応答速度を実現します。
*   **The Sortable Table Standard**:
    *   **Law**: 管理画面の一覧テーブル（ユーザー、商品、ログ等）において、「項目の並び替え（Sort）ができない」状態は、業務ツールとして不完全（Incomplete）です。
    *   **Action**: 必ず `SortableTableHead` コンポーネントを使用し、ヘッダークリックによるサーバーサイドソート（`sortBy`, `sortOrder`）を標準機能として実装してください。矢印アイコンの挙動やパラメータ名は全機能で統一を義務付けます。

### 3.2. The React/Hydration Hardening Protocol (Lesson 42.18)
*   **The Hooks Order Guarantee**:
    *   **Law**: React Hooks (`useEffect`, `useState`, `useQuery`) は、いかなる条件分岐（`if`, `return`）よりも**前**に記述しなければなりません。
    *   **Violation**: "Rendered more hooks than during the previous render" エラーは、早期リターン（Early Return）の後に Hooks を置いたことによる**初歩的な実装ミス**です。
    *   **Action**: 全てのコンポーネントにおいて、**Hooks 定義ブロック** を最上部に固定配置する構造を強制します。

*   **The Anchor Nesting Prohibition (Hydration Mismatch)**:
    *   **Law**: `<a>` タグの中に `<a>` タグや `<button>` を入れることは HTML 仕様違反であり、React の Hydration Mismatch の主因です。
    *   **Context**: Widget全体をリンクにしたい場合によく発生します。
    *   **Action**: ネストするのではなく、親要素に `onClick` ハンドラを設定するか、CSS (`absolute inset-0`) でリンクをオーバーレイさせる手法を使用してください。

*   **The suppressHydrationWarning Standard**:
    *   **Law**: `suppressHydrationWarning` は「魔法の杖」ではありません。
    *   **Allowed**: 日付（`Date`）、乱数、ローカルストレージ依存の初期値など、**サーバーとクライアントで値が異なることが不可避なテキストノード**にのみ使用を許可します。
    *   **Banned**: HTML構造の不一致（タグの入れ子ミス）を隠蔽するために使用することは厳禁です。

*   **The Hidden Element & Ghost Dimension Protocol**:
    *   **Law 1 (Render Cost)**: `display: none` (`hidden`) の要素は、画面上は見えませんが、Reactのレンダリングコストと仮想DOMのノード数を消費し続けます。
    *   **Action**: モバイルメニューやドロワーなど、表示頻度が低い大きな要素には `hidden` ではなく条件付きレンダリング（`{ isOpen && <Drawer /> }`）を使用し、DOMツリーをクリーンに保ってください。
    *   **Law 2 (Dimension Trap)**: 非表示状態の要素は、`width/height` が「0」として計算されます。
    *   **Action**: 初期状態で非表示の要素内で `ResizeObserver` やカルーセル、マップ等の「サイズ依存の初期化」を行う場合は、表示された瞬間に `resize` イベントを明示的に発火させるか、再マウントを強制して「表示が崩れる（Ghost Dimension）」を防いでください。

### 3.3. Layout Architecture
*   **The Single Container Protocol**:
    *   Layoutがコンテナ (`container`) を提供する場合、Page側での再定義（二重パディング）を厳禁とします。
    *   **Baseline Harmony (Filter Alignment Protocol)**:
        *   **Law**: ラベル付きの `Input` と `Button` を横並びにする際、`items-center` で中央揃えにすることを禁止します。
        *   **Action**: 必ず **`items-end`** を使用し、ラベルの高さを考慮した「下端（Baseline）揃え」を徹底してください。これにより、ピクセルパーフェクトな視覚的一貫性を保証します。`items-center` はラベルと入力の境界をあやふやにし、デザインの品位を損なう「素人仕事」とみなされます。

    *   **The Natural Scrolling Protocol (Rule 12.6)**:
        *   **Law**: `h-screen` と `overflow-y-auto` を無計画にネストさせ、二重スクロールバーを発生させることは UX の敗北です。
        *   **Action**: スクロールコンテナは画面内に**ただ一つ**（通常は `body` またはメインレイアウト）であることを原則とします。部分スクロールが必要な場合は、必ず `dvh` (Dynamic Viewport Height) を考慮し、Mobile Safari でのアドレスバー挙動を検証してください。

    *   **The Any-Screen Typography Protocol (Adaptive Scaling)**:
        *   **Law**: 固定の `text-3xl` 等の指定は、大画面では貧弱に、小画面では暴力的に働きます。
        *   **Action**: 
            1. **Adaptive Base**: 文字サイズは必ずモバイル基準（`text-xl`）から書き始め、`sm:` や `lg:` などのブレークポイントで最適化（Scaling）を行うことを義務付けます。
            2. **Visual Hierarchy**: 画面サイズが変わっても「情報の重要度（Hierarchy）」が維持されるよう、見出しと本文のコントラスト比を適切に管理してください。

    *   **The Fragmented UI Protocol (Consistency Mandate)**:
        *   **Law**: 「似ているが違う」は最悪です。UIコンポーネント（パンくず、見出し、ボタン等すべて）は、**その配置コンテキスト（Wrapper/Layout）まで含めて** 標準化しなければなりません。
        *   **Action**: ページごとのアドホックなCSS調整（「ここだけ少し背景色を変える」「マージンを足す」）を禁止します。サイト全体で一つの「正解（Gold Standard）」を定め、全てのページをそれに準拠させてください。

### 3.4. モーションとジェスチャー (Motion & Gestures - The "Soul")
*   **物理ベース (Physics-Based)**: すべてのアニメーションは**スプリング物理**（剛性/減衰）を使用します。要素は弾み、伸び、わずかに潰れるべきです。
*   **ジェスチャー (Swipe First)**:
    *   **ナビゲーション (Navigation)**: 「スワイプバック」を普遍的にサポートします。
    *   **アクション (Actions)**: リスト項目には**Swipe-to-Action**（アーカイブ、削除など）を使用します。
    *   **感触 (Feel)**: ジェスチャーは指の動きに 1:1 で追従しなければなりません。ラグは厳禁です。

### 3.5. 五感のデザイン (Multi-Sensory Design)
*   **ハプティクス (Haptics)**:
    *   **触覚フィードバック**: 成功（Success）、失敗（Error）、選択（Selection）、衝突（Impact）の各イベントに対して、iOS/Androidのネイティブハプティクスパターンを割り当てます。
    *   **繊細さ**: 「ブブッ」という不快な振動ではなく、「コツッ」「コンッ」という繊細で高級感のあるフィードバックを追求します。
*   **ソニック・ブランディング (Sonic Branding)**:
    *   **サウンドロゴ**: アプリ起動時や重要な達成時（コンバージョン）には、ブランドを象徴する短いサウンド（サウンドロゴ）を再生し、記憶に残る体験を作ります。
    *   **UIサウンド**: ボタン押下やトグル切り替えにも、邪魔にならない微細なサウンド（Click, Pop）を付与します（設定でOFF可能にする）。

## 4. パフォーマンス・アニメーション (Performance Animation)
*   **60fps (120fps) ターゲット**:
    *   アニメーションは常に60fps（可能なら120fps）を維持しなければなりません。
    *   **GPU最適化**: `transform` と `opacity` プロパティのみをアニメーションさせます。`width`, `height`, `top`, `left` のアニメーションはレイアウト再計算（Reflow）を引き起こすため禁止します。
    *   **Will-Change**: 必要な場合のみ `will-change` プロパティを使用し、ブラウザにヒントを与えますが、乱用は避けます（メモリ消費増大のため）。

## 5. 適応性とフォルダブル (Adaptability & Foldables)

### 4.1. ユニバーサル・レスポンシブ (Universal Responsiveness)
*   **ルール**: 「モバイルファースト」は死語です。我々は **"Any-Screen"**（あらゆる画面）のためにデザインします。
*   **フォルダブル (Foldables)**:
    *   **ヒンジ認識 (Hinge Awareness)**: UIはヒンジを認識し、賢く分割されなければなりません（テーブルトップモード）。
    *   **連続性 (Continuity)**: 折りたたみ/展開時に、状態（State）は完全に保持されなければなりません。
*   **大画面 (Large Screens)**: **Canonical Layouts**（リスト詳細、サポートペイン、フィード）を使用し、余白を有効活用します。単にモバイルUIを「引き伸ばす」ことは禁止します。
*   **The CSS Containment Protocol (Whitespace Glitch Prevention)**:
    *   **Context**: アコーディオン展開時等に、スクロール計算が狂い膨大な余白（Whitespace）が発生することがあります。
    *   **Action**: `overflow-y-auto` を持つコンテナには `style={{ contain: 'layout' }}` を付与し、子要素のレイアウト変動がコンテナ外に影響しないよう制限してください。
*   **The Universal Beauty Protocol (Responsive Verification Mandate)**:
    *   **Law**: 「PCで動くからOK」は、レスポンシブデザインの不備を隠蔽する壽由話であり、放置された変更は「未完成」とみなします。
    *   **Action**: 全ての機能追加・UI実装において、以下の3環境での「美しさ」と「機能性」を確認・保証することを**最重要義務**とします。
        1.  **SP (Mobile)**: 縦持ち (Width < 640px)
        2.  **Tablet**: 縦持ち・横持ち (Width 768px ～ 1280px) ※特にiPad縦での崩れに注意。
        3.  **PC (Desktop)**: フルサイズ (Width > 1280px)
    *   **Checklist**:
        *   要素が重なっていないか？（Overlap）
        *   文字が小さすぎる、または大きすぎて溢れていないか？（Scaling）
        *   タッチ操作（Touch）とマウス操作（Hover）の両方が快適か？
        *   特定のデバイス幅（768px～1024pxの中間域）でレイアウトが破綻していないか？


## 6. アクセシビリティと包括性 (Accessibility & Inclusivity)
*   **WCAG 2.1 AA基準 (WCAG 2.1 AA Standard)**:
    *   **コントラスト (Contrast)**: テキストと背景のコントラスト比は最低 **4.5:1** を確保します。
    *   **スケーリング (Scale)**: フォントサイズはユーザー設定（Dynamic Type / Text Scaling）に追従しなければなりません。
*   **タッチ領域 (Touch Targets - Mobile First)**:
    *   **ルール**: すべてのインタラクティブ要素は最低 **44x44dp (iOS) / 48x48dp (Android)** のタッチ領域を確保します。
    *   **到達性 (Reachability)**: 頻繁に使用するアクションは画面下部（親指の届く範囲）に配置します。
    *   **The Fat Finger Protocol (Label Wrapping)**:
        *   **Law**: チェックボックスやラジオボタンを単体で配置することを禁止します。
        *   **Action**: 必ず `<label>` タグ（または `shadcn/ui` の `Label` コンポーネント）でテキストごとラップし、タッチ有効領域を最大化してください。「文字を押しても反応しない」はバグです。
*   **セマンティクス (Semantics)**:
    *   すべてのカスタムコンポーネントには、スクリーンリーダー（TalkBack/VoiceOver）用の適切なセマンティックラベルを付与します。画像には必ず `alt` テキストを設定します。
*   **A11y Legal Defense (ADA/EAA Compliance)**:
    *   **Risk**: アクセシビリティ対応不足は、米国障害者法 (ADA Title III) や欧州アクセシビリティ法 (EAA) に基づく訴訟リスクを生じます。
    *   **Mandate**: `aria-label` の欠如、コントラスト比不足は「バグ」ではなく「法的瑕疵」として扱います。CIでの自動チェックに加え、四半期に一度のスクリーンリーダー（VoiceOver/NVDA等）による実機検証を義務付けます。
*   **A11y Zero Tolerance CI (Build Gate)**:
    *   **Mandate**: `axe-core` または `pa11y-ci` をCIパイプラインに組み込み、レベル `critical` および `serious` の違反が1つでも検出された場合、**ビルドを強制失敗**させます。
    *   **Exemption**: UIライブラリ内部の修正不可能な外部要因に限り、理由を文書化した上で例外リスト（Ignore Config）への追加を許可します。
*   **Non-Color Indication Protocol (色に依存しない情報伝達)**:
    *   **Law**: エラー表示や重要情報は、**色だけ**に依存してはなりません。色覚多様性を持つユーザーが情報を見落とします。
    *   **Action**: 必ずアイコン（⚠️、✅、❌）やテキスト（「必須」「エラー」「成功」）を**併用**し、色＋アイコン＋テキストの**三重伝達**を標準としてください。
*   **Font Size & Zoom Protocol (フォントサイズとズーム)**:
    *   **rem Mandate**: `font-size` は `rem` 単位で指定し、ユーザーのブラウザ設定を尊重します。`px` 固定は `:root` レベルのみ許可します。
    *   **Zoom Resilience**: ブラウザのズーム機能（**200%**）でレイアウトが崩れないように設計してください。コンテンツの切れや重なりはバグとして扱います。
*   **Tab Order Protocol (キーボードナビゲーション順序)**:
    *   **Law**: DOM順序とタブ順序を一致させます。`tabindex` の正値（例: `tabindex="5"`）は**禁止**です。
    *   **Allowed**: `tabindex="0"`（自然なタブ順に追加）と `tabindex="-1"`（プログラムからのフォーカスのみ）のみ許可します。
    *   **Escape Key**: モーダルやドロップダウンは `Escape` キーで閉じられなければなりません。
*   **Skip Link Protocol (スキップナビゲーション)**:
    *   **Mandate**: ページの冒頭に **「メインコンテンツへスキップ」** リンクを実装してください。
    *   **Implementation**: 通常は非表示、フォーカス時のみ可視化する `sr-only` + `:focus` パターンを使用します。
*   **ARIA Attributes Standard (ARIA属性基準)**:
    *   **aria-live**: 動的に変化するコンテンツ（トースト通知、カウントダウン等）には `aria-live="polite"` を設定し、スクリーンリーダーに変更を通知します。
    *   **aria-expanded / aria-controls**: アコーディオンやドロップダウンには、開閉状態を示す `aria-expanded` と制御対象を示す `aria-controls` を設定します。
    *   **First Rule of ARIA**: セマンティックHTMLで十分な場合はARIAを使わないでください。過剰なARIAはかえって混乱を招きます。
*   **Label Association Protocol (ラベル関連付け)**:
    *   **Mandate**: すべての入力フィールドに `<label>` を `htmlFor` 属性で関連付けてください。
    *   **Placeholder-Only Prohibition**: `placeholder` をラベルの代替にすることは厳禁です。プレースホルダーはフォーカス時に消えるため、ユーザーが入力の目的を見失います。
*   **Error Notification Protocol (フォームエラー通知)**:
    *   **Mandate**: フォームエラーは `aria-live="assertive"` で即座にスクリーンリーダーに通知します。
    *   **Association**: エラーメッセージはフィールドの直下に配置し、`aria-describedby` でフィールドと関連付けてください。
    *   **Clarity**: エラーメッセージは「どのフィールド」に不備があるかを**明確に**示さなければなりません。
*   **Required Fields Protocol (必須フィールド明示)**:
    *   **ARIA**: 必須フィールドには `aria-required="true"` を設定します。
    *   **Visual**: 視覚的にも「必須」ラベルまたは `*` マーク + テキストで明示してください（色だけに依存しない: Non-Color Indication Protocol準拠）。
*   **Lighthouse Score Gate (品質ゲート)**:
    *   **Mandate**: Lighthouse Accessibility Score **90点以上** を**デプロイ要件**とします。90点未満のページはバグとして扱います。
    *   **Manual Testing**: 定期的にキーボードのみでのサイト操作テスト、スクリーンリーダー（VoiceOver / NVDA）での読み上げ確認、および200%ズームテストを実施してください。

## 7. ユーザー主権 (User Sovereignty - User First)
*   **データ所有権 (Data Ownership)**:
    *   ユーザーは自分のデータを完全にコントロールできる権利を持ちます。「エクスポート」「完全削除」はわかりやすい場所に配置します。
*   **ダークパターンの禁止 (No Dark Patterns)**:
    *   ユーザーを欺くデザイン（退会を隠す、勝手にカートに追加する等）は厳禁です。
    *   **喜びの指標 (Delight Metric)**: ユーザーが「操作していて楽しい」と感じる瞬間（Micro-delights）を意図的に設計します。
*   **透明性 (Transparency)**:
    *   AIの判断根拠や、なぜそのコンテンツが表示されたかをユーザーが理解できるようにします（Explainable AI）。

## 8. ツールとワークフロー (Tools & Workflow)
*   **Figma**: 信頼できる唯一の情報源（Source of Truth）。正確なトークンのハンドオフにはDev Modeを使用します。
*   **Rive / Lottie**: コードベースのアニメーションが複雑すぎる場合は、**Rive**（ステートマシン付きベクターアニメーション）を使用します。
*   **インクルーシブ・コピーライティング (Inclusive Copywriting)**:
    *   性別、人種、年齢、能力に関わらず、誰もが排除されない言葉選び（Inclusive Language）を行います。

## 9. AI UX戦略 (AI UX Strategy - Latency Management)
*   **ストリーミング・ファースト (Streaming First)**:
    *   AIの生成待ち時間は「体感ゼロ」でなければなりません。
    *   **ストリーミング応答 (Streaming Responses)**: 回答が完了するのを待たず、1トークンずつリアルタイムに表示します（タイピングアニメーション）。
*   **楽観的更新 (Optimistic Updates)**:
    *   ユーザーのアクション（送信ボタン押下など）に対しては、AIの処理を待たずに即座にUIを反応させます（チャットバブルの即時表示など）。
*   **透明性 (Transparency)**:
    *   AIが「考えている」状態（Thinking...）と「書いている」状態（Generating...）を視覚的に区別し、ユーザーに安心感を与えます。

## 10. ユーザーオンボーディングとガイド (User Onboarding & Guidance)
*   **コーチマーク (Coach Marks)**:
    *   **コンテキスト重視**: ユーザーが初めてその画面を訪れた時、または新しい機能が追加された時のみ表示します。
    *   **UIパターン**: 添付画像のように、対象の要素（ボタン等）をハイライトし、吹き出し（Tooltip）で簡潔な説明とアクション（「記録」など）を提示します。
    *   **スキップ可能**: ユーザーが強制的にチュートリアルを見せられるストレスを避けるため、必ず「スキップ」または「閉じる」手段を提供します。
*   **機能発見 (Feature Discovery)**:
    *   **プログレッシブ・ディスクロージャー**: 全ての機能を一度に説明せず、ユーザーの習熟度に合わせて徐々に高度な機能を提示します。
    *   **エンプティステート (Empty States)**: データがない状態（Zero Data）を「エラー」ではなく「オンボーディングの機会」と捉えます。「記録がありません」だけでなく、「最初の記録を追加しましょう」という明確なCall to Action (CTA) を配置します。
*   **一般消費者視点 (General Consumer Perspective)**:
    *   **専門用語禁止**: UI上のテキストには「データベース」「同期」「API」などの技術用語を一切使用しません。「保存」「更新」「連携」など、誰でもわかる言葉を選びます。
    *   **直感性**: 「説明書を読まなくても使える」をゴールとします。アイコンには必ずラベルを併記し、意味の曖昧さを排除します。
    *   **Focus Ring Protocol (Rule 0.99: Accessibility Sight)**:
        *   **Law**: フォーカス状態（Tabキー操作等）が視覚的に認識できないUIは、キーボードユーザーにとって「暗闇の迷路」であり、アクセシビリティ上の敗北です。
        *   **Action**: ブラウザ標準のフォーカスリングを消去（`outline-none`）した場合は、必ず代替となる**高コントラストなフォーカスリング**（例: `ring-2 ring-primary ring-offset-2`）を再定義してください。「見えないフォーカス（Invisible Focus）」はバグとして扱います。
    *   **Micro-Interaction Standards**:
        *   **Cursor Affordance Mandate**: クリックでアクションが発生する全ての要素（カード、デイトピッカー、カスタム入力欄等）には、ホバー時に必ず **`cursor-pointer`** を適用し、アフォーダンスを明確にしてください。
        *   **Hover State Fidelity**: インタラクティブなカードには、ホバー時に背景色の微変やわずかな浮浮（`shadow-md`）を付与し、その要素が「反応する」ことをユーザーの潜在意識に伝えなさい。
        *   **Clipboard Interaction Protocol (Copy Feedback)**: URLやコードの「コピー」アクション成功時は、必ず **トースト通知** または **アイコン変化（チェックマーク等）** を即座に表示し、ユーザーに成功を明示してください。`navigator.clipboard` が失敗する環境（非HTTPS等）では、テキスト選択状態にして手動コピーを促すフォールバックを実装します。
        *   **Input Reflection Protocol (Real-time Label Sync)**: アコーディオン等の開閉UIにおいて、内部の入力フィールド（`name`, `title`等）の変更は、親コンポーネント（リストビューやアコーディオンヘッダー）に**リアルタイムで反映**させなければなりません。「保存するまでタイトルが変わらない」挙動は、管理画面においてはUXの遅延（ラグ）として認知されます。
    *   **Code Input Standard (Rule 14.12)**:
        *   **Law**: HTML/CSS/JSON等のコード編集が必要な箇所で、生の `textarea` を使用することは、シンタックスハイライトがなくミスを誘発し、品質を著しく損なうため厳禁です。
        *   **Action**: 必ず `react-simple-code-editor` (+ `prismjs`) などのエディタコンポーネントを使用し、プロフェッショナルな品質を提供してください。生の `Textarea` の使用は未完成とみなします。
    *   **The Microcopy Quality Protocol (Kindness First)**:
        *   **Law (No Blame)**: エラーメッセージはユーザーを「責める」のではなく「助ける」文言にしてください。
            *   **NG**: "不正な入力です (Invalid Input)"
            *   **OK**: "メールアドレスの形式で入力してください" / "半角英数字のみ使用できます"
        *   **Law (Safety Warning)**: 削除確認などの危険操作では、**不可逆性を強調する言葉**（「この操作は取り消せません」）を赤色UIと共に添えてください。
    *   **The Explicit Explanation Protocol (Zero Jargon / Tooltip Mandate)**:
        *   **Law**: 開発者にとっての「常識（API, Webhook, MRR等）」は、ユーザーにとっては「謎の記号」です。これらに説明がないことは、ツールとしての敗北を意味します。
        *   **Action**: 
            1. **No Jargon**: UI上のテキストには極力専門用語を使用せず、誰でもわかる言葉を選びます。
            2. **Tooltip Mandate**: どうしても専門用語や計算値（MRR等）が必要な場合は、必ず **`Info` アイコンと `Tooltip`** を付与し、「それが何であり、どう計算され、ビジネスにどう影響するか」を非エンジニアの言葉で解説してください。
            3. **Completion**: Tooltipの実装完了をもって、その機能の「完成」とみなします。

## 11. 安全なUIプロトコル (Safety UI Protocols)
*   **No Native Popups**:
    *   `window.alert`, `confirm`, `prompt` の使用を禁止します。スレッドをブロックしUXを損なうため、必ず `Dialog` コンポーネントを使用します。
*   **Destructive Actions**:
    *   **Magic Word**: データの完全削除など、取り返しのつかない操作には、「OK」ボタンではなく、「delete」等の**マジックワード入力**を求める確認ダイアログを実装します。
*   **Dirty Check**:
    *   未保存の変更がある状態での離脱に対し、「変更が失われます」という警告を表示します。
*   **Loading Lock Protocol (Double-Submit Prevention)**:
    *   **Law**: フォーム送信中や非同期処理中にボタンが押せる状態を放置することは、データの二重登録やRace Conditionの原因となり厳禁です。
    *   **Action**: 処理中 (`isLoading`) はボタンを `disabled` 属性で無効化し、視覚的にもグレーアウトまたはスピナーを表示してください。重大な副作用を伴うアクションでは `pointer-events-none` を併用し、物理的なクリックを遮断します。
*   **Responsive Action Button Protocol**:
    *   **Mobile**: 重要なアクションボタン（登録、保存、購入等）は `w-full`（画面幅いっぱい）で押しやすくします。
    *   **Desktop**: `w-auto` かつ十分な最小幅を確保し、**中央配置** とします。PCで `w-full` にして間延びさせることは禁止です。
    *   **Affordance**: 影 (`shadow-md`) やホバーエフェクトを付与し、「押せる感」を演出します。

## 12. おもてなしUX (Omotenashi UX - Japanese Hospitality)
*   **気が利く (Kigakiku - Anticipatory Design)**:
    *   **先回り**: ユーザーが困る前に、ニーズを先読みして解決策を提示します。
    *   **例**: フォーム入力でエラーが出た瞬間、単に赤くするのではなく、「全角になっています。半角に修正しますか？」と修正ボタンを提示します。
*   **間 (Ma - Negative Space)**:
    *   **余白の美学**: シリコンバレーの「情報の密度」と、日本の「間（余白）」を融合させます。余白は単なるスペースではなく、ユーザーに「思考の時間」を与えるための機能です。
*   **相槌 (Aizuchi - Reassuring Feedback)**:
    *   **反応**: ユーザーのあらゆるアクション（タップ、スクロール、入力）に対して、視覚的または触覚的（Haptics）な「相槌」を返します。「あなたの操作は正しく伝わっていますよ」という安心感を常に与え続けます。
*   **The Graceful Error Recovery Protocol (謝罪と導線の義務)**:
    *   **Law**: 予期せぬエラー発生時には、事実を伝えるだけでなく、ユーザーへの共感を表現し、**次にユーザーが取るべきアクション**（再読込、ホームに戻る、問い合わせる等）の導線ボタンを必ず添えてください。
    *   **Action**: エラーページやエラーモーダルには、原因の簡潔な説明と共に、最低1つの回復アクションボタンを配置してください。「行き止まり（Dead End）」のエラー画面は、ユーザーの離脱を加速させるUXの敗北です。

## 13. デザインOpsとツール連携 (Design Ops & Tools)
*   **デザインシステム (Design System)**:
    *   **Single Source of Truth**: Figma上のデザインシステム（Styles, Variables, Components）を唯一の正解とします。コード（Tailwind Config）は常にFigmaに従属します。
*   **ツール連携プロトコル (Tool Usage Protocol)**:
    *   **Figma (UI/UX)**: エンジニアは必ず **Dev Mode** を使用してプロパティを確認します。目分量での実装は厳禁です。
    *   **Adobe Creative Cloud**: ロゴや複雑なグラフィックにはPhotoshop/Illustratorを使用し、SVGまたはWebPとしてFigmaに配置します。
    *   **Canva**: OGPや社内資料などの「非プロダクトUI」にはCanvaを積極的に使用し、テンプレート化して効率化します。
*   **ハンドオフ (Hand-off)**:
    *   **ステータス管理**: Figma上の各フレームには「Draft」「Ready for Dev」「Shipped」のステータスを明記します。
    *   **エクスポート**: 画像は原則として **WebP** または **SVG** でエクスポートします。PNG/JPGは特別な理由がない限り使用しません。



## 14. インタラクション安全プロトコル (Interaction Safety Protocols)

### 14.1. The Responsive Safety Protocol (No-Trap Mandate)
*   **Law**: PCとSPではインタラクションの物理法則が異なります。
*   **Action**:
    1.  **SP (Drawer Safety)**: Drawer内のスクロール領域には `data-vaul-no-drag` を付与し、誤閉鎖を防ぎます。
    2.  **PC (Viewport Safety)**: Popover等の浮動要素には必ず `max-height` を設定し、画面外へのはみ出しを防ぎます。
    3.  **Responsive Split**: モバイルでは `Drawer`、PCでは `Popover` を使い分ける実装を標準とします。

### 14.2. The Mobile Click/Tap Fix
*   **Law**: モバイル上のPopover等は、フォーカス制御の競合によりタップイベントを拾えない場合があります。
*   **Action**: インタラクティブ要素（リスト項目等）には `pointer-events-auto` を強制し、`onClick` / `onMouseDown` / `onPointerUp` などの多重バインディングでイベント発火を保証します。
*   **Combobox Interaction Protocol**:
    *   **Stable IDs**: 仮想リスト（CMDK等）の `value` 属性には、必ず一意かつ不変な **ASCII文字列**（ID等）を使用してください。日本語を使用すると選択ロジック（フィルタリング）が誤動作します。
    *   **Searchability**: 日本語での検索が必要な場合は、`keywords` プロパティ（配列）を明示的に指定して検索性を担保します。

### 14.3. The Z-Index Stratification Protocol
*   **Law**: Z-Indexの戦いに終止符を打ちます。
    *   **Level 4 (Max)**: `z-[10000]` - Overlay Components (Select, Popover, Tooltip, Calendar) ※Modalより上
    *   **Level 3**: `z-[9999]` - Dialog / Modal
    *   **Level 2**: `z-[1000]` - Full Screen UI (Mobile Menu, Drawer)
    *   **Level 1**: `z-50` - Fixed Header, Floating Buttons
    *   **Level 0**: `z-0` ~ `z-40` - Page Content
*   **Action**: 恣意的な `z-100` などのマジックナンバーを禁止します。この階層構造を厳守してください。
