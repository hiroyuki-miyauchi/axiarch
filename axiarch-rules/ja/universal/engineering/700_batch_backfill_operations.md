# 700. バッチ・バックフィル運用と失敗計数 (Batch, Backfill & Failure Accounting)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-06-12

> [!IMPORTANT]
> **Level 1 Priority: Absolute Compliance（最上位の優先事項）**
> バッチ・バックフィルは「人間が見ていない時間帯に、大量のデータへ不可逆な変更を加えうる」最も静かな高リスク作業である。
> 本ファイルの MUST 要件はリスク低減と品質の底上げを目的とし、実装の簡便さ・開発速度よりも優先する。

> [!CAUTION]
> **Primary Directive（主要方針）**
> 「部分失敗を『成功』として報告するジョブは、監視が存在しないことよりも有害である」
> 本ファイルは、機械呼出（スケジューラ / キュー / 手動バッチ / バックフィル / 移行）で動く**全ジョブ**に適用される、言語・スタック非依存の普遍規律である。
> 本ファイルが正本化するのは**「ジョブ / 処理単位の失敗計数契約」**であり、ログ・メトリクス基盤の総論は `ai/100`、SLO・アラート全般は `operations/400`、スタック固有実装は `engineering/500`・`510` へ委譲する（§1.2 責任分界表参照）。

---

## 目次

- §1. 主要方針・責務範囲
  - §1.1. 適用範囲
  - §1.2. 責任分界表（隣接ファイルとの境界）
  - §1.3. 基本原則と RFC 2119 用語
- §2. ジョブサマリ・失敗計数契約（本ファイルの核）
  - §2.1. 標準フィールド契約
  - §2.2. 3値 outcome — 部分失敗を「成功」として返さない
  - §2.3. skipped / dedup の計数義務
  - §2.4. per-item 失敗捕捉と元ペイロード保全（DLQ）
  - §2.5. 1実行1 canonical サマリ行
  - §2.6. メトリクス計上規約（OTel 整合）
  - §2.7. 失敗分類タクソノミ（retryable × 起因軸）
  - §2.8. Silent Failure 禁止
  - §2.9. 言語非依存の契約 interface
- §3. バックフィル / 機械呼出ジョブ規律
  - §3.1. 冪等設計（at-least-once 前提）
  - §3.2. チェックポイント / watermark 永続化と再開
  - §3.3. チャンク分割とスロットリング（背圧）
  - §3.4. dry-run 必須プロトコル
  - §3.5. 4段階移行（dual-write → read → write → 旧削除）
  - §3.6. Shadow Read / Scientist パターン
  - §3.7. 検証の独立（件数 + checksum + サンプリング）
  - §3.8. 順序保証と依存関係の処理順
  - §3.9. Kill Switch / Pause の事前準備
  - §3.10. リトライ規律（単一レイヤ・backoff + jitter）
  - §3.11. スケジューラ catchup 統制
  - §3.12. 対象抽出の本番分離
- §4. テスト義務（quality/000 への接続）
- §5. 多角観点（可観測性 / FinOps / 性能 / プライバシー / Zero Trust）
- §6. 実装スニペット（参考実装）
- §7. アンチパターン集
- §8. 成熟度モデル L1–L5
- Appendix A: 逆引き索引
- Cross-Reference（関連ルール）

---

## §1. 主要方針・責務範囲 (Primary Directive & Scope)

### §1.1. 適用範囲

-   **Rule 700.1.1（適用対象）**: 本ファイルは、**人間の対話的操作なしに機械呼出で実行される全処理**に適用する（MUST）。具体的には以下を含むが、これらに限定されない:
    -   スケジューラ起動のジョブ（cron / cloud scheduler 等）
    -   キュー / イベント駆動のワーカー（メッセージキュー・イベントバス消費者）
    -   手動起動のバッチ（運用スクリプト・one-off タスク）
    -   バックフィル（既存データへの遡及的書き込み・再計算）
    -   データ移行（スキーマ移行に伴うデータ移送・変換）
-   **判定基準**: 「失敗したことに、誰がいつ気づくのか？」に即答できない処理は、すべて本ファイルの適用対象である。リクエスト/レスポンス型の同期 API は対象外（`engineering/100` 参照）だが、API の内部でバッチ的な複数 item 処理を行う場合は §2 の計数契約を適用する（SHOULD）。

### §1.2. 責任分界表（隣接ファイルとの境界）

-   **Rule 700.1.2（責任分界）**: 本ファイルは「ジョブ / 処理単位の失敗計数契約と運用規律」のみを正本とし、以下は各正本へ委譲する（MUST）:

| トピック | 正本（委譲先） | 本ファイルとの関係 |
|:--------|:-------------|:-----------------|
| 構造化ログ・メトリクス・トレースの基盤総論 | `ai/100_data_analytics.md` Part XI–XV | 本ファイルは「ジョブが**何を**計上するか」を定義し、「**どう**収集・転送するか」は委譲 |
| SLO・アラート・Canonical Log Lines 基盤 | `operations/400_site_reliability.md` §13, §22–§26 | サマリ行の形式は本ファイル §2.5、アラート設計は委譲 |
| インシデント対応・ロールバック手順 | `operations/500_incident_response.md` | ジョブ失敗が事故化した後の対応は委譲 |
| GCP 固有のバッチ構成（Cloud Run Jobs / Pub/Sub 等） | `engineering/500_firebase_gcp.md` §38 | 本ファイルは汎用規律、構成パターンは委譲 |
| AWS 固有のバッチ構成（Lambda / SQS / Step Functions 等） | `engineering/510_aws_cloud.md` | 同上 |
| テスト層の定義（ユニット / 統合 / E2E） | `quality/000_qa_testing.md` §5–§6 | ジョブ固有のテスト義務のみ本ファイル §4 で定義 |
| スキーマ進化（Expand-Contract）・バックフィル SQL 安全基準 | `engineering/000_engineering_standards.md` Part XVII | DDL/DML の安全基準は委譲、ジョブとしての運用規律は本ファイル |
| PII 保護・プライバシー・バイ・デザイン | `security/000_security_privacy.md` §7 | 失敗サンプル保全時のマスキング要件のみ §5.4 で言及 |

