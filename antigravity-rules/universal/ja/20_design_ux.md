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

### 1.2. トレンドスカウティング・プロトコル (Trend Scouting Protocol)
*あらゆる*デザインタスク（単一のコンポーネントであっても）の前に、以下の「スカウティング・ループ」を義務付けます：
1.  **リーダー分析 (Analyze Leaders)**: **Mobbin** (iOS/Androidのフロー)、**Awwwards** (Webトレンド)、**Google Design** (最新仕様) を確認します。
2.  **解剖 (Deconstruct)**: トップティアのアプリがなぜ「心地よい」のかを解剖します（例：「このモーダルのバウンスが遊び心を演出している」）。
3.  **適用 (Apply)**: その「感覚（Soul）」を我々のコンテキストに適応させます。**盲目的にコピーするのではなく、インタラクションの「魂」を盗みます。**
4.  **AI活用 (AI Leverage)**: 生成AIを使用して、標準的なUIコンポーネントの「未来的」なバリエーションをブレインストーミングします。

## 2. デザインエンジニアリング (Design Engineering)

### 2.1. デザイン・トークン (Design Tokens)
*   **Single Source of Truth**: 色、スペーシング、タイポグラフィ、シャドウ、角丸などの全てのデザイン値は、FigmaのVariablesで定義し、コード（Tailwind Config / CSS Variables）と100%同期させます。
*   **ハードコード禁止**: `px` や `#hex` を直接コードに書くことは**厳禁**です。必ずトークン（例: `color-primary-500`, `spacing-4`）を使用します。
*   **Dynamic Theme**: テーマ設定 (`site_settings`) は、Runtime (`RootLayout`) でDBから取得し、CSS変数として注入します。

## 2. コンポーネント実装ガイド (Component Guidelines)
### 2.1. Implementation Patterns
*   **Skeleton Loader**:
    *   データ読み込み中（Suspense）は、スピナーではなく **Skeleton Screen** (`<Skeleton />`) を使用し、レイアウトシフト（CLS）を防ぎます。
*   **Feedback Hierarchy**:
    *   **Toast**: 成功・通知（非同期）。
    *   **Inline Alert**: 文脈依存のエラー。
    *   **Modal Dialog**: 重要な警告。`z-[9999]` で最前面に表示。
*   **Optimistic UI (楽観的更新)**:
    *   いいね等の軽量アクションは、サーバー応答を待たずに即座に表示更新し、ネイティブアプリ並みの応答速度を実現します。

### 2.2. Layout Architecture
*   **The Natural Scrolling Protocol**:
    *   `h-screen` + `overflow-scroll` による独自スクロールコンテナを禁止し、`min-h-screen` によるブラウザネイティブスクロールを採用します。
*   **The Single Container Protocol**:
    *   Layoutがコンテナ (`container`) を提供する場合、Page側での再定義（二重パディング）を厳禁とします。
*   **Navigation Standards**:
    *   **Breadcrumb Priority**: パンくずリストは「命綱」であり、モバイル・PC問わず**必ずページ最上部**に配置します。モバイルではアクションボタンと縦積み（Stack）にします。
    *   **Extension Defense**: グローバルナビゲーション（Link）には `suppressHydrationWarning` を付与し、ブラウザ拡張機能によるDOM改変から保護します。

### 2.2. モーションとジェスチャー (Motion & Gestures - The "Soul")
*   **物理ベース (Physics-Based)**: すべてのアニメーションは**スプリング物理**（剛性/減衰）を使用します。要素は弾み、伸び、わずかに潰れるべきです。
*   **ジェスチャー (Swipe First)**:
    *   **ナビゲーション (Navigation)**: 「スワイプバック」を普遍的にサポートします。
    *   **アクション (Actions)**: リスト項目には**Swipe-to-Action**（アーカイブ、削除など）を使用します。
    *   **感触 (Feel)**: ジェスチャーは指の動きに 1:1 で追従しなければなりません。ラグは厳禁です。

