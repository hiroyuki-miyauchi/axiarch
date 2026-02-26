# 30. エンジニアリングの卓越性 (Engineering Excellence - General)

### 1.2. Supreme Directive: Realism First Protocol (Anti-Haribote)
*   **Definition**:
    *   **Haribote (ハリボテ)**: UI（皮膚）が存在しても、その背後で「データの永続化」と「再取得（Hydration）」が完全に行われていない機能は、いかなる理由があっても**「詐欺的実装（Deception）」** と定義し、実装完了とは認めません。
*   **Mandate (The Vein Check)**:
    *   **Rule**: 機能実装の完了条件は、UIの描画ではなく、**「UI → Action → DB → Action → UI」** というデータの血管（Round-Trip）が疎通していることを確認するまでコミットしてはなりません。
    *   **Physical Verification**: 開発者ツールだけでなく、必ずDB（psql/Table Editor）で**物理的に値が書き込まれていること**を確認する義務を負います。「動いているように見える」は禁止です。
*   **Deception Penalty**:
    *   保存されない設定画面や、リロードすると消える入力フォームをPRに含めることは、レビュワーとユーザーに対する**裏切り行為（Betrayal）**であり、修正完了まで全ての作業を凍結します。

        *   **The License Quarantine (AGPL Block)**: ライセンスガバナンスの詳細については、`60_security_privacy.md` の Rule 5 を参照し、**AGPL (Affero GPL)** の使用防止を徹底してください。
        *   **Ref**: AIによるGit操作の絶対禁止については、最高法規 `00_core_mindset.md` の Rule 8.1 を参照し、これを厳守してください。
