# 38. Web標準技術 (Web Standards - HTML/CSS/PHP)

## 1. HTML & CSS (The Foundation)
*   **セマンティックHTML (Semantic HTML)**:
    *   `div` 漬けを禁止します。`header`, `main`, `footer`, `article`, `section` を適切に使用し、SEOとアクセシビリティを最大化します。

### 1.1. 高度なCSS設計 (Advanced CSS Architecture)
*   **BEM (Block Element Modifier) の厳格化**:
    *   **命名規則**: `Block__Element--Modifier` を厳守します。
    *   **孫要素の禁止**: `Block__Element__Grandchild` は禁止です。構造が深くなる場合は、新しいBlockとして切り出します（フラット構造の維持）。
    *   **状態管理**: BEMと合わせて `is-active`, `has-error` などのステートクラスを使用します（例: `Button--primary.is-active`）。
*   **SASS/SCSS 最適化**:
    *   **ネスト制限**: ネストは **最大3階層** までとします。深すぎるネストは詳細度（Specificity）の競争を生み、保守性を著しく低下させます。
    *   **アンパサンド (`&`) の乱用禁止**: 検索性を損なうため、クラス名の一部を `&` で結合すること（例: `&__element`）は推奨しません。フルネームで記述することを好みます。
*   **モダンレイアウト (Modern Layout)**:
    *   **Container Queries**: コンポーネントの再利用性を高めるため、Media Queries (`@media`) よりも Container Queries (`@container`) を優先します。

### 1.2. CSSパフォーマンス (Rendering Performance)
*   **レンダリング最適化**:
    *   **Containment**: 複雑なウィジェットには `contain: content` を使用し、ブラウザの再計算範囲を隔離します。
    *   **Will-Change**: アニメーション要素には `will-change` を使用しますが、メモリ消費を防ぐため、必要なタイミングのみ適用します。
    *   **GPUアクセラレーション**: アニメーションには `transform` と `opacity` のみを使用し、`top`, `left`, `width` などのレイアウト変更（Reflow）を伴うプロパティのアニメーションは禁止します。
*   **レスポンシブ (Responsive)**:
    *   **モバイルファースト**: CSSは常にモバイル向けのスタイルをデフォルトとし、`min-width` メディアクエリでデスクトップ向けに拡張します。

## 2. JavaScript (Vanilla & ES6+)
*   **モダン標準 (Modern Standards)**:
    *   jQueryは原則禁止です（レガシー改修を除く）。`querySelector`, `fetch`, `ES Modules` などの標準APIを使用し、軽量で高速なコードを書きます。
    *   **非同期処理**: コールバック地獄を避け、`async/await` を使用して可読性を高めます。
*   **パフォーマンス (Performance)**:
    *   **DOM操作の最小化**: DOMへのアクセスは高コストです。変数にキャッシュするか、`DocumentFragment` を使用して再描画（Reflow/Repaint）を最小限に抑えます。

## 3. PHP (Modern PHP)
*   **PSR準拠 (PSR Standards)**:
    *   **PSR-12**: コーディングスタイルはPSR-12に完全準拠します。
    *   **型宣言**: 引数と戻り値には必ず型（Type Hinting）を指定し、堅牢性を高めます（PHP 7.4/8.0+）。
*   **セキュリティ (Security)**:
    *   **XSS対策**: 出力時は必ずエスケープ処理（`htmlspecialchars`）を行います。
    *   **SQLインジェクション対策**: 生のSQLを書かず、必ずPDOのプリペアドステートメントまたはORMを使用します。