### 2.3. 五感のデザイン (Multi-Sensory Design)
*   **ハプティクス (Haptics)**:
    *   **触覚フィードバック**: 成功（Success）、失敗（Error）、選択（Selection）、衝突（Impact）の各イベントに対して、iOS/Androidのネイティブハプティクスパターンを割り当てます。
    *   **繊細さ**: 「ブブッ」という不快な振動ではなく、「コツッ」「コンッ」という繊細で高級感のあるフィードバックを追求します。
*   **ソニック・ブランディング (Sonic Branding)**:
    *   **サウンドロゴ**: アプリ起動時や重要な達成時（コンバージョン）には、ブランドを象徴する短いサウンド（サウンドロゴ）を再生し、記憶に残る体験を作ります。
    *   **UIサウンド**: ボタン押下やトグル切り替えにも、邪魔にならない微細なサウンド（Click, Pop）を付与します（設定でOFF可能にする）。

## 3. パフォーマンス・アニメーション (Performance Animation)
*   **60fps (120fps) ターゲット**:
    *   アニメーションは常に60fps（可能なら120fps）を維持しなければなりません。
    *   **GPU最適化**: `transform` と `opacity` プロパティのみをアニメーションさせます。`width`, `height`, `top`, `left` のアニメーションはレイアウト再計算（Reflow）を引き起こすため禁止します。
    *   **Will-Change**: 必要な場合のみ `will-change` プロパティを使用し、ブラウザにヒントを与えますが、乱用は避けます（メモリ消費増大のため）。

## 4. 適応性とフォルダブル (Adaptability & Foldables)

### 4.1. ユニバーサル・レスポンシブ (Universal Responsiveness)
*   **ルール**: 「モバイルファースト」は死語です。我々は **"Any-Screen"**（あらゆる画面）のためにデザインします。
*   **フォルダブル (Foldables)**:
    *   **ヒンジ認識 (Hinge Awareness)**: UIはヒンジを認識し、賢く分割されなければなりません（テーブルトップモード）。
    *   **連続性 (Continuity)**: 折りたたみ/展開時に、状態（State）は完全に保持されなければなりません。
*   **大画面 (Large Screens)**: **Canonical Layouts**（リスト詳細、サポートペイン、フィード）を使用し、余白を有効活用します。単にモバイルUIを「引き伸ばす」ことは禁止します。

## 5. アクセシビリティと包括性 (Accessibility & Inclusivity)
*   **WCAG 2.1 AA基準 (WCAG 2.1 AA Standard)**:
    *   **コントラスト (Contrast)**: テキストと背景のコントラスト比は最低 **4.5:1** を確保します。
    *   **スケーリング (Scale)**: フォントサイズはユーザー設定（Dynamic Type / Text Scaling）に追従しなければなりません。
*   **タッチ領域 (Touch Targets - Mobile First)**:
    *   **ルール**: すべてのインタラクティブ要素は最低 **44x44dp (iOS) / 48x48dp (Android)** のタッチ領域を確保します。
    *   **到達性 (Reachability)**: 頻繁に使用するアクションは画面下部（親指の届く範囲）に配置します。
*   **セマンティクス (Semantics)**:
    *   すべてのカスタムコンポーネントには、スクリーンリーダー（TalkBack/VoiceOver）用の適切なセマンティックラベルを付与します。画像には必ず `alt` テキストを設定します。

## 6. ユーザー主権 (User Sovereignty - User First)
*   **データ所有権 (Data Ownership)**:
    *   ユーザーは自分のデータを完全にコントロールできる権利を持ちます。「エクスポート」「完全削除」はわかりやすい場所に配置します。
*   **ダークパターンの禁止 (No Dark Patterns)**:
    *   ユーザーを欺くデザイン（退会を隠す、勝手にカートに追加する等）は厳禁です。
    *   **喜びの指標 (Delight Metric)**: ユーザーが「操作していて楽しい」と感じる瞬間（Micro-delights）を意図的に設計します。
