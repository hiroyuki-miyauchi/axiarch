# 62. ライセンスと依存関係管理 (License & Dependency Management)

## 1. ライセンスコンプライアンス (License Compliance)
*   **許可されるライセンス (Permissive Licenses)**:
    *   **MIT, Apache 2.0, BSD**: これらは商用利用に適しており、推奨されます。
    *   **帰属表示 (Attribution)**: 多くのライセンスは著作権表示を求めています。アプリ内の「設定 > ライセンス」画面等で、使用しているOSSのライセンス一覧を自動生成して表示する仕組み（例: `license-plist`, `oss-licenses-plugin`）を導入します。
*   **禁止されるライセンス (Prohibited Licenses)**:
    *   **GPL, AGPL (Copyleft)**: これらは「感染性」を持ち、リンクした独自のコードも公開する義務が生じるため、プロプライエタリな商用アプリでの使用は**厳禁**です。

*   **ライセンス分類テーブル (License Classification)**:

    **✅ 許可（安全）**:

    | ライセンス | リスク | 備考 |
    |:----------|:------|:-----|
    | MIT | ✅ 安全 | 最も緩やか。商用利用可 |
    | Apache-2.0 | ✅ 安全 | 特許条項含む。商用利用可 |
    | BSD-2-Clause / BSD-3-Clause | ✅ 安全 | 商用利用可 |
    | ISC | ✅ 安全 | MIT同等 |
    | CC0-1.0 | ✅ 安全 | パブリックドメイン相当 |
    | 0BSD | ✅ 安全 | 帰属表示不要 |

    **⚠️ 要注意（法務確認必須）**:

    | ライセンス | リスク | 対応 |
    |:----------|:------|:-----|
    | LGPL-2.1 / LGPL-3.0 | ⚠️ 条件付き | 動的リンクならOK。法務確認後に例外許可 |
    | MPL-2.0 | ⚠️ 条件付き | ファイル単位Copyleft。法務確認後に例外許可 |

    **🔴 禁止（即時ブロック）**:

    | ライセンス | リスク | 対応 |
    |:----------|:------|:-----|
    | GPL-2.0 / GPL-3.0 | 🔴 高 | プロジェクト全体のソース公開義務 |
    | AGPL-3.0 | 🔴 最高 | SaaS利用でも公開義務 |
    | SSPL | 🔴 最高 | 類似の感染力。MongoDBライセンスとして知られる |
*   **SBOM (Software Bill of Materials)**:
    *   **義務化**: 全てのビルドアーティファクトに対して、SPDXまたはCycloneDX形式の **SBOM** を自動生成します。これにより、サプライチェーンセキュリティを担保し、エンタープライズ顧客への信頼性を高めます。
    *   **Retention**: 各リリースのSBOMは最低 **2年間** 保持し、監査要求に即座に応答可能な状態を維持してください。

## 2. 自動スキャンとガードレール (Auto-Scan & Guardrails)
*   **CIパイプライン**:
    *   **FOSSA / Snyk**: CI/CDパイプラインにライセンススキャンツールを統合します。
    *   **ビルドブロック**: 禁止ライセンス（GPL等）や、Criticalな脆弱性が検出された場合、ビルドを自動的に失敗させます。人間による見落としを排除します。
    *   **License Enforcement**: `license-checker` や `license-report` 等のツールをCIに組み込み、禁止ライセンス（GPL/AGPL/SSPL）を含むPRは**自動ブロック**してください。
    *   **Vulnerability Gate**: `npm audit` または `Snyk` をCI/CDに組み込み、**Critical/High** の脆弱性が検出された場合はPRマージを**自動ブロック**してください。

## 3. 依存関係の選定基準 (Dependency Selection Criteria)
*   **ヘルスチェック (Health Metrics)**:
    *   **スター数**: GitHubで一定の評価（例: 1,000 stars以上）を得ているか。
    *   **メンテナンス**: 最終コミットが6ヶ月以内か。IssueやPRが放置されていないか。
    *   **バス係数**: メンテナーが一人だけではないか（プロジェクトの持続可能性）。
*   **サイズインパクト (Size Impact)**:
    *   **Bundlephobia**: Webアプリの場合、バンドルサイズへの影響を確認します。機能に対して過大すぎるライブラリは避けます（例: 日付操作にMoment.jsではなくdate-fnsやDay.jsを使う）。

## 4. バージョン管理 (Version Management)
*   **ロックファイル (Lock Files)**:
    *   **The CI Lockfile Protocol**:
        *   **Law**: `package-lock.json` の管理基準はSRE憲法 (`52`) の "Lockfile Integrity Protocol" に準拠します。CI環境では必ず `npm ci` を使用し、曖昧さを排除してください。
    *   `package-lock.json`, `yarn.lock`, `Podfile.lock`, `pubspec.lock` 等は**必ずコミット**し、チーム全員とCI環境で同一のバージョンがインストールされることを保証します。
*   **アップデート戦略 (Update Strategy)**:
    *   **定期更新**: 月に1回など、定期的に依存関係を更新する日（Dependency Day）を設けます。
    *   **セキュリティパッチ**: セキュリティパッチは**48時間以内**に適用することを義務付けます。Critical/Highの脆弱性は最優先で対応してください。
    *   **週次確認**: 依存パッケージの更新状況を**週次**で確認し、放置されたセキュリティアップデートがないか監視してください。
    *   **Lockfile Diff Review**: `package-lock.json` の意図しない変更を検知するため、PRレビュー時にLockfileの差分を**必ず確認**してください。
