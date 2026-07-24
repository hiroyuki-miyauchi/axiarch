## 変更種別 / Type of Change

<!-- feat / fix / docs / refactor / perf / test / build / ci / chore / revert -->

- [ ] 破壊的変更を含む / Includes a breaking change
- [ ] Universal Ruleを変更する / Changes a Universal Rule
- [ ] Blueprintを変更する / Changes a Blueprint

## 変更内容 / What

<!-- 変更の概要を記述してください / Describe your changes -->

## 変更理由・関連Issue / Why and Related Issue

<!-- なぜ必要か、Issue番号、ADR等を記述 / Explain why and link the Issue or ADR -->
Closes #

## 検証方法・結果 / How to Test and Results

<!-- 実行したcommandと結果、未実行なら理由を記述 / List commands and results, or explain why not run -->

```text
command:
result:
```

## リスク評価 / Risk Assessment

<!-- Low / Medium / High と理由、影響範囲、失敗時の利用者影響 / State risk level, rationale, blast radius, and user impact -->

## ロールバック計画 / Rollback Plan

<!-- git revertで十分か、追加復旧、forward fix、公開成果物や外部状態の扱い / Explain revert, recovery, forward-fix, and external-state handling -->

## マイグレーション・互換性 / Migration and Compatibility

<!-- DB、schema、seed、config、API、SDK、adopter upgrade、後方互換性。なければNone / Describe impacts or write None -->

- [ ] DB schema変更なし / No DB schema change
- [ ] migration／seed変更なし / No migration or seed change
- [ ] 既存利用者・採用先との互換性を確認した / Existing consumers and adopters remain compatible

## リリース影響・版数管理 / Release Impact and Versioning

<!-- SemVer影響、CHANGELOG、ROADMAP、installer、manifest、配布ref、tag／Release。非該当ならNone -->

- [ ] 版数変更なし / No version change
- [ ] 版数surfaceと日英release文書を同期した / Version surfaces and bilingual release docs are synchronized
- [ ] tagを作成する場合は署名、immutability、公開後検証を確認した / Tag publication verifies signing, immutability, and post-release convergence
- [ ] tag／Release／package／deployはこのPRのmergeと別の承認対象として扱った / Publication remains a separately approved action

## セキュリティ・プライバシー・FinOps / Security, Privacy, and FinOps

<!-- secret、PII、権限、供給網、API／compute／storageコスト、N+1や無制限retryの影響 -->

- [ ] secret／credentialを追加・露出していない / No secret or credential is added or exposed
- [ ] PIIの新規取得・保存・ログ出力なし / No new PII collection, storage, or logging
- [ ] 権限・trust boundaryへの影響を確認した / Permission and trust-boundary impacts were reviewed
- [ ] 無制限loop／retry、N+1、不要な外部API呼び出しなし / No unbounded loop, retry, N+1, or unnecessary external API call

## 承認境界・外部状態 / Approval Boundary and External State

<!-- repository外の設定、DB apply、deploy、tag、Release等。未実行のものと必要なownerを明記 -->

- [ ] GitHub／cloud／registry等の外部設定変更なし / No external service setting change
- [ ] 外部変更がある場合、対象・owner・承認・rollbackを明記した / External changes identify target, owner, approval, and rollback
- [ ] AI支援差分を人間が確認し、必要な来歴をcommit／PRへ残した / AI-assisted changes received human review and required provenance

## ガバナンス・日英整合チェック / Governance and Bilingual Checklist

> [!IMPORTANT]
> **事前のIssueなしのPRは原則マージしません。**
> **PRs without a prior Issue will generally not be merged.**

- [ ] このPRに対応するIssueが存在する / A related Issue exists for this PR
- [ ] Issueで事前に議論・承認を得ている / The proposal was discussed and approved in the Issue

### バイリンガル要件 / Bilingual Requirement

- [ ] `ja/universal/` と `en/universal/` の両方を更新した（該当する場合） / Updated both `ja/` and `en/` (if applicable)
- [ ] `ja/blueprint/` と `en/blueprint/` の両方を更新した（該当する場合） / Updated both `ja/` and `en/` (if applicable)
- [ ] `axiarch-prompts/` の対象フォルダ（`develop/`, `audit/`, `govern/`, `operate/`）を `ja/` と `en/` の両方更新した（該当する場合） / Updated both `ja/` and `en/` in the relevant subfolder(s) of `axiarch-prompts/` (if applicable)
- [ ] **Universal Rules を変更する場合**: 「憲法改正」としての明示的な承認を得ている / If modifying Universal Rules: explicit "Amend Constitution" approval obtained
- [ ] 変更した正本、INDEX、README、manifest、healthの同期を確認した / Canonical rules, indexes, README, manifest, and health remain synchronized

## 補足情報 / Additional Context

<!-- 必要に応じて追記 / Add any additional context -->