*   **透明性 (Transparency)**:
    *   AIの判断根拠や、なぜそのコンテンツが表示されたかをユーザーが理解できるようにします（Explainable AI）。

## 7. ツールとワークフロー (Tools & Workflow)
*   **Figma**: 信頼できる唯一の情報源（Source of Truth）。正確なトークンのハンドオフにはDev Modeを使用します。
*   **Rive / Lottie**: コードベースのアニメーションが複雑すぎる場合は、**Rive**（ステートマシン付きベクターアニメーション）を使用します。
*   **インクルーシブ・コピーライティング (Inclusive Copywriting)**:
    *   性別、人種、年齢、能力に関わらず、誰もが排除されない言葉選び（Inclusive Language）を行います。

## 8. AI UX戦略 (AI UX Strategy - Latency Management)
*   **ストリーミング・ファースト (Streaming First)**:
    *   AIの生成待ち時間は「体感ゼロ」でなければなりません。
    *   **ストリーミング応答 (Streaming Responses)**: 回答が完了するのを待たず、1トークンずつリアルタイムに表示します（タイピングアニメーション）。
*   **楽観的更新 (Optimistic Updates)**:
    *   ユーザーのアクション（送信ボタン押下など）に対しては、AIの処理を待たずに即座にUIを反応させます（チャットバブルの即時表示など）。
*   **透明性 (Transparency)**:
    *   AIが「考えている」状態（Thinking...）と「書いている」状態（Generating...）を視覚的に区別し、ユーザーに安心感を与えます。

## 9. ユーザーオンボーディングとガイド (User Onboarding & Guidance)
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
    *   **Micro-Interaction Standards**:
        *   **Cursor Affordance**: クリック可能な要素（カード、独自入力欄含む）は、ホバー時に必ず `cursor-pointer` を適用し、アフォーダンスを明確にします。

## 10. 安全なUIプロトコル (Safety UI Protocols)
*   **No Native Popups**:
    *   `window.alert`, `confirm`, `prompt` の使用を禁止します。スレッドをブロックしUXを損なうため、必ず `Dialog` コンポーネントを使用します。
*   **Destructive Actions**:
    *   **Magic Word**: データの完全削除など、取り返しのつかない操作には、「OK」ボタンではなく、「delete」等の**マジックワード入力**を求める確認ダイアログを実装します。
*   **Dirty Check**:
    *   未保存の変更がある状態での離脱に対し、「変更が失われます」という警告を表示します。

## 10. おもてなしUX (Omotenashi UX - Japanese Hospitality)
*   **気が利く (Kigakiku - Anticipatory Design)**:
    *   **先回り**: ユーザーが困る前に、ニーズを先読みして解決策を提示します。
    *   **例**: フォーム入力でエラーが出た瞬間、単に赤くするのではなく、「全角になっています。半角に修正しますか？」と修正ボタンを提示します。
*   **間 (Ma - Negative Space)**:
    *   **余白の美学**: シリコンバレーの「情報の密度」と、日本の「間（余白）」を融合させます。余白は単なるスペースではなく、ユーザーに「思考の時間」を与えるための機能です。
*   **相槌 (Aizuchi - Reassuring Feedback)**:
    *   **反応**: ユーザーのあらゆるアクション（タップ、スクロール、入力）に対して、視覚的または触覚的（Haptics）な「相槌」を返します。「あなたの操作は正しく伝わっていますよ」という安心感を常に与え続けます。
## 11. デザインOpsとツール連携 (Design Ops & Tools)
*   **デザインシステム (Design System)**:
    *   **Single Source of Truth**: Figma上のデザインシステム（Styles, Variables, Components）を唯一の正解とします。コード（Tailwind Config）は常にFigmaに従属します。
