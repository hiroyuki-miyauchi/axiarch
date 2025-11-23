# 110. Data & DocOps Strategy

## 1. Modern Data Stack (BI Strategy)
*   **Architecture**:
    *   **Ingest**: Firebase/GCPの生データをBigQueryに集約する。
    *   **Transform**: 生データを分析用テーブル（Mart）に加工する。
    *   **Visualize**: Looker Studioを使用し、経営判断に必要なKPI（LTV, CAC, Retention）をリアルタイムで可視化する。
*   **Single Source of Truth**:
    *   「スプレッドシートでの手動集計」を禁止する。全ての数字はBigQueryから自動生成されるダッシュボードを正とする。

## 2. DocOps (Documentation Operations)
*   **Docs as Code**:
    *   ドキュメントはコードと等価である。Gitで管理し、PRレビューの対象とする。
    *   コードの変更とドキュメントの更新は「アトミック（不可分）」である。ドキュメント更新なきコード変更はマージしてはならない。
*   **Freshness & Maintenance**:
    *   **Dead Link Check**: リンク切れを自動検知する仕組みを導入する。
    *   **Review Cycle**: 主要なルールファイルは四半期ごとに見直し（Review）を行い、陳腐化を防ぐ。
*   **AI Generation**:
    *   API仕様書やボイラープレートコードのドキュメントは、AIを活用して自動生成し、人間は「Why（なぜそうしたか）」の記述に集中する。
