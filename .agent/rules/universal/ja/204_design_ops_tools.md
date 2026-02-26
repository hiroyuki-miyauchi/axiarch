# 20. デザインとUX戦略 (Design & UX Strategy)

> [!CRITICAL]
> **Rule 20.0: The Consistency Mandate (Professionalism Protocol)**
>
> - **Law**: UI/UXの不統一は「プロ意識の欠如」である。
> - **Action**: 「この画面だけボタンが左にある」「ここだけ削除フローが違う」といった些細なズレを許容してはならない。全体の調和（Harmony）を乱す要素は、機能していようとバグである。
> - **Target**: 特に「削除」「保存」「認証」などのクリティカルなフローにおいては、ユーザーのメンタルモデルを守るため、鉄の統一（Iron Consistency）を維持せよ。

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
