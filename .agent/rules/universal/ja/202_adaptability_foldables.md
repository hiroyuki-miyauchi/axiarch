# 20. デザインとUX戦略 (Design & UX Strategy)

> [!CRITICAL]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: UI/UXの不統一は「プロ意識の欠如」である。
> - **Action**: 「この画面だけボタンが左にある」「ここだけ削除フローが違う」といった些細なズレを許容してはならない。全体の調和（Harmony）を乱す要素は、機能していようとバグである。
> - **Target**: 特に「削除」「保存」「認証」などのクリティカルなフローにおいては、ユーザーのメンタルモデルを守るため、鉄の統一（Iron Consistency）を維持せよ。

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
