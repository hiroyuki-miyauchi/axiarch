# 20. Design & UX Strategy

## 1. Philosophy: "Silicon Valley Excellence & Google First"

### 1.1. The "Wow" Factor (Delight)
*   **Mandate**: すべてのインタラクションは「生きている」と感じさせなければならない。静的な画面ではなく、**動的な体験**を構築する。
*   **Google Standard**: **Material Design 3 (Material You)** およびその進化形である **"Expressive"** (2025+) をベースラインとして採用する。
*   **Differentiation**: Googleのシステムを使用しつつ、**高精度のモーション**、**カスタムシェーダー**、**大胆なタイポグラフィ**によって差別化し、「シリコンバレーのプレミアム感」を演出する。

### 1.2. Trend Scouting Protocol (Mandatory)
*あらゆる*デザインタスク（単一のコンポーネントであっても）の前に、以下の「スカウティング・ループ」を義務付ける：
1.  **Analyze Leaders**: **Mobbin** (iOS/Androidのフロー)、**Awwwards** (Webトレンド)、**Google Design** (最新仕様) を確認する。
2.  **Deconstruct**: トップティアのアプリがなぜ「心地よい」のかを解剖する（例：「このモーダルのバウンスが遊び心を演出している」）。
3.  **Apply**: その「感覚（Soul）」を我々のコンテキストに適応させる。**盲目的にコピーするのではなく、インタラクションの「魂」を盗む。**
4.  **AI Leverage**: 生成AIを使用して、標準的なUIコンポーネントの「未来的」なバリエーションをブレインストーミングする。

## 2. Visual Language & System

### 2.1. Material 3 Expressive
*   **Dynamic Color**: `dynamic_color`エンジンを活用し、ユーザーの壁紙/OSと調和させるが、重要なアクションには高コントラストなオーバーライドを強制する。
*   **Shapes**: **Expressive Shapes**（非対称の角、モーフィングするコンテナ）を使用し、「箱型」のグリッドを打破する。
*   **Typography**: バリアブルフォント（Roboto Flex, Interなど）を使用し、インタラクション中に太さや幅をアニメーションさせる。

### 2.2. Motion & Gestures (The "Soul")
*   **Physics-Based**: すべてのアニメーションは**スプリング物理**（剛性/減衰）を使用する。要素は弾み、伸び、わずかに潰れるべきである。
*   **Gestures (Swipe First)**:
    *   **Navigation**: 「スワイプバック」を普遍的にサポートする。
    *   **Actions**: リスト項目には**Swipe-to-Action**（アーカイブ、削除など）を使用する。
    *   **Feel**: ジェスチャーは指の動きに 1:1 で追従しなければならない。ラグは厳禁。閾値を超えた際の確認には**Haptics**（軽い振動）を使用する。
*   **Micro-interactions**:
    *   **Buttons**: 押下時に縮小 (`0.95x`) し、離すとバウンスして戻る。
    *   **Lists**: スタaggered（滝のような）エントランスアニメーションを採用する。
    *   **Transitions**: 単純なプッシュ遷移ではなく、**Container Transforms**（カードがページに拡大する）を使用する。

## 3. Design System Ops (Scalability & Performance)

### 3.1. Scalability & Maintenance
*   **Atomic Design**: Atomic Design（Atoms -> Molecules -> Organisms）を厳守する。
*   **Tokenization**: すべての色、スペーシング、タイポグラフィはトークン化する。**ハードコードされた値は禁止。**
*   **Component Governance**: 新しいコンポーネントを作成する前に、既存のものが拡張できないか確認する。「コンポーネントの肥大化（Bloat）」を避ける。

### 3.2. Performance & Cost Awareness
*   **Render Cost**: 重いエフェクト（Blur, Shadows）は慎重に使用する。ローエンドデバイスでのテストを義務付ける。
    *   *Rule*: ブラーがフレーム落ちを引き起こす場合は、半透明のスクリム（Scrim）に置き換える。
*   **Asset Optimization**: ラスター画像よりも**ベクター（SVG/Lottie/Rive）**を優先する。ラスターが必要な場合は**WebP**を使用し、Lazy Loadする。
*   **Battery Impact**: ユーザーが操作していない状態での無限ループアニメーションは避ける（バッテリー消費抑制）。

## 4. Adaptability & Foldables

### 4.1. Universal Responsiveness
*   **Rule**: 「モバイルファースト」は死語である。我々は **"Any-Screen"**（あらゆる画面）のためにデザインする。
*   **Foldables**:
    *   **Hinge Awareness**: UIはヒンジを認識し、賢く分割されなければならない（テーブルトップモード）。
    *   **Continuity**: 折りたたみ/展開時に、状態（State）は完全に保持されなければならない。
*   **Large Screens**: **Canonical Layouts**（リスト詳細、サポートペイン、フィード）を使用し、余白を有効活用する。単にモバイルUIを「引き伸ばす」ことは禁止する。

## 5. Accessibility (A11y)
*   **Non-Negotiable**: アクセシビリティは「あれば良い」ものではなく、ローンチブロッカー（必須要件）である。
*   **Touch Targets**: すべてのインタラクティブ要素は最低 48x48dp を確保する。
*   **Semantics**: すべてのカスタムコンポーネントには、スクリーンリーダー（TalkBack/VoiceOver）用の適切なセマンティックラベルを付与する。

## 6. Tools & Workflow
*   **Figma**: 信頼できる唯一の情報源（Source of Truth）。正確なトークンのハンドオフにはDev Modeを使用する。
*   **Rive / Lottie**: コードベースのアニメーションが複雑すぎる場合は、**Rive**（ステートマシン付きベクターアニメーション）を使用する。
*   **Inclusive Copywriting**:
    *   性別、人種、年齢、能力に関わらず、誰もが排除されない言葉選び（Inclusive Language）を行う。

## 4. AI & Personalization
*   **Hyper-Personalization**:
    *   AIを活用し、ユーザー一人ひとりの文脈に合わせて、表示内容や提案を動的に最適化する。
