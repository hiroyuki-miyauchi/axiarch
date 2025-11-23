# 90. Advanced Operations (Legal, FinOps & AI Ethics)

## 1. FinOps (Cloud Cost Optimization)
*   **Cost Awareness**:
    *   スタートアップにとってキャッシュは酸素である。無駄なクラウドリソースは「死」を意味する。
*   **Alerting & Quotas**:
    *   GCP予算アラート（Budget Alerts）を必ず設定する（50%, 90%, 100%）。
    *   Firebaseの無限ループによる課金事故を防ぐため、Firestoreの読み書き回数やCloud Functionsの実行時間にクォータ（上限）を設ける。
*   **Optimization**:
    *   定期的にコスト分析を行い、未使用のリソース（Zombie Instances）を削除する。

## 2. Legal & Compliance (Legal View)
*   **IP & Licensing**:
    *   使用するライブラリのライセンス（MIT, Apache 2.0等）を厳格に確認する。GPL汚染を避ける。
    *   生成されたコードやアセットの知的財産権が自社に帰属することを確認する。
*   **Terms & Privacy**:
    *   利用規約（ToS）とプライバシーポリシーは、リリース前に必ず整備する。特に「AIの誤回答（Hallucination）」に対する免責事項を含める。

## 3. AI Ethics & Governance
*   **Responsible AI**:
    *   AIモデルが差別的、暴力的、あるいは不適切なコンテンツを生成しないよう、フィルタリング（Safety Settings）を最大化する。
    *   **Human in the Loop**: AIの判断がユーザーの生命や財産に重大な影響を与える場合、必ず人間の確認プロセスを挟む。
*   **Transparency**:
    *   ユーザーに対して「AIと対話していること」を明示する（Bot Disclosure）。
