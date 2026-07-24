# Security Policy / セキュリティポリシー

## 🇯🇵 日本語

### Axiarchにおける「セキュリティ」とは

> [!IMPORTANT]
> Axiarchの中心はルール／ドキュメントですが、配布物にはinstaller、upgrade、
> health check、Git hook用Shell scriptとGitHub Actions workflowも含まれます。
> アプリケーションserverではない一方、供給網、command実行、path操作、
> credential、release完全性に関する通常のsoftware security riskがあります。

Axiarchは、AIエージェントの品質とセキュリティ水準を底上げし、逸脱行動のリスクを低減するための**「憲法駆動型のガバナンス・アーキテクチャ（ガードレール）」**です。AIの出力は基盤モデルの能力やコンテキストに依存するため、本作は**すべての脆弱性を完全に排除する魔法の盾（Silver
Bullet）ではありません**。その真の目的は、強固なルールアーキテクチャを適用することで、AIが生成するコードとセキュリティ意識の「床（最低基準）」を構造的・組織的に引き上げることです。

### 報告対象

以下のような問題を発見した場合にご報告ください：

| 報告対象                         | 例                                                 |
| :------------------------------- | :------------------------------------------------- |
| ルール設計の欠陥                 | セキュリティガイダンスに抜け穴や矛盾がある場合     |
| 意図しないAI行動を誘発するルール | ルールの記述がAIに危険な行動パターンを許容する場合 |
| ルール間の競合                   | 複数のルールが矛盾し、セキュリティ上の隙を生む場合 |
| 推奨プラクティスの陳腐化         | 業界標準の変化によりルールが不適切になった場合     |
| 配布scriptの脆弱性                | command injection、path traversal、意図しない上書き・削除 |
| CI／release供給網の脆弱性         | secret露出、過大権限、未検証artifact、tag／Release改ざん |

### 報告方法

- exploit手順、未公開脆弱性、credential、個人情報を含む報告は
  [GitHub Private Vulnerability Reporting](https://github.com/hiroyuki-miyauchi/axiarch/security/advisories/new)
  を使用し、公開Issueへ記載しないでください
- 機微情報を含まないルール改善、古い文書、一般的なhardening提案は
  [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues) で受け付けます

> [!NOTE]
> 報告には影響範囲、再現条件、対象version／commit、既知の緩和策を含め、
> secretや実利用者dataは最小化・redactしてください。

### 対応方針

- 報告を受領次第、内容を確認します
- 妥当な指摘はルールの改修・追加として反映します
- 貢献者のクレジットを記載します（希望する場合）

---

## 🇺🇸 English

### What "Security" Means in Axiarch

> [!IMPORTANT]
> Axiarch is primarily a rules and documentation framework, but its distribution
> also includes installer, upgrade, health-check, Git-hook shell scripts, and
> GitHub Actions workflows. It is not an application server, but it still has
> ordinary software-security surfaces involving supply chains, command execution,
> path handling, credentials, and release integrity.

Axiarch is a **constitution-driven governance architecture (guardrail
framework)** designed to raise the floor of quality and reduce the risk of
uncontrolled behavior in AI agents. Since AI output inherently depends on the underlying
model, context, and prompts, Axiarch **does not act as a silver bullet that
completely guarantees security**. Its true purpose is to elevate the minimum
baseline ("floor") of AI-generated code quality and security awareness by
enforcing a robust, structural rule architecture.

### What to Report

Please report if you discover any of the following:

| In Scope                                 | Example                                                               |
| :--------------------------------------- | :-------------------------------------------------------------------- |
| Flaws in rule design                     | Gaps or contradictions in security guidance                           |
| Rules that induce unintended AI behavior | Rule wording that permits dangerous AI action patterns                |
| Conflicts between rules                  | Multiple rules contradicting each other, creating security gaps       |
| Outdated recommended practices           | Rules that have become inappropriate due to industry standard changes |
| Distributed-script vulnerabilities       | Command injection, path traversal, or unintended overwrite/deletion   |
| CI and release supply-chain weaknesses    | Secret exposure, excess privilege, unverified artifacts, or tag/Release tampering |

### How to Report

- Reports containing exploit details, unpublished vulnerabilities, credentials,
  or personal data must use
  [GitHub Private Vulnerability Reporting](https://github.com/hiroyuki-miyauchi/axiarch/security/advisories/new)
  and must not be posted to a public Issue
- Non-sensitive rule improvements, stale documentation, and general hardening
  proposals may use [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues)

> [!NOTE]
> Include impact, reproduction conditions, affected version or commit, and known
> mitigations. Minimize and redact secrets and real-user data.

### Response Policy

- Reports will be reviewed upon receipt
- Valid findings will be reflected as rule modifications or additions
- Credit will be given to contributors (if desired)
