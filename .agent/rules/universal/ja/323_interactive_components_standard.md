# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 2.4. Interactive Components Standard
*   **Rich Selection Protocol**:
    *   従来のラジオボタン/チェックボックスは原則禁止とし、**「押せることが直感的にわかるリッチなカード型UI」** を標準とします。
*   **Responsive Combobox Protocol**:
    *   **Desktop**: `Popover` (modal=true) を使用し、コンテンツとの重なりには `z-[9999]` を付与します。
    *   **Mobile**: タッチ操作性を高めるため、Popoverではなく **Drawer (Vaul)** を使用します。
    *   **Mobile Click/Tap Fix**: `vaul` (Drawer) 内のスクロール可能な領域には `data-vaul-no-drag` 属性を付与し、スワイプ操作による意図しない閉塞を防ぎます。
    *   **Breadcrumb Priority Lesson (Stack Layout)**: モバイルヘッダーでパンくずリストとアクションボタンを横並びにすると、パンくずが画面外に追いやられます。これらは「独立した行」として縦積み（Stack: `flex-col`）にすることを推奨します。
    *   **Interaction**: `CommandItem` には `pointer-events-auto` を強制し、`onClick`/`onPointerUp` をバインドしてタップ漏れを防ぎます。
    *   **Stable IDs**: `CommandItem` や `SelectItem` の `value` には、必ず一意かつ不変な **ASCII文字列**（ID等）を使用してください。日本語を `value` にすると選択ロジックが誤動作します。日本語検索が必要な場合は `keywords` プロパティを使用します。

### 2.5. The Z-Index Stratification Protocol (Menu Dominance)
*   **Law**: Z-Indexの「マジックナンバー化」を防ぎ、UIの重なり順序を保証します。
*   **Definition**:
    *   **Overlay (10000)**: `Select`, `Popover`, `Tooltip`, `Calendar` 等のオーバーレイ要素。これらは常に最前面でなければなりません。
    *   **Modal (9999)**: `Dialog`, `Sheet` 等の画面全体を覆うUI。オーバーレイよりは下です。
    *   **Menu (1000)**: ドロワーメニューやナビゲーションメニュー。
    *   **Header (50)**: 固定ヘッダー。
    *   **Floaters (40)**: チャットボタン等のフローティング要素。決してメニューの上に配置してはなりません。
