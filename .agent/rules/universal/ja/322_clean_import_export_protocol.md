# 33. Webフロントエンドエンジニアリング (Web Frontend Engineering - Next.js)

### 2.2. The Clean Import & Export Protocol
*   **The Barrel Export Prohibition (Performance Guard)**:
    *   **Law**: ディレクトリ単位の `index.ts` (Barrel file) による一括再エクスポートを禁止します。
    *   **Reason**: 開発環境（Next.js Dev）でのビルド速度を著しく低下させ、かつ意図しないトランスパイル負荷（全コンポーネントの読み込み）を誘発するためです。インポートは必ず物理ファイル・パスから直接行ってください。

*   **The Dead Code Execution Protocol**:
    *   **Law**: 条件分岐や早期リターンの「後」で、重いインポートや外部モジュールの関数実行、DOMへの副作用（useEffect等）を配置しないでください。
    *   **Action**: 条件によって完全に不要なロジックは、コードベース内で「物理的に」実行されないように、Next.jsの `dynamic()` や `Suspense` の境界で分離するか、条件分岐の外側（Top-Level）に定義のみを配置してください。

*   **The Clean Import Protocol**:
    *   **Law**: `import` ステートメントは必ずファイルの最上部（Top-Level）に記述してください。コンポーネント内や制御フロー内でのインポートは、ビルド挙動を不安定にし、HMR (Hot Module Replacement) を破損させ、一見無関係なシリアライズエラーを誘発します。
    *   **Action**: どんなに急いでいても、インポートはファイルの先頭に集約してください。

*   **The Semicolon Guard (ASI Safety)**:
    *   **Law**: 副作用実行行の後で、次行が括弧で始まる場合（`(` や `[`）は、必ず明示的にセミコロン `;` を付与してください。ASI（Automatic Semicolon Insertion: 自動セミコロン挿入）の失敗による「ステルス・バグ」を物理的に封殺します。
    *   **Action**: ESLint の `no-unexpected-multiline` ルールを有効にし、CIで自動検出してください。

*   **The Component Colocation Protocol (適切な粒度の維持)**:
    *   **Law**: 特定のコンポーネントでのみ使用される「サブコンポーネント」「型定義」「定数」は、原則として **同一ファイル内 (Co-location)** に記述してください。過剰なファイル分割は認知負荷を増大させます。
    *   **Split Threshold**: ファイルが **300行** を超えた場合にのみ、サブコンポーネントを別ファイルに分離することを許可します。分離時はディレクトリを作成し、関連ファイルをまとめてください。

### 2.3. Headless UI Architecture (Web Only Prohibition)
*   **Rule**: UIコンポーネントは「データの表示」と「イベントの発火」のみに専念し、ビジネスロジックを持たせてはなりません（Dumb UI）。
*   **Prohibition**: コンポーネント内で `fetch` を行ったり、特定ページのDOM構造に依存したステート管理（Web Only設計）を行うことは、将来のNative化を阻害するため厳禁です。
