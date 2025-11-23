# 100. Crisis Management & SRE (Site Reliability Engineering)

## 1. Incident Response Protocol (War Room)
*   **Severity Levels (SEV)**:
    *   **SEV-0 (Critical)**: 全ユーザーが利用不可、データ損失。即時対応（24/365）。
    *   **SEV-1 (Major)**: 主要機能（決済、ログイン）が利用不可。営業時間外でも呼び出し。
    *   **SEV-2 (Minor)**: 一部機能の不具合。翌営業日に対応。
*   **War Room**:
    *   SEV-1以上が発生した場合、直ちに「War Room」（専用チャット/通話）を立ち上げ、解決するまで解散しない。
    *   **Roles**:
        *   **Commander**: 全体の指揮、意思決定（オーナーまたはAI）。
        *   **Ops**: 実際の修正作業（AI）。
        *   **Comms**: ユーザーへの状況報告（AI）。

## 2. Blameless Post-Mortem
*   **Philosophy**:
    *   「誰がミスをしたか」ではなく「なぜシステムがミスを許容したか」を問う。
    *   インシデント解決後24時間以内に、詳細な事後分析レポート（Post-Mortem）を作成する。
*   **Action Items**:
    *   再発防止策を必ず実装し、タスクリストに追加する。

## 3. Disaster Recovery (DR)
*   **Backup Strategy**:
    *   Firestore/Cloud SQLの自動バックアップを有効化し、定期的にリストア訓練を行う。
*   **Playbooks**:
    *   「DBが消えた時」「APIがダウンした時」などの具体的な対応手順書（Playbook）を事前に用意する。
