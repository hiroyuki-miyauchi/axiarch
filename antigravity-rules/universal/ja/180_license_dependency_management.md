# 180. ライセンスと依存関係管理 (License & Dependency Management)

## 1. ライセンスコンプライアンス (License Compliance)
*   **許可されるライセンス (Permissive Licenses)**:
    *   **MIT, Apache 2.0, BSD**: これらは商用利用に適しており、推奨されます。
    *   **帰属表示 (Attribution)**: 多くのライセンスは著作権表示を求めています。アプリ内の「設定 > ライセンス」画面等で、使用しているOSSのライセンス一覧を自動生成して表示する仕組み（例: `license-plist`, `oss-licenses-plugin`）を導入します。
*   **禁止されるライセンス (Prohibited Licenses)**:
    *   **GPL, AGPL (Copyleft)**: これらは「感染性」を持ち、リンクした独自のコードも公開する義務が生じるため、プロプライエタリな商用アプリでの使用は**厳禁**です。例外的に、API経由で疎結合する場合のみ許可されることがありますが、法務確認が必須です。
    *   **CC-BY-NC (Non-Commercial)**: 商用利用不可の素材やライブラリは使用しません。
*   **商用アセット (Commercial Assets)**:
    *   **フォント・画像・有料プラグイン**: 購入したライセンスの範囲（Web/App、PV数制限、シート数）を厳守します。ライセンス証書は一元管理します。

## 2. 依存関係の選定基準 (Dependency Selection Criteria)
*   **ヘルスチェック (Health Metrics)**:
    *   **スター数**: GitHubで一定の評価（例: 1,000 stars以上）を得ているか。
    *   **メンテナンス**: 最終コミットが6ヶ月以内か。IssueやPRが放置されていないか。
    *   **バス係数**: メンテナーが一人だけではないか（プロジェクトの持続可能性）。
*   **セキュリティ (Security)**:
    *   **脆弱性チェック**: `npm audit` や `dependabot` で既知の脆弱性がないか確認します。Critical/Highの脆弱性があるライブラリは導入不可です。
*   **サイズインパクト (Size Impact)**:
    *   **Bundlephobia**: Webアプリの場合、バンドルサイズへの影響を確認します。機能に対して過大すぎるライブラリは避けます（例: 日付操作にMoment.jsではなくdate-fnsやDay.jsを使う）。

## 3. バージョン管理 (Version Management)
*   **セマンティックバージョニング (Semantic Versioning)**:
    *   `Major.Minor.Patch` の意味を理解し、`package.json` 等での指定（`^`, `~`, 固定）を意図を持って行います。
*   **ロックファイル (Lock Files)**:
    *   `package-lock.json`, `yarn.lock`, `Podfile.lock`, `pubspec.lock` 等は**必ずコミット**し、チーム全員とCI環境で同一のバージョンがインストールされることを保証します。
*   **アップデート戦略 (Update Strategy)**:
    *   **定期更新**: 月に1回など、定期的に依存関係を更新する日（Dependency Day）を設けます。
    *   **メジャーアップデート**: 破壊的変更を伴うメジャーバージョンの更新は、影響範囲を調査し、移行計画を立ててから実施します。