### §1.3. 基本原則と RFC 2119 用語

-   **Rule 700.1.3（RFC 2119）**: 本ファイルの **MUST / MUST NOT / SHOULD / MAY** は RFC 2119 の定義に従う。MUST はリスク低減のための必須要件であり、逸脱には ADR による明示的な記録を要する。
-   **Rule 700.1.4（誇張禁止）**: 本ファイルは「失敗ゼロ」を約束しない。目的は**失敗の不可視化を構造的に排除し、検知・再開・修復のコストを系統的に下げる**ことである。「完璧な移行」「絶対安全なバックフィル」といった表現は設計文書でも禁止する（MUST NOT）。
-   **Rule 700.1.5（観測なくして実行なし）**: §2 の計数契約を実装していないジョブを本番データに対して実行してはならない（MUST NOT）。例外は読み取り専用かつ冪等な調査クエリのみ（MAY）。

---

## §2. ジョブサマリ・失敗計数契約 (Job Summary & Failure Accounting Contract)

> 本セクションが本ファイルの核である。ここで定義する契約は特定言語の API ではなく、**どの言語・どの実行基盤でも同型に実装できる論理契約**である。

### §2.1. 標準フィールド契約

-   **Rule 700.2.1（標準フィールド）**: 全ジョブは実行終了時に、以下のフィールドを持つ**ジョブ実行サマリ**を生成しなければならない（MUST）:

| フィールド | 型 | 意味 |
|:----------|:---|:-----|
| `jobName` / `runId` | string | ジョブ識別子と実行単位の一意 ID |
| `total` | int | 対象として抽出された item 総数 |
| `processed` | int | 処理を試行した item 数 |
| `succeeded` | int | 成功した item 数 |
| `failed` | int | 失敗した item 数 |
| `skipped` | int | 意図的にスキップした item 数（理由コード必須、§2.3） |
| `retried` | int | リトライが発生した item 数（最終的な成否とは独立に計数） |
| `failuresByReason` | map<string, int> | 失敗分類（§2.7 タクソノミ）別のカウント |
| `failureSamples` | array | 代表失敗サンプルへの参照（item ID + エラー要約。上限付き、PII は §5.4） |
| `startedAt` / `endedAt` | timestamp | 実行開始・終了時刻（UTC） |
| `durationMs` | int | 実行時間 |
| `outcome` | enum | `success` / `partial_failure` / `failure` の3値（§2.2） |

-   **Rule 700.2.2（計数不変条件）**: サマリは以下の不変条件を満たさなければならず、終了時に自己検証する（MUST）:
    -   `processed == succeeded + failed`
    -   `total >= processed + skipped`（差分は「未到達」として明示報告する）
    -   `failed == sum(failuresByReason.values)`
-   **先行例**: Spring Batch `StepExecution` の `readCount` / `writeCount` / `skipCount` / `rollbackCount` は、この契約の最も枯れた先行実装である。新規に発明するのではなく、同型の契約を自分のスタックに移植せよ。

### §2.2. 3値 outcome — 部分失敗を「成功」として返さない

-   **Rule 700.2.3（3値 outcome）**: ジョブの最終結果は `success`（全件成功）/ `partial_failure`（一部失敗）/ `failure`（全件失敗または続行不能）の**3値で区別**しなければならない（MUST）。
-   **Rule 700.2.4（部分失敗の偽装禁止）**: 1件でも失敗した実行を、exit code 0・HTTP 2xx・ジョブステータス「成功」として報告してはならない（MUST NOT）。これは本ファイルで最も重い禁止事項である。部分失敗の隠蔽は、データ欠損が**数週間後に別の場所で**発覚する典型的な原因となる。
-   **実装指針**: 実行基盤が3値を表現できない場合（成功/失敗の2値しかない場合）は、`partial_failure` を**失敗側**に倒す（SHOULD）。「ほぼ成功だから成功」は許可されない。
-   **先行契約**: Robocopy の exit code ビットマスク、rsync の exit 23/24（partial transfer）、AWS Lambda の `ReportBatchItemFailures` は、いずれも「部分失敗は成功と別の値」という同一思想の先行契約である。
-   **exit code 規約（CLI / コンテナジョブ）**: `0` = success、`1` = failure、専用コード（例: `3`）= partial_failure を推奨（SHOULD）。bash 例は §6.3。

### §2.3. skipped / dedup の計数義務