*   **ツール連携プロトコル (Tool Usage Protocol)**:
    *   **Figma (UI/UX)**: エンジニアは必ず **Dev Mode** を使用してプロパティを確認します。目分量での実装は厳禁です。
    *   **Adobe Creative Cloud**: ロゴや複雑なグラフィックにはPhotoshop/Illustratorを使用し、SVGまたはWebPとしてFigmaに配置します。
    *   **Canva**: OGPや社内資料などの「非プロダクトUI」にはCanvaを積極的に使用し、テンプレート化して効率化します。
*   **ハンドオフ (Hand-off)**:
    *   **ステータス管理**: Figma上の各フレームには「Draft」「Ready for Dev」「Shipped」のステータスを明記します。
    *   **エクスポート**: 画像は原則として **WebP** または **SVG** でエクスポートします。PNG/JPGは特別な理由がない限り使用しません。

## 12. ユニバーサル・ビューティー・プロトコル (Universal Beauty Protocol)

### 12.1. The Responsive Mandate
*   **Law**: 全ての機能追加・UI実装において、以下の3環境での「美しさ（Beauty）」と「機能性（Functionality）」を確認・保証することを**最重要義務**とします。
    1.  **SP (Mobile)**: 縦持ち (Width < 640px)
    2.  **Tablet**: 縦持ち・横持ち (Width 768px ~ 1280px) ※特にiPad縦での崩れに注意。
    3.  **PC (Desktop)**: フルサイズ (Width > 1280px)
*   **Action**: "PCで動くからOK" は厳禁です。レスポンシブデザインの不備は「未完成（Incomplete）」とみなします。

### 12.2. The Fragmented UI Lesson (統一性の欠如)
*   **Law**: 「似ているが違う」は最悪です。UIコンポーネント（パンくず、見出し、ボタン等すべて）は、その配置コンテキスト（Wrapper/Layout）まで含めて標準化しなければなりません。
*   **Action**: ページごとのアドホックなCSS調整を禁止します。サイト全体で一つの「正解（Gold Standard）」に従ってください。

### 12.3. The Mobile First Typography (文字サイズの適正化)
*   **Law**: PC基準の巨大なフォントサイズ（いきなり `text-3xl` 等）はモバイル画面を破壊します。
*   **Action**: 文字サイズは必ずモバイル基準（`text-xl`）から書き始め、`sm:` や `lg:` などのブレークポイントで拡大していく「モバイルファースト」な記述を徹底します。

## 13. インタラクション安全プロトコル (Interaction Safety Protocols)

### 13.1. The Responsive Safety Protocol (No-Trap Mandate)
*   **Law**: PCとSPではインタラクションの物理法則が異なります。
*   **Action**:
    1.  **SP (Drawer Safety)**: Drawer内のスクロール領域には `data-vaul-no-drag` を付与し、誤閉鎖を防ぎます。
    2.  **PC (Viewport Safety)**: Popover等の浮動要素には必ず `max-height` を設定し、画面外へのはみ出しを防ぎます。
    3.  **Responsive Split**: モバイルでは `Drawer`、PCでは `Popover` を使い分ける実装を標準とします。

### 13.2. The Mobile Click/Tap Fix
*   **Law**: モバイル上のPopover等は、フォーカス制御の競合によりタップイベントを拾えない場合があります。
*   **Action**: インタラクティブ要素（リスト項目等）には `pointer-events-auto` を強制し、`onClick` / `onMouseDown` / `onPointerUp` などの多重バインディングでイベント発火を保証します。

### 13.3. The Z-Index Stratification Protocol
*   **Law**: Z-Indexの戦いに終止符を打ちます。
    *   **Level 4 (Max)**: `z-[10000]` - Overlay Components (Select, Popover, Tooltip, Calendar) ※Modalより上
    *   **Level 3**: `z-[9999]` - Dialog / Modal
    *   **Level 2**: `z-[1000]` - Full Screen UI (Mobile Menu, Drawer)
    *   **Level 1**: `z-50` - Fixed Header, Floating Buttons
    *   **Level 0**: `z-0` ~ `z-40` - Page Content
*   **Action**: 恣意的な `z-100` などのマジックナンバーを禁止します。この階層構造を厳守してください。
