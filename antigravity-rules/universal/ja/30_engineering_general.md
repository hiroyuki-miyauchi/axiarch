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

## 3. Performance & Optimization (The "Speed")

### 3.1. Asset Optimization
*   **Next-Gen Formats**:
    *   **Web**: **AVIF**をデフォルトとし（`next/image`経由）、WebPにフォールバックする。
    *   **Mobile (Flutter)**: バンドルアセットには**WebP**を使用する。AVIFはサイズが重要な高精細静止画にのみ使用する（プラグインが必要なため）。
    *   **Vectors**: アイコンや単純なイラストには**SVG**を使用する。
*   **Lazy Loading**:
    *   ファーストビュー（Above the fold）以下の画像は必ずLazy Loadする。
    *   体感速度向上のため、"Blur-up"プレースホルダー（`blurDataURL`）を使用する。

### 3.2. Code Hygiene (Lightweighting)
*   **Tree Shaking**:
    *   **Imports**: Tree Shakingを阻害する「バレルファイル（index.ts）」を避ける。特定のモジュールをインポートする（例：`import { map } from 'lodash/map'`）。
    *   **Dead Code**: `dart analyze`や`eslint-plugin-unused-imports`を使用して、未使用コードを自動的に検出し削除する。
*   **Dependency Diet**:
    *   **Audit**: 新しいパッケージを追加する前に、必ずバンドルサイズへの影響を確認する（Bundlephobiaを使用）。
    *   **Pruning**: 未使用の依存関係は即座に削除する。

### 3.3. Full-Stack Performance Strategy
*   **CDN & Edge Caching**:
    *   **Static Assets**: 静的アセットは必ずCDN（Firebase Hosting/Cloud CDN）経由で配信し、積極的なキャッシュポリシー（`Cache-Control: public, max-age=31536000, immutable`）を適用する。
    *   **Edge Logic**: ロジックをユーザーに近づける。地域固有の処理には **Cloud Functions (2nd Gen)** または **Edge Middleware** (Next.js) を使用する。
*   **Latency & UX Impact**:
    *   **Rule**: 「速度は機能である」。100msの遅延は収益を1%低下させる。
    *   **Optimistic UI**: ユーザー操作に対して*即座に*UIを更新し、その後サーバーと同期する。同期に失敗した場合は優雅にエラー処理（ロールバック）を行う。
    *   **Skeleton Screens**: 待機時間の体感を短くするため、スピナーではなくスケルトンスクリーンを使用する。

### 3.4. Evolutionary Architecture (Future-Proofing)
*   **Fitness Functions**:
    *   **Automated Guardrails**: アーキテクチャ特性を保護するための「フィットネス関数」を定義する（例：「起動時間は2秒未満」「循環参照禁止」）。
    *   **CI Enforcement**: これらのメトリクスが悪化した場合、ビルドを失敗させる。
*   **YAGNI (You Ain't Gonna Need It)**:
    *   **Strict Prohibition**: 「念のため」の機能実装は厳禁。現在の要件に必要なもの**だけ**を実装する。
    *   **KISS**: 複雑なコードよりもシンプルなコードの方が、将来の変更に強い。

## 4. Technical Debt & Cleanup (The "Boy Scout")

### 4.1. The "Boy Scout Rule"
*   **Mandate**: 「来た時よりも美しくして立ち去る。」
*   **Action**: ファイルを触る際は、そのファイル内の少なくとも1つの小さな問題（フォーマット、命名、未使用インポート）を修正する。

### 4.2. Automated Cleanup
*   **Tools**:
    *   **Flutter**: `dart analyze` と `dart fix --apply` を定期的に実行する。
    *   **Next.js**: **Knip** を使用して未使用のファイルやエクスポートを検出する。
    *   **General**: **SonarQube** 等を統合し、コード品質を継続的に監視する。

### 4.3. Debt Paydown Protocol
*   **Definition**: 「技術的負債」は比喩ではなく、金融負債である。利子（複雑性）が蓄積する。
*   **Routine**: **スプリントの20%**（または2週間に1日）を、リファクタリングとクリーンアップに充てる。この時間は新機能開発を禁止する。

## 5. Digital 5S (Cleanup & Optimization)
*   **Seiri (整理) & Seiton (整頓)**:
    *   未使用のファイル、画像、関数、コメントアウトされたコードは「ゴミ」である。発見次第即座に削除する。
    *   ディレクトリ構造は常に論理的で予測可能な状態に保つ。
*   **Seiso (清掃) - Refactoring**:
    *   **Continuous Refactoring**: 機能追加のたびに、既存コードを少しだけ綺麗にする（Boy Scout Rule）。大規模なリファクタリング期間を設けるのではなく、日常的に行う。
    *   **Performance Tuning**: 定期的にプロファイリングを行い、ボトルネックを解消する。推測で最適化しない（Premature Optimization is the root of all evil）。

## 6. Observability
*   **Monitor Everything**:
    *   「動いている」だけでなく「どう動いているか」を可視化する（ログ、メトリクス、エラートラッキング）。
    *   エラーはユーザーより先に検知する。
