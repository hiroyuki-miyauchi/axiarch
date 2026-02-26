# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 2.6. The Design Consistency Protocol (No Native Inputs)
*   **Law**: システム標準の `<input type="date">` 等の使用を禁止します。Shadcn UI等のデザインシステム内で「異物」となり、デザインの統一性を損なうためです。
*   **Action**: 必ず `Popover + Calendar` や `Select` コンポーネントを使用し、独自のスタイルを適用してください。横並びの要素は `h-10` (40px) 等の固定高さで揃えることを義務付けます。
*   **クラスの整列**: `prettier-plugin-tailwindcss` を導入し、クラス名の並び順を自動的かつ強制的に統一します。
    *   **The App-Like Feel Protocol (Overscroll Control)**:
        *   **Context**: モバイル向けWebアプリ（PWA）や、ネイティブアプリ風の操作性を提供する場合。
        *   **Action**: `overscroll-behavior-y: none` を適用し、ブラウザの「Pull to Refresh」を無効化することを**推奨**します。ただし、ブラウザ標準の更新操作が必要な一般的なWebサイトでは、この設定を強制しないでください。
*   **The Hook Dependency Protocol**:
    *   **Law**: `useEffect` や `useCallback` の依存配列は、ESLintの警告 (`react-hooks/exhaustive-deps`) に完全に従い、使用している変数を全て記述してください。
    *   **Prohibition**: 「無限ループするから」という理由で依存配列を間引く（嘘をつく）ことは厳禁です。それはロジック自体が間違っている（Effect内でStateを更新しすぎている等）証拠です。設計を見直してください。