-   **Rule 700.2.5（スキップ計数）**: 意図的なスキップ（フィルタ条件・既処理判定・dedup）も**必ず計数し、理由コードを付与**する（MUST）。無音で捨てられた item は「失敗」よりも発見が難しい。
-   **Rule 700.2.6（dedup の可視化）**: 冪等化・重複排除によって実行されなかったジョブ / item も、観測可能なイベントとして記録する（SHOULD）。先行例: GitLab の idempotent jobs は重複排除された実行を明示的に計上する。
-   **判定基準**: 「`total` と `succeeded` の差を、サマリだけで完全に説明できるか？」— できなければ無音破棄が存在する。

### §2.4. per-item 失敗捕捉と元ペイロード保全（DLQ）

-   **Rule 700.2.7（per-item 捕捉）**: 失敗は**item 単位**で捕捉し、1 item の失敗がバッチ全体を未計数のまま中断させてはならない（MUST）。バッチ全体を単一 try/catch で包む実装は §7 アンチパターンである。
-   **Rule 700.2.8（元ペイロード保全）**: 失敗 item は、**再処理に必要な元ペイロード（または元データへの参照）+ 失敗理由 + 失敗時メタデータ**を添えて dead-letter 置き場（DLQ / 失敗テーブル / 失敗ファイル）へ退避する（MUST）。先行例: Pub/Sub の dead-letter topic は転送時に元 subscription と配信回数を属性として付与する。
-   **Rule 700.2.9（DLQ は監視対象）**: DLQ の滞留件数と滞留時間はメトリクス化し、閾値超過でアラートする（MUST）。退避して終わりの DLQ は「第二の墓場」である（アラート設計は `operations/400` へ委譲）。

### §2.5. 1実行1 canonical サマリ行

-   **Rule 700.2.10（canonical サマリ行）**: 1回のジョブ実行につき、§2.1 の全フィールドを含む**構造化・機械可読のサマリログを正確に1行**出力する（MUST）。進捗ログを何行出力してもよいが（MAY）、集計・検索・アラートの正本はこの1行である。
-   **先行例**: Stripe の canonical log lines（1リクエスト1集約行）のジョブ版である。リクエスト型の canonical log line 基盤は `operations/400` §13 を参照。
-   **JSON 例**: §6.2 参照。

### §2.6. メトリクス計上規約（OTel 整合）

-   **Rule 700.2.11（メトリクス計上）**: サマリの主要カウント（processed / succeeded / failed / skipped）と duration は、ログとは別に**メトリクスとしても計上**する（MUST）。ログだけでは「ジョブ別エラー率の推移」を低コストで集計できない。
-   **Rule 700.2.12（OTel semantic conventions 準拠）**: メトリクス・属性の命名は OpenTelemetry semantic conventions に整合させる（SHOULD）:
    -   失敗理由の属性は `error.type` 相当の**低カーディナリティ値**（§2.7 タクソノミのコード）に限定する。item ID・生メッセージを属性に入れてはならない（MUST NOT）
    -   単位はメトリクス名・単位注釈で明示する（`_total`, `duration` は ms/s を明記）
-   **委譲**: カーディナリティ管理・命名規約の総論は `ai/100` §14.3–§14.4 を正本とする。

### §2.7. 失敗分類タクソノミ（retryable × 起因軸）

-   **Rule 700.2.13（失敗分類）**: 全失敗は **2軸のタクソノミ**で分類する（MUST）:

| | `user`（入力・データ起因） | `system`（自システム起因） | `dependency`（外部依存起因） |
|:--|:--|:--|:--|
| **`retryable`** | （原則存在しない — 入力は再試行しても変わらない） | 一時的リソース枯渇・デッドロック | タイムアウト・5xx・レート制限 |
| **`non_retryable`** | バリデーション違反・参照整合性違反 | バグ・設定誤り・不変条件違反 | 4xx（認証・権限・不正リクエスト） |

-   **Rule 700.2.14（分類コードの安定性）**: 分類コードは低カーディナリティの安定した enum とし、`failuresByReason` のキーおよびメトリクス属性として共用する（MUST）。
-   **先行例**: gRPC status codes（`UNAVAILABLE` は retryable、`INVALID_ARGUMENT` は non-retryable）、Google AIP-193/194 のエラー設計・自動リトライ判定はこのタクソノミの先行整理である。
-   **接続**: この分類は §3.10 のリトライ規律（retryable のみ再試行）の入力となる。分類なきリトライは盲目の再試行である。

### §2.8. Silent Failure 禁止

-   **Rule 700.2.15（空 catch 禁止）**: 例外・エラーを捕捉して**何もしない**（ログなし・計数なし・再 throw なし）コードを書いてはならない（MUST NOT）。先行規範: Google Java Style 6.2（例外を無視しない）、.NET CA1031（過度に広範な catch の禁止）。
-   **Rule 700.2.16（意図的無視の明示）**: 例外を意図的に無視することが正当な場合（クリーンアップ時の二次エラー等）は、**理由を説明するコメントを必須**とし、可能なら `skipped` として計数する（MUST）。
-   **Rule 700.2.17（握りつぶしの定義拡張）**: 「catch してログだけ出して計数しない」も silent failure である。ログは流れ去るが、計数はサマリに残る。**計数なきログ出力は捕捉とみなさない**（MUST）。

### §2.9. 言語非依存の契約 interface

-   **Rule 700.2.18（契約の言語非依存性）**: §2.1 の契約は言語を問わず同型に実装する。以下は**参考表現**であり（e.g. TypeScript / Python）、特定言語の採用を強制するものではない:

```typescript
// 参考実装例（e.g. TypeScript）— 言語非依存契約の代表表現
type JobOutcome = 'success' | 'partial_failure' | 'failure';

interface JobRunSummary {
  jobName: string;
  runId: string;
  total: number;
  processed: number;
  succeeded: number;
  failed: number;
  skipped: number;
  retried: number;
  failuresByReason: Record<string, number>; // §2.7 タクソノミコードがキー
  failureSamples: Array<{ itemId: string; reason: string; message: string }>;
  startedAt: string; // ISO 8601 UTC
  endedAt: string;
  durationMs: number;
  outcome: JobOutcome;
}
```

```python
# 参考実装例（e.g. Python）— 同一契約の型ヒント版
from typing import Literal, TypedDict

class JobRunSummary(TypedDict):
    job_name: str
    run_id: str
    total: int
    processed: int
    succeeded: int
    failed: int
    skipped: int
    retried: int
    failures_by_reason: dict[str, int]
    failure_samples: list[dict]  # {item_id, reason, message}（上限付き）
    started_at: str
    ended_at: str
    duration_ms: int
    outcome: Literal["success", "partial_failure", "failure"]
```

-   集計ヘルパー（FailureCounter）の参考実装は §6.1。

---

## §3. バックフィル / 機械呼出ジョブ規律 (Backfill & Machine-Invoked Job Discipline)

### §3.1. 冪等設計（at-least-once 前提）

-   **Rule 700.3.1（at-least-once 前提）**: キュー・スケジューラ・リトライ機構は**重複配信・重複起動する**前提で設計する（MUST）。exactly-once を基盤に期待した設計は禁止する。
-   **Rule 700.3.2（冪等キー + 一意制約）**: 書き込みを伴う処理は、**冪等キー（自然キーまたは導出キー）+ ストレージ側の一意制約**で重複適用を構造的に防ぐ（MUST）。アプリ側の「既存チェック → 挿入」だけでは競合時に破れる。
-   **先行例**: Stripe の Idempotency-Key、AWS Builders' Library「Making retries safe with idempotent APIs」。

### §3.2. チェックポイント / watermark 永続化と再開

-   **Rule 700.3.3（チェックポイント義務）**: 実行時間が分単位を超えうるジョブは、**進捗（最後に処理した位置 / watermark）を永続化**し、失敗・中断後に**続きから再開**できなければならない（MUST）。「失敗したら最初から」は、再実行のたびに障害窓を広げる。
-   **Rule 700.3.4（再開の検証）**: チェックポイントからの再開は §4.2 のテストで検証されていなければならない（MUST）。
-   **先行例**: Flink の checkpoint / savepoint、Temporal の heartbeat + 進捗永続化。

### §3.3. チャンク分割とスロットリング（背圧）

-   **Rule 700.3.5（チャンク分割）**: 大量データへの書き込みは固定上限のチャンクに分割し、チャンク間に待機を挟む（MUST）。具体的な SQL 安全基準（バッチサイズ・sleep）は `engineering/000` Part XVII を正本とする。
-   **Rule 700.3.6（健全性連動の背圧）**: チャンクサイズ・並列度・待機時間は固定値ではなく、**下流（DB・外部 API）の健全性指標に連動**して自動減速できる設計を推奨する（SHOULD）。先行例: GitLab の batched background migrations は DB 健全性シグナルで自動的に停止・減速する。

### §3.4. dry-run 必須プロトコル

-   **Rule 700.3.7（dry-run 必須）**: 書き込みを伴うバックフィル・移行は、**dry-run モード（書き込みなしで対象件数・変更内容を報告）を実装し、本実行前に必ず実施**する（MUST）。
-   **Rule 700.3.8（段階的拡大）**: 本実行は段階的に拡大する（MUST）: ① dry-run（全件・書き込みなし）→ ② 1% 程度の限定実行 → ③ staging / 非本番での全件 → ④ 本番 canary（限定範囲）→ ⑤ 本番全件。各段階で §2 サマリと §3.7 検証を確認してから次へ進む。
-   **先行例**: Google SRE Workbook Ch.13（Data Processing Pipelines）の段階的ロールアウト原則。

### §3.5. 4段階移行（dual-write → read → write → 旧削除）

-   **Rule 700.3.9（4段階移行）**: 稼働中システムのデータ移行は以下の4段階で行い、段階の省略・順序逆転を禁止する（MUST）:
    1.  **Dual-write**: 新旧両方へ書き込み（旧が正、新は追従）
    2.  **Read 切替**: 読み取りを新へ切替（書き込みは両方継続）
    3.  **Write 切替**: 書き込みを新のみへ
    4.  **旧削除**: 検証完了（§3.7）後にのみ旧経路・旧データを削除
-   **Rule 700.3.10（dual-write 整合性）**: dual-write 期間の新旧不整合は**必ず発生する**前提で、監査ログまたはキュー経由の突合で検知・修復する仕組みを持つ（MUST）。
-   **先行例**: Stripe のオンラインマイグレーション4段階、Notion のシャーディング移行（監査ログ + 突合で dual-write を検証）。

### §3.6. Shadow Read / Scientist パターン

-   **Rule 700.3.11（新旧比較）**: 読み取り経路の切替前に、**新旧両方から読んで結果を比較し、差分を計数する shadow read**を実施することを推奨する（SHOULD）。差分は §2.1 サマリと同様に計数・サンプル保全する。
-   **先行例**: GitHub の Scientist パターン（候補経路を本番トラフィックで並走させ、結果差分のみ記録する）。

