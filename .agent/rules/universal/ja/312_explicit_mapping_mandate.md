# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

### 13.48. The Explicit Mapping Mandate（ミューテーション明示マッピング義務）
*   **Law**: Service層やServer Action内でデータベースへの書き込みペイロードを構築する際、スプレッド構文（`...input`）による一括展開を**禁止**します。全てのフィールドを明示的にマッピングしてください。
*   **Action**:
    1.  **No Spread Payload**: `supabase.from('table').update({ ...formData })` のようなスプレッド展開によるペイロード構築を禁止します。入力オブジェクトに含まれる予期しないフィールド（UIが追加した状態管理用フィールド等）がDBに送信され、エラーまたはデータ汚染を引き起こします。
    2.  **Field-by-Field Construction**: ペイロードは `{ name: input.name, email: input.email, status: input.status }` のように、各フィールドを個別に指定してください。これにより、送信されるデータの範囲が明確になり、レビューが容易になります。
    3.  **JSONB Structural Mapping**: ネストされたJSON/JSONB構造を持つフィールドも、トップレベルのスプレッドに頼らず、内部構造を明示的に構築してください。特に配列データ（画像リスト等）は、元データの順序と内容を正確に維持するマッピングが必要です。
    4.  **DTO-Payload Alignment Check**: DTOにフィールドが追加された際は、Service層のマッピングにも同時に追加してください。マッピングの欠落は「保存しても反映されない」サイレントバグの最も一般的な原因です。
*   **Rationale**: スプレッド構文は簡潔ですが、「何が送信されるか」の制御を放棄する行為です。特に管理画面のような大規模フォームでは、UIの状態管理用フィールド、計算フィールド、未定義フィールドが混入するリスクが高く、明示的なマッピングだけがデータの整合性を保証します。

### 13.49. The Mutation Count Verification Protocol（ミューテーション影響行数検証義務）
*   **Law**: データベースへの書き込み操作（INSERT/UPDATE/DELETE）の結果を検証する際、`error` の有無だけでなく、**影響を受けた行数（`count`）**を必ず確認しなければなりません。`error: null` かつ `count: 0` の組み合わせは「Phantom Success（偽の成功）」であり、実質的な失敗として扱ってください。
*   **Action**:
    1.  **Count Validation**: ID指定の単一レコード操作（`.eq('id', id)`）では、`count` が `1`（または期待される数）であることを検証してください。`count` が `0` または `null` の場合は、権限不足（RLS拒否）またはレコード不在として例外をスローしてください。
    2.  **Bulk Operation Awareness**: 一括更新・削除操作では、`count` が入力データの件数と一致することを検証してください。部分的な成功（10件中7件のみ更新）はデータの不整合を意味します。
    3.  **Sub-Step Integrity**: 単一のService関数内で複数のテーブルを連続して更新する場合、全てのサブステップで `error` と `count` の両方を検証してください。途中のステップの失敗をスキップすると、一部だけが更新された「Partial Phantom Success」となります。
    4.  **Diagnostic Logging**: ミューテーション結果のログには `count` を必ず含めてください（例: `Logger.info('Update result:', { count })`）。事後の障害分析において、影響行数は最も重要な手がかりです。
*   **Rationale**: Row Level Security（RLS）を使用するデータベースでは、権限不足のクエリが「エラーなし・0行影響」という形でサイレントに拒否されることがあります。`error` のみをチェックする従来のパターンでは、この「成功のように見える失敗」を検知できず、ユーザーには「保存したのに反映されない」という最も不透明なバグとして現れます。

### 13.50. The Authentication Guard Enumeration Consistency（認証ガード列挙整合性義務）
*   **Law**: ロールベースアクセス制御（RBAC）において、許可ロールのリストを複数のガード関数で個別管理することを**禁止**します。全てのガード関数は、共通の定数配列（例: `ALLOWED_ADMIN_ROLES`）を参照し、ロール定義の単一真実源（SSOT）を確立しなければなりません。
*   **Action**:
    1.  **Shared Role Constants**: 許可ロール（`admin`, `super_admin`, `master_admin` 等）は、単一の定数配列として定義し、全てのガード関数（ページアクセス制御、Server Action認可、RLSポリシー等）がこの定数を参照してください。
    2.  **Simultaneous Update Mandate**: 新しいロールを追加する際は、全てのガード関数が自動的に更新される構造にしてください。定数配列を共有していれば、更新箇所は1箇所で済みます。
    3.  **Dead Zone Detection**: 「画面には入れるが、操作（保存等）だけが失敗する」という不透明なデッドロックを防ぐため、ページレベルのガードとアクションレベルのガードが同一のロール集合を参照していることを定期的に監査してください。
    4.  **Failure Transparency**: ガード関数が認可エラーを返す際は、フロントエンドでエラーをキャッチし、開発環境では `Logger.warn` でロール不整合を即座に検知できるようにしてください。
