# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

### 13.29. The Service Aggregation Protocol（サービス集約プロトコル）
*   **Law**: 複数のGateway/Repository/Actionを呼び出して1画面（1ページ）分のデータを組み立てる「集約ロジック」は、**Service層に抽出**しなければなりません。UI層（ページコンポーネント、コントローラー）は、Serviceを呼び出すだけの薄いエントリーポイントに徹してください。
*   **Action**:
    1.  **Single Responsibility**: 1つのページに5つ以上のデータソースからフェッチしている場合、それは「ページがService層の仕事をしている」シグナルです。`XxxService.getPageData()` に集約してください。
    2.  **Testability**: Service層はPure Functionまたは注入可能な依存関係のみで構成し、UI/フレームワーク依存を持たないでください。これにより単体テストが可能になります。
    3.  **Reusability**: 同一データセットを複数のUI（管理画面、公開ページ、API）から利用する場合、Serviceを共有することで「同じデータの別解釈」を防止してください。
*   **Rationale**: UI層にデータ集約ロジックが散在すると、同一データへのアクセスパスが複数生まれ、キャッシュ戦略やエラーハンドリングの統一が不可能になります。Service層は「ビジネスロジックの正門」として機能します。

### 13.30. The Production Build Verification Protocol（本番ビルド検証義務）
*   **Law**: 開発サーバー（`dev` モード）が動作していることは、コードの正しさの証明には**なりません**。型チェック（`tsc --noEmit`）および本番ビルド（`npm run build` 等）が通過するまで、そのコードは「存在しない」ものとして扱ってください。
*   **Action**:
    1.  **Mandatory Triple Crown**: タスク完了前に以下の3つのチェックを必ず通過させてください。
        *   ① 型チェック（`tsc --noEmit`）: 型エラーゼロ
        *   ② リンター（`eslint --max-warnings=0`）: 警告ゼロ
        *   ③ 本番ビルド（`npm run build`）: ビルド成功
    2.  **PR Rejection**: 上記3点の通過結果が提示されていないPRは即時却下してください。
    3.  **Dev Mode Trap**: `dev` モードではHot Module Replacement（HMR）やランタイムエラーの遅延評価により、本番では発生するエラーが隠蔽されます。`import` の解決、Tree Shaking、SSRパスの実行は `build` でのみ完全に検証されます。
*   **Rationale**: 開発サーバーは「寛容すぎる」環境です。本番ビルドは、デッドインポートの検出、SSRパスのクラッシュ、動的ルートの型不整合など、開発モードでは沈黙するエラーを顕在化させる唯一の手段です。

### 13.31. The CI/CD Environment Gap Protocol（CI/CD環境乖離プロトコル）
*   **Law**: CI環境は「空のデータベース（Clean Room）」でテストを実行するため、**既存データとの衝突**（ユニーク制約違反、外部キー不整合、NOT NULL制約のデフォルト値不足等）を検知できません。データ操作を含む変更は、本番データとの衝突を前提とした防衛的コードで記述してください。
*   **Action**:
    1.  **Defensive DML**: `INSERT` 文には `ON CONFLICT ... DO UPDATE` または `DO NOTHING` を使用し、冪等性を確保してください。
    2.  **Pre-Check**: `ALTER TABLE` で `NOT NULL` 制約を追加する場合、既存の `NULL` 値を事前に `UPDATE` でデフォルト値に埋めてください。
    3.  **Staging Verification**: 可能な限り、本番に近いデータを持つステージング環境でデータ変更を事前検証してください。
*   **Rationale**: CIの「全グリーン」は「無菌室での成功」に過ぎません。本番環境の複雑さ（既存データ、並行アクセス、歴史的メンテナンス負債）を忘れた時、デプロイ障害は確実に訪れます。

### 13.32. The Clean Workspace Mandate（クリーンワークスペース義務）
*   **Law**: タスク完了時、作業中に生成された一時ファイル、ビルドキャッシュ、空ディレクトリ、デバッグ用の `console.log` は**全て除去**してからコミットしてください。リポジトリは「使用後即廃棄（Scorched Earth）」の原則で常にクリーンな状態を維持します。
*   **Action**:
    1.  **Checklist**: コミット前に以下を確認してください。
        *   一時ファイル（`.tmp`, `.bak`, `*.log` 等）が残っていないか
        *   空ディレクトリ（ファイルが0個のフォルダ）が残っていないか
        *   `console.log` / `console.debug` がコードに残っていないか
        *   ビルドキャッシュ（`.next/cache` 等）がGit追跡対象に含まれていないか
    2.  **Gitignore Hygiene**: `.gitignore` にビルド出力、環境ファイル、IDE設定が網羅されていることを初期化時に確認してください。
    3.  **Branch Hygiene**: マージ済みブランチは速やかに削除してください。放置ブランチは「環境差異による事故」の温床です。