### §3.7. 検証の独立（件数 + checksum + サンプリング）

-   **Rule 700.3.12（3層検証）**: 移行・バックフィルの完了判定は、最低限以下の3層で検証する（MUST）:
    1.  **件数照合**: 新旧の対象件数一致（最も安価・最も粗い）
    2.  **集約値照合**: checksum / hash / 集約統計（sum, min, max）の一致
    3.  **サンプリング照合**: 無作為抽出した item の**フィールド単位**の完全一致
-   **Rule 700.3.13（検証の独立性）**: 検証は**移行実装とは独立したコード（可能なら別の担当者）**で行う（MUST）。移行コードのバグは、同じコードによる検証では原理的に検出できない。
-   **先行例**: Notion の移行検証（独立した突合ジョブ）、GCP Data Validation Tool（DVT — 移行とは独立した照合ツール）。

### §3.8. 順序保証と依存関係の処理順

-   **Rule 700.3.14（依存順処理）**: 参照整合性（FK 相当）・因果関係のあるデータは、**親 → 子の依存順**で処理する（MUST）。並列化は依存グラフ上で独立な単位（例: テナント単位・集約ルート単位）に限定する。
-   **Rule 700.3.15（順序依存の明示）**: item 間の処理順序に意味がある場合（イベント再生等）は、その前提をジョブ定義に明示し、並列度 1 を強制するか、順序キー単位の逐次性を保証する（MUST）。

### §3.9. Kill Switch / Pause の事前準備

-   **Rule 700.3.16（kill switch 必須）**: 本番データへ書き込むバックフィル・移行は、**実行開始前に**安全な停止手段（kill switch / pause）を用意し、動作確認しておく（MUST）。「止め方を走りながら考える」ことを禁止する。
-   **Rule 700.3.17（停止の安全性）**: 停止はチャンク境界で行われ、チェックポイント（§3.2）と整合して**再開可能**でなければならない（MUST）。プロセス kill しか手段がない設計は不合格である。
-   **先行例**: LaunchDarkly の migration / kill-switch フラグ分類、Shopify maintenance_tasks（pause / resume / 進捗永続化を標準装備）。

### §3.10. リトライ規律（単一レイヤ・backoff + jitter）

-   **Rule 700.3.18（単一レイヤリトライ）**: リトライは**アーキテクチャ内の単一レイヤ**に集約する（MUST）。アプリ・キュー・スケジューラ・クライアントの各層が独立にリトライすると、失敗時に試行数が乗算され retry storm となる。
-   **Rule 700.3.19（backoff + jitter + 上限）**: リトライは exponential backoff + jitter + **最大試行回数の上限**を必須とする（MUST）。先行例: AWS Architecture Blog「Exponential Backoff And Jitter」。
-   **Rule 700.3.20（non-retryable の即時確定）**: §2.7 で `non_retryable`（4xx 系・バリデーション違反等）に分類された失敗を再試行してはならない（MUST NOT）。即座に failed として計数し、DLQ へ退避する。

### §3.11. スケジューラ catchup 統制

-   **Rule 700.3.21（auto-catchup 既定無効）**: スケジューラの「未実行分の自動追いつき実行（catchup / backfill）」は**既定で無効**とする（MUST）。長期停止からの復帰時に過去分が殺到する事故を防ぐ。
-   **Rule 700.3.22（明示バックフィル）**: 過去分の実行が必要な場合は、**対象期間と並列度上限を明示した手動バックフィル**として実行する（MUST）。先行例: Airflow の `catchup=False` 既定化と明示的 backfill コマンド + `max_active_runs` 制限。

### §3.12. 対象抽出の本番分離

-   **Rule 700.3.23（抽出の分離）**: バックフィル対象の抽出（大量スキャン・重い集計）は、本番プライマリ DB から分離した**スナップショット・レプリカ・分析基盤**に対して行う（SHOULD）。本番への書き込みは ID リスト化された対象に対する制御されたチャンク処理（§3.3）のみとする。
-   **先行例**: Stripe のオンラインマイグレーションにおけるスナップショット由来の対象抽出。

---

## §4. テスト義務 (Testing Obligations)

> テスト層の定義（ユニット / 統合 / E2E）・テストダブル・Testcontainers 等の総論は `quality/000_qa_testing.md` §5–§6 を正本とする。本セクションは**ジョブ固有のテスト義務のみ**を定義する。

-   **Rule 700.4.1（冪等性テスト）**: 同一入力でジョブを**2回実行し、最終状態が1回実行時と完全一致**することを検証するテストを必須とする（MUST）。先行例: GitLab の idempotent worker 用 shared example（全冪等ジョブに同一のテスト雛形を適用）。擬似コードは §6.4。
-   **Rule 700.4.2（チェックポイント再開テスト）**: 処理途中で意図的に中断し、**チェックポイントから再開して欠損・重複なく完了**することを検証する（MUST）。中断点はチャンク境界と非境界の両方を試す（SHOULD）。
-   **Rule 700.4.3（部分失敗テスト）**: 一部 item を意図的に失敗させ、以下を検証する（MUST）:
    -   失敗 item が `failed` および `failuresByReason` に正しく計数される
    -   失敗 item の元ペイロードが DLQ（§2.4）へ退避される
    -   成功 item の処理が失敗 item に巻き込まれない
    -   outcome が `partial_failure` になり、成功として報告されない（§2.2）
