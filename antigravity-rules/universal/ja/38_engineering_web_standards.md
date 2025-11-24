# 38. Web標準技術 (Web Standards - HTML/CSS/PHP)

## 1. HTML & CSS (The Foundation)
*   **セマンティックHTML (Semantic HTML)**:
    *   `div` 漬けを禁止します。`header`, `main`, `footer`, `article`, `section` を適切に使用し、SEOとアクセシビリティを最大化します。
*   **CSS設計 (CSS Architecture)**:
    *   **BEM (Block Element Modifier)**: Tailwindを使用しないプロジェクト（WordPressテーマ等）では、**BEM** 命名規則を厳守し、スタイルの衝突と詳細度の地獄を防ぎます。
    *   **SASS/SCSS**: ネスト、変数、Mixinを活用し、保守性の高いスタイルシートを記述します。
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