*   **Rationale**: ロールの種類が増えた際に、全てのガード関数を同時に更新し忘れると、「管理画面にはログインできるが、特定の操作だけがサイレントに拒否される」という極めて不透明なデッドロックが発生します。この種のバグはエラーメッセージも表示されないため、原因特定に膨大な時間を浪費します。

### 13.51. The Sub-Step Mutation Integrity Protocol（サブステップ・ミューテーション整合性義務）
*   **Law**: 単一のサービスメソッド内で複数の非同期書き込み操作（INSERT/UPDATE/DELETE）を連続して実行する場合、**全てのサブステップで `error` オブジェクトを検証**し、エラーが発生した場合は即座にプロセスを停止して例外をスローしなければなりません。
*   **Action**:
    1.  **No Silent Continue**: `await supabase.from('table').delete()` のように戻り値の `error` をチェックせず後続処理に進むことを禁止します。全ての書き込み操作で `const { error } = await ...` として結果を受け取り、エラーチェックを行ってください。
    2.  **Step-by-Step Logging**: 各サブステップの開始時と完了時にログを出力し（例: `Logger.info('[Step 2/5] Updating tags...')`）、障害発生時にどのステップで失敗したかを即座に特定できるようにしてください。
    3.  **Aggregate Error Reporting**: 中間ステップの失敗が最終結果（`return { success: true }`）を汚染しないよう、サービスメソッド全体を `try-catch` で囲み、いずれかのステップで例外が発生した場合は明示的な失敗レスポンスを返してください。
    4.  **Transaction Awareness**: 外部APIのシンプルな呼び出し（PostgREST等）はデフォルトでアトミックなトランザクションとして扱われないことを認識し、途中失敗時の補償処理（ロールバック相当）や冪等性の確保を設計に組み込んでください。
*   **Rationale**: マルチテーブル更新において途中のステップの失敗を無視すると、メインテーブルは更新されたが関連テーブルは古いままという「Partial Phantom Success（部分的偽成功）」が発生します。ユーザーには「保存成功」と表示されるにもかかわらず、一部のデータだけが反映されないため、問題の発見が大幅に遅れます。

### 13.52. The Error Object Transparency Mandate（エラーオブジェクト透過性義務）
*   **Law**: エラーハンドリングにおいて、エラーオブジェクトをそのまま文字列として連結・出力すること（結果として `[object Object]` が出力される）を**禁止**します。エラーの `message`, `code`, `details` 等のプロパティを**明示的に分解**してログに記録しなければなりません。
*   **Action**:
    1.  **Structured Error Logging**: `Logger.error('Operation failed', { error: err.message, code: err.code, details: err.details })` のように、エラーオブジェクトのプロパティを個別のフィールドとして出力してください。`Logger.error('Failed: ' + error)` は `[object Object]` となり、原因特定が不可能です。
    2.  **Catch Block Standard**: 全ての `catch` ブロックにおいて、捕捉したエラーが `Error` インスタンスか `PostgrestError` か等を判定し、それぞれのプロパティを適切に抽出してください。
    3.  **Error Serialization**: クライアントへ返すエラーレスポンスにおいても、内部エラーの構造を適切に変換し、`{ success: false, error: 'Human-readable message', code: 'ERROR_CODE' }` 形式で返却してください。
    4.  **Development vs. Production**: 開発環境ではエラーの全プロパティをログに含め、本番環境では機密情報（スタックトレース、内部パス等）をマスクした上で、運用に必要な情報（`code`, `message`）のみを出力してください。
*   **Rationale**: `[object Object]` は、障害対応における最も無価値な情報です。特にデータベースエラー（Supabase `PostgrestError` 等）は `message`, `code`, `details`, `hint` といった豊富な診断情報を持っていますが、オブジェクトの直接連結によりこれらが全て失われ、障害の根本原因分析が事実上不可能になります。
