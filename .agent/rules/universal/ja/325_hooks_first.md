# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 2.7. The React Hooks Order Guarantee Protocol (Hooks First)
*   **Law**: Hooks (useState, usePathname等) の呼び出し順序は、レンダリング間で不変でなければなりません。
*   **Prohibition**: Hooks呼び出しの**後**に配置されるべき早期リターン（`if (!data) return null`）や条件分岐を、Hooksの前（最上部）に置くことは禁止です。また、Hooks呼び出しの後に条件付きリターン（Early Return）を配置してはなりません。これは、後続のHooks呼び出し回数がレンダリング間で変動し、"Rendered more hooks..." エラーを引き起こすためです。
*   **Suspense Mandate (useSearchParams)**:
    *   `useSearchParams()` を使用するコンポーネントは、ビルド時の静的解析エラーを防ぐため、必ず `<Suspense>` 境界でラップすることを義務付けます。
    *   **The Error Boundary Protocol (No White Screen)**:
        *   **Law**: Reactのランタイムエラーによる「画面真っ白（White Screen of Death）」は許されません。
        *   **Action**: `react-error-boundary` を使用し、ルート (`layout.tsx`) および主要な機能セクションごとにエラー境界を設置し、必ず「再試行ボタン付きのエラーUI」を表示してください。
*   **Correct Structure (The Hooks First Protocol)**:
    *   **Law**: Hooks 呼び出しの**後**に条件付きリターン（Early Return）を配置することは、次回レンダリングでの Hooks 数変動を招き React の整合性を破壊するため**有罪**であり、完全禁止とします。これはデバッグを極めて困難にする**「技術的重罪（Felony）」**です。
    *   **Mandatory Order (Google Antigravity Standard)**:
        1.  **ALL HOOKS FIRST**: 全ての Hooks (useState, usePathname 等) をコンポーネント最上部に集約。
        2.  **DERIVED STATE**: Hooks の後に変数計算や状態判定を配置。
        3.  **CONDITIONAL RETURN**: 最後に `if (shouldHide) return null` などのリターンを配置。

### 2.7.1. The Static Component Persistence Protocol (外部定義義務)
*   **Law**: レンダリング関数の内部で別のコンポーネントを定義してはなりません。再レンダリングのたびに新しいコンポーネント型が生成され、React が DOM ツリーを破棄するため、**入力フォーカスの喪失**、**ステートの初期化**、および致命的なパフォーマンス低下を招きます。
*   **Action**: サブコンポーネントやラッパーコンポーネントは必ず **Module Scope（ファイルの最外部）** で定義してください。値を渡す必要がある場合は、明示的に Props を介して行ってください。
*   **Anti-Pattern**: `const MyComponent = () => { const SubComponent = () => <div />; return <SubComponent />; }` — これは**技術的重罪**です。

### 2.7.2. The Route Conflict Ban (Zero Duplicate Route)
*   **Law**: ページのリファクタリング（ディレクトリ移動）時は、必ず**移動元のディレクトリを物理的に削除**してください。古い `page.tsx` が残存していると、フレームワーク（Next.js等）がルート競合を検出し**ビルドエラー**を引き起こします。
*   **Action**: ファイル移動後は `find` や `git status` で旧ファイルの残存がないことを確認してください。