-   **Rule 700.4.4（リトライ分類テスト）**: `retryable` 失敗が backoff 付きで再試行され、`non_retryable` 失敗が**再試行されずに即時確定**することを、分類コードごとに検証する（MUST）。

---

## §5. 多角観点 (Multi-Perspective Review)

### §5.1. 可観測性

-   **Rule 700.5.1（実行中の進捗可視化）**: 長時間ジョブは終了時サマリ（§2.5）に加え、**実行中の処理レート・エラー率・進捗（processed/total）・推定残り時間**を観測可能にする（SHOULD）。「終わるまで何も見えない」ジョブは、停止判断（§3.9）を不可能にする。

### §5.2. FinOps

-   **Rule 700.5.2（コスト事前見積もり）**: 大規模バックフィルは実行前に、**ジョブ自体のコスト（コンピュート・読み書き課金）と下流への誘発コスト**を概算する（SHOULD）。従量課金基盤では「全件再処理」が請求の崖（scale cliff）になりうる。dry-run（§3.4）の件数報告を見積もりの入力とする。コスト統制の総論は `operations/600_cloud_finops.md` を参照。

### §5.3. 性能と下流保護

-   **Rule 700.5.3（下流保護優先）**: ジョブのスループット最大化より**下流（本番 DB・外部 API）の保護を優先**する（MUST）。背圧（§3.3）・レート制限遵守・オフピーク実行を基本とし、ジョブ起因で本番 SLO を毀損した場合は即時 pause（§3.9）する。

### §5.4. プライバシー

-   **Rule 700.5.4（失敗サンプルの PII 統制）**: `failureSamples`・DLQ に保全する元ペイロードに PII が含まれる場合、**マスキング・トークン化・参照化（ID のみ保持）**のいずれかを適用する（MUST）。DLQ は本番テーブルより監視が緩くなりがちな「影のデータストア」であり、保持期間も明示する。詳細は `security/000` §7 および `ai/100` §15.3 を正本とする。

### §5.5. Zero Trust（ジョブの最小権限）

-   **Rule 700.5.5（ジョブ専用最小権限）**: ジョブは**専用のワークロード ID と最小権限**で実行する（MUST）。「管理者権限の汎用バッチユーザー」を共用してはならない（MUST NOT）。バックフィルのような一時的ジョブの権限は、完了後に失効させる（SHOULD）。

---

## §6. 実装スニペット (Implementation Snippets)

> 以下はすべて**参考実装**（e.g. TypeScript / bash）であり、言語非依存契約（§2）の代表例として示す。自スタックの慣用形に翻訳して用いること。

### §6.1. FailureCounter ヘルパー（e.g. TypeScript）

```typescript
// §2.1 契約を満たすサマリを安全に組み立てる参考実装
class FailureCounter {
  private succeeded = 0;
  private failed = 0;
  private skipped = 0;
  private retried = 0;
  private byReason = new Map<string, number>();
  private samples: Array<{ itemId: string; reason: string; message: string }> = [];
  private static readonly MAX_SAMPLES = 20;

  ok(): void { this.succeeded++; }
  skip(): void { this.skipped++; }
  retry(): void { this.retried++; }

  fail(itemId: string, reason: string, message: string): void {
    this.failed++;
    this.byReason.set(reason, (this.byReason.get(reason) ?? 0) + 1);
    if (this.samples.length < FailureCounter.MAX_SAMPLES) {
      this.samples.push({ itemId, reason, message }); // PII は §5.4 に従いマスク済みであること
    }
  }

  summarize(jobName: string, runId: string, total: number, startedAt: Date): JobRunSummary {
    const endedAt = new Date();
    const processed = this.succeeded + this.failed; // §2.2 不変条件を構造的に保証
    const outcome = this.failed === 0 ? 'success'
      : this.succeeded === 0 ? 'failure' : 'partial_failure';
    return {
      jobName, runId, total, processed,
      succeeded: this.succeeded, failed: this.failed,
      skipped: this.skipped, retried: this.retried,
      failuresByReason: Object.fromEntries(this.byReason),
      failureSamples: this.samples,
      startedAt: startedAt.toISOString(), endedAt: endedAt.toISOString(),
      durationMs: endedAt.getTime() - startedAt.getTime(),
      outcome,
    };
  }
}
```

### §6.2. canonical サマリ行の JSON 例（§2.5）

```json
{
  "timestamp": "2026-06-12T03:15:42.000Z",
  "level": "warn",
  "msg": "job_run_completed",
  "jobName": "backfill_order_totals",
  "runId": "run_01HXYZ",
  "total": 120000,
  "processed": 119500,
  "succeeded": 119480,
  "failed": 20,
  "skipped": 500,
  "retried": 35,
  "failuresByReason": { "dependency.retryable.timeout": 14, "user.non_retryable.validation": 6 },
  "failureSamples": [{ "itemId": "ord_8821", "reason": "user.non_retryable.validation", "message": "negative amount" }],
  "startedAt": "2026-06-12T02:50:00.000Z",
  "endedAt": "2026-06-12T03:15:42.000Z",
  "durationMs": 1542000,
  "outcome": "partial_failure"
}
```

### §6.3. 3値 exit code の bash 例（§2.2）

