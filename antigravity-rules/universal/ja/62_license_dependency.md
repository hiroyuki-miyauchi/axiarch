# 62. ライセンスと依存関係管理 (License & Dependency Management)

## 1. ライセンスコンプライアンス (License Compliance)
*   **許可されるライセンス (Permissive Licenses)**:
    *   **MIT, Apache 2.0, BSD**: これらは商用利用に適しており、推奨されます。
    *   **帰属表示 (Attribution)**: 多くのライセンスは著作権表示を求めています。アプリ内の「設定 > ライセンス」画面等で、使用しているOSSのライセンス一覧を自動生成して表示する仕組み（例: `license-plist`, `oss-licenses-plugin`）を導入します。
*   **禁止されるライセンス (Prohibited Licenses)**:
    *   **GPL, AGPL (Copyleft)**: これらは「感染性」を持ち、リンクした独自のコードも公開する義務が生じるため、プロプライエタリな商用アプリでの使用は**厳禁**です。
*   **SBOM (Software Bill of Materials)**:
    *   **義務化**: 全てのビルドアーティファクトに対して、SPDXまたはCycloneDX形式の **SBOM** を自動生成します。これにより、サプライチェーンセキュリティを担保し、エンタープライズ顧客への信頼性を高めます。

## 2. 自動スキャンとガードレール (Auto-Scan & Guardrails)
*   **CIパイプライン**:
    *   **FOSSA / Snyk**: CI/CDパイプラインにライセンススキャンツールを統合します。
    *   **ビルドブロック**: 禁止ライセンス（GPL等）や、Criticalな脆弱性が検出された場合、ビルドを自動的に失敗させます。人間による見落としを排除します。

## 3. 依存関係の選定基準 (Dependency Selection Criteria)
*   **ヘルスチェック (Health Metrics)**:
    *   **スター数**: GitHubで一定の評価（例: 1,000 stars以上）を得ているか。
    *   **メンテナンス**: 最終コミットが6ヶ月以内か。IssueやPRが放置されていないか。
    *   **バス係数**: メンテナーが一人だけではないか（プロジェクトの持続可能性）。
*   **サイズインパクト (Size Impact)**:
    *   **Bundlephobia**: Webアプリの場合、バンドルサイズへの影響を確認します。機能に対して過大すぎるライブラリは避けます（例: 日付操作にMoment.jsではなくdate-fnsやDay.jsを使う）。

## 4. バージョン管理 (Version Management)
*   **ロックファイル (Lock Files)**:
    *   `package-lock.json`, `yarn.lock`, `Podfile.lock`, `pubspec.lock` 等は**必ずコミット**し、チーム全員とCI環境で同一のバージョンがインストールされることを保証します。
*   **アップデート戦略 (Update Strategy)**:
    *   **定期更新**: 月に1回など、定期的に依存関係を更新する日（Dependency Day）を設けます。
