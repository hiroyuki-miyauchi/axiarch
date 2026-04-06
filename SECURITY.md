# Security Policy / セキュリティポリシー

## 🇯🇵 日本語

### Axiarchにおける「セキュリティ」とは

> [!IMPORTANT]
> Axiarchは実行コードを含まないルール/ドキュメントのみのフレームワークです。
> 一般的なソフトウェアのCVE（脆弱性識別子）とは**性質が根本的に異なります**。

Axiarchは、AIエージェントの品質とセキュリティ水準を底上げし、逸脱行動を防止するための**「憲法駆動型のガバナンス・アーキテクチャ（ガードレール）」**です。AIの出力は基盤モデルの能力やコンテキストに依存するため、本作は**すべての脆弱性を完全に排除する魔法の盾（Silver Bullet）ではありません**。その真の目的は、強固なルールアーキテクチャを適用することで、AIが生成するコードとセキュリティ意識の「床（最低基準）」を構造的・組織的に引き上げることです。

### 報告対象

以下のような問題を発見した場合にご報告ください：

| 報告対象 | 例 |
|:--------|:---|
| ルール設計の欠陥 | セキュリティガイダンスに抜け穴や矛盾がある場合 |
| 意図しないAI行動を誘発するルール | ルールの記述がAIに危険な行動パターンを許容する場合 |
| ルール間の競合 | 複数のルールが矛盾し、セキュリティ上の隙を生む場合 |
| 推奨プラクティスの陳腐化 | 業界標準の変化によりルールが不適切になった場合 |

### 報告方法

- **推奨**: [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues) でご報告ください
- ルール改善の提案や議論も歓迎です

> [!NOTE]
> 実行コードを含まないため、一般的なセキュリティインシデント（情報漏洩・権限昇格等）のリスクはありません。報告いただいた内容はルールの改修・追加として反映されます。

### 対応方針

- 報告を受領次第、内容を確認します
- 妥当な指摘はルールの改修・追加として反映します
- 貢献者のクレジットを記載します（希望する場合）

---

## 🇺🇸 English

### What "Security" Means in Axiarch

> [!IMPORTANT]
> Axiarch is a rules/documentation-only framework with **no executable code**.
> Its security concerns are **fundamentally different** from typical software CVEs.

Axiarch is a **constitution-driven governance architecture (guardrail framework)** designed to raise the floor of quality and prevent uncontrolled behavior in AI agents. Since AI output inherently depends on the underlying model, context, and prompts, Axiarch **does not act as a silver bullet that completely guarantees security**. Its true purpose is to elevate the minimum baseline ("floor") of AI-generated code quality and security awareness by enforcing a robust, structural rule architecture.

### What to Report

Please report if you discover any of the following:

| In Scope | Example |
|:---------|:--------|
| Flaws in rule design | Gaps or contradictions in security guidance |
| Rules that induce unintended AI behavior | Rule wording that permits dangerous AI action patterns |
| Conflicts between rules | Multiple rules contradicting each other, creating security gaps |
| Outdated recommended practices | Rules that have become inappropriate due to industry standard changes |

### How to Report

- **Recommended**: Report via [GitHub Issues](https://github.com/hiroyuki-miyauchi/axiarch/issues)
- Rule improvement proposals and discussions are also welcome

> [!NOTE]
> Since Axiarch contains no executable code, there is no risk of typical security incidents (data leaks, privilege escalation, etc.). Reports will be addressed as rule modifications or additions.

### Response Policy

- Reports will be reviewed upon receipt
- Valid findings will be reflected as rule modifications or additions
- Credit will be given to contributors (if desired)
