# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

### 13.58. The Mapper Input Robustness Protocol（マッパー入力堅牢性）
*   **Law**: DTOマッパー関数（データベース行→DTO変換関数）の設計において、**Postelの法則**「出力は厳格に、入力は寛容に（Be conservative in what you send, be liberal in what you accept）」を適用します。
*   **Action**:
    1.  **Liberal Input**: マッパー関数の入力型は、ORM/DBクライアントの推論結果が不完全（Partial、null混在、結合結果の不定形等）であることを前提とし、過度に厳密な型を強制しないでください。`Record<string, unknown>` やロスのない中間型の使用を許容します。
    2.  **Conservative Output**: マッパー関数の戻り値は、必ず明示的に定義されたDTO型（`StoreDTO`, `UserDTO` 等）であり、型チェッカーが全フィールドの存在と型を保証する状態にしてください。
    3.  **Internal Validation**: 入力の型を緩める代わりに、マッパー関数内部での値検証・Fallback処理（`input.name ?? ''`, `Number(input.price) || 0` 等）を徹底してください。これにより、不正な入力が安全なデフォルト値に変換されます。
    4.  **No Partial Cascade**: マッパー関数の入力型にPartialを使用したことにより、出力DTOのフィールドまでoptionalになる「Partial伝播」を防止してください。出力型は常に完全型（Required）です。
*   **Rationale**: ORM/DBクライアントの型推論は、テーブル結合やRPC呼び出し時に不完全な型を返すことが頻繁にあります。入力に厳密な型を強制すると、Partial不整合や`never`型エラーが頻発し、開発者は`as any`キャストに逃げる悪循環に陥ります。入力を寛容に、出力を厳格にすることで、実用性と型安全性を両立します。

### 13.59. The Migration Static Analysis Guard Protocol（マイグレーション静的解析防衛）
*   **Law**: データベースマイグレーションファイルのPush/Merge時に、CIパイプラインおよびPre-pushフック（Git Hook）で**静的解析**を実行し、危険なSQLパターンを物理的に拒否する仕組みを義務付けます。人間の注意に依存する「運用ルール」は必ず破られます。システム自らが拒否する自動ガードのみが本番環境を守ります。
*   **Action**:
    1.  **Forbidden Pattern Detection**: 以下のパターンをマイグレーションファイルから検出した場合、Push/Mergeを拒否してください。
        -   **`UPDATE` without `DO` block**: WHERE句なし、または競合ハンドリングなしの無防備な更新。データ不整合（Constraint Violation）を招きます。
        -   **`INSERT` without `ON CONFLICT`**: 一意制約違反を招く無防備な追加。
        -   **`UNIQUE` constraint without Cleanup**: 既存の重複データを掃除せずに一意制約を追加すると、マイグレーション適用時にエラーで停止します。
    2.  **Pre-push Hook**: ローカル環境でのPush前にスクリプト（例: `scripts/migration-guard.ts`）を実行し、危険なSQLを即座にフィードバックしてください。`--no-verify` でのフック回避は、プロジェクトの信頼性を破壊する行為として禁止します。
    3.  **CI Pipeline**: GitHub Actions等のCIにおいて `migration:check` ジョブを常時稼働させ、ヒューマンエラーの最終防衛線としてください。このCIジョブの削除・無効化は禁止します。
    4.  **Custom Rules**: プロジェクト固有の危険パターン（例: `DROP TABLE` without `IF EXISTS`、`ALTER TABLE DROP COLUMN` without backup）もルールセットに追加可能な拡張設計としてください。
*   **Rationale**: マイグレーションの事故は「本番データの不可逆的破壊」に直結します。コードレビューのみに依存した防衛は、レビュアーの見落としや緊急デプロイ時のスキップにより容易に突破されます。機械的な静的解析ガードは、24時間365日、一切の例外なく本番環境を守り続けます。
