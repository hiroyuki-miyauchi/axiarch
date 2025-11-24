# 21. デザインOpsとツール連携 (Design Ops & Tools)

## 1. デザインシステム (Design System)
*   **Single Source of Truth**:
    *   **Figma**: Figma上のデザインシステム（Styles, Variables, Components）を唯一の正解とします。コード（Tailwind Config）は常にFigmaに従属します。
*   **デザイントークン (Design Tokens)**:
    *   色、フォントサイズ、スペーシングは全て「トークン」として定義します。`#FF0000` のようなハードコードは禁止です。`primary-500` のような意味のある名前を使用します。

## 2. ツール連携プロトコル (Tool Usage Protocol)
*   **Figma (UI/UX)**:
    *   **Dev Mode**: エンジニアは必ずFigmaの **Dev Mode** を使用してプロパティを確認します。目分量での実装は厳禁です。
    *   **Auto Layout**: デザイナーは全てのコンポーネントで **Auto Layout** を使用し、レスポンシブな振る舞いをエンジニアに伝えます。
*   **Adobe Creative Cloud (High-Fidelity Assets)**:
    *   **Photoshop / Illustrator**: ロゴ、複雑なグラフィック、写真補正にはAdobeツールを使用します。
    *   **連携**: 作成したアセットはSVGまたは高解像度PNG/WebPとして書き出し、Figmaに配置して管理します。
*   **Canva (Marketing Speed)**:
    *   **非コア業務の高速化**: OGP、SNS投稿画像、社内資料などの「非プロダクトUI」には **Canva** を積極的に使用します。
    *   **テンプレート化**: ブランドキット（ロゴ、フォント、色）をCanvaに登録し、誰でもブランドガイドラインに沿ったクリエイティブを瞬時に作成できるようにします。

## 3. ハンドオフ (Hand-off)
*   **定義済みステータス**:
    *   Figma上の各フレームには「Draft」「Ready for Dev」「Shipped」のステータスを明記します。
*   **アセットのエクスポート**:
    *   画像は原則として **WebP** または **SVG** でエクスポートします。PNG/JPGは特別な理由がない限り使用しません。