```bash
#!/usr/bin/env bash
# ジョブ実行後、サマリ JSON から 3 値 exit code を決定する参考実装
set -euo pipefail

outcome=$(jq -r '.outcome' job_summary.json)

case "$outcome" in
  success)          exit 0 ;;  # 全件成功
  partial_failure)  exit 3 ;;  # 部分失敗 — 0 を返してはならない（Rule 700.2.4）
  failure)          exit 1 ;;  # 全件失敗・続行不能
  *)                echo "unknown outcome: $outcome" >&2; exit 1 ;;
esac
```

### §6.4. 冪等性テストの擬似コード（§4.1）

```text
test "ジョブは冪等である（2回実行しても結果不変）":
  given: 初期状態 S0 と入力データセット D を準備する
  when:  ジョブを D に対して実行する          → 状態 S1、サマリ A
  and:   同一ジョブを D に対して再実行する     → 状態 S2、サマリ B
  then:  S2 == S1                       （状態が変化しない）
  and:   B.failed == 0                  （再実行がエラーにならない）
  and:   B.skipped + B.succeeded == B.processed + B.skipped
         （再実行分は skipped（既処理）または冪等な上書き成功として計数される）
```

---

## §7. アンチパターン集 (Anti-Pattern Catalog)

| # | アンチパターン | 違反ルール | 帰結 |
|:--|:-------------|:----------|:-----|
| 1 | バッチ全体を単一 try/catch で包み、per-item 失敗が消える | 700.2.7 | 1件の失敗で全体が不明確に死ぬ / 失敗 item を特定できない |
| 2 | 部分失敗なのに exit 0 / 成功ステータスを返す | 700.2.4 | データ欠損が数週間後に別の場所で発覚する |
| 3 | skipped / dedup を計数せず無音で捨てる | 700.2.5 | 「処理されなかった item」の存在自体に気づけない |
| 4 | kill switch / pause を用意せずに本番バックフィル開始 | 700.3.16 | 異常検知後も止められず被害が拡大する |
| 5 | dry-run を省略していきなり全件書き込み | 700.3.7 | 対象件数の桁違い・条件誤りに本番で気づく |
| 6 | 検証を移行実装と同一人物・同一コードで実施 | 700.3.13 | 移行コードのバグを検証が素通しする |
| 7 | アプリ + キュー + スケジューラの多層リトライで retry storm | 700.3.18 | 障害時に試行数が乗算され下流を圧殺する |
| 8 | catch して握りつぶし（空 catch・ログのみ・計数なし） | 700.2.15–17 | silent failure の温床 / サマリが現実と乖離する |
| 9 | `error.type` 相当の属性に item ID・生メッセージを入れる | 700.2.12 | メトリクス基盤のカーディナリティ爆発・コスト急騰 |
| 10 | 失敗サンプル / DLQ に生 PII を無期限保存 | 700.5.4 | 影のデータストア化・コンプライアンス違反 |
| 11 | 冪等設計なしで at-least-once キューに接続 | 700.3.1–2 | 重複配信のたびに二重処理・二重課金が発生する |
| 12 | チェックポイントなしの長時間ジョブ | 700.3.3 | 失敗のたびに最初から再実行し障害窓が拡大する |
| 13 | 無制限並列・スロットリングなしで本番 DB に書き込む | 700.3.5–6 | バックフィルが本番サービスの SLO を毀損する |
| 14 | non_retryable（4xx 系）失敗を無限リトライ | 700.3.20 | 絶対成功しない試行でキューとログが汚染される |
| 15 | スケジューラの auto-catchup を有効のまま長期停止から復帰 | 700.3.21 | 過去分ジョブが殺到し下流が飽和する |
| 16 | 対象抽出の重いスキャンを本番プライマリ DB で実行 | 700.3.23 | 抽出クエリ自体が本番性能事故になる |
| 17 | dual-write 期間の新旧不整合を突合せず放置 | 700.3.10 | read 切替時に不整合データがユーザーへ露出する |
| 18 | 検証完了前に旧データ・旧経路を削除 | 700.3.9 | 不可逆。ロールバック先が消滅する |
| 19 | DLQ を設定するだけで滞留を監視しない | 700.2.9 | 退避した失敗が永遠に再処理されない「第二の墓場」 |
| 20 | サマリをログにのみ書き、メトリクス計上しない | 700.2.11 | エラー率の推移・劣化傾向を集計できない |

---

## §8. 成熟度モデル L1–L5 (Maturity Model)

| Level | 状態 | 特徴 |
|:------|:-----|:-----|
| **L1: Blind** | 失敗が見えない | ジョブは動くが計数なし。失敗はユーザー報告や偶然で発覚。空 catch が存在する |
| **L2: Logged** | ログはあるが契約がない | エラーログは出るが計数契約（§2.1）・3値 outcome（§2.2）がなく、部分失敗が成功に混入する |
| **L3: Accounted** | 失敗計数契約を実装 | 全ジョブが JobRunSummary + canonical サマリ行 + DLQ を実装。冪等性・部分失敗テスト（§4）あり |
| **L4: Operated** | 運用規律が定着 | dry-run / 段階実行 / kill switch / チェックポイント再開が標準手順。メトリクス + アラートで劣化を検知 |
| **L5: Verified** | 独立検証と継続改善 | 移行は4段階 + 独立検証（§3.7）が既定。shadow read / 突合が自動化され、失敗分類の傾向がプロセス改善に還流する |

-   **Rule 700.8.1（最低ライン）**: 本番データへ書き込む全ジョブは **L3 以上**を必須とする（MUST）。移行・大規模バックフィルの実施は **L4 相当の運用手順**を満たしてから行う（MUST）。

---

