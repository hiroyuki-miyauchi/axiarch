# 30. Engineering Excellence (General)

## 1. Code Quality
*   **Clean Code**:
    *   コードは「資産」である。可読性、単一責任原則（SRP）、DRY原則を徹底する。
    *   変数名や関数名は、コメントなしでも意図が伝わるように命名する（Self-documenting code）。
*   **Refactoring (Boy Scout Rule)**:
    *   触ったファイルは、必ず触る前より綺麗にしてコミットする。技術的負債を溜めない。
    *   「後で直す」は決してやってこない。今直す。

## 2. Security by Design (DevSecOps)
*   **Security First**:
    *   セキュリティは後付け機能ではない。設計段階から組み込む。
    *   **Zero Trust**: 入力値は全て疑う（バリデーション必須）。認証・認可は厳格に。
    *   機密情報（API Key等）は決してコードにハードコードしない。

## 3. Observability
*   **Monitor Everything**:
    *   「動いている」だけでなく「どう動いているか」を可視化する（ログ、メトリクス、エラートラッキング）。
    *   エラーはユーザーより先に検知する。
