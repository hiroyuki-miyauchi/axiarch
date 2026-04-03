# 52. SREと信頼性エンジニアリング (SRE & Reliability Engineering)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> - **「Hope is not a strategy」** — 信頼性は希望ではなくエンジニアリングで達成する。
> - 本番環境の信頼性に影響する全ての判断は、**SLO（Service Level Objective）に基づく定量的根拠**によって行われなければならない。
> - 監視なきシステムは「動いている」のではなく「壊れていることに気づいていない」だけである。
> - **「Slow is the New Down」** — 技術的に稼働していても遅いサービスは「障害」である。ユーザー体感品質を最優先せよ。
> **60パート・60セクション構成。**


---

## 目次

- [Part I: 基盤・哲学](#part-i-基盤哲学)
- [Part II: SLI / SLO / SLA](#part-ii-sli--slo--sla)
- [Part III: エラーバジェット](#part-iii-エラーバジェット)
- [Part IV: 可観測性基盤（Observability Foundation）](#part-iv-可観測性基盤observability-foundation)
- [Part V: 構造化ログ・Canonical Log Lines](#part-v-構造化ログcanonical-log-lines)
- [Part VI: 分散トレーシング](#part-vi-分散トレーシング)
- [Part VII: Continuous Profiling](#part-vii-continuous-profiling)
- [Part VIII: フロントエンド可観測性](#part-viii-フロントエンド可観測性)
- [Part IX: PII保護・ログセキュリティ](#part-ix-pii保護ログセキュリティ)
- [Part X: アラート・通知](#part-x-アラート通知)
- [Part XI: On-Call設計](#part-xi-on-call設計)
- [Part XII: インシデント管理（SRE観点）](#part-xii-インシデント管理sre観点)
- [Part XIII: Blameless文化・Learning from Incidents](#part-xiii-blameless文化learning-from-incidents)
- [Part XIV: デプロイメント戦略](#part-xiv-デプロイメント戦略)
- [Part XV: Progressive Delivery・Feature Flag信頼性](#part-xv-progressive-deliveryfeature-flag信頼性)
- [Part XVI: ロールバック・破壊的変更管理](#part-xvi-ロールバック破壊的変更管理)
- [Part XVII: カオスエンジニアリング・DiRT](#part-xvii-カオスエンジニアリングdirt)
- [Part XVIII: 負荷テスト・フェイルオーバーテスト](#part-xviii-負荷テストフェイルオーバーテスト)
- [Part XIX: レジリエンスパターン](#part-xix-レジリエンスパターン)
- [Part XX: Self-Healing Infrastructure](#part-xx-self-healing-infrastructure)
- [Part XXI: メンテナンスモード・Graceful Degradation](#part-xxi-メンテナンスモードgraceful-degradation)
- [Part XXII: パフォーマンスエンジニアリング](#part-xxii-パフォーマンスエンジニアリング)
- [Part XXIII: キャッシュ戦略](#part-xxiii-キャッシュ戦略)
- [Part XXIV: IaC・GitOps](#part-xxiv-iacgitops)
- [Part XXV: コンテナ / Kubernetes / Service Mesh](#part-xxv-コンテナ--kubernetes--service-mesh)
- [Part XXVI: Serverless / Edge信頼性](#part-xxvi-serverless--edge信頼性)
- [Part XXVII: 容量計画（Capacity Planning）](#part-xxvii-容量計画capacity-planning)
- [Part XXVIII: Toil管理](#part-xxviii-toil管理)
- [Part XXIX: データ耐久性・バックアップ](#part-xxix-データ耐久性バックアップ)
- [Part XXX: 供給チェーン・依存関係信頼性](#part-xxx-供給チェーン依存関係信頼性)
- [Part XXXI: 環境管理・Configuration Management](#part-xxxi-環境管理configuration-management)
- [Part XXXII: FinOps・テレメトリコスト管理](#part-xxxii-finopsテレメトリコスト管理)
- [Part XXXIII: 可観測性ダッシュボード・レポーティング](#part-xxxiii-可観測性ダッシュボードレポーティング)
- [Part XXXIV: SRE as Code・ガバナンス](#part-xxxiv-sre-as-codeガバナンス)
- [Part XXXV: Production Readiness Review](#part-xxxv-production-readiness-review)
- [Part XXXVI: Platform Engineering](#part-xxxvi-platform-engineering)
- [Part XXXVII: AI駆動SRE（AIOps）](#part-xxxvii-ai駆動sreaiops)
- [Part XXXVIII: マルチリージョン・DR（SRE観点）](#part-xxxviii-マルチリージョンdrsre観点)
- [Part XXXIX: SRE組織・文化・教育](#part-xxxix-sre組織文化教育)
- [Part XL: SRE成熟度モデル・アンチパターン](#part-xl-sre成熟度モデルアンチパターン)
- [Part XLI: Database Reliability Engineering](#part-xli-database-reliability-engineering)
- [Part XLII: API Reliability Engineering](#part-xlii-api-reliability-engineering)
- [Part XLIII: Network Reliability・DNS SRE](#part-xliii-network-reliabilitydns-sre)
- [Part XLIV: AI/ML System SRE（MLOps/LLMOps）](#part-xliv-aiml-system-sremlopsllmops)
- [Part XLV: Release Engineering](#part-xlv-release-engineering)
- [Part XLVI: Sustainability / Green SRE](#part-xlvi-sustainability--green-sre)
- [Part XLVII: SRE Economics・ダウンタイムコスト](#part-xlvii-sre-economicsダウンタイムコスト)
- [Part XLVIII: 規制コンプライアンス自動化](#part-xlviii-規制コンプライアンス自動化)
- [Part XLIX: Runbook Automation・自動化フレームワーク](#part-xlix-runbook-automation自動化フレームワーク)
- [Part L: SRE将来展望・新興技術](#part-l-sre将来展望新興技術)
- [Part LI: Observability 2.0・AI駆動可観測性](#part-li-observability-20ai駆動可観測性)
- [Part LII: DORA 5th Metric・信頼性のビジネスKPI化](#part-lii-dora-5th-metric信頼性のビジネスkpi化)
- [Part LIII: SRE as a Service・Developer-First SRE](#part-liii-sre-as-a-servicedeveloper-first-sre)
- [Part LIV: GenAI / RAG Pipeline SRE](#part-liv-genai--rag-pipeline-sre)
- [Part LV: 規制コンプライアンス深化](#part-lv-規制コンプライアンス深化)
- [Part LVI: Incident Analytics・Cognitive Incident Management](#part-lvi-incident-analyticscognitive-incident-management)
- [Part LVII: SRE for Hybrid / Multi-Cloud](#part-lvii-sre-for-hybrid--multi-cloud)
- [Part LVIII: Shift-Left Reliability（CI/CD統合信頼性）](#part-lviii-shift-left-reliabilitycicd統合信頼性)
- [Part LIX: Data-Driven SRE・SREメトリクスウェアハウス](#part-lix-data-driven-sresreメトリクスウェアハウス)
- [Part LX: SRE for IoT / Embedded Systems](#part-lx-sre-for-iot--embedded-systems)
- [Appendix A: 逆引き索引（Quick Reference Index）](#appendix-a-逆引き索引quick-reference-index)
- [Appendix B: クロスリファレンス](#appendix-b-クロスリファレンス)

---

## Part I: 基盤・哲学

### §1. SRE基本原則

*   **Law（Service Reliability Hierarchy）**: SREの目的は「システムを壊れなくすること」ではなく、「システムが壊れた時に素早く復旧し、同じ障害を二度と起こさない仕組みを構築すること」である。

    | 階層 | 内容 | 例 |
    |:-----|:-----|:---|
    | **1. Monitoring（監視）** | 何が起きているかを知る | メトリクス、ログ、トレース |
    | **2. Incident Response（インシデント対応）** | 問題に素早く対応する | オンコール、ランブック |
    | **3. Post-mortem（事後分析）** | 根本原因を理解し再発を防ぐ | Blameless Post-mortem |
    | **4. Testing & Release（テスト・リリース）** | 変更による障害を防ぐ | カナリア、負荷テスト |
    | **5. Capacity Planning（容量計画）** | 未来の需要に備える | リソース予測、飽和度管理 |
    | **6. Development（開発）** | 信頼性を設計に組み込む | SLO駆動開発 |
    | **7. Product（プロダクト）** | ユーザー体験として信頼性を提供 | エラーバジェット駆動意思決定 |

*   **6つの基本原則**:
    1.  **Hope is not a strategy** — 「壊れないだろう」は戦略ではない。全ての前提を検証せよ
    2.  **Embrace risk** — リスクをゼロにするのではなく、計量し管理する（エラーバジェット思想）
    3.  **Eliminate toil** — 反復的・手動的・自動化可能な作業（Toil）を組織的に排除する
    4.  **Move fast, don't break things** — 速度と信頼性は二律背反ではない。SLOとエラーバジェットで両立
    5.  **Measure everything** — 測定できないものは改善できない
    6.  **Slow is the New Down** — 技術的に「稼働中」でも、ユーザーが遅いと感じれば「障害」である。P99テールレイテンシを重視せよ

*   **SREの50%ルール**: SREエンジニアの作業時間のうち、運用作業（Toil含む）は**最大50%**に制限し、残り50%以上をエンジニアリング（自動化・改善）に充てること。超過する場合はToil削減プロジェクトを最優先で起票する。

### §2. SREの役割と責任範囲

*   **本ルール（52）の管轄範囲**:

    | 管轄 | 本ルール（52） | 委譲先 |
    |:-----|:-------------|:------|
    | SLI/SLO/エラーバジェット | ✅ 定義・運用 | — |
    | 可観測性・監視 | ✅ 設計・運用 | — |
    | デプロイ戦略 | ✅ CD/Progressive Delivery | 30 (CI/CD詳細) |
    | カオスエンジニアリング | ✅ 設計・運用 | 70 (テスト戦略) |
    | インシデント対応（詳細） | 概要・SRE固有メトリクス | 53 (Crisis Management) |
    | BCP/DR（詳細） | RPO/RTO概要・Fire Drill | 53 (Crisis Management) |
    | セキュリティ | 可観測性・監査ログ | 60 (Security & Privacy) |
    | パフォーマンス | ✅ ベンチマーク・負荷テスト | — |
    | FinOps | ✅ SRE観点のコスト管理 | — |
    | 容量計画 | ✅ リソース予測・飽和度 | — |
    | Toil管理 | ✅ 定義・測定・削減 | — |
    | Platform Engineering | ✅ IDP基盤原則 | — |
    | Production Readiness Review | ✅ レビュープロセス | — |
    | Database Reliability | ✅ DRE原則・信頼性 | 37 (Supabase詳細) |
    | API Reliability | ✅ API SLO/信頼性 | 35 (API詳細) |
    | AI/ML SRE | ✅ MLOps/LLMOps信頼性 | 40 (AI実装詳細) |

### §3. SREの信頼性アーキテクトとしての進化

*   **Law**: 2025年以降のSREは単なる「サーバー運用者」ではなく、「信頼性のアーキテクト」である。チームやシステムに横断的に組み込まれ、設計段階から信頼性を確保する。
*   **AI時代のSRE**: AI/MLシステムの台頭により、SREはモデルのパフォーマンス監視、推論レイテンシSLO、GPU容量計画など新たな領域に責任を拡張する。
*   **Shift-Left Reliability**: 信頼性を開発ライフサイクルの初期段階（設計・コーディング時）に組み込む。本番投入後に「信頼性を追加する」アプローチは禁止。
*   **Production Excellence**: Googleの手法に倣い、シニアSREリーダーによるチーム横断評価を実施。ページャー負荷、エラーバジェット消費率、プロジェクト完了率を指標とする。

---

## Part II: SLI / SLO / SLA

### §4. SLI設計原則

*   **Law**: SLI（Service Level Indicator）は**ユーザー体験を直接反映する指標**でなければならない。内部メトリクス（CPU使用率等）はSLIではなく、SLI劣化の原因調査に使用する補助指標。
*   **SLI選定の4原則**:
    1.  **ユーザー中心**: ユーザーが体感する品質を測定する（例: レスポンス時間、エラー率）
    2.  **測定可能**: 自動的・継続的に計測できる
    3.  **対処可能**: 値が閾値を超えた時に具体的なアクションが取れる
    4.  **比率ベース**: 「良いイベント / 全イベント」の比率で表現する

*   **SLIカテゴリ別テンプレート**:

    | カテゴリ | SLI定義 | 計測方法（例） |
    |:--------|:-------|:-------------|
    | **可用性** | 成功リクエスト / 総リクエスト | ロードバランサーログ |
    | **レイテンシ** | 閾値以内で完了したリクエスト / 総リクエスト | P50/P95/P99分布 |
    | **品質** | エラーなしレスポンス / 総レスポンス | アプリケーションログ |
    | **鮮度** | 閾値以内に更新されたデータ / 全データ | データパイプラインログ |
    | **正確性** | 正しい結果を返したリクエスト / 総リクエスト | 品質モニタリング |
    | **スループット** | 処理完了タスク / 投入タスク | ジョブキューメトリクス |
    | **耐久性** | データ損失なしの期間 / 総期間 | ストレージ監視 |
    | **カバレッジ** | 正しく処理されたデータ比率 / 総データ | バッチ処理ログ |

### §5. SLO策定・OpenSLO

*   **Law**: プロジェクト開始時にSLOを定義し、月次でレビューしなければならない。SLOは「約束」ではなく「目標」であり、エラーバジェットの消費速度に基づいて意思決定を行う。
*   **SLO設計テンプレート**:

    | サービスカテゴリ | SLI（指標） | SLO（目標例） | 計測方法（例） |
    |:--------------|:----------|:------------|:-------------|
    | **全体稼働率** | 成功リクエスト / 総リクエスト | ≧ 99.9%（月間43分以内の停止） | UptimeRobot / Analytics |
    | **主要API** | P95 レスポンスタイム | ≦ 200ms | Canonical Log Line集計 |
    | **主要API** | P99 レスポンスタイム | ≦ 500ms | テールレイテンシ監視 |
    | **詳細ページAPI** | P95 レスポンスタイム | ≦ 300ms | Canonical Log Line集計 |
    | **静的アセット配信** | P95 TTFB | ≦ 100ms | CDN Analytics |
    | **AI応答** | P95 レスポンスタイム | ≦ 3000ms | AI FinOpsダッシュボード |
    | **エラー率** | 5xxレスポンス比率 | ≦ 0.1% | エラー追跡ツール + Server Logs |

*   **OpenSLO仕様準拠**: SLO定義は**OpenSLO仕様**（YAML）で宣言的に管理。ベンダー中立のSLO定義を可能にし、CIパイプラインで自動検証。

    ```yaml
    # openslo.yaml — OpenSLO仕様準拠SLO定義
    apiVersion: openslo/v1
    kind: SLO
    metadata:
      name: api-availability
      displayName: "主要APIの可用性"
    spec:
      service: api-gateway
      description: "主要APIの可用性SLO"
      budgetingMethod: Occurrences
      objectives:
        - displayName: "99.9% 可用性"
          target: 0.999
          timeWindow:
            - duration: 30d
              isRolling: true
      indicator:
        metadata:
          name: api-availability-sli
        spec:
          ratioMetric:
            good:
              metricSource:
                type: prometheus
                spec:
                  query: sum(rate(http_requests_total{code!~"5.."}[5m]))
            total:
              metricSource:
                type: prometheus
                spec:
                  query: sum(rate(http_requests_total[5m]))
    ```

*   **SLO Controller**: Kubernetes環境ではSLO Controller（Sloth/Pyrra等）を導入し、SLO定義からPrometheusアラートルール・Grafanaダッシュボードを自動生成。SLO定義変更時はCIで自動再生成・適用。
*   **SLO Review Cadence**: 月次でSLI/SLO達成状況をレビューし、閾値の見直しを行う。四半期でSLO妥当性の再評価。
*   **Status Page（障害透明性）**: 外部ステータスページを設置し、SLO達成状況を自動連携。障害の隠蔽は「信頼の死」。

### §6. SLA管理と法的考慮

*   **Law**: SLA（Service Level Agreement）はSLOよりも**保守的**に設定。SLAは法的拘束力を持つ契約であり、違反時にはペナルティが発生。
*   **SLO → SLA変換の原則**: `SLA ≦ SLO - マージン`（例: SLO 99.9% → SLA 99.5%）
*   **計画メンテナンス**: 72時間前通知を義務付け、SLA計算から除外する契約条項を確保。

### §7. 外部依存サービスのSLO統合

*   **Law**: システム全体のSLOは、依存する外部サービスのSLOを超えることはできない（**SLO Chain Rule**）。
*   **Dependency SLI**: 外部サービス（決済API、メール配信、CDN等）ごとにSLIを定義し、依存関係マップ上で可視化。
*   **合成SLO計算**: `System SLO ≦ min(Service_A_SLO × Service_B_SLO × ...)`
*   **Fallback設計**: 外部依存のSLO違反時のフォールバック戦略を事前定義。
*   **Dependency SLO Budget**: 外部依存サービスのSLO違反がシステム全体のエラーバジェットに与える影響を定量化。依存先のSLOが自社SLOの80%以上を消費する場合、フォールバック強化を最優先。

---

## Part III: エラーバジェット

### §8. エラーバジェット基本

*   **Law**: エラーバジェットは「許容される不信頼性の量」。SLOが99.9%なら、月間エラーバジェットは0.1%（約43分）。
*   **Tiered Error Budget Policy**:

    | エラーバジェット残量 | 状態 | アクション |
    |:------------------|:-----|:---------|
    | **> 50%** | 健全 | 通常の機能開発を継続 |
    | **25-50%** | 注意 | リスクの高いリリースを延期。信頼性改善タスクを並行実施 |
    | **5-25%** | 警告 | 新機能リリースを凍結（Feature Freeze）。信頼性改善に集中 |
    | **< 5%** | 危険 | **全リソースを信頼性に集中**。経営陣への報告義務 |
    | **0%（枯渇）** | 枯渇 | 信頼性改善以外の全デプロイを禁止 |

*   **エラーバジェットの経済的影響**: エラーバジェット消費1%あたりのビジネスインパクト（売上損失・ユーザー離脱）を定量化し、経営判断に活用（→ Part XLVII参照）。

### §9. Multi-Window / Multi-Burn-Rateアラート

*   **Law**: エラーバジェットの消費速度（Burn Rate）を**複数の時間窓**で監視し、誤検知を最小化しつつ重大な消費を即座に検出。

    | 窓 | Burn Rate閾値 | アラートレベル | 意味 |
    |:---|:-----------|:-----------|:-----|
    | **1時間 / 5分** | > 14.4 | **P0（即時）** | 1時間で1日分のバジェットを消費するペース |
    | **6時間 / 30分** | > 6.0 | **P1（1時間）** | 6時間で1日分のバジェットを消費 |
    | **1日 / 2時間** | > 3.0 | **P2（4時間）** | 緩やかだが持続的な消費 |
    | **3日 / 6時間** | > 1.0 | **Ticket** | トレンド注視、チケット起票 |

*   **Rationale**: 単一窓のアラートは誤検知か見落としのいずれかに偏る。Google SRE Workbookの推奨するMulti-Window方式を採用。

---

## Part IV: 可観測性基盤（Observability Foundation）

### §10. 五本柱 + Golden Signals

*   **Law**: 可観測性は**Metrics・Logs・Traces・Events・Profiles**の5要素で構成。Continuous Profilingを第5の柱として位置付ける。

    | 柱 | 用途 | 例 |
    |:---|:-----|:---|
    | **Metrics** | 数値データ。傾向把握・アラート | CPU使用率、RPS、エラー率 |
    | **Logs** | イベント詳細記録。デバッグ | リクエストログ、エラーログ |
    | **Traces** | リクエスト経路追跡。ボトルネック特定 | 分散トレーシング |
    | **Events** | 状態変化の記録。変更追跡 | デプロイ、設定変更、スケーリング |
    | **Profiles** | リソース消費の詳細分析 | CPU/Memory/Lock profiling |

*   **Golden Signals（4つの黄金シグナル）**: 全サービスにおいて以下を最優先で監視:
    1.  **Latency（レイテンシ）**: P50/P95/P99。P99テールレイテンシを特に重視
    2.  **Traffic（トラフィック）**: システムへの要求量（RPS等）
    3.  **Errors（エラー）**: 失敗したリクエストの比率
    4.  **Saturation（飽和度）**: リソースの使用率

*   **RED Method（Request-oriented）**: マイクロサービス向け。Rate（リクエスト率）、Errors（エラー率）、Duration（処理時間）
*   **USE Method（Resource-oriented）**: インフラ向け。Utilization（使用率）、Saturation（飽和度）、Errors（エラー率）

### §11. OpenTelemetry統合・パイプラインアーキテクチャ

*   **Law**: 可観測性の計装には**OpenTelemetry（OTel）**を業界標準として採用。ベンダー固有SDKへの直接依存は原則禁止。
*   **OTel採用原則**:
    1.  **ベンダー中立の計装**: アプリにはOTel SDKのみ使用。バックエンドはOTel Collectorを介して接続
    2.  **自動計装の活用**: Auto-Instrumentationを最大限活用。手動計装は必要な箇所のみ
    3.  **セマンティック規約**: 属性名はOTel Semantic Conventions v1.30+準拠（`http.request.method`, `db.system`, `server.address`等）。Stability Guaranteesに従い、Stable属性のみを本番アラートに使用
    4.  **サンプリング戦略**: Head-based / Tail-basedサンプリングでコスト管理

*   **OTel Collectorデプロイパターン**:

    | パターン | 構成 | 適用場面 |
    |:--------|:-----|:--------|
    | **Agent** | 各ノードにSidecar/DaemonSet | 低レイテンシ、ローカルバッファリング |
    | **Gateway** | 集約ゲートウェイ | ルーティング、フィルタリング、サンプリング |
    | **Agent + Gateway** | 二段構成 | 大規模環境の推奨構成 |

    ```yaml
    # otel-collector-config.yaml — OTel Collector Gateway構成例
    receivers:
      otlp:
        protocols:
          grpc:
            endpoint: 0.0.0.0:4317
          http:
            endpoint: 0.0.0.0:4318
    processors:
      batch:
        timeout: 5s
        send_batch_size: 8192
      tail_sampling:
        decision_wait: 10s
        policies:
          - name: errors
            type: status_code
            status_code: {status_codes: [ERROR]}
          - name: slow-traces
            type: latency
            latency: {threshold_ms: 1000}
          - name: probabilistic
            type: probabilistic
            probabilistic: {sampling_percentage: 10}
    exporters:
      otlphttp:
        endpoint: https://your-backend.example.com
    service:
      pipelines:
        traces:
          receivers: [otlp]
          processors: [tail_sampling, batch]
          exporters: [otlphttp]
        metrics:
          receivers: [otlp]
          processors: [batch]
          exporters: [otlphttp]
    ```

*   **Attribute Naming Gateway**: OTel Collectorのattributeプロセッサを活用し、非標準属性名を組織統一名に変換する中央ゲートウェイを設置。属性名の乱立を防止。
*   **OpAMP（Open Agent Management Protocol）**: OTel Collectorのリモート管理プロトコル。大規模環境でのCollector設定の集中管理・動的更新・ヘルス監視を実現。Fleet管理の標準として採用を推奨。

### §12. eBPFベース可観測性

*   **Law**: カーネルレベルの高精度可観測性が必要な場合、**eBPF**ベースのツールを活用。アプリケーションコード変更不要で計装可能。
*   **活用領域**:
    1.  **ネットワーク可観測性**: TCP再送、接続レイテンシ、DNS解決時間
    2.  **アプリケーションプロファイリング**: 関数レベルのCPU/メモリ使用量（コード変更不要）
    3.  **セキュリティ監視**: システムコール監視、異常プロセス検出
    4.  **パフォーマンス分析**: I/Oレイテンシ、スケジューラレイテンシ
*   **ツーリング**: Grafana Beyla（自動計装）、Cilium Hubble（ネットワーク）、bpftrace、Pixie
*   **OTel eBPF SIG**: OTelのeBPF計装SIGが2026年に安定版1.0リリースを予定。ゼロコード可観測性の基盤として活用。
*   **注意**: eBPFはLinuxカーネル5.10+が前提。Managed Kubernetes環境では利用可能性を事前確認。

### §12-b. OTel CI/CD Observability

*   **Law**: CI/CDパイプライン自体を可観測性の対象とする。ビルド・テスト・デプロイの各段階をOTelトレースで計装。
*   **OTel CI/CD Observability SIG（2025-2026）**:
    1.  **パイプライントレース**: ビルド→テスト→デプロイの全段階をOTelスパンで記録。失敗原因のトレーサビリティを確保
    2.  **テスト実行メトリクス**: テスト実行時間、Flakyテスト率、テストカバレッジをOTelメトリクスで自動収集
    3.  **デプロイ相関**: デプロイイベントとSLI変動の自動相関。デプロイ起因のSLI劣化を即時検出
    4.  **Semantic Conventions for CI/CD**: `cicd.pipeline.name`, `cicd.pipeline.run.id`, `cicd.task.type` 等の標準属性を使用

    ```yaml
    # CI/CD OTel計装の概念例（GitHub Actions）
    # OTel Collector経由でビルドメトリクスを送信
    env:
      OTEL_EXPORTER_OTLP_ENDPOINT: "https://collector.example.com:4317"
      OTEL_SERVICE_NAME: "ci-pipeline"
      OTEL_RESOURCE_ATTRIBUTES: "cicd.pipeline.name=main-build,deployment.environment=ci"
    ```

*   **OTel Logs GA（2025）**: OTel LogsシグナルがStable（GA）に昇格。構造化ログのOTel SDKによる統一的な収集が推奨。ベンダー固有のLog Agentへの依存を段階的に削減。

---

## Part V: 構造化ログ・Canonical Log Lines

### §13. 構造化ログ

*   **Law**: ログは**JSON形式（構造化ログ）**で出力。平文ログは禁止。
*   **Log Level Standard**:
    *   `error`: 例外発生、回復不能な状態 — 本番で常時出力
    *   `warn`: 非推奨使用、パフォーマンス懸念 — 本番で常時出力
    *   `info`: 重要なビジネスイベント — 本番で常時出力
    *   `debug`: 開発用詳細情報 — 本番では**無効化**
*   **Canonical Log Lines**: リクエスト終了時に1行の集約ログを出力。

    ```json
    {
      "timestamp": "2026-03-19T00:00:00Z",
      "level": "info",
      "msg": "request_completed",
      "method": "GET",
      "path": "/api/stores/123",
      "status": 200,
      "duration_ms": 45,
      "db_queries": 3,
      "cache_hit": true,
      "request_id": "req_abc123",
      "trace_id": "4bf92f3577b34da6a3ce929d0e0e4736",
      "user_id": "usr_xyz"
    }
    ```

### §14. ログパイプライン信頼性

*   **Law**: ログ自体の欠損は「目が見えない状態での運用」を意味する。ログパイプラインの信頼性を保証せよ。
*   **要件**:
    1.  **バックプレッシャー制御**: ログ生成速度が処理速度を超えた場合、ドロップではなくバッファリング。バッファ上限到達時はサンプリング
    2.  **ログ欠損検知**: シーケンス番号またはハートビートの欠落を検知し、アラート発報
    3.  **デッドレターキュー**: パースエラーのログは破棄せずDLQに退避
    4.  **ログローテーション**: ディスク枯渇防止のためサイズ/時間ベースのローテーション設定
    5.  **暗号化転送**: ログの転送はTLS暗号化を必須化

---

## Part VI: 分散トレーシング

### §15. トレーシング基盤

*   **Law**: 複雑な分散トランザクションには`correlation_id`を付与し、ログを一気通貫で追跡可能にする。
*   **Trace Context伝播**: W3C Trace Context規格準拠の`traceparent`ヘッダーを全サービス間で伝播。
*   **W3C Baggage**: サービス間でビジネスコンテキスト（tenant_id、feature_flag等）を伝播するためにW3C Baggage仕様を活用。ただし機密情報の伝播は禁止。
*   **Outcome**: 障害発生時に「どのリクエストが、どのサービスで、どのステップで失敗したか」を60秒以内に特定できる状態を維持。

### §16. サービスマップ・依存関係可視化

*   **Law**: 分散トレースデータから**サービスマップを自動生成**し、サービス間の依存関係・レイテンシ・エラー率をリアルタイムで可視化。
*   **活用**:
    1.  **依存関係の発見**: 未知の依存関係やボトルネックの特定
    2.  **変更影響分析**: デプロイ前に影響を受けるサービスを予測
    3.  **障害伝播追跡**: カスケード障害の伝播経路を可視化

### §17. Request ID / Health Check Protocol

*   **Request ID Protocol**: APIレスポンスには必ず`x-request-id`を含める。レスポンスヘッダーとエラーJSONボディの両方に含めること。
*   **Health Check Protocol**: 全アプリは`/api/health`または`/healthz`を常設。DB接続・キャッシュ接続等の基本ヘルス情報を返却。
    *   **Liveness**: プロセスが生存しているか（再起動判定用）
    *   **Readiness**: トラフィックを受け付けられるか（ルーティング判定用）
    *   **Startup**: 初期化が完了したか（起動時の早期キル防止用）
*   **Deep Health Check**: `/healthz/deep`エンドポイントで依存サービス（DB、キャッシュ、外部API）の接続状態を確認。ただしレイテンシへの影響を考慮し、頻度を制限。

---

## Part VII: Continuous Profiling

### §18. Continuous Profiling原則

*   **Law**: Continuous Profilingは可観測性の**第5の柱**。本番環境で常時プロファイルを収集し、パフォーマンスのボトルネックをコードレベルで特定。
*   **収集対象**:

    | プロファイル種別 | 用途 | ツール例 |
    |:-------------|:-----|:--------|
    | **CPU** | CPU時間を消費する関数の特定 | Pyroscope, Parca |
    | **Memory（Heap）** | メモリリーク・大量アロケーションの検出 | Pyroscope, pprof |
    | **Goroutine/Thread** | 並行処理のボトルネック | Pyroscope |
    | **Lock/Mutex** | ロック競合の検出 | Pyroscope |
    | **Wall Clock** | 実経過時間ベースのボトルネック | Pyroscope |

*   **低オーバーヘッド**: eBPFベースのプロファイラーは本番でのオーバーヘッドを1-3%に抑制可能。
*   **フレームグラフ**: プロファイルデータはフレームグラフで可視化し、ホットスポットを直感的に特定。
*   **差分分析**: デプロイ前後のプロファイルを比較し、パフォーマンスリグレッションを自動検出。

---

## Part VIII: フロントエンド可観測性

### §19. フロントエンド監視

*   **Law**: フロントエンドのスクリプトエラー（Uncaught Exception）やハイドレーションエラーを監視するため、**Sentry**または同等ツールの導入を必須とする。
*   **Scope**: 本番環境（`NODE_ENV=production`）でのみ有効化。
*   **RUM（Real User Monitoring）**: CWV（LCP/INP/CLS）をリアルユーザーから収集し、合成モニタリングと比較。
*   **Session Replay**: エラー発生時のユーザーセッションを再現可能にし、再現困難なバグの調査を効率化。PII除外の設定を必須化。

### §20. Web Vitals SLO

*   **Law**: Core Web Vitalsに対してもSLOを定義し、エラーバジェットで管理。

    | 指標 | Good | Needs Improvement | Poor |
    |:-----|:-----|:-----------------|:-----|
    | **LCP** | ≦ 2.5s | 2.5-4.0s | > 4.0s |
    | **INP** | ≦ 200ms | 200-500ms | > 500ms |
    | **CLS** | ≦ 0.1 | 0.1-0.25 | > 0.25 |

*   **SLO目標**: 75パーセンタイルでGoodを達成。CrUXデータで月次追跡。
*   **INP深化**: INP（Interaction to Next Paint）はFIDの後継として2024年にCore Web Vitalsに昇格。Long Taskの分解、yield to main thread、イベントハンドラの最適化を重点対策。

---

## Part IX: PII保護・ログセキュリティ

### §21. PII保護

*   **Law**: 構造化ログに個人情報（メール、電話番号、トークン等）を含めること**禁止**。
*   **Action**:
    1.  Loggerレベルで自動マスキング（`***MASKED***`）を実装
    2.  監査ログにもトレースIDを記録し、双方向の追跡を可能に
    3.  ログ保持期間を定義し、期限超過ログの自動削除
    4.  ログのアクセス制御（RBAC）を実装
    5.  ログ内のPIIスキャン自動化（DLP統合）
*   **Cross-Reference**: `600_security_privacy.md` (PII保護)

---

## Part X: アラート・通知

### §22. SLOベースアラート

*   **Law**: アラートは**SLOベース**（エラーバジェット消費速度）を第一に、閾値ベースを補助として設計。「何となく遅い」ではなく定量的根拠に基づく。
*   **原則**: 症状ベース（Symptom-based）のアラートを優先。原因ベース（Cause-based）のアラートはダッシュボードでの可視化に留める。

### §23. 定量アラート閾値基準

*   **The Alert Matrix**:

    | メトリクス | Warning | Critical | 対応アクション |
    |:---------|:--------|:---------|:-------------|
    | **エラー率** (5xx) | > 1%（5分間） | > 5%（5分間） | 即時調査・ロールバック検討 |
    | **P95 レスポンスタイム** | > 500ms | > 2000ms | クエリ最適化・キャッシュ見直し |
    | **P99 レスポンスタイム** | > 1000ms | > 5000ms | テールレイテンシ調査 |
    | **DB接続プール使用率** | > 70% | > 90% | コネクション最適化 |
    | **メモリ使用率** | > 80% | > 95% | メモリリーク調査 |
    | **ディスク使用率** | > 70% | > 90% | ログローテーション・拡張 |
    | **証明書有効期限** | 30日以内 | 7日以内 | 自動更新確認 |
    | **AI API日次コスト** | 予算の80% | 予算の100% | レート制限強化 |

### §24. アラート疲労防止

*   **対策**:
    1.  **Quiet Hours**: 深夜帯（0:00-7:00）はP2以下を抑制。P0/P1は24時間通知
    2.  **Alert Grouping**: 同一原因の複数アラートを1つに集約
    3.  **Flapping Detection**: 短時間に状態が頻繁に切り替わるアラートを自動抑制
    4.  **Signal-to-Noise Ratio**: 四半期ごとにアラートを棚卸し。対応不要だったアラートを削除
    5.  **アラートの3要件**: 全アラートは①即座にアクション可能 ②人間の判断が必要 ③時間的制約がある、の3つを満たすこと
    6.  **Alert Hygiene Score**: アラートの品質スコアを月次で計測（対応率、対応時間、誤検知率）

### §25. エスカレーションチャネルマトリクス

| 重大度 | 通知チャネル | 応答期限 | 例 |
|:------|:-----------|:--------|:---|
| **P0 (Critical)** | 電話/SMS + 即時通知 | **15分** | サービス全停止、データ消失 |
| **P1 (High)** | 即時通知 + PagerDuty | **1時間** | 主要機能停止 |
| **P2 (Medium)** | 警告チャネル | **4時間** | 非主要機能の不具合 |
| **P3 (Low)** | メール + Issue Tracker | **次営業日** | 軽微バグ |

### §26. Actionable Alert Template

*   **Law**: 全アラートは以下のテンプレートに従い、受信者の認知負荷を最小化する。

    ```
    🚨 [P0] API可用性SLO違反 — Burn Rate 15.2x
    
    ■ 何が起きているか:
      主要API（/api/v1/*）の5xxエラー率が8.3%に上昇。
      過去1時間のBurn Rateが14.4を超過。
    
    ■ 影響:
      推定影響ユーザー: 12,000人
      エラーバジェット残量: 23% → 15%（直近1時間で8%消費）
    
    ■ 推奨アクション:
      1. 直近のデプロイを確認 → [デプロイ履歴リンク]
      2. ロールバック基準に該当する場合は即時実行
      3. ランブック: [ランブックリンク]
    
    ■ ダッシュボード: [Grafanaリンク]
    ■ トレース: [Jaegerリンク]
    ```

---

## Part XI: On-Call設計

### §27. On-Call基本原則

*   **Law**: オンコール体制はSREの根幹。特定個人への負担集中を防止する公正なシステムを構築。
*   **原則**:
    1.  **ローテーション**: PagerDuty等を用いて公平にローテーション（1週間交代推奨）
    2.  **エスカレーション**: Primary → 5分無応答 → Secondary自動エスカレーション
    3.  **ランブック連携**: 全P0/P1アラートに対応するランブックを事前準備
    4.  **補償**: オンコール待機時間に対する適切な補償
    5.  **負荷制限**: 1シフトあたり2件/日を超える場合、根本原因の改善を優先
    6.  **ハンドオフ**: シフト交代時に引き継ぎドキュメントを作成

### §28. On-Call人間工学

*   **Law**: On-Callは持続可能でなければならない。人間工学に基づく設計を導入。
*   **設計要件**:
    1.  **認知負荷の最小化**: アラートには「何が起きているか」「何をすべきか」「ランブックリンク」を含める（§26 Actionable Alert Template参照）
    2.  **インシデント後休暇**: SEV-1対応後に最低半日の回復時間を保証
    3.  **ページ頻度の追跡**: 月次でOn-Callの「幸福度」を測定（深夜ページ数、対応時間等）
    4.  **Shadow On-Call**: 新メンバーは最低2週間のシャドウイング期間を設ける
    5.  **Wheel of Misfortune**: Googleの訓練手法。過去のインシデントをロールプレイで再現し、対応力を強化

### §29. On-Call Cognitive Load Model

*   **Law**: On-Call中のエンジニアの認知負荷を定量的にモデル化し、持続不可能な状態を早期検知。
*   **認知負荷スコア（月次計測）**:

    | 指標 | 重み | 健全 | 要改善 | 危険 |
    |:----|:-----|:-----|:------|:-----|
    | **深夜ページ数** (0-7時) | ×3 | 0-1回/月 | 2-4回/月 | 5回以上/月 |
    | **日中ページ数** | ×1 | 0-5回/月 | 6-15回/月 | 16回以上/月 |
    | **平均対応時間** | ×2 | < 30分 | 30-60分 | > 60分 |
    | **バーンアウト自己申告** | ×5 | なし | 軽度 | 重度 |

---

## Part XII: インシデント管理（SRE観点）

### §30. インシデントレスポンスフロー概要

*   **Law**: 詳細プロトコルは`503_incident_response.md`に委譲。本セクションはSRE固有の観点を定義。
*   **SRE固有の対応義務**:
    1.  **15分ルール**: 重大障害時は検知から15分以内に一次対応を開始
    2.  **Degraded Mode判断**: MTTR目標超過時、機能制限モードへ切替
    3.  **ロールバック判断**: §41のロールバック基準に基づき即時ロールバック

### §31. SRE固有のインシデントメトリクス・DORA

*   **Law**: 以下のメトリクスを月次で追跡。

    | メトリクス | 定義 | Elite目標（2025） |
    |:---------|:-----|:---------------|
    | **MTTD** | 障害発生から検知までの平均時間 | ≦ 5分 |
    | **MTTR** | 検知から復旧までの平均時間 | ≦ 1時間 |
    | **MTBF** | 障害間の平均時間 | 増加傾向 |
    | **Change Failure Rate** | 障害を引き起こしたデプロイの割合 | ≦ 5% |
    | **Deployment Frequency** | デプロイ頻度 | 日次以上 |
    | **Incident Recurrence Rate** | 同一原因インシデントの再発率 | 0% |

*   **DORA 7 Archetypes（2025）**: DORAは従来の4段階分類（Low/Medium/High/Elite）から、**7つのアーキタイプ**（8指標ベース）に移行。チームのスループット・安定性・パフォーマンスの多面的評価を推奨。
*   **DORA 7 Archetypes詳細**:

    | アーキタイプ | 特徴 | 対策 |
    |:----------|:-----|:-----|
    | **Climate Champions** | 全指標Elite。AI活用も高い | ベストプラクティスの他チーム展開 |
    | **Fast Movers** | スループット高/安定性中 | 安定性投資（テスト強化） |
    | **Balanced** | 全指標中程度 | ボトルネック特定→集中改善 |
    | **Slow but Steady** | スループット低/安定性高 | CI/CD自動化・デプロイ頻度向上 |
    | **Struggling** | 全指標低 | 基盤投資（CI/CD・監視構築） |
    | **High Performers under Pressure** | 高パフォーマンスだがバーンアウトリスク | Toil削減・チーム拡大 |
    | **Low Performers Scaling** | 成長中だが品質低下 | Quality Gate導入・段階的成長 |

*   **8指標体系（2025）**: 従来の4メトリクスに加え、Reliability、AI Adoption Level、Team Culture Score、Operational Load指標も含めた8指標での多面的評価を推奨。

### §32. インシデントコミュニケーション

*   **Law**: インシデント発生時のステークホルダーコミュニケーションは信頼維持の要。
*   **原則**:
    1.  **Status Page即時更新**: インシデント検知後15分以内に外部ステータスページを更新
    2.  **内部コミュニケーション**: 専用Slackチャネル（`#incident-YYYYMMDD-XXX`）を即時作成
    3.  **定期アップデート**: 復旧中は30分ごとにステータスを更新
    4.  **収束報告**: 復旧後24時間以内にサマリーを全ステークホルダーに共有
*   **Cross-Reference**: `503_incident_response.md` (危機コミュニケーション詳細)

---

## Part XIII: Blameless文化・Learning from Incidents

### §33. Blameless Post-mortem

*   **Law**: 「誰が悪かったか」ではなく「なぜシステムが許容したか」を追求。
*   **Post-mortem義務**:
    *   **対象**: SEV-1/SEV-2の全インシデント
    *   **期限**: 障害収束後**48時間以内**にRCAとアクションをドキュメント化
    *   **成果物**: タイムライン、根本原因、影響範囲、改善アクション（担当者・期限付き）
*   **5 Whys**: 表面的な原因で停止せず、システム的な根本原因まで掘り下げる。

### §34. Learning from Incidents (LFI)

*   **Law**: インシデントは「失敗」ではなく「学習機会」。組織的な学習プロセスを構築。
*   **LFIフレームワーク**:
    1.  **Just Culture**: 個人の処罰ではなくシステム改善に焦点。ただし重過失・悪意は例外
    2.  **Incident Story Sharing**: 月例で匿名化されたインシデントストーリーを全社共有
    3.  **Pattern Analysis**: 複数インシデントからの共通パターンを抽出し、システミックな改善を実施
    4.  **Action Item Tracking**: Post-mortemのアクションアイテム完了率を追跡。目標: 30日以内に80%完了
    5.  **Near-Miss Reporting**: 障害に至らなかったニアミスも報告・分析対象とする

### §35. Adaptive Capacity・レジリエンスの学術的基盤

*   **Law**: システムの信頼性は静的な設計だけでなく、**適応能力（Adaptive Capacity）**に依存する。
*   **理論基盤**:
    1.  **David Woods' 4つの能力**: 予測（Anticipate）・監視（Monitor）・対応（Respond）・学習（Learn）
    2.  **Safety-IIパラダイム**: 「物事がうまくいく理由」を理解することが「物事が失敗する理由」の理解と同等に重要
    3.  **Rasmussen's Drift Model**: システムは安全境界に向かって徐々にドリフトする。このドリフトを検知・防止する仕組みを構築

### §36. 分解ベーストリアージ

*   **Law**: 大規模変更後の不具合は、一斉ロールバックではなく**機能グループごとの段階的ロールバック**で最小再現単位を特定。
*   **Server Log Sovereignty**: サーバーログを一次情報源として活用。HTTPステータス・エラースタックで切り分け。

---

## Part XIV: デプロイメント戦略

### §37. Automated Deployment Mandate

*   **Law**: 本番環境へのデプロイは、**いかなる場合も手動コマンドで行ってはならない**。
*   **Prohibition**: 「手動デプロイ」はオペミスを誘発する「エンジニアリングの自殺行為」。
*   **Action**: デプロイは「検証されたコード（PR）」が「信頼されたパイプライン（GitHub Actions等）」を通過した結果として自動実行。
*   **デプロイ前ゲート**:
    1.  `tsc --noEmit`（型チェック）✅
    2.  `npm run build`（ビルドチェック）✅
    3.  自動テスト通過 ✅
    4.  責任者の承認 ✅

### §38. ブランチ衛生・Preview環境管理

*   **Branch Hygiene**: 「マージされたら削除」はエンジニアの呼吸。
*   **Preview Environment Evacuation**: Preview環境でマイグレーション不整合が発生した場合、修復に時間を浪費せず即座に放棄して新環境を作成。
*   **Gatekeeper**:
    *   **Linter Zero Tolerance**: `eslint --max-warnings=0`を義務付け
    *   **Husky Guard**: `pre-push`フックでの`main`/`master`への直接プッシュ禁止

---

## Part XV: Progressive Delivery・Feature Flag信頼性

### §39. Progressive Delivery戦略

*   **Law**: 新機能のリリースは段階的に行い、全ユーザーへの一斉展開を避ける。

    | 戦略 | 概要 | リスク軽減 | 適用場面 |
    |:-----|:-----|:---------|:--------|
    | **Blue/Green** | 新旧環境を並行稼働、トラフィック瞬時切替 | ダウンタイムゼロ | インフラ変更 |
    | **Canary** | 1-5%のユーザーに先行展開 | 漸進的リスク検知 | 機能リリース |
    | **Feature Flag** | コードデプロイとリリースを分離 | 即時無効化可能 | 全機能 |
    | **Shadow Traffic** | 本番トラフィックを新サービスに複製 | ゼロリスク検証 | バックエンド刷新 |
    | **Dark Launch** | 機能を非表示で本番投入・メトリクス収集 | パフォーマンス検証 | 大規模変更 |

*   **SLO連動ロールバック**: カナリア中にSLO違反を検知したら**自動ロールバック**。

### §40. Feature Flag信頼性

*   **Law**: Feature Flagは強力だが、管理されないフラグは技術的負債となる。
*   **Feature Flag Lifecycle**:
    1.  **作成時**: 有効期限（TTL）を必ず設定。推奨: 最大90日
    2.  **運用時**: フラグの状態と影響範囲をダッシュボードで可視化
    3.  **退役時**: 全展開完了後、フラグとガード条件をコードから除去
*   **Stale Flag検知**: 90日以上変更されていないフラグを自動検出し、クリーンアップチケットを起票。
*   **Flag一貫性**: 分散システムでのフラグ評価の一貫性を保証（Eventually Consistentな伝播遅延を許容する設計）。

---

## Part XVI: ロールバック・破壊的変更管理

### §41. ロールバック即時実行原則

*   **Law**: ロールバックは常に**1ステップで実行可能**な状態を維持。

### §42. 破壊的マイグレーション制約

*   **Law**: `ALTER TABLE DROP COLUMN`等の破壊的マイグレーションを含むデプロイは、**責任者の事前承認**を必須とする。
*   **Expand & Contract Pattern**:
    1.  **Expand**: 新カラム/テーブルを追加（既存コード影響なし）
    2.  **Migrate**: データを新構造に移行
    3.  **Contract**: 旧カラム/テーブルを削除（全コード移行後）

### §43. ロールバック基準

| 指標 | 閾値 | 判定 |
|:-----|:-----|:-----|
| エラー率 (5xx) | > 5%（5分間） | 即時ロールバック |
| P95レスポンスタイム | > 2000ms（10分間） | 即時ロールバック |
| P99レスポンスタイム | > 5000ms（10分間） | 即時ロールバック |
| Core Web Vitals CLS | > 0.25 | 緊急調査 + ロールバック検討 |
| 監視ツール P0エラー | 1件以上 | 即時ロールバック |

---

## Part XVII: カオスエンジニアリング・DiRT

### §44. カオスエンジニアリング原則

*   **Law**: 「システムは必ず壊れる」前提。意図的に障害を注入して回復力をテスト。
*   **仮説駆動実験設計**:
    1.  仮説の定義 → 2. 定常状態の定義 → 3. 障害注入 → 4. 観測 → 5. 分析
*   **Steady-State深化**: 定常状態はシステムメトリクスだけでなく、**ビジネスメトリクス**（注文数、ログイン成功率等）も含める。ビジネスインパクトの早期検知を可能にする。
*   **ツーリング**: ChaosMesh / Gremlin / Litmus / AWS Fault Injection Service

### §45. GameDay運営・DiRT

*   **Law**: Google発の**DiRT（Disaster Recovery Testing）**を体系化。定期的な全社規模のDRテストを実施。
*   **成熟度段階別GameDay**:

    | レベル | 内容 | 環境 | 頻度 |
    |:------|:-----|:-----|:-----|
    | **Level 1** | テーブルトップ演習 | 会議室 | 四半期 |
    | **Level 2** | ステージングでの障害注入 | ステージング | 月次 |
    | **Level 3** | 予告ありの本番カオステスト | 本番 | 四半期 |
    | **Level 4** | 予告なしの本番カオステスト | 本番 | 半年 |
    | **Level 5** | クロスリージョンDiRT | 本番（複数リージョン） | 年次 |

*   **DiRT実施要件**: 実施前にロールバック手順を確認。影響範囲を事前定義し、安全停止条件（Abort Criteria）を設定。

---

## Part XVIII: 負荷テスト・フェイルオーバーテスト

### §46. 負荷テスト基準

*   **Law**: 本番トラフィック急増に備え、事前の負荷テストでボトルネックを特定。

    | 対象 | 同時接続数目標 | レスポンスタイム目標 |
    |:-----|:------------|:-----------------:|
    | **主要公開ページ** | 500 concurrent | ≦ 1.0s (p95) |
    | **検索API** | 200 concurrent | ≦ 2.0s (p95) |
    | **詳細ページ** | 300 concurrent | ≦ 1.5s (p95) |
    | **AI/リアルタイムAPI** | 50 concurrent | ≦ 5.0s (p95) |

*   **ボトルネック対応**: p95が目標の**1.5倍を超過**した場合、リリースをブロック。
*   **Prohibition**: 本番環境での負荷テストは**禁止**。
*   **Tooling**: k6 / Grafana k6 Cloud / Gatling / Artillery

### §47. フェイルオーバーテスト

*   **Law**: フェイルオーバー機構は定期テストなしに動作保証不可。
*   **テスト項目**: DB読み取りレプリカ切替、CDNオリジンフェイルオーバー、DNSフェイルオーバー、マルチリージョン切替
*   **頻度**: 四半期に1回以上。結果を記録し改善を追跡。

---

## Part XIX: レジリエンスパターン

### §48. レジリエンス設計パターン

| パターン | 目的 | 実装指針 |
|:--------|:-----|:--------|
| **Circuit Breaker** | カスケード障害の防止 | Open/Half-Open/Closedの3状態管理 |
| **Retry with Backoff** | 一時的障害からの回復 | Exponential Backoff + Jitter。最大3回・上限30秒 |
| **Timeout** | 無限待ちの防止 | 全外部呼出しにタイムアウト設定。デフォルト10秒 |
| **Bulkhead** | 障害の局所化 | リソースプールを機能別に分離 |
| **Rate Limiting** | 過負荷の防止 | Token Bucket / Sliding Window |
| **Fallback** | 障害時のデフォルト応答 | キャッシュデータ返却、機能制限モード |
| **Backpressure** | 上流への過負荷伝播防止 | キュー飽和時のリクエスト拒否 |

### §49. Adaptive Capacity

*   **Law**: システムは**予測不能な状況に適応する能力**を持つべき。静的な閾値だけでなく、動的に適応するレジリエンスを設計。
*   **原則**:
    1.  **Graceful Stretch**: 想定以上の負荷に対し、品質を段階的に落としつつサービスを継続
    2.  **Adaptive Throttling**: トラフィック急増時に動的にレート制限を調整
    3.  **Load Shedding**: リソース枯渇時に低優先度リクエストを意図的に棄却し、高優先度を保護

### §50. Gray Failure対応

*   **Law**: **Gray Failure（灰色障害）**は、システムが完全に停止せず部分的に劣化した状態。従来の二値的（UP/DOWN）な監視では検出不可能。
*   **Gray Failureの特性**:
    1.  **差別的影響**: 一部のユーザー/リクエストのみ影響を受ける
    2.  **観測者依存**: 監視システムからは正常に見えるが、ユーザーからは異常
    3.  **緩慢な進行**: 突然の障害ではなく、徐々に劣化
*   **検出パターン**:
    1.  **多視点監視**: 複数の観測ポイント（CDN、LB、アプリ、クライアント）からの整合性チェック
    2.  **異常検知ML**: ベースラインからの統計的逸脱を検出
    3.  **Canary-based Detection**: 定期的な合成トランザクションで品質をプロービング
    4.  **ユーザー報告相関**: サポート問い合わせとメトリクスの相関分析
*   **対応戦略**: AZ（Availability Zone）レベルでのZonal Shiftを活用し、影響を受けているゾーンからトラフィックを退避。

### §50-b. Adaptive Concurrency Limits

*   **Law**: 静的な同時接続数制限ではなく、**動的にConcurrency Limitを調整**するパターンを採用。
*   **原則**:
    1.  **Vegas Algorithm**: TCPのVegas輻輳制御に着想。レイテンシの増加を検知してConcurrency Limitを自動削減
    2.  **Gradient Algorithm**: レイテンシの勾配（増加率）に基づくより反応的な制御
    3.  **Netflix Concurrency Limiter**: Netflix OSS `concurrency-limits` ライブラリを参考実装
*   **適用場面**: APIゲートウェイ、サービス間通信、DBコネクションプール
*   **利点**: 手動チューニング不要。トラフィックパターンの変化に自動適応。過負荷時のカスケード障害を防止。

---

## Part XX: Self-Healing Infrastructure

### §51. Self-Healing Tier

| Tier | 内容 | 例 |
|:-----|:-----|:---|
| **Tier 1: 自動再起動** | クラッシュしたプロセスの自動再起動 | Kubernetes RestartPolicy, PM2 |
| **Tier 2: 自動スケーリング** | 負荷に応じた自動リソース増減 | HPA, Cloud Auto-scaling |
| **Tier 3: 自動フェイルオーバー** | プライマリ障害時の自動切替 | DB Read Replica昇格, DNS failover |
| **Tier 4: AI駆動自動修復** | 異常検知→自動診断→自動修復 | AIOps（§117参照） |

*   **ガードレール**: 自動修復に**安全制約**を設定。1時間あたりの自動再起動回数上限、スケーリング上限等を定義。
*   **Auto-Remediation Playbook**: 自動修復の意思決定ロジックをコード化し、バージョン管理。修復アクション前後のSLIスナップショットを記録。

---

## Part XXI: メンテナンスモード・Graceful Degradation

### §52. Graceful Degradation

*   **Law**: 障害時は全停止ではなく**機能制限モード**でコア機能を維持。
*   **Feature Flag連携**: 各機能をFeature Flagで制御し、障害時の部分的無効化を**再デプロイ不要**で実行。

    ```typescript
    // Feature Flag による Graceful Degradation
    if (!flags.ai_enabled && request.pathname.startsWith('/api/ai')) {
      return Response.json(
        { error: 'AI_SERVICE_TEMPORARILY_DISABLED' },
        { status: 503 }
      );
    }
    ```

### §53. メンテナンスモード設計

*   **Law**: メンテナンス状態はDB設定（`site_settings`）で管理。MiddlewareとServer Actionsの両方でチェック。
*   **切替方式**: 再デプロイ不要。Edge Config / DB flag / KV Storeで即時切替。

---

## Part XXII: パフォーマンスエンジニアリング

### §54. パフォーマンスベンチマーク基準

| 指標 | 目標 | 計測ツール |
|:----|:-----|:---------|
| **Lighthouse Performance** | ≧ 90 | Lighthouse CI |
| **LCP** | ≦ 2.5s | CrUX / Web Vitals |
| **INP** | ≦ 200ms | CrUX / Web Vitals |
| **CLS** | ≦ 0.1 | CrUX / Web Vitals |
| **TTFB** | ≦ 800ms | サーバーログ |
| **JSバンドルサイズ** | ≦ 150KB (gzip) | Bundle Analyzer |

*   **Measurement Cycle**: CI/CDでPR時にLighthouse CI。週次でCWV自動計測。月次でCrUXレポート分析。
*   **Degradation Response**: 2週連続で目標未達の場合、改善チケットを最優先で起票。

### §55. API応答時間標準

*   **Target**: APIレスポンスは**100ms以内**を目標。
*   **P99監視**: P95だけでなく**P99レイテンシ**も追跡。P99 > 1000msで警告。「Slow is the New Down」。

### §56. パフォーマンスバジェット

*   **Law**: パフォーマンスバジェットをCI/CDパイプラインに統合し、バジェット超過でビルドを失敗させる。

    | リソース | バジェット |
    |:--------|:---------|
    | **JS（gzip）** | ≦ 150KB |
    | **CSS（gzip）** | ≦ 30KB |
    | **画像（ページあたり）** | ≦ 500KB |
    | **フォント** | ≦ 100KB |
    | **サードパーティスクリプト** | ≦ 50KB |

---

## Part XXIII: キャッシュ戦略

### §57. The Cache Hierarchy

| Tier | TTL（目安） | 対象データ | DB負荷 |
|:-----|:-----------|:----------|:------|
| **STATIC** | 86400秒（24時間） | マスタデータ | ゼロ |
| **WARM** | 300秒（5分） | 検索結果、一覧 | 低 |
| **HOT** | 60秒（1分） | 詳細ページ、レビュー | 中 |
| **REALTIME** | 0秒 | 決済、認証、在庫 | 最大 |

*   **Mandate**: 新規クエリ作成時は上記Tierのいずれかを選択。全てをREALTIMEにすることは禁止。
*   **Cache Invalidation Strategy**: TTL期限切れ + イベント駆動の無効化（Write-through / Write-behind）。
*   **Thundering Herd防止**: キャッシュ期限切れ時の大量リクエスト同時到達を防ぐため、Probabilistic Early Expiration / Request Coalescingを実装。

---

## Part XXIV: IaC・GitOps

### §58. Infrastructure as Code（IaC）原則

*   **Law**: 全インフラを宣言的コード（Terraform / Pulumi / OpenTofu等）で定義しバージョン管理。
*   **原則**:
    1.  **宣言的定義**: 「あるべき状態」を記述
    2.  **バージョン管理**: 全IaCコードをGitで管理。レビュー・承認フロー経由
    3.  **再現可能性**: 同じコードから同一環境を何度でも再構築可能
    4.  **ステートファイル管理**: リモートバックエンドで管理。ローカルステート禁止
    5.  **ドリフト検出**: 定期的にインフラ実態とコードの乖離を検出
*   **Drift Detection深化**: ドリフト検出はスケジュール実行（最低日次）し、検出時にP2アラートを発報。手動変更の痕跡を許容しない。

### §59. GitOps・宣言的インフラ管理

*   **Law**: Gitを「Single Source of Truth」としたGitOpsフローを採用。
*   **原則**: 宣言的 → バージョン管理 → 自動適用 → 自動差分検知（Reconciliation Loop）

---

## Part XXV: コンテナ / Kubernetes / Service Mesh

### §60. コンテナ/Kubernetes信頼性パターン

1.  **Liveness / Readiness / Startup Probe**: 必ず定義
2.  **Resource Limits**: 全Podに`requests`/`limits`を設定
3.  **Pod Disruption Budget（PDB）**: ローリングアップデート時の最小可用Pod数を保証
4.  **Anti-Affinity**: 同一サービスのPodを異なるノード/AZに分散
5.  **Graceful Shutdown**: SIGTERMハンドル + in-flight request完了待機

### §61. SLO Operator（Kubernetes）

*   **Law**: KubernetesネイティブのSLO管理にはSLO Operator（Sloth/Pyrra/OpenSLO Operator）を導入。
*   **機能**:
    1.  **CRD（Custom Resource Definition）ベースのSLO定義**: SLO仕様をKubernetesマニフェストとして管理
    2.  **Burn-rateアラート自動生成**: SLO定義からMulti-Window Burn-rateアラートルールを自動生成
    3.  **ダッシュボード自動生成**: Grafana dashboardをSLO定義から自動生成
    4.  **GitOps統合**: SLO定義変更をPRレビュー経由で適用

### §62. Service Mesh信頼性

*   **Law**: マイクロサービス環境では**Service Mesh**（Istio / Envoy / Linkerd）によるサービス間通信の信頼性確保を推奨。
*   **提供機能**:
    1.  **mTLS**: サービス間通信の自動暗号化
    2.  **トラフィック管理**: 重み付きルーティング、カナリア、ミラーリング
    3.  **可観測性**: サービス間レイテンシ・エラー率の自動収集
    4.  **レジリエンス**: Circuit Breaker、Retry、Timeout、Rate Limitingをインフラ層で統一実装
    5.  **認可**: サービス間のアクセスポリシーを宣言的に定義

---

## Part XXVI: Serverless / Edge信頼性

### §63. Serverless / Edge信頼性

1.  **コールドスタート対策**: Warm-up戦略（定期Heartbeat呼出し）
2.  **タイムアウト設計**: 想定最大処理時間の**1.5倍**に設定
3.  **冪等性**: リトライによる重複実行を考慮し全関数を冪等に設計
4.  **グローバル分散**: Edge Functionのデータソースレイテンシに注意
5.  **Concurrency制御**: 同時実行数の上限設定。バックエンドDB接続枯渇を防止

### §64. Edge可観測性

*   **Law**: エッジ環境固有の可観測性課題に対応する設計を実施。
*   **要件**:
    1.  **エッジログ集約**: CDN/Edge Functionのログを中央に集約。遅延転送を許容
    2.  **エッジ固有メトリクス**: キャッシュヒット率、オリジンフォールバック率、地理的レイテンシ分布
    3.  **合成モニタリング**: 主要地域からの定期的な合成リクエストでエッジ品質を監視

---

## Part XXVII: 容量計画（Capacity Planning）

### §65. リソース予測・飽和度管理

*   **Law**: リソースの飽和は障害の前兆。主要リソースの使用率と成長率を継続的に監視。

    | リソース | Warning | Critical | アクション |
    |:--------|:-------|:---------|:---------|
    | **CPU** | > 70%（持続） | > 90% | スケールアウト / 最適化 |
    | **メモリ** | > 80% | > 95% | メモリリーク調査 / 増設 |
    | **ディスク** | > 70% | > 85% | ログローテーション / 拡張 |
    | **DB接続プール** | > 70% | > 90% | Pooler導入 / 接続最適化 |
    | **ネットワーク帯域** | > 60% | > 80% | CDN活用 / 帯域拡張 |

*   **リードタイム計算**: 現在の成長率からCritical到達までの日数を算出。**30日前**までに対策を完了。

### §66. オートスケーリング設計

*   **Law**: オートスケーリングは**適切な上限**を設定。上限なしはDDoS時のコスト爆発を招く。
*   **設計指針**: スケールアウト: CPU 70% or メモリ 80%。スケールイン: CPU 30% and メモリ 40%（クールダウン付き）。最大インスタンス数を明示。
*   **N+1冗長性**: 1台停止でも全トラフィックを処理可能な状態を維持。

---

## Part XXVIII: Toil管理

### §67. Toilの定義・測定

*   **Law**: Toilとは手動的・反復的・自動化可能・戦術的・スケーラブルでない作業の全てに該当するもの。
*   **50%ルール**: Toilは**最大50%**。超過時はToil削減を最優先で起票。

### §68. Toil削減戦略

*   **自動化優先度マトリクス**:

    | | 発生頻度: 高 | 発生頻度: 低 |
    |:---|:-----------|:-----------|
    | **自動化コスト: 低** | ✅ **最優先** | ✅ 早期に自動化 |
    | **自動化コスト: 高** | ⚠️ ROI評価 | ❌ 手動許容 |

*   **一般的な削減対象**: 手動デプロイ→CI/CD、手動DB操作→マイグレーション、手動証明書更新→Let's Encrypt、手動ログ調査→ダッシュボード

### §69. Toilバジェット

*   **Law**: 各チームは月あたりの許容Toil時間上限を設定。超過時はToil削減を最優先タスクとする。
*   **Toil計測**: 週次でToil時間を記録。月次でトレンド分析。エンジニアリング時間確保率（> 50%）を追跡。

---

## Part XXIX: データ耐久性・バックアップ

### §70. RPO/RTO設計

*   **RPO**: **24時間**。毎日バックアップ取得。
*   **RTO**: **2時間**。リストア手順を確立し2時間以内にサービス再開。
*   **Cross-Reference**: `503_incident_response.md` §3 (BIA), §13 (DR戦略)

### §71. バックアップ戦略

*   **3-2-1-1ルール**: 3コピー、2メディア、1オフサイト、1イミュータブル。
*   **Off-Site Backup Mandate**: 外部ストレージ（S3/R2等）への定期論理バックアップを義務付け。
*   **イミュータブルバックアップ**: ランサムウェア対策として、最低1つのバックアップはイミュータブル（上書き不可）ストレージに保存。

### §72. Fire Drill Protocol

*   **Mandate**: 四半期に1回、実際にリストアを行い正常稼働を確認。未検証バックアップは「存在しない」。
*   **Verification Matrix**: リストア完了、テーブル数一致、行数整合性（±5%）、RLS適用確認、アプリ起動確認。いずれかの失敗で**P1アラート**発報。

---

## Part XXX: 供給チェーン・依存関係信頼性

### §73. 依存関係管理

*   **Lockfile Integrity**: `package-lock.json`/`pnpm-lock.yaml`は「聖域」。CIでエラー時はLockfile再生成。
*   **SBOM（Software Bill of Materials）**: CycloneDX 1.6/SPDX 3.0形式で全依存関係を管理。ビルド時に自動生成。
*   **VEX（Vulnerability Exploitability eXchange）**: 脆弱性の実際の悪用可能性を評価し、誤検知の削減とトリアージ効率化を実現。
*   **Cross-Reference**: `602_oss_compliance.md` (SBOM/SCA/SLSA詳細)

### §74. 脆弱性スキャン

*   **Law**: CIパイプラインに統合。Critical/Highでマージをブロック。
*   **対応SLA**: Critical: 24時間、High: 1週間、Medium: 次スプリント、Low: バックログ

### §75. Schema-Code同期

*   **Law**: コードがZero Defectsでも**DBスキーマ未適用**ならシステムは動作しない。
*   **Action**: Migration Status Check、Schema Drift Detection、Deploy Pipeline統合。
*   **Ghost Column Prevention**: マイグレーション未適用のカラム名をクエリで使用することは禁止。

### §76. SLSA・サプライチェーン整合性

*   **Law**: ソフトウェアサプライチェーンの整合性をSLSA（Supply-chain Levels for Software Artifacts）v1.1フレームワークで保証。
*   **最低要件**: SLSA Level 2（ビルドサービスの使用 + 署名付き来歴情報）
*   **目標**: SLSA Level 3（ビルドプラットフォームの堅牢化）
*   **Sigstore統合**: コンテナイメージ・SBOMの署名にSigstore（Cosign/Fulcio/Rekor）を使用。OIDC Trusted Publishingによるキーレス署名を推奨。

---

## Part XXXI: 環境管理・Configuration Management

### §77. Fail-Fast Configuration Mandate

*   **Law**: 起動時に全クリティカル環境変数の存在・形式を検証。不足時は即座に`process.exit(1)`。
*   **No Silent Fallbacks**: クリティカル設定のデフォルト値によるサイレントフォールバックは禁止。

### §78. Dynamic Configuration Management

*   **Law**: 設定変更は再デプロイなしで反映可能な設計とし、変更追跡を義務付ける。
*   **原則**:
    1.  **設定変更監査**: 全設定変更をAudit Logに記録（who/when/what/why）
    2.  **段階的ロールアウト**: 設定変更もProgressiveに適用（カナリア→全展開）
    3.  **設定変更ロールバック**: 設定変更がSLI劣化を引き起こした場合、即座に前の値に復元
    4.  **Feature Gate**: 機能の有効/無効をDB/KV Storeの設定フラグで制御

### §79. キャッシュリセットProtocol

*   **Law**: コアクエリロジック/RLSポリシー/環境変数変更時は、検証前に**開発サーバーの強制終了とクリーンリスタート**を義務化。

---

## Part XXXII: FinOps・テレメトリコスト管理

### §80. クラウド予算アラート

| レベル | 消費率 | アクション |
|:------|:------|:---------|
| **Warning** | 50% / 80% | Slack/チャット通知 |
| **Critical** | 100% | Email + 即時通知メンション |
| **Panic** | 150% | 開発環境リソースの自動停止を検討 |

### §81. ゾンビリソース排除

*   **Law**: 月に一度、全クラウド環境をスキャンし不要リソースを物理削除。
*   **対象**: 未使用IP、残存Preview環境、孤立ストレージ、停止中インスタンス、保持ポリシー超過バックアップ

### §82. テレメトリコスト管理

*   **Law**: 可観測性データのコストは管理されなければ指数関数的に増大する。テレメトリを**インフラ同様に管理**せよ。
*   **原則**:
    1.  **テレメトリバジェット**: メトリクス/ログ/トレースのデータ量に月次バジェットを設定
    2.  **サンプリング戦略**: 全トレースを保存しない。Tail-basedサンプリングでエラーと高レイテンシに集中
    3.  **ログレベル管理**: 本番でdebugログを有効化しない。ログ量の異常増加を監視
    4.  **メトリクスカーディナリティ**: 高カーディナリティラベル（user_id等）のメトリクスへの付与を制限
    5.  **Data Tiering**: ホットデータ（直近7日）とコールドデータ（30日超）でストレージ階層を分離

### §83. AI Cost Governance

*   **Model Selection**: 複雑推論はTier 1（高精度）、定型処理はTier 2（高速・低コスト）。
*   **30% Profitability Rule**: AI原価はプラン月額の**30%を超えない**。
*   **Circuit Breaker**: APIコスト異常急騰時、AI機能を自動停止。

---

## Part XXXIII: 可観測性ダッシュボード・レポーティング

### §84. ダッシュボード必須メトリクス

*   **リアルタイム**: アクティブユーザー数、RPS、エラー率、P95/P99レスポンスタイム
*   **日次**: Core Web Vitals、DB接続プールピーク、キャッシュヒット率、AI API利用量
*   **週次**: 未解決エラー数とトレンド、SLO達成率、脆弱性スキャン結果
*   **月次**: SLOレビューレポート、Toil比率、容量計画状態、改善アクション進捗

### §85. Executive SREダッシュボード

*   **Law**: 経営層向けにSREの状態と投資対効果を一目で把握できるダッシュボードを提供。
*   **指標**:
    1.  **SLO達成率**: サービス別・月次推移
    2.  **エラーバジェット残量**: 全サービスの残量ヒートマップ
    3.  **ダウンタイムコスト**: 推定収益損失（→ Part XLVII参照）
    4.  **DORA Metrics**: Deployment Frequency、Change Failure Rate、MTTR、Lead Time
    5.  **Toil比率**: エンジニアリング時間確保率

### §86. SREレポーティング義務

*   **Law**: 月次でSLOレビューレポートを作成。各SLO達成率、エラーバジェット残量、インシデントサマリー、Toil比率、容量リスクを含める。

---

## Part XXXIV: SRE as Code・ガバナンス

### §87. Code-Not-Policy Mandate

*   **Law**: 人間の「約束」は必ず破られる。ルールの実効性は**コード化された物理的制約**でのみ担保。
*   **Action**: CIに自動チェック実装、Git Hooks、起動時バリデーション。

### §88. SRE as Code

*   **Law**: SREの運用プラクティスを可能な限りコード化し、バージョン管理する。

    | 領域 | コード化手法 | ツール例 |
    |:-----|:----------|:--------|
    | **SLO定義** | SLOs-as-Code | OpenSLO, Sloth |
    | **アラートルール** | Alerts-as-Code | Prometheus rules YAML |
    | **ランブック** | Runbook-as-Code | Runbook.md + 自動化スクリプト |
    | **ポリシー** | Policy-as-Code | OPA Rego, AWS Cedar |
    | **インフラ** | IaC | Terraform, Pulumi |
    | **デプロイ** | Pipeline-as-Code | GitHub Actions YAML |
    | **ダッシュボード** | Dashboard-as-Code | Grafana Terraform Provider |

### §89. Observability as Code

*   **Law**: ダッシュボード・アラートルール・SLO定義は全てコード化し、バージョン管理する。手動でGUIから作成したダッシュボードは「一級市民」ではない。
*   **実装**:
    1.  **Grafana Terraform Provider**: ダッシュボード定義をHCLで管理
    2.  **Prometheus Rules**: アラートルールをYAMLで定義し、GitOpsで適用
    3.  **CI/CD統合**: ダッシュボード/アラート変更もPRレビュー対象

### §90. 監査追跡義務

*   **Law**: 破壊的操作に監査ログの計装を義務付け。Before/Afterの状態記録、トレースID連携、Human-Readableラベル。

---

## Part XXXV: Production Readiness Review

### §91. Production Readiness Review (PRR)

*   **Law**: 新サービスまたは大規模変更の本番投入前に、**PRR（Production Readiness Review）**を実施。
*   **PRRチェックリスト**:

    | カテゴリ | チェック項目 |
    |:--------|:-----------|
    | **SLI/SLO** | SLI/SLOが定義されているか |
    | **可観測性** | メトリクス/ログ/トレースが計装されているか |
    | **アラート** | SLOベースのアラートが設定されているか |
    | **ランブック** | P0/P1アラートに対応するランブックが存在するか |
    | **デプロイ** | ロールバック手順が確立されているか |
    | **負荷テスト** | 想定トラフィックでの負荷テストが実施されているか |
    | **セキュリティ** | 認証/認可/暗号化が適切か |
    | **依存関係** | 外部依存サービスのSLOが確認されているか |
    | **バックアップ** | バックアップ/リストアの手順が確認されているか |
    | **容量計画** | 必要リソースとスケーリング戦略が定義されているか |
    | **コスト** | 月次コスト予測が算出されているか |

### §92. Production Excellence

*   **Law**: Googleの「Production Excellence」に倣い、シニアSREリーダーによるチーム横断のプロダクション品質評価を実施。
*   **評価指標**: ページャー負荷、エラーバジェット消費率、PRR項目の充足率、Toil比率、Post-mortemアクションアイテム完了率。
*   **頻度**: 四半期ごと。評価結果を全チームに共有し、改善計画を策定。

### §93. Reliability Review（設計レビュー）

*   **Law**: 設計段階でSREが参加するReliability Reviewを実施し、以下を検証:
    1.  単一障害点（SPOF）の特定と排除
    2.  障害モード分析（FMEA）
    3.  依存関係の信頼性評価
    4.  スケーラビリティ設計の妥当性

---

## Part XXXVI: Platform Engineering

### §94. Internal Developer Platform (IDP)基盤

*   **Law**: 開発者の生産性を最大化するため、インフラの複雑さを抽象化するIDPを構築。
*   **IDP原則**: Self-Service、Golden Path、Guardrails、Product Mindset。
*   **Platform as Product**: IDPを社内プロダクトとして扱い、ユーザー（開発者）のフィードバックに基づいて継続的に改善。NPS/CSATを計測し、採用率・満足度を追跡。「使われないプラットフォームは失敗」。
*   **ツーリング**: Backstage / Port / Humanitec

### §95. Golden Pathとサービステンプレート

*   **Law**: 新規サービスの立ち上げには組織承認の**サービステンプレート**を使用。
*   **テンプレート要素**: CI/CD設定、ヘルスチェック、構造化ログ、メトリクス計装、SLO定義、Dockerfile/IaC

### §96. Developer Experience (DevEx)メトリクス

| メトリクス | 目標 | 計測方法 |
|:---------|:-----|:--------|
| **ローカルビルド時間** | ≦ 30秒 | CIログ |
| **CI/CDパイプライン時間** | ≦ 10分 | パイプラインダッシュボード |
| **環境セットアップ時間** | ≦ 30分 | オンボーディングログ |
| **デプロイ頻度** | 日次以上 | デプロイメトリクス |

### §97. Service Scorecard

*   **Law**: 各サービスの信頼性状態を**Service Scorecard**で可視化。
*   **スコアリング項目**: SLO達成率、On-Call負荷、テストカバレッジ、ドキュメント鮮度、セキュリティスキャン結果、依存関係の最新度

### §97-b. Platform SLO

*   **Law**: IDPそのもののSLOを定義し、プラットフォームの信頼性を定量管理。
*   **Platform SLI/SLO**:

    | SLI | SLO | 意味 |
    |:---|:----|:-----|
    | **セルフサービス可用性** | ≧ 99.9% | 開発者ポータル・APIの稼働率 |
    | **環境プロビジョニング時間** | ≦ 5分（P95） | 新規環境の立ち上げ速度 |
    | **CI/CDパイプライン成功率** | ≧ 98% | インフラ起因の失敗を除く |
    | **Golden Pathからの逸脱率** | ≦ 10% | 標準テンプレート利用率 |

### §97-c. Backstage Plugin信頼性

*   **Law**: BackstageをベースとするIDPでは、Pluginエコシステムの信頼性が全体の信頼性を左右する。
*   **原則**:
    1.  **Plugin SLO**: サードパーティPlugin導入時は個別のSLOを定義
    2.  **Plugin Health Check**: 各PluginのAPI応答・データ鮮度を監視
    3.  **Fallback UI**: Plugin障害時にDegraded UIを表示（ポータル全停止を回避）
    4.  **Plugin更新SLA**: セキュリティパッチは7日以内、機能更新は四半期サイクル

---

## Part XXXVII: AI駆動SRE（AIOps）

### §98. AI異常検知・予測分析

*   **Law**: AI/MLを活用して閾値ベースでは検知困難な異常パターンを検出。
*   **活用領域**: 異常検知、予測分析（容量枯渇予測）、ログ分析（パターン抽出）、インテリジェントアラート

### §99. AI Trust Paradox・Human-AI協調

*   **Law**: AIはSREの能力を増幅するが、**AI Trust Paradox**（AI生成の設定/コードの検証Toil増加）に注意。
*   **原則**:
    1.  **AI提案は常に人間がレビュー**: AI自動修復の判断のみでの実行はエラーバジェット残量 > 50%の場合に限定
    2.  **AI Verification Toil**: AI生成出力の検証作業をToilとして計測。自動検証基盤の構築を優先
    3.  **Human-in-the-Loop**: クリティカルな決定（ロールバック、スケーリング、データ削除）は人間の承認必須
    4.  **AI SREエージェント監視**: AIエージェントの行動ログを記録し、意図しないドリフトを検出

### §100. Agentic AI SRE

*   **Law**: 2025-2026のAI SREは「提案」から「自律実行」へ進化。ただし厳格なガードレールが必須。
*   **Agentic SREの段階**:

    | レベル | 自律度 | 例 | ガードレール |
    |:------|:------|:---|:----------|
    | **L1: 通知** | 情報提供のみ | 異常検知→Slack通知 | なし |
    | **L2: 提案** | 修復案を提示 | ロールバック推奨 | 人間が判断 |
    | **L3: 承認付き実行** | 人間承認後に実行 | スケーリング実行 | 承認ゲート |
    | **L4: 自律実行** | 条件付き自動実行 | Pod再起動 | ホワイトリスト |
    | **L5: 完全自律** | 複雑判断も自動 | 研究段階 | 未確立 |

*   **AI Copilot for Incident Response**: AIがインシデント対応をリアルタイムで支援。過去のPost-mortemと類似インシデントを自動検索し、推奨修復手順を提示。MCP/A2Aプロトコルを活用したエージェント間連携により、ログ分析→根本原因推定→修復提案までを自動化。
    *   **制約**: AI Copilotの提案は常に人間が検証。Copilotの応答品質を月次で評価（正答率、偽陽性率）。

### §101-b. MCP/A2A/ACP統合プロトコル

*   **Law**: AIOps SREエージェントは**MCP（Model Context Protocol）**/**A2A（Agent-to-Agent）**/**ACP（Agent Communication Protocol）**に準拠した標準プロトコルで通信。
*   **アーキテクチャ**:
    1.  **MCP**: AIエージェントがツール（Grafana、PagerDuty、Terraform等）と対話するための統一プロトコル。ツール仕様をJSON Schemaで記述し、エージェントが動的にツールを発見・実行
    2.  **A2A**: 複数AIエージェント間の協調。監視エージェント→分析エージェント→修復エージェントのチェーン実行
    3.  **ACP**: エージェントの能力宣言・タスク委譲のためのプロトコル
*   **SRE運用での活用**:
    1.  **インシデント対応**: 監視エージェント→ログ分析エージェント→ランブック実行エージェントの自律チェーン
    2.  **容量計画**: メトリクス収集エージェント→予測エージェント→スケーリング実行エージェント
    3.  **ガードレール**: エージェント間通信は全て監査ログに記録。Blast Radius制限はエージェントレベルで適用

### §101. ガードレール付き自動修復

| ガードレール | 内容 |
|:----------|:-----|
| **Action Scope制限** | 実行可能アクションを事前ホワイトリスト化 |
| **Blast Radius制限** | 影響5%超は人間承認必須 |
| **連続実行制限** | 同一アクション1時間あたり3回まで |
| **ロールバック義務** | 修復後SLI劣化で自動ロールバック |
| **監査ログ** | 全自動修復アクションを記録 |

---

## Part XXXVIII: マルチリージョン・DR（SRE観点）

### §102. マルチリージョン設計原則

*   **Law**: ミッションクリティカルなサービスは単一リージョン障害に耐えられる設計。
*   **原則**: Active-Passive / Active-Active選択、クロスリージョンレプリケーション、DNSフェイルオーバー、IaC再構築（15分以内）。

### §103. Cell-Based Architecture

*   **Law**: 大規模システムでは**Cell-Based Architecture**を検討。障害の影響範囲（Blast Radius）を物理的に限定。
*   **原則**:
    1.  **独立セル**: 各セルは独立したインフラスタック（DB、キャッシュ、アプリ）を持つ
    2.  **ルーティング**: ユーザーを特定のセルにルーティング（テナント/地域ベース）
    3.  **障害隔離**: 1セルの障害が他セルに波及しない設計
    4.  **段階的ロールアウト**: 変更を1セルずつ適用

### §104. ベンダーロック回避

*   **Law**: インフラの**70%以上**が単一ベンダー独自機能に依存する状態は「構造的リスク」。
*   **Action**: 抽象化レイヤー、OTel + S3互換ストレージ、Exit Strategy文書化。

### §105. ドメイン管理

*   **Domain Auto-Renewal**: ドメイン有効期限切れは「復元困難なインシデント」。自動更新有効化、Whois情報最新化、DNS Sovereignty。

---

## Part XXXIX: SRE組織・文化・教育

### §106. SREチーム構成モデル

| モデル | 概要 | 適用場面 |
|:------|:-----|:--------|
| **Embedded SRE** | 開発チーム内にSREを配置 | 緊密な連携が必要 |
| **Centralized SRE** | 独立SREチームが横断管理 | 大規模・標準化必要 |
| **Hybrid** | コアSRE + 各チームのSREチャンピオン | 中〜大規模 |
| **Platform SRE** | IDP/Platform teamとSREを統合 | Platform Engineering組織 |

### §107. On-Call文化・バーンアウト防止

*   公平なローテーション、インシデント後休暇、ページ数制限、心理的安全性、On-Call補償。

### §108. SREスキルマトリクス

| スキル領域 | Junior | Mid | Senior |
|:---------|:------|:----|:------|
| 監視・アラート | 既存運用 | 新規設計 | アーキテクチャ設計 |
| インシデント対応 | Scribe | Ops Lead | Incident Commander |
| カオスエンジニアリング | GameDay参加 | 実験設計 | 戦略策定 |
| SLO設計 | SLO追跡 | SLI/SLO策定 | エラーバジェットポリシー設計 |

### §109. SRE教育プログラム

*   **推奨リソース**: Google SRE Books 3冊、DORA State of DevOps Report、On-Call訓練（メンター付きシャドウイング）
*   **新メンバーオンボーディング**: 監視ダッシュボードアクセス取得、On-Callツールセットアップ、ランブック確認、Post-mortem過去事例レビュー、On-Call 2週間シャドウイング、GameDay参加

---

## Part XL: SRE成熟度モデル・アンチパターン

### §110. 5段階成熟度モデル

| レベル | 名称 | 特徴 | 主要指標 |
|:------|:-----|:-----|:--------|
| **Level 1: Reactive** | 事後対応 | 障害後に対応。監視は最低限 | MTTR > 4時間 |
| **Level 2: Proactive** | 事前対策 | 基本監視・SLO定義済み | MTTR 1-4時間 |
| **Level 3: Strategic** | 戦略的 | エラーバジェット運用・カオスエンジニアリング | MTTD < 5分、Toil < 50% |
| **Level 4: Autonomous** | 自律的 | Self-Healing・AI駆動異常検知 | 自動復旧率 > 70% |
| **Level 5: Antifragile** | 反脆弱性 | 障害から学び強くなるシステム | インシデント再発率 0% |

### §111. 成熟度評価チェックリスト

- [ ] 全サービスにSLI/SLOが定義されている
- [ ] エラーバジェットポリシーが運用されている
- [ ] On-Callローテーションが公平に運用されている
- [ ] Post-mortemが48時間以内に実施されている
- [ ] カオスエンジニアリングが定期的に実施されている
- [ ] Toil比率が50%以下である
- [ ] バックアップの復旧訓練が四半期に1回実施されている
- [ ] 全P0/P1アラートにランブックが紐づいている
- [ ] 構造化ログが全サービスに導入されている
- [ ] PRR（Production Readiness Review）が実施されている
- [ ] Observability as Codeが実践されている

### §112. SREアンチパターン集

| # | アンチパターン | 問題 | 正しいアプローチ |
|:--|:-----------|:-----|:-------------|
| 1 | **Hope-Driven Operations** | 監視なし運用 | SLOとメトリクスで定量管理 |
| 2 | **Alert Fatigue Factory** | 全メトリクスにアラート | SLOベースの症状ベースアラート |
| 3 | **Toil Acceptance** | 手動作業を「仕事」と認識 | Toil測定・削減 |
| 4 | **Hero Culture** | 特定エンジニアに依存 | Bus Factor ≧ 2 |
| 5 | **Blame Game** | 障害の犯人捜し | Blameless Post-mortem |
| 6 | **Dashboard Cemetery** | 使われないダッシュボード | フィードバックに基づく設計 |
| 7 | **100% SLO Trap** | 100%稼働率を目標 | 現実的SLO（99.9%等） |
| 8 | **Deploy and Pray** | テストなしデプロイ | Progressive Delivery |
| 9 | **Goldplated Monitoring** | 監視インフラの複雑化 | OTelで標準化 |
| 10 | **Zombie Runbooks** | 更新されないランブック | 定期レビュー義務 |
| 11 | **Silent Failures** | エラーが静かに飲み込まれる | Fail-Fast + 構造化ログ |
| 12 | **Config Drift** | 環境間の設定差異 | IaC + GitOps + ドリフト検出 |
| 13 | **Telemetry Bloat** | 可観測性データの無制限蓄積 | テレメトリバジェット + サンプリング |
| 14 | **AI Blindspot** | AI判断を無条件信頼 | Human-in-the-Loop + Trust but Verify |
| 15 | **Gray Failure Blindness** | 二値的監視に依存 | 多視点監視 + 異常検知ML |
| 16 | **Observability Sprawl** | ツール乱立 | OTel標準化 + Observability as Code |

---

## Part XLI: Database Reliability Engineering

### §113. DRE基本原則

*   **Law**: データベースは信頼性の根幹。DRE（Database Reliability Engineering）の原則に基づきデータ層の信頼性を確保。
*   **O'Reilly Principles**: 「希望はバックアップ戦略ではない」「すべてのDBメトリクスはSLIである」

### §114. 接続プール管理

*   **Law**: アプリケーションとDB間の接続は**接続プーラー**（PgBouncer / Supavisor等）で管理。直接接続は禁止。
*   **設計指針**:
    1.  **プールサイズ**: `max_connections = (コア数 * 2) + ディスク数`（PostgreSQL推奨公式）
    2.  **モード**: Transactionモードを推奨（Preparedステートメント非使用時）
    3.  **監視**: アクティブ接続数、待機キュー長、接続取得レイテンシをメトリクス化
    4.  **枯渇アラート**: プールの80%使用でWarning、90%でCritical

### §115. マイグレーション安全性

*   **Law**: スキーマ変更は**Expand & Contract**パターンを厳守。
*   **安全なマイグレーション手順**:
    1.  **ロック回避**: `ALTER TABLE`にはタイムアウトを設定（`SET lock_timeout = '5s'`）
    2.  **インデックス作成**: `CREATE INDEX CONCURRENTLY`を使用
    3.  **大規模テーブル変更**: カラム追加時にデフォルト値を使用（PostgreSQL 11+はテーブルリライト不要）
    4.  **バリデーション**: マイグレーション適用後にスキーマ整合性を自動チェック

### §116. クエリパフォーマンス・Slow Query SLO

*   **Law**: Slow Queryはユーザー体験を直接損なう。SLOとして管理。
*   **Slow Query SLI**: `実行時間 < 100ms のクエリ / 全クエリ`
*   **Slow Query SLO**: 99%のクエリが100ms以内に完了
*   **対策**:
    1.  `pg_stat_statements`の有効化と定期レビュー
    2.  `EXPLAIN ANALYZE`によるクエリプラン分析
    3.  Missing Indexの自動検出と提案
    4.  N+1クエリの検出・排除

### §117. レプリケーション・自動バキューム

*   **Replication Lag SLO**: プライマリ→レプリカ間の遅延を1秒以内に維持
*   **監視**: `pg_stat_replication`でリアルタイム監視。遅延増加でアラート
*   **Autovacuum監視**: Dead tuple比率、Autovacuumの実行頻度・所要時間を追跡

---

## Part XLII: API Reliability Engineering

### §118. API SLO設計

*   **Law**: APIの信頼性はエンドポイント単位でSLI/SLOを定義。
*   **エンドポイント別SLO**:

    | エンドポイント種別 | 可用性SLO | レイテンシSLO (P95) | レイテンシSLO (P99) |
    |:---------------|:---------|:------------------|:------------------|
    | **認証API** | 99.99% | ≦ 100ms | ≦ 300ms |
    | **読み取りAPI** | 99.9% | ≦ 200ms | ≦ 500ms |
    | **書き込みAPI** | 99.9% | ≦ 300ms | ≦ 1000ms |
    | **検索API** | 99.5% | ≦ 500ms | ≦ 2000ms |
    | **バッチAPI** | 99.0% | — | — |

### §119. Contract Testing

*   **Law**: APIのConsumerとProviderの契約を自動テストで保証。
*   **実装**: Pact / CDC（Consumer-Driven Contracts）を導入し、CIで自動実行。
*   **Cross-Reference**: `700_qa_testing.md` (テスト戦略)

### §120. API後方互換性・Deprecationポリシー

*   **Law**: 公開APIの破壊的変更は**禁止**。やむを得ない場合は以下のプロセスを遵守。
*   **Deprecation Lifecycle**:
    1.  **告知**: 最低6ヶ月前に非推奨を告知（APIレスポンスヘッダーに`Sunset`ヘッダー）
    2.  **移行支援**: 新APIへの移行ガイドを提供
    3.  **使用状況追跡**: 非推奨APIの残存コンシューマーを追跡
    4.  **廃止**: 全コンシューマーの移行完了後に廃止

### §121. Rate Limiting SRE（適応的レート制限）

*   **Law**: レート制限は固定値ではなく、システムの状態に応じて**適応的に調整**。
*   **Adaptive Rate Limiting**:
    1.  **通常時**: 標準レート制限（例: 100 req/min/user）
    2.  **高負荷時**: エラーバジェット消費速度に応じてレート制限を動的に厳格化
    3.  **攻撃検知時**: 異常パターン検知で個別IPをブロック

### §122. API Gatewayの信頼性

*   **Law**: API Gatewayは全APIトラフィックの入り口。単一障害点にならない冗長構成を必須化。
*   **要件**: ヘルスチェック、Circuit Breaker、Request/Response Transformation、認証/認可、レート制限、キャッシング

---

## Part XLIII: Network Reliability・DNS SRE

### §123. DNS信頼性

*   **Law**: DNSは全サービスのアクセスの基盤。DNS障害 = 全サービス障害。
*   **要件**:
    1.  **冗長構成**: 最低2つの独立DNSプロバイダー（Dual-Provider DNS）
    2.  **DNSSEC**: DNS応答の真正性を暗号的に保証
    3.  **DNS Failover**: ヘルスチェックベースの自動フェイルオーバー
    4.  **TTL管理**: 通常300秒、フェイルオーバー用に60秒の低TTLレコードを準備
    5.  **DNS監視**: 解決時間、NXDOMAIN率、伝播状態をメトリクス化

### §124. TLS証明書管理

*   **Law**: TLS証明書の有効期限切れはサービス障害に直結。**自動更新を必須化**。
*   **要件**:
    1.  **自動発行・更新**: Let's Encrypt / ACM等を活用
    2.  **期限監視**: 30日前にWarning、7日前にCritical
    3.  **Certificate Transparency Logs**: CT Logsを監視し、不正な証明書発行を検出
    4.  **HSTS**: HTTP Strict Transport Securityの適用

### §125. CDN信頼性・Multi-CDN

*   **Law**: CDNはセカンダリプロバイダーを準備。プライマリCDN障害時の自動切替を設計。
*   **要件**:
    1.  **Origin Shield**: オリジンサーバーへのトラフィックを集約するミドルティアキャッシュ
    2.  **Cache Hit Rate SLO**: ≧ 90%を目標
    3.  **Purge戦略**: コンテンツ更新時の即時パージとウォームアップ手順

### §126. ネットワーク可観測性

*   **Law**: ネットワーク層の問題は「見えない」ことが多い。ネットワーク固有の可観測性を構築。
*   **要件**: Flow Logs分析、TCPリトランスミッション率、接続タイムアウト率、DNS解決時間、ネットワークレイテンシのパーセンタイル分布

---

## Part XLIV: AI/ML System SRE（MLOps/LLMOps）

### §127. モデル推論SLO

*   **Law**: AI/MLモデルの推論品質と速度をSLOで管理。

    | SLI | SLO | 計測方法 |
    |:---|:----|:--------|
    | **推論レイテンシ（P95）** | ≦ 500ms（軽量モデル）/ ≦ 3000ms（LLM） | アプリログ |
    | **推論精度** | ≧ 95%（分類タスク） | 品質モニタリング |
    | **推論可用性** | ≧ 99.9% | ヘルスチェック |
    | **ハルシネーション率（LLM）** | ≦ 5% | 品質評価パイプライン |

### §128. GPU/TPU容量計画

*   **Law**: GPU/TPUは高コストかつ供給制約あり。容量計画を慎重に実施。
*   **要件**:
    1.  **GPU使用率追跡**: DCGM Exporter / NVIDIA SMI + Prometheus
    2.  **Right-Sizing**: 推論負荷に対する最適GPU選択
    3.  **スポットインスタンス活用**: 非クリティカル推論にはスポット/プリエンプティブルGPUを活用
    4.  **Multi-Model Serving**: Triton Inference Server等で複数モデルを同一GPUでホスト

### §129. Feature Store信頼性

*   **Law**: Feature Storeはモデル推論の入力データ提供。信頼性低下はモデル品質劣化に直結。
*   **要件**: 特徴量鮮度SLO（≦ 5分）、特徴量ドリフト検出、Online/Offlineストア整合性、アクセスレイテンシ追跡

### §130. LLM固有SRE

*   **Law**: LLM（Large Language Model）は従来のMLモデルとは異なるSRE課題を持つ。
*   **固有課題**:
    1.  **ハルシネーションSLI**: 事実に反する出力の比率を測定
    2.  **Prompt Version管理**: プロンプトの変更をGitで管理し、A/Bテストで効果を検証
    3.  **Token Budget管理**: リクエストあたりのトークン消費量の上限設定と監視
    4.  **Guardrail**: 不適切な出力のフィルタリング・サニタイゼーション
    5.  **Model Versioning**: モデルバージョンの管理とカナリア展開
    6.  **コスト最適化**: プロンプトキャッシング、セマンティックキャッシング、モデルルーティング

### §131. AI Pipeline信頼性

*   **Law**: データ取り込み→前処理→学習→評価→デプロイのパイプライン全体の信頼性を保証。
*   **要件**:
    1.  **データドリフト検出**: 学習データと本番データの分布差異を監視
    2.  **モデルデグラデーション検知**: 推論精度の経時劣化を検出
    3.  **再学習トリガー**: 精度低下やデータドリフト検出時の自動パイプライントリガー
    4.  **パイプライン冪等性**: 再実行で同一結果を保証

---

## Part XLV: Release Engineering

### §132. Release Candidate管理

*   **Law**: 本番リリースは**Release Candidate（RC）**を経由。RC認定なしの直接リリースは禁止。
*   **RCプロセス**:
    1.  **RC Cut**: メインブランチからRCブランチを切り出し
    2.  **RC Validation**: ステージング環境でのフルテスト・負荷テスト
    3.  **RC Approval**: テスト結果を基にリリース承認者が判断
    4.  **RC Deploy**: 承認後のプロダクション展開

### §133. Cherry-Pick Protocol

*   **Law**: RC後の緊急修正は**Cherry-Pick**で対応。RC外の変更混入を防止。
*   **要件**:
    1.  Cherry-Pickの理由をPRに明記
    2.  ターゲットブランチでのCIテスト通過
    3.  2名以上のレビュー
    4.  Cherry-Pick履歴の追跡

### §134. Release Train Model

*   **Law**: 定期的なリリースサイクル（Release Train）により、デプロイ可予測性を向上。
*   **モデル**: 週次Train（月〜木はFeature追加、金はFreeze、翌週月にリリース）

### §135. Rollout Percentage管理

*   **Law**: 大規模変更のロールアウトは段階的に実施。SLI監視と連動。
*   **段階**: 1% → 5% → 25% → 50% → 100%。各段階で最低30分の安定性確認。SLI劣化時は前段階にロールバック。

---

## Part XLVI: Sustainability / Green SRE

### §136. Carbon-Aware Computing

*   **Law**: 計算リソースの使用は環境コストを伴う。SREはサステナビリティを信頼性設計に組み込む。
*   **原則**:
    1.  **低炭素リージョン選択**: バッチ処理・非リアルタイムワークロードを再生可能エネルギー比率の高いリージョンにスケジュール
    2.  **Time-Shifting**: 非緊急タスクをグリッドの炭素強度が低い時間帯に移動
    3.  **Carbon-Aware SDK**: Green Software Foundation の Carbon Aware SDK を活用

### §137. Green Metricsダッシュボード

*   **Law**: エネルギー効率とカーボンフットプリントを可視化・追跡。
*   **指標**:

    | 指標 | 定義 | 目標 |
    |:-----|:-----|:-----|
    | **PUE** | Power Usage Effectiveness | ≦ 1.2 |
    | **CUE** | Carbon Usage Effectiveness | 可能な限り低減 |
    | **WUE** | Water Usage Effectiveness | 可能な限り低減 |
    | **SCI** | Software Carbon Intensity | 月次追跡・改善 |

### §138. Idle Resource最適化

*   **Law**: アイドルリソースは「環境に対する負債」。
*   **Action**:
    1.  開発/ステージング環境の夜間・週末自動停止
    2.  Serverless First: 常時稼働不要なワークロードはServerless化
    3.  Right-Sizing: 過剰プロビジョニングされたインスタンスの定期見直し

---

## Part XLVII: SRE Economics・ダウンタイムコスト

### §139. ダウンタイムコスト算出モデル

*   **Law**: 信頼性投資の正当化にはダウンタイムの金銭的影響を定量化する必要がある。
*   **コスト要素**:

    | 要素 | 算出方法 |
    |:-----|:--------|
    | **直接的収益損失** | (分あたり売上) × ダウンタイム分数 |
    | **SLA違反ペナルティ** | 契約条項に基づく返金/クレジット |
    | **復旧コスト** | (エンジニア時給) × (投入人数 × 対応時間) |
    | **ブランド毀損** | 顧客離脱率 × 顧客生涯価値 |
    | **規制罰金** | 適用法令に基づく罰金額 |

### §140. Reliability Opportunity Cost

*   **Law**: 過剰な信頼性投資もコスト。SLO 99.99%を99.999%に引き上げるコストと、その差分がもたらすビジネス価値を比較。
*   **原則**: 「Nine（9の数）を1つ追加するコストは指数関数的に増大する」。ビジネス要件に基づいてSLOターゲットを適正化。

### §141. エラーバジェット経済学

*   **Law**: エラーバジェット1%の消費が与えるビジネスインパクトを金額換算し、Feature Release vs 信頼性改善の意思決定に活用。
*   **計算**: `エラーバジェット1%の価値 = 月間売上 × SLO閾値超過による推定離脱率`

### §142. SRE投資のROI

*   **Law**: SREチームへの投資対効果を四半期で計測・報告。
*   **ROI指標**: Toil削減による時間節約額、MTTR短縮による損失回避額、自動化による効率化額、インシデント削減による信頼性向上分

### §143. Reliability Debt管理

*   **Law**: Reliability Debtは技術的負債の一種。未対応のPost-mortemアクション、更新されないランブック、SLO未定義のサービス等を「負債」として追跡。
*   **Debt Score**: 各負債項目にリスクスコアを付与し、優先的に返済。

---

## Part XLVIII: 規制コンプライアンス自動化

### §144. DORA / NIS2 / CRAコンプライアンス

*   **Law**: EU金融セクター（DORA）、重要インフラ事業者（NIS2）、およびデジタル製品製造者（CRA）向けに、SREプラクティスをコンプライアンス要件にマッピング。

    | 規制 | SRE関連要件 | 対応するSREプラクティス |
    |:-----|:----------|:-------------------|
    | **DORA** | ICTリスク管理 | SLO/エラーバジェット管理 |
    | **DORA** | インシデント報告 | 構造化Post-mortem + 自動レポート生成 |
    | **DORA** | レジリエンステスト | DiRT / カオスエンジニアリング |
    | **DORA** | サードパーティリスク | 依存関係SLO + SBOM |
    | **NIS2** | サイバーセキュリティ | 脆弱性スキャン + PII保護 |
    | **NIS2** | インシデントハンドリング | §30-32 インシデント管理 |
    | **CRA** | 脆弱性処理義務 | SBOM + 脆弱性スキャンSLA + パッチ管理 |
    | **CRA** | セキュリティアップデート | 自動更新基盤 + Rollout管理 |
    | **CRA** | インシデント報告（24h） | 自動インシデント検出 + レポート生成 |
    | **SOC2** | 可用性 | SLO + 可観測性 |
    | **ISO27001** | 情報セキュリティ管理 | 監査ログ + アクセス制御 |

### §145. Evidence Package自動生成

*   **Law**: 監査対応の証跡を**自動生成**し、監査準備工数を最小化。
*   **自動収集対象**: SLO達成レポート、インシデントレポート、変更履歴（Git log）、アクセスログ、脆弱性スキャン結果、バックアップ検証記録

### §146. Compliance-as-Code

*   **Law**: コンプライアンス要件をコードで定義し、CIパイプラインで自動検証。
*   **ツーリング**: OPA（Open Policy Agent）/ Checkov / tfsec / Trivy
*   **例**: 「全S3バケットは暗号化が有効」→ OPAポリシーで検証 → CI失敗でマージブロック

### §147. 監査レディネスダッシュボード

*   **Law**: 規制対応状況をリアルタイムで可視化。
*   **指標**: コンプライアンス充足率、未対応項目数、証跡自動収集率、次回監査までの残日数

---

## Part XLIX: Runbook Automation・自動化フレームワーク

### §148. Runbook設計原則

*   **Law**: Runbookは「最も経験の浅いOn-Callエンジニアが深夜2時に問題解決できる」品質を目標。
*   **構成要素**:
    1.  **トリガー**: どのアラート/条件でこのRunbookを実行するか
    2.  **症状**: 何が観測されるか
    3.  **診断手順**: Decision Tree形式（If → Then → Else）
    4.  **修復手順**: ステップバイステップの修復アクション
    5.  **検証手順**: 修復後の確認方法
    6.  **エスカレーション**: 解決不能時の連絡先

### §149. Runbook Automation Engine

*   **Law**: 高頻度RunbookはAutomation Engineで自動実行。
*   **段階的自動化**:
    1.  **Manual Runbook**: 手順書としてのRunbook
    2.  **Semi-Automated**: コピペ実行可能なスクリプト付きRunbook
    3.  **Automated with Approval**: ボタン1つで実行（人間承認必須）
    4.  **Fully Automated**: アラートトリガーで自動実行
*   **ツーリング**: Rundeck / PagerDuty Automation Actions / StackStorm

### §150. Self-Service Remediation

*   **Law**: 開発者がSREに頼らず自ら修復できるセルフサービスを提供。
*   **例**: キャッシュフラッシュ、Pod再起動、Feature Flag無効化、ログレベル変更

### §151. ChatOps統合

*   **Law**: Runbook実行をSlack/Teams等のチャットから直接トリガー可能にする。
*   **要件**: コマンド実行ログの自動記録、実行権限チェック、結果のチャンネル共有

---

## Part L: SRE将来展望・新興技術

### §152. WebAssembly (Wasm) Runtime信頼性

*   **Law**: Wasmがサーバーサイドランタイムとして台頭。Wasm固有の信頼性課題に備える。
*   **課題**: メモリ安全性の検証、サンドボックス脱出リスク、コールドスタート特性（Docker比で高速）、可観測性計装（OTel Wasm SDK）
*   **WASI 0.3.0（2026年2月予定）**: WebAssembly System Interfaceが0.3.0で非同期/イベント駆動デプロイをサポート。コンテナ代替としての採用が加速。
    *   **エッジデバイス**、**Serverless環境**、**CDN Workers**でのの採用が有望
    *   Wasmバイナリサイズの小ささ（数MB）と起動速度（ミリ秒単位）がエッジコンピューティングに最適

### §152-b. Ambient Mesh（Sidecar-less Service Mesh）

*   **Law**: Istio Ambient Mesh（ztunnelベース）によるSidecar不要のService Meshが安定化。リソース消費と運用複雑性を大幅に削減。
*   **利点**:
    1.  **リソース削減**: Sidecarプロキシ不要によるCPU/メモリ節約（Podあたり100-200MBの削減）
    2.  **運用単純化**: Sidecarインジェクション・アップグレードの複雑性が解消
    3.  **ゼロトラストmTLS**: ztunnelによるL4レベルのmTLS自動適用
*   **注意**: L7ポリシー（ヘッダーベースルーティング等）が必要な場合はWaypoint Proxyを追加。段階的な移行戦略を推奨。

### §152-c. Confidential Computing SRE

*   **Law**: 機密コンピューティング（TEE: Trusted Execution Environment）環境でのSREプラクティス。
*   **課題と対策**:
    1.  **可観測性制約**: TEE内のデータは外部監視が困難。TEE対応の可観測性エージェントをエンクレーブ内に配置
    2.  **Attestation監視**: TEEのリモートアテステーションの成功/失敗をメトリクス化
    3.  **パフォーマンスオーバーヘッド**: TEEによる5-15%のパフォーマンス低下をSLOに織り込む
*   **適用場面**: 金融データ処理、医療データ分析、マルチパーティML学習

### §153. Quantum-Safe暗号移行

*   **Law**: 量子コンピュータの実用化に備え、暗号アルゴリズムの移行計画を策定。
*   **Action**: Post-Quantum Cryptography（PQC）対応アルゴリズムへの移行プランニング、ハイブリッド暗号の段階的導入、「Harvest Now, Decrypt Later」脅威への対策

### §154. Sovereign Cloud SRE

*   **Law**: データ主権要件（GDPR、各国データローカライゼーション法）に対応するSovereign Cloud環境でのSREプラクティス。
*   **課題**: リージョン制約下での冗長性設計、データ越境制限下でのDR戦略、ローカル規制対応

### §155. Digital Twin for Infrastructure

*   **Law**: インフラのDigital Twinを構築し、変更の影響を仮想環境でシミュレーション。
*   **活用**: 容量計画の精度向上、カオスエンジニアリングの仮想実行、コスト予測

### §156. Edge Computing / 衛星通信SRE

*   **Law**: LEO衛星網（Starlink等）やエッジデバイスの増加により、従来のデータセンター中心のSREモデルでは対応困難な環境へのSRE適用。
*   **課題**: 高レイテンシ・低帯域環境での可観測性、自律的なエッジ修復、分散合意アルゴリズム

---

## Part LI: Observability 2.0・AI駆動可観測性

### §157. Observability 2.0原則

*   **Law**: 従来の「3本柱（メトリクス・ログ・トレース）」を超え、**Observability 2.0**はデータの相関分析・因果推論・予測分析を統合した知性的可観測性を目指す。
*   **原則**:
    1.  **Wide Events / Structured Events**: 高カーディナリティ・高次元イベントデータを中心に据え、任意のディメンションでスライス＆ダイスが可能な分析基盤を構築
    2.  **Correlation over Collection**: データ収集量より、データ間の自動相関と因果関係の推論を重視
    3.  **Query-Driven Exploration**: 事前定義のダッシュボードに依存せず、アドホッククエリで仮説検証を反復実行
    4.  **Semantic Understanding**: OTel Semantic Conventions v1.30+によりデータの意味を標準化し、ツール横断の分析を可能にする
*   **OTel Collector v1.0 GA対応**（2025年安定版リリース）:
    1.  **Stable API保証**: v1.0 GAにより、Collector設定の後方互換性が保証
    2.  **Profiling Signal**: OTel Profiling Signalが安定版に昇格。CPU/メモリプロファイリングをメトリクス・トレースと統合
    3.  **eBPFプロファイリングエージェント**: OTel eBPF Profilerがカーネルレベルのスタックトレースを<1% CPUオーバーヘッドで収集。ゼロコード・マルチ言語対応
    4.  **OpAMP成熟**: OpAMPプロトコルがGA。数千台規模のCollectorフリート管理を実現
*   **AI-Driven Observability**:
    1.  **LLM-Powered Log Analysis**: LLMによる自然言語クエリでログ分析（「過去1時間の認証エラーの根本原因は？」）
    2.  **Causal Root Cause Analysis**: 異常検知→因果グラフ構築→根本原因の自動推定
    3.  **Predictive Alerting**: 過去のパターンから将来の障害を予測し、事前にアラートを発報
    4.  **Anomaly Explanation**: 異常検知結果を人間理解可能な言語で自動説明

### §158. Observabilityコスト最適化

*   **Law**: Observabilityデータは「収集すればするほど良い」ではない。**ROI最適化**の視点でテレメトリ投資を管理。
*   **原則**:
    1.  **テレメトリROI分析**: 各テレメトリシグナルのコスト対検出価値を定量評価
    2.  **Adaptive Sampling**: システム状態に応じてサンプリングレートを動的調整（正常時: 1%、障害時: 100%）
    3.  **テレメトリパイプラインSLO**: テレメトリデータの到達遅延をSLOで管理（例: メトリクス ≦ 30秒、ログ ≦ 60秒）
    4.  **Cardinality Management**: メトリクスのカーディナリティ爆発を防止。ラベル追加時はカーディナリティ影響評価を義務化
    5.  **Sustainability Observability**: テレメトリ基盤自体のカーボンフットプリントを可視化・最適化

---

## Part LII: DORA 5th Metric・信頼性のビジネスKPI化

### §159. DORA Reliability Metric

*   **Law**: DORA 2025レポートにより**Reliability**が5番目のコアメトリクスに正式昇格。従来の4メトリクス（Deployment Frequency、Lead Time for Changes、Change Failure Rate、Time to Restore Service）に加え、**一貫したシステムパフォーマンス**を定量的に測定。
*   **DORA 5 Metrics統合ダッシュボード**:

    | メトリクス | 定義 | Elite目標 |
    |:---------|:-----|:---------|
    | **Deployment Frequency** | 本番デプロイ頻度 | オンデマンド（日次以上） |
    | **Lead Time for Changes** | コミットから本番デプロイまでの時間 | < 1時間 |
    | **Change Failure Rate** | デプロイ起因の障害率 | < 5% |
    | **Time to Restore Service** | 障害からの復旧時間 | < 1時間 |
    | **Reliability** | SLO達成率・ユーザー体感品質 | SLO 99.9%+ |

*   **AI Amplifier Effect**: DORA 2025は「AIは組織の既存文化を増幅する」と結論。高成熟チームはAIで加速し、低成熟チームはAIにより機能不全が顕在化する。
*   **DORA AI Capabilities Model**: AIの効果を最大化するケイパビリティモデル。AIツール導入前に、DevOps/SREの基盤プラクティス（CI/CD、自動テスト、可観測性）を十分に成熟させることが前提。

### §160. Revenue-Linked SLO（収益連動SLO）

*   **Law**: SLOをビジネスKPIと直接結合し、信頼性の経営的価値を可視化。
*   **実装**:
    1.  **Revenue per 9（9の収益価値）**: SLO 99.9%→99.99%に引き上げた場合の追加収益を算出
    2.  **Customer Journey SLO**: ユーザーの重要ジャーニー（登録→課金→利用）全体にSLOを設定
    3.  **SLO Breach → Business Impact Alert**: SLO違反時に推定収益損失額をアラートに含める
    4.  **Reliability NPS**: 信頼性がNPS（Net Promoter Score）に与える影響を四半期で追跡

---

## Part LIII: SRE as a Service・Developer-First SRE

### §161. SREaaS（SRE as a Service）モデル

*   **Law**: 全ての組織がフルタイムSREチームを持つ必要はない。SREaaS（外部SRE）モデルの活用を検討。
*   **モデル分類**:

    | モデル | 概要 | 適用場面 |
    |:------|:-----|:--------:|
    | **Consulting SRE** | SRE評価・戦略策定 | SRE導入初期 |
    | **Managed SRE** | 監視・On-Call・インシデント対応を外部委託 | 小〜中規模組織 |
    | **Embedded SREaaS** | 外部SREが社内チームに組み込み | スケーリング期 |
    | **Fractional SRE** | パートタイムでSRE専門知識を提供 | スタートアップ |

*   **SREaaS選定基準**: SLO策定能力、On-Call品質、Runbook品質、テクノロジスタック適合性、コミュニケーション言語

### §162. Developer-First SRE

*   **Law**: SREの原則とツールを開発チームに押し出し、開発者自身がサービスの信頼性に責任を持つ文化を醸成。
*   **原則**:
    1.  **Shift-Left Reliability**: 設計段階からSLO定義、信頼性テスト、可観測性計装を組み込む
    2.  **Self-Service SRE Tooling**: 開発者がSRE承認なしで利用できるセルフサービスツール群（ダッシュボード作成、アラート設定、Feature Flag管理）
    3.  **DevEx SLO**: 開発者の生産性をSLOで管理

        | メトリクス | SLO目標 | フレームワーク |
        |:---------|:-------|:------------|
        | **ローカルビルド時間** | ≦ 30秒 | SPACE Framework |
        | **PR マージまでの時間** | ≦ 24時間 | SPACE Framework |
        | **環境セットアップ** | ≦ 30分 | DevEx Survey |
        | **On-Call認知負荷** | Pages/週 ≦ 2 | Cognitive Load Model |

    4.  **You Build It, You Run It**: サービスの運用責任はそのサービスを構築したチームが持つ。SREは「サポート」ではなく「イネーブラー」

---

## Part LIV: GenAI / RAG Pipeline SRE

### §163. GenAIアプリケーションSRE

*   **Law**: Generative AIアプリケーションは従来のWebアプリケーションとは異なる信頼性課題を持つ。専用のSREプラクティスを定義。
*   **GenAI固有SLI/SLO**:

    | SLI | SLO | 計測方法 |
    |:----|:----|:--------|
    | **TTFT（Time to First Token）** | ≦ 200ms（ストリーミング） | アプリログ |
    | **トークン生成速度** | ≧ 30 tokens/sec | アプリログ |
    | **ハルシネーション率** | ≦ 3%（ファクトチェック済み） | 品質評価パイプライン |
    | **Guardrail Trigger率** | ≦ 5%（誤ブロック率） | ガードレールログ |
    | **Context Window利用効率** | ≧ 70% | プロンプト分析 |

*   **Prompt Version SLO**: プロンプト変更はGitで管理し、A/Bテストで効果を検証。プロンプト変更によるハルシネーション率増加 > 1ポイントは自動ロールバック。
*   **Model Router SRE**: 複数LLMプロバイダー間のルーティング信頼性を管理。プライマリプロバイダー障害時の自動フェイルオーバー、コスト/品質のバランシング。

### §164. RAG Pipeline信頼性

*   **Law**: RAG（Retrieval Augmented Generation）パイプラインの各段階の信頼性を保証。
*   **RAGパイプラインSLI**:
    1.  **Retrieval Recall SLI**: 関連ドキュメントの取得率（≧ 90%）
    2.  **Embedding鮮度SLI**: ベクトルDBのインデックス更新遅延（≦ 15分）
    3.  **Context Relevance SLI**: LLMに渡されたコンテキストの関連性スコア（≧ 0.8）
    4.  **Grounding SLI**: 回答がRAGソースに基づく率（≧ 95%）
*   **Vector DB信頼性**: ベクトルDBの可用性SLO（≧ 99.9%）、クエリレイテンシSLO（P95 ≦ 50ms）、インデックス整合性チェック
*   **Semantic Caching SRE**: セマンティックキャッシュの信頼性管理。キャッシュヒット率SLO、セマンティック類似度閾値のチューニング、キャッシュ無効化戦略

---

## Part LV: 規制コンプライアンス深化

### §165. EU AI Act SREマッピング

*   **Law**: EU AI Act（2025年施行開始）の要件をSREプラクティスにマッピング。High-Risk AIシステムは追加のSRE義務を負う。
*   **SRE対応マトリクス**:

    | EU AI Act要件 | SREプラクティス | セクション参照 |
    |:------------|:-------------|:-----------|
    | **リスク管理システム** | SLO/エラーバジェットによる定量的リスク管理 | §4-§9 |
    | **データガバナンス** | データドリフト検出、データ品質SLI | §131 |
    | **技術文書** | Runbook、Postmortem、PRR | §91, §148 |
    | **記録保持（ロギング）** | 構造化ログ、監査ログ、OTel計装 | §13, §90 |
    | **透明性** | Status Page、SLOダッシュボード | §5 |
    | **人間による監督** | Human-in-the-Loop、AI Trust Paradox対応 | §99 |
    | **堅牢性・正確性** | カオスエンジニアリング、負荷テスト | §44-§46 |
    | **サイバーセキュリティ** | 脆弱性スキャン、SBOM | §73-§76 |

*   **CRA 2027タイムライン**: Cyber Resilience Act（CRA）は2027年に完全施行。デジタル製品の製造者は脆弱性処理（SBOM + 5年間のセキュリティアップデート）を義務付けられる。SREチームはCRA対応のタイムラインを逆算し、2026年中に基盤整備を完了すること。
*   **CRA規制タイムライン詳細**:

    | 日付 | マイルストーン | SRE対応 |
    |:-----|:-------------|:--------|
    | **2024/12** | CRA発効 | ギャップ分析開始 |
    | **2026/9/11** | 脆弱性報告義務開始 | 自動インシデント検出・報告基盤必須 |
    | **2027/12/11** | 全義務適用 | SBOM・SLSA・パッチ管理完全対応 |

*   **CRA報告義務（2026/9月開始）**: 積極的に悪用されている脆弱性の報告が義務化。SREチームは以下を準備:
    1.  脆弱性検出から24時間以内の初回報告プロセスの自動化
    2.  ENISA/国内CSIRTへの報告テンプレート準備
    3.  脆弱性情報の構造化管理（CVE/CVSS/VEX統合）

### §165-b. EU AI Act時間軸詳細

*   **Law**: EU AI Actの段階的施行スケジュールに従い、SREプラクティスを整備。

    | 日付 | 適用範囲 | SRE対応 |
    |:-----|:---------|:--------|
    | **2025/2** | 禁止プラクティス適用 | AIシステムのリスク分類確認 |
    | **2025/8** | GPAIモデル規則 | LLMOps・モデルガバナンス整備 |
    | **2026/8** | 高リスクAI義務 | 監視・ログ・品質管理のSRE実装 |
    | **2027/8** | 全規則完全適用 | 継続的コンプライアンス監視 |

### §166. SOC2 / ISO27001 SREマッピング深化

*   **Law**: SOC2 Trust Service Criteria（TSC）とISO27001のAnnex A統制をSREプラクティスに網羅的にマッピング。
*   **SOC2 TSCマッピング**:

    | TSC | SREプラクティス |
    |:----|:-------------|
    | **CC6.1（論理アクセス制御）** | RBAC、MFA、最小権限原則 |
    | **CC7.2（システム監視）** | OTel計装、SLOダッシュボード、アラート |
    | **CC7.3（変更検知）** | IaC + ドリフト検出、GitOps |
    | **CC8.1（変更管理）** | CI/CD、PRR、Progressive Delivery |
    | **A1.2（リカバリ計画）** | Fire Drill Protocol、RPO/RTO |

*   **監査ストーリー自動生成**: CIパイプラインから監査ストーリー（「誰が・いつ・何を・なぜ変更したか」）を自動生成し、監査対応工数を80%削減する目標を設定。
*   **Continuous Compliance Monitoring**: コンプライアンス状態をリアルタイムダッシュボードで可視化し、違反を即時検出。OPA Gatekeeper / Kyverno等のAdmission Controllerで非準拠リソースのデプロイをブロック。

---

## Part LVI: Incident Analytics・Cognitive Incident Management

### §167. Incident Analytics Dashboard

*   **Law**: インシデントデータを戦略的資産として扱い、体系的な分析基盤を構築。
*   **分析指標**:

    | 指標 | 定義 | 活用 |
    |:-----|:-----|:-----|
    | **Incident Frequency** | カテゴリ別の発生頻度 | 投資優先度の判断 |
    | **MTTD/MTTR Trend** | 検知・復旧時間の推移 | 改善効果の定量化 |
    | **Recurrence Rate** | 同一原因の再発率 | Post-mortemアクション品質 |
    | **Blast Radius Score** | 影響ユーザー数/売上 | ビジネスインパクト評価 |
    | **Time to Engage** | 検知→初動までの時間 | On-Call品質評価 |
    | **Cascade Depth** | カスケード障害の連鎖深度 | アーキテクチャ改善指針 |

### §168. Incident Pattern Mining

*   **Law**: 複数インシデントの横断分析で**システミックな弱点**を特定。
*   **手法**:
    1.  **Common Cause Analysis（CCA）**: 複数インシデントに共通する根本原因パターンを抽出。依存関係・時間帯・チーム・変更種類で分類
    2.  **Temporal Pattern Detection**: 特定の時間帯・曜日・イベント（リリース直後等）に集中するインシデントを検出
    3.  **Correlation Matrix**: インシデントカテゴリと変更カテゴリ（デプロイ・設定変更・インフラ変更）の相関を分析
    4.  **AI-Powered Clustering**: LLMを活用したPost-mortemの意味的クラスタリング。類似インシデントの自動グルーピング

### §169. Cognitive Incident Management

*   **Law**: インシデント対応における人間の**認知的負荷**を定量化・最適化。
*   **認知的インシデント管理（CIM）フレームワーク**:
    1.  **Sensemaking支援**: AI/MLによるアラートのコンテキスト自動付与。「何が起きているか」の理解を加速
    2.  **Decision Support Matrix**: 重大度×影響範囲のマトリクスに基づく推奨アクションをRunbookに統合
    3.  **Incident Fatigue Index**: On-Callエンジニアの累積疲労を計量化。月間ページ数×深夜率×平均対応時間で算出し、閾値超過時に強制休息
    4.  **Incident Handoff Quality**: シフト交代時の情報引き継ぎ品質をスコアリング。コンテキストロスを防止

---

## Part LVII: SRE for Hybrid / Multi-Cloud

### §170. マルチクラウド信頼性戦略

*   **Law**: マルチクラウド環境では、クラウド間の一貫した信頼性管理が不可欠。
*   **原則**:
    1.  **Abstraction Layer**: アプリケーションをクラウド固有APIから抽象化。Terraform / Pulumi / Crossplane等のマルチクラウド対応IaCを使用
    2.  **Unified Observability**: OTelを中心に全クラウドからのテレメトリを統合。クラウド固有の監視APIへの直接依存を最小化
    3.  **Cross-Cloud SLO**: サービス全体のSLOをクラウド横断で定義。各クラウドの可用性SLOの合成計算
    4.  **Egress Cost Awareness**: クラウド間データ転送コストを常に意識。不要なクロスクラウド通信を排除

### §171. Control Plane冗長化

*   **Law**: マルチクラウドのControl Plane（DNS、LB、サービスメッシュControl Plane）は単一障害点にならない設計。
*   **パターン**:
    1.  **DNS**: 複数DNSプロバイダーの併用（Route 53 + Cloudflare等）
    2.  **Global Load Balancer**: クラウド横断の負荷分散。ヘルスチェックベースの自動フェイルオーバー
    3.  **Config Store**: 設定の同期メカニズム。Eventually Consistentな設定伝播を許容する設計
    4.  **Secret Management**: HashiCorp Vault等のクラウド横断シークレット管理

### §172. Cloud Portability SLO

*   **Law**: 特定クラウドへの依存度をSLOとして定量管理。
*   **指標**:

    | 指標 | 健全 | 要改善 | 危険 |
    |:-----|:-----|:------|:-----|
    | **クラウド固有API依存率** | < 20% | 20-50% | > 50% |
    | **クラウド間移行テスト頻度** | 年次 | なし | — |
    | **Exit Strategy文書鮮度** | 6ヶ月以内 | 1年以内 | 未策定 |

---

## Part LVIII: Shift-Left Reliability（CI/CD統合信頼性）

### §173. Pre-Merge信頼性ゲート

*   **Law**: 信頼性の検証を**本番投入後**ではなく**PRマージ前**に移動。
*   **CI統合チェック**:
    1.  **SLO定義チェック**: 新サービスのPRにSLO定義ファイル（OpenSLO YAML）が含まれているか自動検証
    2.  **OTel計装チェック**: 主要エンドポイントにOTel計装が存在するか静的解析。未計装エンドポイントの警告
    3.  **Performance Budget Gate**: バンドルサイズ・レスポンスタイム基準への適合をCIで自動チェック
    4.  **Runbook Existence Check**: 新規アラートルール追加時に対応Runbookの存在を検証
    5.  **Resilience Pattern Lint**: Circuit Breaker / Retry / Timeout未設定の外部呼出しを検出

    ```yaml
    # .github/workflows/reliability-gate.yml — 信頼性ゲートの概念例
    name: Reliability Gate
    on: [pull_request]
    jobs:
      reliability-check:
        runs-on: ubuntu-latest
        steps:
          - uses: actions/checkout@v4
          - name: SLO Definition Check
            run: |
              if git diff --name-only HEAD~1 | grep -q "src/services/"; then
                test -f openslo.yaml || echo "::error::新サービスにSLO定義がありません"
              fi
          - name: OTel Instrumentation Check
            run: npx otel-lint --check-endpoints
          - name: Performance Budget
            run: npx bundlesize --config .bundlesizerc.json
    ```

### §174. Chaos as Code（CI統合カオステスト）

*   **Law**: カオスエンジニアリングをCIパイプラインに統合。小規模な信頼性テストをPR単位で実行。
*   **原則**:
    1.  **Toxiproxy統合**: テスト実行時にネットワーク遅延・エラーを注入し、タイムアウト設定やリトライ動作を検証
    2.  **Dependency Outage Simulation**: 外部依存のモックを障害状態にし、フォールバック動作を検証
    3.  **Resource Constraint Test**: メモリ/CPU制限下でのアプリケーション挙動を検証
*   **ツーリング**: Toxiproxy / Testcontainers + Chaos / Steadybit

### §175. テスト環境信頼性SLO

*   **Law**: テスト環境の不安定さは開発生産性を直接損なう。テスト環境自体のSLOを定義。
*   **テスト環境SLI/SLO**:

    | SLI | SLO | 対策 |
    |:---|:----|:-----|
    | **テスト環境可用性** | ≧ 99.5% | 自動復旧・モニタリング |
    | **CI Flaky Rate** | ≦ 2% | Flaky Test自動検出・隔離 |
    | **テスト実行時間** | ≦ 10分（P95） | 並列化・シャーディング |
    | **テストデータ鮮度** | ≦ 24時間 | 自動シーディング |

---

## Part LIX: Data-Driven SRE・SREメトリクスウェアハウス

### §176. SREメトリクスウェアハウス設計

*   **Law**: SRE関連の全メトリクスを統合的に分析するためのデータウェアハウスを構築。
*   **データソース統合**:
    1.  **SLO達成データ**: OpenSLO / Slothからの月次SLO達成率
    2.  **インシデントデータ**: PagerDuty / OpsGenieからのインシデント履歴
    3.  **変更データ**: Git / CI/CDからのデプロイ履歴
    4.  **コストデータ**: クラウドプロバイダーからの利用量・コスト
    5.  **可観測性メトリクス**: OTel Backendからのサマリーメトリクス
*   **分析基盤**: BigQuery / Snowflake / ClickHouseでSREデータレイクを構築。Grafana / Lookerで可視化。

### §177. Historical SLO Trend分析

*   **Law**: SLO達成率の長期トレンドを分析し、システム信頼性の進化を定量化。
*   **分析項目**:
    1.  **SLO達成率の四半期推移**: サービスごとの改善/劣化トレンド
    2.  **エラーバジェット消費パターン**: 季節性・リリースサイクルとの相関
    3.  **デプロイ頻度 vs Change Failure Rate**: スループットと安定性のバランス推移
    4.  **Toil比率推移**: 自動化投資の効果を定量化

### §178. SRE ROI Dashboard（CFO/CTO向け）

*   **Law**: SRE投資の経営への価値を定量的に証明するダッシュボード。
*   **指標**:

    | 指標 | 算出方法 | 報告先 |
    |:-----|:--------|:------|
    | **障害回避額** | MTTR短縮 × 分あたり売上 | CFO |
    | **Toil削減効果** | 削減時間 × エンジニア時給 | CTO |
    | **自動化ROI** | 投資額 vs 節約額（年間） | CFO/CTO |
    | **信頼性NPS影響** | SLO達成率 vs NPS変動相関 | CEO |
    | **SRE投資対効果比** | 総節約額 / SREチームコスト | CFO |

---

## Part LX: SRE for IoT / Embedded Systems

### §179. IoTデバイスフリート管理SRE

*   **Law**: 数千〜数百万のIoTデバイスフリートの信頼性管理は従来のサーバーSREとは異なるアプローチが必要。
*   **固有課題**:
    1.  **大規模フリート管理**: デバイスごとのバージョン管理・設定管理
    2.  **接続不安定性**: 間欠的な接続環境での可観測性設計
    3.  **リソース制約**: メモリ/CPU制限下での計装（軽量OTelエージェント）
    4.  **物理的アクセス不能**: リモート修復のみ。物理的な介入は最終手段
*   **デバイスSLO**: デバイスの「正常稼働率」「データ送信成功率」「コマンド応答時間」をSLI/SLOで管理。

### §180. OTA Update信頼性

*   **Law**: OTA（Over-The-Air）ファームウェア更新の失敗はデバイスの文鎮化を意味する。
*   **信頼性要件**:
    1.  **A/B Partitioning**: 新旧ファームウェアのデュアルパーティション。更新失敗時は旧バージョンにフォールバック
    2.  **段階的ロールアウト**: 1%→5%→25%→100%。各段階でデバイスヘルスメトリクスを確認
    3.  **ロールバックSLO**: 更新失敗率 ≦ 0.1%。超過時は即座にロールアウト停止
    4.  **Delta Update**: 差分アップデートにより帯域使用量を最小化
    5.  **更新完了確認**: デバイスからのActivation Report受信を必須化

### §181. エッジデバイス可観測性

*   **Law**: 低帯域・高レイテンシ環境のエッジデバイスに対する可観測性戦略。
*   **設計原則**:
    1.  **ローカルバッファリング**: テレメトリをデバイス上にバッファリングし、接続時に一括送信
    2.  **Adaptive Telemetry**: デバイス状態に応じてテレメトリ量を動的調整（正常時: サマリーのみ、異常時: 詳細ログ）
    3.  **Edge Aggregation**: エッジゲートウェイでテレメトリを事前集約し、クラウドへの転送量を削減
    4.  **デバイスヘルスダッシュボード**: フリート全体のバッテリー残量・接続状態・ファームウェアバージョン分布を可視化

---

## Appendix A: 逆引き索引

| キーワード | 参照セクション |
|:---------|:-----------|
| **SLI / SLO / SLA** | §4-§7 |
| **OpenSLO** | §5 |
| **SLO Controller** | §5, §61 |
| **エラーバジェット** | §8-§9, §141 |
| **Multi-Window Burn-Rate** | §9 |
| **Golden Signals** | §10 |
| **RED / USE Method** | §10 |
| **OpenTelemetry / OTel** | §11 |
| **OTel Collector** | §11 |
| **OTel Semantic Conventions** | §11 |
| **eBPF** | §12 |
| **構造化ログ** | §13 |
| **Canonical Log Lines** | §13 |
| **ログパイプライン** | §14 |
| **分散トレーシング** | §15-§16 |
| **W3C Trace Context / Baggage** | §15 |
| **Health Check** | §17 |
| **Continuous Profiling** | §18 |
| **フロントエンド監視 / Sentry** | §19 |
| **Core Web Vitals / INP** | §20 |
| **PII保護** | §21 |
| **SLOベースアラート** | §22 |
| **アラート閾値** | §23 |
| **アラート疲労防止** | §24 |
| **Actionable Alert** | §26 |
| **On-Call設計** | §27-§29 |
| **Cognitive Load Model** | §29 |
| **インシデントメトリクス / DORA** | §31 |
| **インシデントコミュニケーション** | §32 |
| **Blameless Post-mortem** | §33 |
| **Learning from Incidents** | §34 |
| **Adaptive Capacity** | §35, §49 |
| **Gray Failure** | §50 |
| **デプロイメント** | §37-§38 |
| **Progressive Delivery** | §39 |
| **Feature Flag** | §40, §52 |
| **ロールバック基準** | §43 |
| **カオスエンジニアリング / DiRT** | §44-§45 |
| **負荷テスト** | §46 |
| **レジリエンスパターン** | §48 |
| **Circuit Breaker** | §48 |
| **Self-Healing** | §51 |
| **Graceful Degradation** | §52 |
| **パフォーマンスバジェット** | §56 |
| **キャッシュ戦略** | §57 |
| **IaC / GitOps** | §58-§59 |
| **Drift Detection** | §58 |
| **Kubernetes / K8s** | §60-§61 |
| **Service Mesh** | §62 |
| **Serverless / Edge** | §63-§64 |
| **容量計画** | §65-§66 |
| **Toil管理** | §67-§69 |
| **バックアップ / 3-2-1-1** | §70-§72 |
| **Fire Drill** | §72 |
| **SBOM / VEX / SLSA** | §73, §76 |
| **Dynamic Configuration** | §78 |
| **FinOps** | §80-§83 |
| **テレメトリコスト** | §82 |
| **AI Cost** | §83 |
| **Executive Dashboard** | §85 |
| **SRE as Code** | §88 |
| **Observability as Code** | §89 |
| **PRR** | §91 |
| **Production Excellence** | §92 |
| **Platform Engineering / IDP** | §94-§97 |
| **Service Scorecard** | §97 |
| **AIOps** | §98-§101 |
| **Agentic AI SRE** | §100 |
| **Cell-Based Architecture** | §103 |
| **ベンダーロック回避** | §104 |
| **SREチームモデル** | §106 |
| **SRE成熟度モデル** | §110 |
| **SREアンチパターン** | §112 |
| **DRE / 接続プール** | §113-§117 |
| **Slow Query SLO** | §116 |
| **API SLO** | §118 |
| **Contract Testing** | §119 |
| **API Deprecation** | §120 |
| **Rate Limiting** | §121 |
| **DNS信頼性** | §123 |
| **TLS証明書** | §124 |
| **Multi-CDN** | §125 |
| **AI/ML SRE / MLOps** | §127-§131 |
| **LLMOps SRE** | §130 |
| **Release Candidate** | §132 |
| **Cherry-Pick Protocol** | §133 |
| **Green SRE / Carbon-Aware** | §136-§138 |
| **ダウンタイムコスト** | §139 |
| **Reliability Debt** | §143 |
| **DORA規制 / NIS2** | §144 |
| **Compliance-as-Code** | §146 |
| **Runbook設計** | §148 |
| **Runbook Automation** | §149 |
| **ChatOps** | §151 |
| **Wasm** | §152 |
| **Quantum-Safe** | §153 |
| **Digital Twin** | §155 |
| **Observability 2.0** | §157 |
| **OTel Collector v1.0 GA** | §157 |
| **OTel Profiling Signal** | §157 |
| **AI-Driven Observability** | §157 |
| **Observabilityコスト最適化** | §158 |
| **Adaptive Sampling** | §158 |
| **DORA 5th Metric / Reliability** | §159 |
| **Revenue-Linked SLO** | §160 |
| **SREaaS** | §161 |
| **Developer-First SRE** | §162 |
| **DevEx SLO / SPACE** | §162 |
| **GenAI SRE** | §163 |
| **TTFT / Token生成速度** | §163 |
| **RAG Pipeline SRE** | §164 |
| **Vector DB信頼性** | §164 |
| **Semantic Caching SRE** | §164 |
| **EU AI Act** | §165 |
| **CRA 2027** | §165 |
| **SOC2 TSCマッピング** | §166 |
| **Continuous Compliance** | §166 |
| **OTel CI/CD Observability** | §12-b |
| **OTel Logs GA** | §12-b |
| **DORA 7 Archetypes詳細** | §31 |
| **Adaptive Concurrency Limits** | §50-b |
| **Platform SLO** | §97-b |
| **Backstage Plugin信頼性** | §97-c |
| **MCP/A2A/ACP統合** | §101-b |
| **WASI 0.3.0** | §152 |
| **Ambient Mesh / ztunnel** | §152-b |
| **Confidential Computing SRE** | §152-c |
| **CRA 2026報告義務** | §165 |
| **EU AI Actタイムライン** | §165-b |
| **Incident Analytics** | §167 |
| **Incident Pattern Mining** | §168 |
| **Cognitive Incident Management** | §169 |
| **マルチクラウドSRE** | §170 |
| **Control Plane冗長化** | §171 |
| **Cloud Portability SLO** | §172 |
| **Pre-Merge信頼性ゲート** | §173 |
| **Chaos as Code** | §174 |
| **テスト環境信頼性SLO** | §175 |
| **SREメトリクスウェアハウス** | §176 |
| **Historical SLO Trend** | §177 |
| **SRE ROI Dashboard** | §178 |
| **IoT SRE** | §179 |
| **OTA Update信頼性** | §180 |
| **エッジデバイス可観測性** | §181 |

---

## Appendix B: クロスリファレンス

| 関連ルール | 参照内容 |
|:---------|:--------|
| **300_engineering_standards.md** | CI/CDパイプライン詳細、コードレビュー、ブランチ戦略 |
| **340_web_frontend.md** | フロントエンドパフォーマンス、Lighthouse、CWV |
| **301_api_integration.md** | API設計、認証、エラーハンドリング |
| **320_supabase_architecture.md** | Supabase固有のDB信頼性、RLS、マイグレーション |
| **400_ai_engineering.md** | AI/ML実装詳細、プロンプトエンジニアリング |
| **341_headless_cms.md** | コンテンツ管理、メディア配信 |
| **503_incident_response.md** | BCP/DR詳細、インシデント管理詳細プロトコル |
| **600_security_privacy.md** | セキュリティ、PII保護、認証認可 |
| **601_data_governance.md** | データプライバシー、GDPR、各国規制 |
| **602_oss_compliance.md** | ライセンス管理、SBOM/SCA詳細、SLSA |
| **700_qa_testing.md** | テスト戦略、Contract Testing |
| **801_governance.md** | ガバナンス、権限設計 |