## Appendix A: 逆引き索引（キーワード → セクション）

| キーワード | セクション |
|:----------|:----------|
| 適用範囲 / 機械呼出 / どのジョブが対象か | §1.1 |
| 責任分界 / 委譲先 / 隣接ファイル境界 | §1.2 |
| JobRunSummary / 標準フィールド / 計数不変条件 | §2.1 |
| outcome 3値 / partial_failure / exit code | §2.2, §6.3 |
| skipped / dedup / 無音破棄禁止 | §2.3 |
| DLQ / dead-letter / 元ペイロード保全 | §2.4 |
| canonical サマリ行 / 1実行1行 | §2.5, §6.2 |
| メトリクス / OTel / error.type / カーディナリティ | §2.6 |
| 失敗分類 / retryable / non_retryable / user / system / dependency | §2.7 |
| silent failure / 空 catch 禁止 / 握りつぶし | §2.8 |
| 契約 interface（TypeScript / Python 参考） | §2.9, §6.1 |
| 冪等性 / 冪等キー / 一意制約 / at-least-once | §3.1 |
| チェックポイント / watermark / 再開 | §3.2 |
| チャンク分割 / スロットリング / 背圧 | §3.3 |
| dry-run / 1% 実行 / canary / 段階的拡大 | §3.4 |
| 4段階移行 / dual-write / read 切替 / 旧削除 | §3.5 |
| shadow read / Scientist パターン / 新旧比較 | §3.6 |
| 検証 / 件数照合 / checksum / サンプリング / 検証の独立 | §3.7 |
| 処理順 / FK 依存 / 順序保証 | §3.8 |
| kill switch / pause / 停止手段 | §3.9 |
| リトライ / backoff / jitter / retry storm / 単一レイヤ | §3.10 |
| catchup / auto-catchup 無効 / 明示バックフィル / 並列度制限 | §3.11 |
| 対象抽出 / スナップショット / レプリカ分離 | §3.12 |
| 冪等性テスト / 再開テスト / 部分失敗テスト / リトライ分類テスト | §4 |
| 進捗可視化 / 処理レート / 残り時間 | §5.1 |
| FinOps / ジョブコスト / scale cliff | §5.2 |
| 下流保護 / SLO 毀損時 pause | §5.3 |
| PII マスキング / 失敗サンプル / DLQ 保持期間 | §5.4 |
| 最小権限 / ワークロード ID / Zero Trust | §5.5 |
| FailureCounter / 参考実装 | §6.1 |
| アンチパターン | §7 |
| 成熟度モデル / L1–L5 / 最低ライン | §8 |

---

**参考規格・先行事例（References）**: RFC 2119 / OpenTelemetry Semantic Conventions / Spring Batch StepExecution / AWS Lambda ReportBatchItemFailures / rsync・Robocopy exit codes / Stripe canonical log lines・idempotency・online migrations / GitLab idempotent jobs・batched background migrations / Google SRE Workbook Ch.13 / GitHub Scientist / Notion sharding migrations / GCP Data Validation Tool / LaunchDarkly migration flags / Shopify maintenance_tasks / Airflow catchup / AWS Builders' Library / gRPC status codes / Google AIP-193・194 / Google Java Style 6.2 / .NET CA1031

**Cross-Reference（関連ルール）:**
-   `quality/000_qa_testing.md` — §5 ユニットテスト・§6 統合テスト（テスト層定義の正本。本ファイル §4 はジョブ固有義務のみ）
-   `engineering/710_data_reconciliation.md` — **定常的な**整合検証・不変量・説明可能性 SLO の正本（本ファイルが扱うのは移行時の突合とジョブ単位の失敗計数まで）
-   `engineering/740_data_contracts.md` — 境界越えデータの生産者/消費者契約（スキーマ検証失敗は本ファイル §2.4 の計数+DLQ 規律で受ける）
-   `ai/100_data_analytics.md` — Part XI–XV 可観測性・メトリクス・構造化ログの基盤総論（§14.3 カーディナリティ・§15.3 ログ PII）
-   `operations/400_site_reliability.md` — §13 Canonical Log Lines・§22–§26 SLO ベースアラート（サマリ行の収集・通知側）
-   `operations/500_incident_response.md` — ジョブ失敗が事故化した際の対応・ロールバック手順
-   `operations/600_cloud_finops.md` — ジョブコスト統制・従量課金の崖対策（本ファイル §5.2 の総論）
-   `engineering/000_engineering_standards.md` — Part XVII Expand-Contract・バックフィル SQL 安全基準（DDL/DML 層の正本）
-   `engineering/100_api_integration.md` — Webhook / イベント駆動のリトライ・Poison Message（同期 API 境界）
-   `engineering/200_supabase_architecture.md` — マイグレーション不変性・DB 層の運用規律
-   `engineering/500_firebase_gcp.md` — §38 バッチ処理 & データパイプライン（GCP 固有構成）
-   `engineering/510_aws_cloud.md` — AWS 固有のバッチ / キュー構成（SQS・Lambda・Step Functions）
-   `security/000_security_privacy.md` — §7 プライバシー・バイ・デザイン（失敗サンプル・DLQ の PII 統制）
-   `core/000_core_mindset.md` — 検証なき完了報告の禁止・事実ベース報告の基本姿勢

---

**Last Updated**: 2026-06-12
**Authority**: Universal Constitution (axiarch core)
**Classification**: Engineering — Batch, Backfill & Failure Accounting