*   **Rationale**: 残置された一時ファイルやデバッグコードは、次の開発者（未来の自分を含む）に「これは意図的に残されたコードなのか？」という不要な認知負荷を与えます。クリーンなリポジトリはチーム全体の生産性に直結します。

### 13.33. The Dead Code Prohibition Protocol（デッドコード禁止プロトコル）
*   **Law**: 「将来使うかもしれない」という理由でコードを残すことは、技術的負債の最大の温床です。**現在使用されていないコード（未使用の変数、インポート、関数、型定義）は即時削除**を義務付けます。
*   **Action**:
    1.  **No Future-Use Code**: 現在の機能で使用されていないコードは、コメントアウトも含めて一切残しません。必要になった時に Git 履歴から復元してください。
    2.  **Strict Variable Hygiene**: 宣言されたが一度も参照されない変数・定数・インポートは、ビルド前に全て除去してください。`_` プレフィックスは、destructuring での明示的な値の廃棄（例: `const [_, setValue] = useState()`）にのみ許可します。
    3.  **Lint Enforcement**: ESLint の `no-unused-vars` / `@typescript-eslint/no-unused-vars` を `error` に設定し、CIで物理的にブロックしてください。
*   **Rationale**: 未使用コードは「壊れた窓」です。1つ放置すれば、チーム全体が「少しくらいなら大丈夫」と判断し、コードベース全体の品質が低下します。

### 13.34. The Warning Suppression Prohibition Protocol（警告抑制禁止プロトコル）
*   **Law**: Linter や型チェッカーの警告を**抑制・無視するディレクティブ**を安易に使用することを原則禁止します。警告は「修正すべきコードの臭い」であり、消すのではなく根本原因を修正してください。
*   **Action**:
    1.  **ESLint**: `eslint-disable`, `eslint-disable-next-line` の使用は原則禁止です。やむを得ず使用する場合は、**理由を明記したコメント**を必ず併記してください（例: `// eslint-disable-next-line -- ライブラリの型定義が不正確なため`）。
    2.  **TypeScript**: `@ts-ignore`, `@ts-nocheck`, `@ts-expect-error` の使用を原則禁止します。型エラーは型定義の修正で解消してください。
    3.  **Other Tools**: Stylelint、Prettier 等のツールについても同様に、抑制ディレクティブの使用は根本解決の後の最終手段としてのみ許容します。
    4.  **CI Enforcement**: 抑制ディレクティブの新規追加を検出する Lint ルール（例: `eslint-comments/no-unlimited-disable`）の導入を推奨します。
*   **Rationale**: 警告抑制は「問題を見えなくする」だけで解決しません。抑制コメントが増殖するとコードベースの信頼性が損なわれ、真に重要な警告が埋もれます。

### 13.35. The Type Integrity Mandate（型誠実性義務）
*   **Law**: TypeScript の型システムをバイパスする行為は「バグの埋め込み」と定義します。**`as any` による型キャストを原則禁止**し、型の正確性を最優先事項とします。
*   **Action**:
    1.  **No `as any`**: `as any` は型チェッカーを完全に無効化するため、使用を禁止します。外部ライブラリの型が不正確な場合は、`declare module` で正確な型定義を提供してください。
    2.  **Strict Action Return Types**: Server Actions、API ハンドラ、Service 関数の戻り値には、必ず明示的な型定義を付与してください。`any` や `unknown` を戻り値型として使用することは禁止です。
    3.  **No Type Assertion Chains**: `(value as unknown as TargetType)` のような多段キャストは、型安全性の破壊を示すアンチパターンです。データ変換関数を作成し、ランタイムでの検証を伴う型変換を行ってください。
    4.  **Lint Enforcement**: `@typescript-eslint/no-explicit-any` を `error` に設定してください。
*   **Rationale**: `as any` は「型チェッカーへの嘘」です。コンパイル時には問題が見えなくなりますが、ランタイムでは予期しない型のデータが流通し、デバッグ困難なバグを引き起こします。
