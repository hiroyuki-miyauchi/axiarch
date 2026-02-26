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
