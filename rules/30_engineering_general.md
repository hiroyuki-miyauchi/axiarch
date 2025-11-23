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

## 3. Digital 5S (Cleanup & Optimization)
*   **Seiri (整理) & Seiton (整頓)**:
    *   未使用のファイル、画像、関数、コメントアウトされたコードは「ゴミ」である。発見次第即座に削除する。
    *   ディレクトリ構造は常に論理的で予測可能な状態に保つ。
*   **Seiso (清掃) - Refactoring**:
    *   **Continuous Refactoring**: 機能追加のたびに、既存コードを少しだけ綺麗にする（Boy Scout Rule）。大規模なリファクタリング期間を設けるのではなく、日常的に行う。
    *   **Performance Tuning**: 定期的にプロファイリングを行い、ボトルネックを解消する。推測で最適化しない（Premature Optimization is the root of all evil）。

## 4. Observability
*   **Monitor Everything**:
    *   「動いている」だけでなく「どう動いているか」を可視化する（ログ、メトリクス、エラートラッキング）。
    *   エラーはユーザーより先に検知する。
