# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 2.8. The Hydration Stability Protocol (Zero Mismatch)
*   **Law 1 (Dynamic Content)**: `new Date()` や `Math.random()` などの動的な値を JSX 内に直接埋め込むことを禁止します。これらは SSR と CSR で値がズレ、Hydration Error を引き起こします。
*   **Law 2 (Identifier Match)**: `id` や `htmlFor` には必ず一意かつ不変な値を付与するか、React の `useId` を使用して物理的な一致を保証してください。
*   **Law 3 (Extension Defense)**: ブラウザ拡張機能（Grammarly, Password Managers 等）による属性注入による不一致を防ぐため、`<html>` や `<body>` には `suppressHydrationWarning` を付与してください。**ただし、開発者自身のロジック不備（バグ）を隠すためにこの属性を使用することは厳禁です。**
*   **Law 4 (Date Formatting)**: 日付の表示は必ずクライアントサイド（`useEffect` 内）でフォーマットするか、サーバーサイドで確定した文字列（UTC等）として渡してください。
