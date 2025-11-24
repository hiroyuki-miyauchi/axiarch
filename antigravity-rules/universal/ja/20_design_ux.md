# 20. デザインとUX戦略 (Design & UX Strategy)

## 1. デザイン哲学 (Philosophy: "Silicon Valley Excellence & Google First")

### 1.1. 圧倒的な「Wow」体験 (The "Wow" Factor - Delight)
*   **必須要件 (Mandate)**: すべてのインタラクションは「生きている」と感じさせなければなりません。静的な画面ではなく、**動的な体験**を構築します。
*   **Google標準 (Google Standard)**: **Material Design 3 (Material You)** およびその進化形である **"Expressive"** (2025+) をベースラインとして採用します。
*   **Apple標準 (Apple Standard)**: iOSにおいては、**Human Interface Guidelines (HIG)** を尊重します。Material Designを無理やり適用せず、プラットフォーム固有の操作感（Platform Fidelity）を維持します（例: スイッチ、ピッカー）。
*   **差別化 (Differentiation)**: Googleのシステムを使用しつつ、**高精度のモーション**、**カスタムシェーダー**、**大胆なタイポグラフィ**によって差別化し、「シリコンバレーのプレミアム感」を演出します。
*   **ツール連携 (Tools)**: Figma, Adobe, Canvaの具体的な運用ルールについては `21_design_ops_tools.md` を参照してください。

### 1.2. トレンドスカウティング・プロトコル (Trend Scouting Protocol)
*あらゆる*デザインタスク（単一のコンポーネントであっても）の前に、以下の「スカウティング・ループ」を義務付けます：
1.  **リーダー分析 (Analyze Leaders)**: **Mobbin** (iOS/Androidのフロー)、**Awwwards** (Webトレンド)、**Google Design** (最新仕様) を確認します。
2.  **解剖 (Deconstruct)**: トップティアのアプリがなぜ「心地よい」のかを解剖します（例：「このモーダルのバウンスが遊び心を演出している」）。
3.  **適用 (Apply)**: その「感覚（Soul）」を我々のコンテキストに適応させます。**盲目的にコピーするのではなく、インタラクションの「魂」を盗みます。**
4.  **AI活用 (AI Leverage)**: 生成AIを使用して、標準的なUIコンポーネントの「未来的」なバリエーションをブレインストーミングします。

## 2. ビジュアル言語とシステム (Visual Language & System)

### 2.1. Material 3 Expressive
*   **ダイナミックカラー (Dynamic Color)**: `dynamic_color`エンジンを活用し、ユーザーの壁紙/OSと調和させますが、重要なアクションには高コントラストなオーバーライドを強制します。
*   **形状 (Shapes)**: **Expressive Shapes**（非対称の角、モーフィングするコンテナ）を使用し、「箱型」のグリッドを打破します。
*   **タイポグラフィ (Typography)**: バリアブルフォント（Roboto Flex, Interなど）を使用し、インタラクション中に太さや幅をアニメーションさせます。

### 2.2. モーションとジェスチャー (Motion & Gestures - The "Soul")
*   **物理ベース (Physics-Based)**: すべてのアニメーションは**スプリング物理**（剛性/減衰）を使用します。要素は弾み、伸び、わずかに潰れるべきです。
*   **ジェスチャー (Swipe First)**:
    *   **ナビゲーション (Navigation)**: 「スワイプバック」を普遍的にサポートします。
    *   **アクション (Actions)**: リスト項目には**Swipe-to-Action**（アーカイブ、削除など）を使用します。
    *   **感触 (Feel)**: ジェスチャーは指の動きに 1:1 で追従しなければなりません。ラグは厳禁です。閾値を超えた際の確認には**ハプティクス**（軽い振動）を使用します。
*   **マイクロインタラクション (Micro-interactions)**:
    *   **ボタン (Buttons)**: 押下時に縮小 (`0.95x`) し、離すとバウンスして戻ります。
    *   **リスト (Lists)**: スタッガード（滝のような）エントランスアニメーションを採用します。
    *   **遷移 (Transitions)**: 単純なプッシュ遷移ではなく、**Container Transforms**（カードがページに拡大する）を使用します。
*   **スライダーとカルーセル (Sliders & Carousels)**:
    *   **スナップ物理**: スクロールは必ずスナップポイントに吸着させます。中途半端な位置で止まることを防ぎます。
    *   **パララックス**: スワイプに合わせて背景や要素を視差効果（Parallax）で動かし、奥行きを表現します。

## 3. デザインシステム運用 (Design System Ops)

### 3.1. 拡張性と保守性 (Scalability & Maintenance)
*   **アトミックデザイン (Atomic Design)**: Atomic Design（Atoms -> Molecules -> Organisms）を厳守します。
*   **トークン化 (Tokenization)**: すべての色、スペーシング、タイポグラフィはトークン化します。**ハードコードされた値は禁止です。**
*   **コンポーネント管理 (Component Governance)**: 新しいコンポーネントを作成する前に、既存のものが拡張できないか確認します。「コンポーネントの肥大化（Bloat）」を避けます。

### 3.2. パフォーマンスとコスト意識 (Performance & Cost Awareness)
*   **描画コスト (Render Cost)**: 重いエフェクト（Blur, Shadows）は慎重に使用します。ローエンドデバイスでのテストを義務付けます。
    *   *ルール*: ブラーがフレーム落ちを引き起こす場合は、半透明のスクリム（Scrim）に置き換えます。
*   **アセット最適化 (Asset Optimization)**: ラスター画像よりも**ベクター（SVG/Lottie/Rive）**を優先します。ラスターが必要な場合は**WebP**を使用し、遅延読み込み（Lazy Load）します。
*   **バッテリーへの影響 (Battery Impact)**: ユーザーが操作していない状態での無限ループアニメーションは避けます（バッテリー消費抑制）。

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
