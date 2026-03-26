# 71. グローバル展開と国際化 (Global Expansion & i18n)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24 | Version 3.0 — ゼロベース再構築

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「国際化は翻訳ではない — すべてのユーザーの文化に対するアーキテクチャ的敬意である。」
> すべてのi18n決定は文化的正確性・アーキテクチャの拡張性・ユーザー信頼を優先しなければならない。
> **文化的正確性 > 機能的パリティ > パフォーマンス > スピード** の優先順位を厳守せよ。
> **16パート・74セクション構成。**

---

## 目次

- [Part I: グローバル展開戦略基盤](#part-i-グローバル展開戦略基盤)
- [Part II: 国際化（i18n）アーキテクチャ](#part-ii-国際化i18nアーキテクチャ)
- [Part III: ローカライゼーション（L10n）基盤](#part-iii-ローカライゼーションl10n基盤)
- [Part IV: RTL・BiDi対応](#part-iv-rtlbidi対応)
- [Part V: CJK・多文字体系対応](#part-v-cjk多文字体系対応)
- [Part VI: タイムゾーン・暦・ロケール管理](#part-vi-タイムゾーン暦ロケール管理)
- [Part VII: 文化的適応・カルチャライゼーション](#part-vii-文化的適応カルチャライゼーション)
- [Part VIII: マルチリージョンインフラ・パフォーマンス](#part-viii-マルチリージョンインフラパフォーマンス)
- [Part IX: 決済・税制・コンプライアンス](#part-ix-決済税制コンプライアンス)
- [Part X: SEO/GEO・コンテンツ国際化](#part-x-seogeoコンテンツ国際化)
- [Part XI: AI/LLM多言語対応](#part-xi-aillm多言語対応)
- [Part XII: モバイル・クロスプラットフォームi18n](#part-xii-モバイルクロスプラットフォームi18n)
- [Part XIII: テスト・品質保証](#part-xiii-テスト品質保証)
- [Part XIV: セキュリティ・プライバシー国際化](#part-xiv-セキュリティプライバシー国際化)
- [Part XV: オブザーバビリティ・FinOps](#part-xv-オブザーバビリティfinops)
- [Part XVI: 組織・プロセス・成熟度](#part-xvi-組織プロセス成熟度)
- [Appendix A: 逆引き索引](#appendix-a-逆引き索引)

---

## Part I: グローバル展開戦略基盤

### セクション 1: グローバル展開哲学・原則

- **i18n-First原則**: i18n（国際化）はプロジェクト開始時（Day 1）からアーキテクチャに組み込む。後付けは技術的負債の最大要因
- **L10n ≠ Translation**: ローカライゼーションは翻訳ではない。文化適応（カルチャライゼーション）・法的適応・技術適応を含む包括的プロセス
- **優先順位の階層**:
  1. **機能的正確性**: データの正確な表示（通貨・日付・数値）
  2. **法的コンプライアンス**: 各国規制への準拠（GDPR・APPI・CCPA等）
  3. **文化的適切性**: 文化的に不適切な表現・デザインの排除
  4. **言語的品質**: 翻訳の自然さ・専門用語の正確性
- **Locale-Agnostic Code**: ビジネスロジックはロケールに依存しない設計。ロケール依存処理はUI層・フォーマット層に集約
- **AI-Ready i18n**: 翻訳リソースファイルはLLMが解析・処理しやすい構造で設計する。コンテキストメタデータの付与・一貫した命名規則を徹底し、AI翻訳の精度を向上

### セクション 2: 市場ティア戦略・GTM

- **ティア分類**:

| ティア | 地域例 | 戦略 | 投資基準 |
|---|---|---|---|
| Tier 1（最優先） | 北米・日本・西欧・オーストラリア | フルカルチャライズ・マーケティング集中 | ARPU高・規制成熟 |
| Tier 2（成長市場） | 東南アジア・南米・インド | バイラル成長・軽量化・低帯域最適化 | ユーザー数成長・モバイルファースト |
| Tier 3（監視対象） | アフリカ・中東・中央アジア | 最低限のi18n・市場動向モニタリング | 将来ポテンシャル評価 |

- **Dynamic Pricing Metadata**: 国別の価格設定・機能制限は、コード内分岐ではなく**Stripe Metadata**（例: `allowed_regions: ['JP', 'US']`）で制御 → `100_product_strategy.md`
- **ティア昇格基準**: ティア変更は以下のKPIに基づく四半期評価
  - MAU成長率 > 20%/月
  - ARPU > グローバル平均の50%
  - 規制環境の安定化

### セクション 3: データ主権・レジデンシー戦略

- **データ主権マッピング**:

| 地域 | 主要規制 | データ保存要件 | 実装アクション |
|---|---|---|---|
| EU | GDPR・EU Data Act (2025年9月施行) | EU域内サーバー原則 | SCC/BCR・Sovereign Cloud検討 |
| 中国 | PIPL・データ越境安全評価制度 | 国内サーバー義務・ICP必須 | 現地パートナー提携 |
| ロシア | 連邦法No.242-FZ | ロシア国内保存義務 | 国内DC利用 |
| インド | DPDPA 2023 | 重要個人データ越境制限 | データ分類・DPIAの実施 |
| 韓国 | PIPA | 適切な安全措置義務 | 地域別暗号化ポリシー |
| ブラジル | LGPD | 適切な保護水準義務 | 国際移転契約 |

- **Sovereign Cloud活用**:
  - 厳格なデータ主権要件にはAWS European Sovereign Cloud / Azure Sovereign Cloud / GCP Sovereign Cloudを活用
  - ソブリンクラウドの選定基準: 暗号鍵の自国管理・運用スタッフの国籍要件・政府監査対応
- **データフロー図**: データが国境を越える**全パス**を文書化し、法的根拠を付記。年次レビュー義務
- → データレジデンシー詳細は `601_data_governance.md` を参照

---

## Part II: 国際化（i18n）アーキテクチャ

### セクション 4: Day 1 i18nアーキテクチャ

- **ハードコード厳禁**: UI上のテキスト（ボタン・ラベル・プレースホルダー・エラーメッセージ・ツールチップ・aria-label含む）のハードコードは**絶対禁止**
- **外部化義務**: 全ての翻訳可能テキストはキーバリュー形式の外部リソースファイル（`en.json`, `ja.json`等）で管理
- **擬似ローカライズ（Pseudo-localization）**:
  - 開発中は擬似言語モード（例: `Account` → `[!!! Àççôûñţ !!!]`）でテスト
  - **検出対象**: ハードコード文字列・レイアウト崩れ（テキスト長30〜40%増への耐性）・文字化け
  - **CI統合**: 擬似ローカライズテストをCI/CDパイプラインに組み込み、ハードコードを自動検出

```javascript
// ❌ 禁止: ハードコード
const label = "名前を入力してください";

// ✅ 正しい: 外部化
const label = t('form.name.placeholder');
```

### セクション 5: 翻訳キー設計・Namespace管理

- **Namespace設計**: 機能/ページごとにNamespaceを分割
  - 例: `common`, `auth`, `error`, `admin`, `settings`, `notification`
- **命名規約**:
  - 区切り文字: ドット（`.`）
  - 最大深度: **3階層**（`feature.section.element`）
  - キー名: 英語スネークケース（`auth.login.submit_button`）
- **コンテキスト付加**: 同一テキストでもコンテキストが異なる場合は別キーとする
  - 例: `common.save`（一般的な保存） vs `settings.profile.save`（プロフィール保存）
- **AI-Ready メタデータ**: 各キーにコンテキスト・最大文字数・スクリーンショットリンクをメタデータとして付加
- **禁止事項**:
  - 翻訳キーに翻訳テキスト自体を使用しない（例: `"Save changes"` をキーにしない）
  - 動的キー生成の禁止（`t(\`error.${code}\`)`）— 静的解析・不足キー検出を妨害

```json
{
  "common": {
    "save": "保存",
    "cancel": "キャンセル",
    "delete": "削除"
  },
  "auth": {
    "login": {
      "title": "ログイン",
      "submit_button": "ログインする",
      "error_invalid": "メールアドレスまたはパスワードが正しくありません"
    }
  }
}
```

### セクション 6: ICU MessageFormat 2.0・CLDR統合

- **ICU MessageFormat 2.0採用**: CLDR 47 / ICU 77で安定版（Stable）となったMessageFormat 2.0を新規実装の標準とする（2025年3月〜）
- **CLDR（Common Locale Data Repository）活用義務**:
  - 日付・時刻・数値・通貨のフォーマットは独自実装禁止。CLDRデータに準拠
  - `Intl` API（JavaScript）またはICUライブラリ経由で利用
- **MessageFormat 2.0の主要機能**:
  - モジュラー構造・カスタムファンクション拡張ポイント
  - 安全なマークアップ埋め込み（XSS防止）
  - 従来のMessageFormat 1.0からの段階的移行パス
- **カスタムファンクション拡張**: ドメイン固有のフォーマッタ（通貨表示・日付相対表示等）をカスタムファンクションとして登録
- **MF 1.0→2.0移行**: 新規コードはMF 2.0必須。既存コードは四半期ごとに移行計画を策定・実行

```
// MessageFormat 2.0 構文例
.local $count = {$itemCount :number}
.match $count
one {{カートに {$count} 個のアイテムがあります。}}
*   {{カートに {$count} 個のアイテムがあります。}}
```

### セクション 7: 複数形・性別・文法ルール

- **CLDR Plural Rules必須**: 複数形処理は独自ロジック禁止。CLDRの複数形カテゴリ（zero/one/two/few/many/other）を使用
  - 英語: 2カテゴリ（one/other）
  - アラビア語: 6カテゴリ（zero/one/two/few/many/other）
  - 日本語: 1カテゴリ（other のみ）
  - ポーランド語: 4カテゴリ（one/few/many/other）
- **性別対応**: 人称を含むメッセージは文法的性別に対応可能な構造とする
  - MF 2.0の`.match`ディレクティブで性別分岐
- **序数対応**: 順位表示（1st, 2nd, 3rd...）もCLDR ordinal rulesに準拠

### セクション 8: 日付・時刻・カレンダー体系

- **Intl.DateTimeFormat使用義務**: 日付・時刻のフォーマットは `Intl.DateTimeFormat` を使用し、ロケール自動適用
- **Temporal API活用**: `Temporal`（TC39 Stage 3、Chrome 130+ / Node 24+で安定化）を積極採用
  - `Temporal.ZonedDateTime`: タイムゾーン付き日時処理
  - `Temporal.PlainDate`: タイムゾーン非依存の日付処理
  - レガシー`Date`オブジェクトの新規使用禁止（Temporal移行推奨）
- **暦体系対応**: 主要市場の暦体系をサポート
  - 和暦（日本: 令和）
  - 仏暦（タイ: 仏滅紀元）
  - ヒジュラ暦（中東: イスラム暦）
- **相対時間**: `Intl.RelativeTimeFormat` を使用（「3日前」「2時間後」等）
- **週の開始日**: ロケールによる差異を考慮（日曜 vs 月曜 vs 土曜）

```javascript
// ✅ ロケール対応の日付フォーマット
const formatter = new Intl.DateTimeFormat('ja-JP-u-ca-japanese', {
  era: 'long', year: 'numeric', month: 'long', day: 'numeric',
});
// → "令和8年3月16日"

// ✅ Temporal API（推奨）
const zdt = Temporal.ZonedDateTime.from({
  timeZone: 'Asia/Tokyo',
  year: 2026, month: 3, day: 16, hour: 23,
});
```

### セクション 9: 数値・通貨・測定単位フォーマット

- **通貨オブジェクト必須**: 価格は「金額 + 通貨コード」のオブジェクトとして扱う
  - `{ amount: 1000, currency: 'JPY' }` — 金額と通貨を分離しない設計は禁止
- **Intl.NumberFormat使用義務**: 数値・通貨の表示フォーマットに使用
- **小数点処理**: 通貨ごとの小数桁数をCLDRに基づき処理（JPY: 0桁、USD: 2桁、BHD: 3桁）
- **測定単位**: `Intl.NumberFormat` の `unit` オプションでロケール対応（km/mi, kg/lb, °C/°F）
- **大きな数値**: `notation: 'compact'` でロケール別の短縮表記（英語: 1.2K、日本語: 1.2万）

```javascript
// ✅ 通貨フォーマット
new Intl.NumberFormat('ja-JP', {
  style: 'currency', currency: 'JPY'
}).format(1000); // → "￥1,000"

new Intl.NumberFormat('en-US', {
  style: 'currency', currency: 'USD'
}).format(9.99); // → "$9.99"

// ✅ コンパクト表記
new Intl.NumberFormat('ja-JP', {
  notation: 'compact', compactDisplay: 'short'
}).format(12000); // → "1.2万"
```

### セクション 10: 文字列連結禁止・コンテキスト付きメッセージ

- **文字列連結の絶対禁止**: 翻訳テキストの動的構築（`"Hello, " + name + "!"`）は禁止
  - 言語による語順の違い（SOV vs SVO）で翻訳不能になる
- **プレースホルダー方式**: 変数挿入はプレースホルダー（`{name}`）で対応
- **文脈注釈（Context Note）**: 翻訳者向けにキーの使用コンテキストをコメントとして付加
- **HTML in 翻訳禁止**: 翻訳文字列内にHTMLタグを直接含めない。リッチテキストはMF 2.0のマークアップ機能またはコンポーネント分割で対応

```javascript
// ❌ 禁止: 文字列連結
const msg = greeting + "、" + userName + "さん！";

// ✅ 正しい: プレースホルダー
const msg = t('greeting.personal', { name: userName });
// en: "Hello, {name}!"
// ja: "{name}さん、こんにちは！"
```

### セクション 11: リソースファイル管理・分割戦略

- **ファイル分割基準**:
  - ページ/機能単位で分割（`auth.json`, `settings.json`, `common.json`）
  - 1ファイルあたり最大500キー目安
- **遅延ロード**: 画面遷移時に必要なNamespaceのみ動的ロード（バンドルサイズ最適化）
- **フォールバックチェーン**: `ja-JP` → `ja` → `en`（デフォルト言語）の順で解決
- **翻訳ファイルのイミュータビリティ**: 翻訳キーの削除は非推奨。Deprecatedマーク後、2リリースサイクル経過後に削除

### セクション 12: エッジi18n・ミドルウェア処理

- **エッジでのロケール検出**:
  - `Accept-Language` ヘッダー解析をエッジ（Cloudflare Workers / Vercel Edge Middleware / Next.js Middleware）で実行
  - Geo-IPによるリージョン判定はフォールバックとして使用（ユーザー設定 > Accept-Language > Geo-IP）
- **エッジリダイレクト**: ロケール未指定URLから適切なロケールURLへのリダイレクトをエッジで処理（オリジンサーバー負荷軽減）
- **エッジキャッシュ**: `Vary: Accept-Language` でロケール別キャッシュ分離

```javascript
// Next.js Middleware によるロケール検出例
export function middleware(request) {
  const locale = request.headers.get('accept-language')?.split(',')[0]?.split('-')[0] || 'en';
  const supportedLocales = ['ja', 'en', 'ko', 'zh'];
  const resolved = supportedLocales.includes(locale) ? locale : 'en';
  // ...リダイレクト処理
}
```

---

## Part III: ローカライゼーション（L10n）基盤

### セクション 13: 翻訳管理システム（TMS）統合

- **TMS導入基準**: 3言語以上の展開時はTMS導入を義務化
- **推奨TMS比較**:

| TMS | 強み | Git連携 | MF 2.0対応 | AI翻訳統合 |
|---|---|---|---|---|
| Crowdin | コミュニティ翻訳・大規模対応 | ✅ GitHub/GitLab/Bitbucket | ✅ | ✅ DeepL/Google/OpenAI |
| Lokalise | 開発者フレンドリー・REST API | ✅ GitHub/GitLab | ✅ | ✅ DeepL/Google |
| Phrase | エンタープライズ・TMS+Strings統合 | ✅ GitHub/GitLab | ✅ | ✅ 自社AI+外部 |

- **TMS選定必須要件**:
  - Gitリポジトリ直接連携（PR自動生成）
  - 翻訳メモリ（TM）・用語集（Glossary）サポート
  - ICU MessageFormat 2.0対応
  - API経由のCLI/CI統合
  - ブランチベース翻訳ワークフロー
- **OTA翻訳更新**: モバイルアプリの翻訳更新はアプリストア再申請なしで反映可能な設計を推奨

### セクション 14: 継続的ローカライゼーション（CI/CD連携）

- **Continuous Localization**: 翻訳プロセスをCI/CDパイプラインに統合し、開発と翻訳を並行稼働
- **ワークフロー**:
  1. 開発者がソースコード内で翻訳キーを追加
  2. CI/CDが新規・変更キーを自動検出しTMSに送信
  3. 翻訳者がTMS上で翻訳・レビュー
  4. 承認済み翻訳がPRとして自動マージ
- **翻訳キー欠落検出**: ソースコード内のキーと翻訳ファイルを比較し、未翻訳キーをCIで自動検出・ビルド失敗
- **翻訳ファイルGit管理義務**: 全翻訳ファイルはJSON/YAML形式でGit管理下に置き、変更履歴を追跡可能にする
- **翻訳完了率ゲート**: CI/CDで翻訳完了率を検証。Tier 1言語は100%必須、Tier 2言語は95%以上でパス

```yaml
# CI/CDパイプライン例（GitHub Actions）
- name: i18n-check
  run: |
    npx i18n-check --source src/ --locales locales/ --fail-on-missing
    npx i18n-coverage --threshold 95 --tier1-threshold 100
```

### セクション 15: 翻訳品質保証（LQA・MTPE・ネイティブレビュー）

- **機械翻訳のみでのリリース禁止**: 全翻訳テキストはネイティブスピーカーによるレビューを経なければならない
- **LQA（Linguistic Quality Assurance）指標**:
  - **MQM（Multidimensional Quality Metrics）**: エラー分類（正確性・流暢性・用語・スタイル）に基づく定量評価
  - 合格基準: MQMスコア **98点以上**（100点満点）
- **MTPE（Machine Translation Post-Editing）**: AI翻訳を使用する場合、必ずポストエディットを実施
  - **Light PE**: UIラベル等の短文 — 意味の正確性確認
  - **Full PE**: マーケティングコピー・法的文書 — ネイティブ品質へ引き上げ
- **レビュープロセス**: 翻訳者 → レビュアー → 技術検証（変数・タグ整合性）の3段階

### セクション 16: 翻訳メモリ・用語集・スタイルガイド

- **翻訳メモリ（TM）活用**: 過去の翻訳を再利用し、一貫性とコスト効率を確保
- **用語集（Glossary）必須**: 全プロジェクトで言語別の用語集を管理
  - 技術用語・ブランド用語・業界用語の統一翻訳を定義
  - 翻訳禁止ワード（ブランド名・製品名等）を明示
- **スタイルガイド**: 言語別のトーン・文体・敬語レベルを定義
  - 日本語: 丁寧語（です・ます）/ フォーマル度の基準
  - 英語: アメリカ英語 vs イギリス英語の統一
- **用語集バージョン管理**: 用語集はGit管理し、変更時はPRレビュー必須

### セクション 17: AI/機械翻訳活用とガバナンス

- **AI翻訳の活用範囲**:

| 用途 | AI翻訳 | ポストエディット | ネイティブレビュー |
|---|:---:|:---:|:---:|
| UIラベル・ボタン | ✅ | ✅ Light PE | ✅ |
| ヘルプ・FAQ | ✅ | ✅ Full PE | ✅ |
| マーケティングコピー | ⚠️ 参考のみ | — | ✅ ゼロから執筆推奨 |
| 法的文書・利用規約 | ❌ 禁止 | — | ✅ 法務レビュー必須 |
| UGC（ユーザー生成コンテンツ） | ✅ リアルタイム | — | ❌ 不要 |

- **AI翻訳プロバイダ比較**:

| プロバイダ | 強み | 言語数 | 特記事項 |
|---|---|---|---|
| DeepL API | 高品質・自然な訳文 | 30+ | EU企業・GDPRフレンドリー |
| Google Cloud Translation Advanced | 言語カバレッジ広大 | 130+ | AutoML Translation対応 |
| AWS Translate | AWSエコシステム統合 | 75+ | Active Custom Translation |
| Claude/GPT-4o | コンテキスト理解・スタイル対応 | 100+ | トークンコスト管理必須 |

- **品質モニタリング**: AI翻訳の品質を定期的にサンプリング評価（月次）。BLEU/COMETスコアでベースライン管理
- **データプライバシー**: 翻訳APIに送信するデータのPII除去・匿名化を義務化
- **コスト管理**: AI翻訳APIコールのトークンバジェットを設定し、月次モニタリング

### セクション 18: グローバルコンテンツガバナンス

- **地域別コンテンツ審査ワークフロー**:
  - 各ターゲット市場の文化的・法的要件に基づくコンテンツ審査プロセスを確立
  - 法務・コンプライアンスチームが地域別にコンテンツを承認
- **コンテンツローカライズ優先度**:
  1. 法的文書（利用規約・プライバシーポリシー）— 各国語必須
  2. 重要UI・オンボーディング — Tier 1言語必須
  3. マーケティング・ブログ — Tier 1言語推奨
  4. ヘルプセンター — 段階的展開
- **翻訳禁止コンテンツ**: ブランド名・製品名・商標は翻訳せず原文を保持

### セクション 19: 翻訳ROI・コスト最適化

- **翻訳コスト指標**:
  - ワードあたりコスト（$/word）× 年間翻訳量
  - AI翻訳+MTPE vs フルヒューマン翻訳のコスト比較
  - TM活用率（高いほどコスト削減）
- **コスト最適化戦略**:
  - TM再利用率の最大化（目標: 70%以上）
  - AI翻訳のLight PE活用でUIラベル翻訳コスト50%削減
  - ソースコンテンツの品質向上（曖昧な原文を減らし翻訳効率向上）

---

## Part IV: RTL・BiDi対応

### セクション 20: CSS論理プロパティ義務化

- **物理プロパティ禁止**: `left`/`right`/`margin-left`/`padding-right`等の物理方向プロパティの使用を禁止
- **論理プロパティ使用義務**:
  - `margin-inline-start` / `margin-inline-end`
  - `padding-block-start` / `padding-block-end`
  - `inset-inline-start` / `inset-inline-end`
  - `border-inline-start` / `border-inline-end`
  - `text-align: start` / `text-align: end`
- **Lint強制**: ESLint/Stylelintで物理プロパティの使用を自動検出・エラー

```css
/* ❌ 禁止: 物理プロパティ */
.sidebar { margin-left: 16px; padding-right: 24px; text-align: left; }

/* ✅ 正しい: 論理プロパティ */
.sidebar { margin-inline-start: 16px; padding-inline-end: 24px; text-align: start; }
```

### セクション 21: BiDi（双方向テキスト）制御

- **`dir` 属性設定**: HTML要素に `dir="ltr"` または `dir="rtl"` を明示的に設定
- **`lang` 属性設定**: `<html lang="ar" dir="rtl">` のようにロケールと方向を同時指定
- **Unicode BiDi制御文字**: 混在テキスト（LTR内のRTLテキスト等）にはUnicode BiDi制御文字（LRM/RLM/LRE/RLE等）を適切に使用
- **`bdi` 要素**: ユーザー生成コンテンツ等、方向が不明なテキストには `<bdi>` 要素で分離
- **数値の方向**: RTL環境でも数値は左から右に表示（アラビア数字・インド数字共通）
- **CSS `direction` プロパティ禁止**: `direction: rtl` をCSSで設定せず、HTML `dir` 属性で制御（アクセシビリティ上の理由）

### セクション 22: RTLテスト自動化

- **RTLスナップショットテスト**: 主要画面のLTR/RTL両方のスクリーンショットを自動取得し比較
- **Storybook RTLデコレータ**: コンポーネントライブラリにRTLデコレータを標準装備
- **CIチェック項目**:
  - 物理プロパティのLintチェック
  - RTLレイアウトの視覚的回帰テスト
  - BiDiテキスト表示の正確性検証
  - フォーム入力のRTL挙動テスト

### セクション 23: アイコン・メディア反転ルール

- **反転すべきアイコン**: 方向性を持つアイコン（矢印・進む/戻る・スライダー・プログレスバー・リスト/ツリーのインデント）
- **反転してはいけないアイコン**: 実世界のオブジェクト（時計・チェックマーク・音楽の再生ボタン）・ブランドロゴ・数学記号
- **CSS実装**: `[dir="rtl"] .icon-arrow { transform: scaleX(-1); }`
- **画像・動画**: テキストを含む画像はRTL版を別途用意

### セクション 24: RTL対応コンポーネント設計パターン

- **Flexbox/Grid RTL自動対応**: `flex-direction: row` は `dir="rtl"` で自動反転。論理プロパティと組み合わせ
- **絶対位置配置**: `inset-inline-start`/`inset-inline-end` を使用（`left`/`right` 禁止）
- **スクロール方向**: 水平スクロールのRTL対応（`direction: rtl` on scroll container — この場合のみCSS directionを許可）
- **アニメーション方向**: スライドイン/アウトの方向をRTL環境で反転

---

## Part V: CJK・多文字体系対応

### セクション 25: CJKフォント戦略

- **フォントサブセッティング**: CJKフォントは文字セットが巨大（数万字）のため、使用文字のサブセット化が必須
  - `unicode-range` によるサブセット分割ロード
  - Google Fonts `text=` パラメータでの動的サブセット
- **可変フォント（Variable Fonts）推奨**: ウェイト・幅をCSSで柔軟に調整可能な可変フォントを優先
- **フォールバック定義**: CJK→システムフォント→汎用ファミリーの順でフォールバック
- **size-adjust**: フォールバック時のレイアウトシフトを `size-adjust` / `ascent-override` / `descent-override` で抑制

```css
/* CJKフォントスタック例 */
font-family: 'Noto Sans JP', 'Hiragino Sans', 'Yu Gothic UI',
             'Meiryo', sans-serif;
```

### セクション 26: 文字エンコーディング・Unicode 16.0

- **UTF-8統一**: プロジェクト全体でUTF-8を唯一のエンコーディングとして使用
- **BOM（Byte Order Mark）禁止**: UTF-8 BOMは使用しない
- **Unicode 16.0対応**: Unicode 16.0（2024年9月リリース）/Emoji 16.1の新文字をサポート
  - 新規スクリプト・絵文字の表示テスト
  - 正規化形式（NFC）の一貫使用
- **DB照合順序**: データベースの照合順序は `utf8mb4`（MySQL）または `C.UTF-8`/`ICU` を使用し、絵文字・サロゲートペアを完全サポート
- **HTTPヘッダー**: `Content-Type: text/html; charset=utf-8` を必ず明示

### セクション 27: 入力メソッド（IME）対応

- **`compositionstart` / `compositionend`イベント**: IME入力中の未確定文字列に対して検索・バリデーションを実行しない
- **テキストフィールド設計**: IME候補ウィンドウとの重なりを考慮したレイアウト
- **`inputmode` 属性**: モバイルでの適切なキーボード表示（`numeric`, `email`, `tel`等）
- **仮想キーボード対応**: `virtualKeyboardPolicy` APIの活用（対応ブラウザ）
- → IME詳細は `200_design_ux.md` のIMEセクションも参照

### セクション 28: 縦書き・ルビ・特殊表記

- **縦書き対応**: 日本語コンテンツで必要な場合、CSS `writing-mode: vertical-rl` を使用
- **ルビ（振り仮名）**: `<ruby>` / `<rt>` 要素を使用。ルビ非対応ブラウザ向けに `<rp>` フォールバック
- **圏点（傍点）**: 強調に `text-emphasis` プロパティを使用（下線ではなく）
- **全角/半角正規化**: ユーザー入力の全角英数・半角カナを適切に正規化
- **CJK行折り返し**: `word-break: auto-phrase`（Chrome 130+）で自然な日本語行折り返し。フォールバックに `overflow-wrap: anywhere`

### セクション 29: 多文字体系・スクリプトサポート

- **Indic Scripts**: デーヴァナーガリー（ヒンディー語）・タミル文字・ベンガル文字等の複雑なリガチャ・結合文字への対応
- **Arabic Shaping**: アラビア文字の文脈依存形態（isolated/initial/medial/final）の正確なレンダリング
- **Thai/Khmer**: 単語区切りのない言語向けのテキスト処理（`Intl.Segmenter` の活用）
- **絵文字**: スキントーン修飾子・ZWJ Sequence対応。レンダリング差異のテスト

```javascript
// ✅ Intl.Segmenter による単語分割（タイ語等）
const segmenter = new Intl.Segmenter('th', { granularity: 'word' });
const segments = segmenter.segment('สวัสดีครับ');
```

---

## Part VI: タイムゾーン・暦・ロケール管理

### セクション 30: UTC保存・ローカル変換原則

- **UTC保存義務**: データベース・バックエンドでの時刻保存は**例外なくUTC**。JST・PST等の特定タイムゾーンでの保存は禁止
- **ローカル変換のタイミング**: ユーザーへの表示直前（UI層）でのみ、ユーザーのタイムゾーンに変換
- **`timestamptz` 使用義務**: PostgreSQLでは `timestamp without time zone` ではなく `timestamptz`（`timestamp with time zone`）を使用

```sql
-- ❌ 禁止
CREATE TABLE events (start_at TIMESTAMP);

-- ✅ 正しい
CREATE TABLE events (start_at TIMESTAMPTZ DEFAULT NOW());
```

### セクション 31: IANA Time Zone DB・DST対応

- **IANA TZ DB使用**: タイムゾーン識別子はIANA Time Zone Database準拠（例: `Asia/Tokyo`, `America/New_York`）
- **UTC±Nオフセットの禁止**: 固定オフセット（`UTC+9`）での保存・処理は禁止。DSTを正しく処理できない
- **DST（夏時間）対応**: DST切替時の処理を必ずテスト
  - 存在しない時刻（Spring Forward: 例 2:00→3:00の間の2:30）
  - 重複する時刻（Fall Back: 例 1:00→2:00が2回発生）
- **TZ DB更新追従**: IANA TZ DB更新（年2〜4回）に自動追従するメンテナンスプロセスを確立
  - Node.js: `full-icu` または ICU4X経由
  - OS: tzdata パッケージの自動更新

### セクション 32: 物理ロケーション例外規則

- **コンテキスト**: UTC原則はデジタルサービスに有効だが、**物理店舗（レストラン・病院等）の営業時間**はユーザーの所在地ではなく店舗の所在地で判定すべき
- **ルール**: 物理的な場所に紐づくデータ（営業時間・予約枠等）の表示・検索は、ユーザーのブラウザロケールに依存せず、**その場所のタイムゾーン**を強制
- **実装**: 「現在営業中」検索等、物理店舗に関わるクエリではサーバーサイドで店舗所在地のタイムゾーンを使用して判定

### セクション 33: 暦体系対応

- **サポート対象暦体系**:
  - グレゴリオ暦（標準）
  - 和暦（日本: `ja-JP-u-ca-japanese`）
  - 仏暦（タイ: `th-TH-u-ca-buddhist`）
  - ヒジュラ暦（中東: `ar-SA-u-ca-islamic-civil`）
  - 民国暦（台湾: `zh-TW-u-ca-roc`）
- **Intl API活用**: `Intl.DateTimeFormat` の `calendar` オプションで暦体系を指定
- **週の開始日**: CLDR `firstDay` データに基づき処理（日本: 日曜、フランス: 月曜、中東: 土曜）
- **年度の概念**: 会計年度・学年度は国により異なる（日本: 4月開始、米国: 9月/10月開始）

### セクション 34: ロケール検出・設定管理

- **ロケール優先度チェーン**:
  1. ユーザーの明示的設定（プロフィール / Cookie）
  2. `Accept-Language` ヘッダー
  3. Geo-IP推定
  4. デフォルト言語（`en`）
- **ロケール設定の永続化**: ユーザーのロケール選択をサーバーサイドに保存（Cookie + DB）
- **ロケールスイッチャーUI**: 全ページからアクセス可能なロケール切替UIを提供。言語名はネイティブ表記（日本語、English、العربية）
- **BCP 47準拠**: ロケールタグはBCP 47形式（`ja-JP`、`en-US`、`ar-SA`）を使用

---

## Part VII: 文化的適応・カルチャライゼーション

### セクション 35: 色・アイコン・ジェスチャーの文化的配慮

- **色の文化的意味差異**:
  - 赤: 中国（幸運・繁栄） vs 西洋（危険・警告）
  - 白: 日本（純潔・清浄、ただし喪の色でもある） vs 西洋（純潔・結婚）
  - 緑: イスラム圏（神聖） vs 西洋（自然・エコ）
  - 紫: タイ（喪服の色） vs 西洋（高貴・贅沢）
- **対策**: グローバルUIでは色に依存した意味伝達を避け、アイコン・テキストを併用
- **ジェスチャー**: サムズアップ（👍）は一部文化で不適切。OKサイン（👌）はブラジルで侮辱的。ジェスチャーアイコンの使用は地域別に検証
- **画像・写真**: モデルの多様性（人種・性別・年齢）を確保。特定文化に偏った画像を避ける

### セクション 36: レイアウト伸縮対応

- **テキスト長変動の目安**:

| 言語ペア | テキスト長変動 | 設計上の考慮 |
|---|---|---|
| 英語→ドイツ語 | +30〜40%増 | ボタン・ナビ幅の柔軟性 |
| 英語→フィンランド語 | +30〜40%増 | ラベル折り返し対応 |
| 英語→日本語 | 文字数減・文字幅増 | line-height調整 |
| 英語→アラビア語 | +25%増 | RTL対応+伸縮 |
| 英語→中国語（簡体字） | -30〜50%減 | 最小幅の確保 |

- **設計原則**:
  - ボタン・ラベルは可変長に対応（固定幅禁止）
  - テキスト切り詰め（ellipsis）は最終手段
  - Flexbox/Gridによる柔軟なレイアウト設計
  - `min-width`/`max-width` による安全なバウンダリ設定
- **テスト**: 擬似ローカライズで30〜40%増のテキスト長を検証

### セクション 37: 名前・住所・電話番号フォーマット

- **名前の多様性**:
  - 性→名の順序（日本・中国・韓国・ハンガリー）
  - ミドルネーム・父称（ロシア・アイスランド）
  - 単名（インドネシア等）
  - **設計**: 「名」「姓」を分離せず、可能なら `full_name` フィールドで対応。分離が必要な場合はロケール別の順序表示ロジック
- **住所フォーマット**: Google libaddressinput / CLDR territoryData に基づくロケール別フォーマット
  - 郵便番号の位置・フォーマット（日本: 〒xxx-xxxx、英国: ポストコード、インド: PINコード）
- **電話番号**: libphonenumber（Google）でバリデーション・フォーマット。国際プレフィックス（`+81`等）対応必須

### セクション 38: 法的・規制的ローカライズ

- **利用規約・プライバシーポリシー**: 対象国の言語での提供を義務化（GDPR第12条・消費者契約法等）
- **同意メカニズム**: 国・地域によるオプトイン/オプトアウトの差異を反映
  - EU: 明示的オプトイン必須（GDPR）。TCF 2.2 / CMP統合
  - 米国: オプトアウト方式。GPP（Global Privacy Platform）対応
  - 日本: APPI 2024改正対応。第三者提供同意
- **年齢制限**: 国によるデジタルサービス利用最低年齢の差異（13歳/16歳等）を管理
- → 法的詳細は `601_data_governance.md` を参照

### セクション 39: 宗教・祝日・カレンダーイベント

- **宗教的配慮**: ラマダン期間中の食品広告抑制、宗教的祝日のマーケティグ自粛等の自動スケジューリング
- **祝日カレンダー**: 国別の祝日データベースを維持し、マーケティング・通知スケジュールに反映
- **季節性**: 南半球と北半球の季節逆転を考慮（夏セール等のタイミング）
- **暦注・干支**: 日本の六曜（大安・仏滅）・中国の旧正月等、文化固有のカレンダーイベント対応

---

## Part VIII: マルチリージョンインフラ・パフォーマンス

### セクション 40: CDN・エッジ配信戦略

- **マルチCDN戦略**: 単一CDN依存を避け、リージョン別に最適なCDNプロバイダを選定
  - アジア: Cloudflare / Akamai / Fastly
  - 中国: Alibaba Cloud CDN / Tencent Cloud CDN（ICP必須）
- **エッジコンピューティング活用**: ロケール判定・リダイレクト・動的コンテンツ生成をエッジで処理
- **静的アセットのロケール別配信**: 言語別画像・フォントファイルをエッジキャッシュ
- **Vary ヘッダー**: `Vary: Accept-Language` で言語別キャッシュを適切に管理
- **エッジi18n処理**: Next.js Middleware / Cloudflare Workers でのロケール検出・ルーティングをエッジで完結

### セクション 41: マルチリージョンデプロイメント

- **リージョン非依存設計**: アプリケーションはハードコードされたリージョンロジックを持たず、環境変数でリージョン構成を注入
- **データレプリケーション**: 読み取り負荷は最寄りリージョンのリードレプリカから提供。書き込みはプライマリリージョンへルーティング
- **フェイルオーバー**: リージョン障害時の自動フェイルオーバー設計（RTO/RPO定義）
- **Observability**: リージョン横断のモニタリング・アラート設定
- **リージョン別デプロイ戦略**: カナリアリリースをリージョン単位で段階的に展開

### セクション 42: データレジデンシー・主権要件（技術実装）

- **規制マッピング**: 対象国のデータローカライゼーション法を継続的にトラッキング
- **Sovereign Cloud**: 厳格なデータ主権要件にはAWS European Sovereign Cloud / Azure Sovereign Cloud / GCP Sovereign Cloudの活用を検討
- **データフロー図**: データが国境を越える全パスを文書化し、法的根拠を明記
- **技術的制御**:
  - 暗号鍵の地域別管理（KMS per region）
  - データ分類に基づく自動ルーティング（PII → 域内サーバー）
  - ログ・テレメトリデータも主権要件の対象
- → データプライバシー詳細は `601_data_governance.md` を参照

### セクション 43: フォント・画像のパフォーマンス最適化

- **フォント読み込み戦略**:
  - `font-display: swap`（テキスト即表示・フォント遅延ロード）
  - Critical CSSに必要最小限のフォントを `preload`
  - CJKフォントは `unicode-range` でサブセット分割
- **画像の地域別最適化**: 地域別のバナー・マーケティング画像はCDNで最寄り配信
- **低帯域対応**: Tier 2/3地域向けに画像圧縮・遅延読み込みを強化
- **AVIF/WebP対応**: モダンフォーマット対応でCJK環境を含むグローバル配信を最適化

### セクション 44: グローバルパフォーマンスバジェット

- **リージョン別CWV目標**:

| メトリクス | Tier 1目標 | Tier 2目標 | Tier 3目標 |
|---|---|---|---|
| LCP | < 2.5s | < 3.0s | < 4.0s |
| FID/INP | < 100ms | < 200ms | < 300ms |
| CLS | < 0.1 | < 0.15 | < 0.2 |

- **フォントロード影響測定**: CJKフォントロードによるLCP影響を定量計測。サブセット分割で1MB以下に抑制
- **低帯域シミュレーション**: Tier 2/3地域を想定した3G/4Gスロットリングテストの実施

### セクション 45: ネットワークレジリエンス・オフライン対応

- **Service Workerによるオフラインi18n**: 翻訳リソースのプリキャッシュ。オフライン時もローカライズされたUIを提供
- **低帯域最適化**: 翻訳ファイルの圧縮（Brotli）・差分更新
- **CDNフォールバック**: プライマリCDN障害時のフォールバックCDN自動切替

---

## Part IX: 決済・税制・コンプライアンス

### セクション 46: 多通貨決済・為替管理

- **ゼロデシマル通貨対応**: JPY・KRW等の小数点なし通貨の処理。Stripeの最小単位に準拠
- **為替レート管理**: リアルタイム為替レート取得。表示レートと決済レートの透明性確保
- **マルチカレンシーバランス**: Stripe Multi-Currency Balances活用。各通貨での残高保持・即時変換・ローカル銀行送金
- **決済手段の地域差**: 国別の主要決済手段への対応

| 地域 | 主要決済手段 | 対応優先度 |
|---|---|---|
| 日本 | クレジットカード・コンビニ決済・PayPay | 必須 |
| 中国 | WeChat Pay・Alipay | 必須 |
| EU | SEPA・iDEAL（NL）・Bancontact（BE）・Klarna | 必須 |
| インド | UPI・RuPay | 必須 |
| 東南アジア | GrabPay・DANA・GCash | 推奨 |
| ブラジル | Pix・Boleto | 推奨 |

- → 決済詳細は `101_revenue_monetization.md` を参照

### セクション 47: 国際税制（VAT/GST/消費税）

- **税率管理**: 国・地域別の税率をデータベースまたはStripe Taxで動的管理
- **VAT/GST表示義務**: 法律により税込/税抜表示の要件が異なる
  - EU: 消費者向け（B2C）は税込表示義務
  - 米国: 税抜表示が一般的（州ごとの売上税）
  - 日本: 総額表示義務
- **デジタルサービス税（DST）**: 各国のDST対応を体系化

| 国/地域 | DST税率 | 閾値 | 施行状況 |
|---|---|---|---|
| 英国 | 2% | グローバル売上£500M+ | 施行中 |
| フランス | 3% | グローバル売上€750M+ | 施行中 |
| イタリア | 3% | グローバル売上€750M+（2025年閾値撤廃） | 施行中 |
| フィリピン | 12% VAT | 外国デジタルサービス（2025年6月〜） | 新規 |
| スリランカ | 18% VAT | 外国デジタルサービス（2025年〜） | 新規 |

- **インボイス対応**: 適格請求書等保存方式（日本）・EU e-Invoice規制対応

### セクション 48: EU OSS/IOSS・越境EC税制

- **OSS（One Stop Shop）**: EU域内のB2C越境販売のVAT一元申告
  - €10,000超でOSS登録義務発生
  - 顧客所在国のVAT税率を適用
  - 四半期ごとの一括申告
- **IOSS（Import One Stop Shop）**: €150以下の越境EC物品のVAT一元申告
  - 販売時に顧客国VAT税率を徴収
  - 月次申告
  - 非EU事業者はEU域内仲介者の指名が必要
- **Stripe Tax統合**: 100カ国以上の税計算・徴収・申告を自動化。OSS/IOSS対応

```javascript
// Stripe Tax 統合例
const session = await stripe.checkout.sessions.create({
  automatic_tax: { enabled: true },
  line_items: [{ price: 'price_xxx', quantity: 1 }],
  mode: 'payment',
});
```

### セクション 49: グローバル規制コンプライアンス

- **EAA（European Accessibility Act）**: 2025年6月施行。EU市場向けデジタルプロダクトのアクセシビリティ義務化
  - EN 301 549準拠（WCAG 2.1 AA基準を包含。WCAG 2.2推奨）
  - 2030年6月: 既存製品・サービスも適合義務
  - 違反時: 罰金・市場アクセス喪失・レピュテーションリスク
- **DMA（Digital Markets Act）**: ゲートキーパー対象プラットフォームのデータポータビリティ・公正競争義務
- **EU Data Act**: 2025年9月完全施行。IoTデータアクセス権・クラウド切替促進

### セクション 50: 規制チェックリスト

| 規制 | 適用地域 | 主要要件 | 対応優先度 |
|---|---|---|---|
| GDPR | EU/EEA | データ保護・越境移転制限 | 必須 |
| CCPA/CPRA | カリフォルニア | 消費者プライバシー | 必須 |
| APPI | 日本 | 個人情報保護法 | 必須 |
| PIPL | 中国 | 個人情報保護法 | 必須 |
| LGPD | ブラジル | データ保護法 | Tier依存 |
| PIPA | 韓国 | 個人情報保護法 | Tier依存 |
| DPDPA | インド | デジタル個人データ保護法 | Tier依存 |
| EAA | EU | アクセシビリティ義務化 | 必須 |
| EU AI Act | EU | AIリスク分類・透明性 | 条件付き |

- **Cookie同意**: 地域別Cookie同意要件の実装（EU: TCF 2.2事前同意、米国: GPP通知ベース）
- → セキュリティ・法務詳細は `600_security_privacy.md` / `601_data_governance.md` を参照

### セクション 51: 多言語E-Invoicing

- **日本**: 適格請求書等保存方式（インボイス制度）。登録番号・税率区分の正確な記載
- **EU**: EN 16931準拠のe-Invoice。Peppol BIS 3.0でのB2G電子送付義務拡大
- **技術実装**: インボイスデータはJSON/XML形式で多言語メタデータを保持。通貨・税率・日付は各国フォーマットに準拠

### セクション 52: PCI DSS・決済セキュリティの国際対応

- **PCI DSS 4.0**: グローバル共通のカード情報セキュリティ基準（2025年3月完全施行）
- **Strong Customer Authentication（SCA）**: EU PSD2準拠の強力な顧客認証。3Dセキュア2.0必須
- **地域別決済セキュリティ要件**: インド（追加認証）・ブラジル（CPF検証）等の固有要件対応

---

## Part X: SEO/GEO・コンテンツ国際化

### セクション 53: 国際SEO

- **hreflang実装義務**: 多言語ページには `<link rel="alternate" hreflang="xx">` を必ず実装
  - `x-default` フォールバックを含める
  - 自己参照hreflangを含める
  - 全言語バリアント間で双方向リンクを設定
- **URL構造戦略**:
  - サブディレクトリ推奨: `example.com/ja/`, `example.com/en/`
  - ccTLD: `example.jp`, `example.de`（ブランド投資が大きい場合）
  - サブドメイン: `ja.example.com`（非推奨—SEOシグナル分散）
- **sitemap.xml**: 言語別URLを含むsitemap生成。hreflang注釈含む
- **canonical設定**: 言語ごとにcanonical URLを正しく設定
- **hreflang監査自動化**: CIでhreflangの双方向性・`x-default`存在・自己参照を自動検証

```html
<link rel="alternate" hreflang="ja" href="https://example.com/ja/page" />
<link rel="alternate" hreflang="en" href="https://example.com/en/page" />
<link rel="alternate" hreflang="x-default" href="https://example.com/en/page" />
```

### セクション 54: GEO（AI検索最適化）多言語対応

- **多言語構造化データ**: JSON-LD形式の構造化データを言語別に提供
- **LLMs.txt多言語対応**: AI検索エンジン向けの `llms.txt` を言語別に用意
- **言語別メタデータ**: title / description / OGP を言語ごとに最適化
- **Answer Engine Optimization**: AI検索（Perplexity/ChatGPT Search/Google AI Overviews）向けのFAQ構造化
- → GEO詳細は `102_growth_marketing.md` を参照

### セクション 55: 多言語コンテンツ戦略

- **Headless CMS連携**: コンテンツモデルに言語フィールドを組み込み、言語別バリアントを管理
- **翻訳ワークフロー統合**: CMSからTMSへのコンテンツ自動送信・翻訳済みコンテンツの自動取り込み
- **フォールバック戦略**: 翻訳未完了コンテンツのフォールバック言語定義（例: fr-CA → fr → en）
- **コンテンツ鮮度同期**: 原文更新時に翻訳版の陳腐化を自動検出・再翻訳トリガー
- → CMS詳細は `341_headless_cms.md` を参照

### セクション 56: 多言語SEO技術負債管理

- **hreflang監査**: 定期的にhreflang実装の正確性を自動監査
  - 孤立言語ページ（他言語からリンクされていない）の検出
  - 404/リダイレクトを指すhreflangの検出
- **重複コンテンツ検出**: 言語間の重複コンテンツ（翻訳されていないページ）の自動検出
- **インデックスカバレッジ**: Google Search Console / Bing Webmaster Toolsで言語別インデックス状況をモニタリング

### セクション 57: 国際コンテンツモデレーション

- **地域別コンテンツポリシー**: 各国の法規制に基づくコンテンツモデレーションルール
  - EU: DSA（Digital Services Act）準拠の違法コンテンツ対応義務
  - ドイツ: NetzDG（ネットワーク執行法）
  - 日本: プロバイダ責任制限法
- **多言語モデレーション**: UGCのモデレーションを対象言語で実施。AI+人間のハイブリッド体制

---

## Part XI: AI/LLM多言語対応

### セクション 58: LLMプロンプト国際化

- **プロンプトテンプレートの多言語化**: システムプロンプト・ユーザー向け応答テンプレートを言語別に管理
- **言語検出と応答言語制御**: ユーザー入力の言語を検出し、同一言語で応答するガードレール
- **トークン効率**: CJK言語はトークン消費量が大きいため、プロンプト設計時にトークンバジェットを考慮
  - 日本語: 英語比で約1.5〜2倍のトークン消費
  - 対策: プロンプト圧縮・Few-shot例の最適化
- **言語指定ガードレール**: システムプロンプトで応答言語を明示的に指定。コンテキストドキュメントの言語に引きずられないよう制御

```
// 多言語プロンプト制御例
System: You MUST respond in the same language as the user's query.
If the user writes in Japanese, respond in Japanese.
Never switch languages mid-response.
```

### セクション 59: RAG多言語ナレッジベース

- **多言語ベクトルインデックス**: 言語別またはクロスリンガルな埋め込みモデルでナレッジベースを構築
- **Embeddingモデル選定**:

| モデル | 多言語対応 | 特徴 | 推奨用途 |
|---|---|---|---|
| multilingual-e5-large-instruct | 100+言語 | MMTEB上位・指示チューニング | クロスリンガル検索 |
| Cohere embed-v4 | 100+言語 | 商用・高精度 | エンタープライズRAG |
| BGE-M3 | 100+言語 | Multi-Granularity | ハイブリッド検索 |

- **クロスリンガル検索**: ユーザーの質問言語と異なる言語のドキュメントも検索可能な設計
- **言語別チャンク管理**: 文書の分割粒度を言語特性に応じて調整（CJKは文字ベース、欧米言語はワードベース）
- **Language-aware Reranking**: 検索結果のリランキングで言語適合性を考慮。クエリ言語と異なるドキュメントにペナルティ
- → AI実装詳細は `400_ai_engineering.md` を参照

### セクション 60: AI生成コンテンツの多言語品質保証

- **ハルシネーション検出**: AI生成テキストの事実性検証を言語別に実施
- **文化的適切性フィルター**: AI出力が対象文化に不適切でないかのガードレール
- **品質メトリクス**: 言語別のBLEU/COMET/BERTScoreによる品質ベンチマーク
- **出力言語バリデーション**: AI応答が指定言語で返されていることを自動検証

### セクション 61: LLMの多言語安全性・バイアス

- **多言語ジェイルブレイク対策**: 英語以外の言語でのプロンプトインジェクション・ジェイルブレイク試行への対策
- **言語間バイアス検出**: LLM出力の言語間品質差異をモニタリング。低リソース言語での品質劣化を検知
- **多言語有害コンテンツフィルタ**: 各言語固有の有害表現・ヘイトスピーチ検出
- → セキュリティ詳細は `600_security_privacy.md` を参照

### セクション 62: AI翻訳ワークフロー統合

- **リアルタイムAI翻訳パイプライン**:
  1. ソーステキスト受信
  2. PII除去・匿名化
  3. AI翻訳実行（DeepL/Google/LLM）
  4. 品質スコア自動評価
  5. 閾値未満はヒューマンレビューキューへ
  6. 承認後にTM登録・デプロイ
- **翻訳キャッシュ**: 同一テキストの重複翻訳APIコールを防止

### セクション 63: 多言語Embedding・セマンティック検索

- **Intl.Segmenter活用**: テキスト分割・トークナイズをロケール対応で実行
- **言語検出の精度**: 短文（< 20文字）の言語検出精度が低いため、ユーザープロファイルの言語設定をフォールバック
- **多言語同義語辞書**: 検索精度向上のため、言語別の同義語マッピングを維持

---

## Part XII: モバイル・クロスプラットフォームi18n

### セクション 64: iOS/Android固有のi18n対応

- **iOS**:
  - `String Catalog`（Xcode 15+/16）で翻訳管理。コンパイラ統合の自動キー抽出
  - `Bundle.main.localizedString` でのリソースアクセス
  - Info.plist の `CFBundleLocalizations` で対応言語を宣言
  - String Catalogのプラットフォームごとの翻訳バリアント対応（iOS/macOS/watchOS）
- **Android**:
  - `res/values-{locale}/strings.xml` で言語リソース管理
  - `android:autoSizeTextType` でテキストサイズ自動調整
  - `BCP 47` ロケールタグ対応（API 24+）
  - Per-app language preferences API（API 33+）
- **共通原則**: プラットフォームネイティブのi18n機構を優先し、カスタム実装を避ける

### セクション 65: Flutter/React Native多言語アーキテクチャ

- **Flutter**: `flutter_localizations` パッケージ + `intl` パッケージ + ARBファイル
- **React Native**: `react-native-localize` + `i18next`/`react-intl` + JSON翻訳ファイル
- **Kotlin Multiplatform**: `moko-resources`でのクロスプラットフォーム翻訳リソース共有
- **OTA更新**: CodePush等によるアプリ更新なしでの翻訳反映戦略
- **RTLレイアウト**: React NativeのI18nManager.forceRTL() / FlutterのDirectionalityウィジェット

### セクション 66: モバイル固有のi18n課題

- **アプリストアメタデータ**: App Store Connect / Google Play Consoleで言語別タイトル・説明文・スクリーンショットを管理
- **プッシュ通知の多言語化**: FCM/APNsでユーザーの言語設定に基づく通知テンプレート切替
- **アプリ内メッセージング**: 言語別のin-app messageテンプレート管理
- **App Clips / Instant Apps**: 限定的なi18nリソースのバンドル最適化

---

## Part XIII: テスト・品質保証

### セクション 67: i18nテスト自動化

- **擬似ローカライズテスト**: CI/CDで擬似ロケールを使用した自動レンダリングテスト
- **Missing Keyテスト**: ソースコード内の全翻訳キーが全対象言語の翻訳ファイルに存在することを検証
- **変数整合性テスト**: 翻訳テキスト内のプレースホルダー（`{name}`等）がソース言語と一致することを検証
- **ICUメッセージ構文バリデーション**: MessageFormat構文の正当性をCIで検証
- **翻訳完了率チェック**: 言語別の翻訳カバレッジをCIで検証

```bash
# CI/CDでのi18nテスト例
npx i18n-check --source src/ --locales locales/ --fail-on-missing
npx messageformat-validator locales/**/*.json
```

### セクション 68: VRT（多言語ビジュアルリグレッション）

- **多言語VRT**: 主要画面の全対象言語でのスクリーンショット比較テスト
- **RTL VRT**: LTR/RTL間のレイアウト比較テスト
- **テキスト長テスト**: 最長テキスト言語（ドイツ語等）でのレイアウト崩れ検出
- **ツール**: Chromatic / Percy / Playwright + screenshot comparison
- → VRT詳細は `700_qa_testing.md` を参照

### セクション 69: アクセシビリティテスト（多言語対応）

- **言語別スクリーンリーダーテスト**: 主要言語でのスクリーンリーダー挙動を検証
- **`lang` 属性検証**: ページ全体及びインライン言語切替の `lang` 属性設定を自動チェック
- **WCAG 2.2多言語対応**: 全言語でWCAG 2.2 AA基準を満たすことを検証
  - WCAG 2.2新基準: Focus Appearance / Dragging Movements / Target Size / Consistent Help / Redundant Entry / Accessible Authentication
- **EAA対応**: EU市場向けプロダクトはEN 301 549準拠のアクセシビリティテストを実施
- → アクセシビリティ詳細は `200_design_ux.md` を参照

### セクション 70: i18n固有E2Eテスト

- **ロケール切替テスト**: 言語切替時にUI全体が正しく再レンダリングされることをPlaywrightで検証
- **フォーム入力テスト**: IME入力・RTLテキスト入力・全角/半角混在テキストの入力テスト
- **日付・通貨表示テスト**: ロケール別のフォーマット正確性をE2Eで検証
- **タイムゾーンテスト**: DST切替前後のイベント時刻表示テスト

### セクション 71: LLMs.txt・AI検索の多言語テスト

- **多言語LLMs.txt検証**: 各言語のLLMs.txtが正しいコンテンツを返すことを検証
- **構造化データ検証**: JSON-LDの多言語バリアントの妥当性をCIでチェック
- **AI検索結果品質テスト**: 主要AI検索エンジンでの多言語クエリ結果をサンプリング検証

---

## Part XIV: セキュリティ・プライバシー国際化

### セクション 72: 暗号規制の国際差異

- **暗号強度要件**:
  - EU: eIDAS 2.0準拠。QES（Qualified Electronic Signature）対応
  - 中国: 国産暗号アルゴリズム（SM2/SM3/SM4）の使用要件
  - ロシア: GOST暗号規格の使用要件（一部シナリオ）
- **暗号鍵管理の地域別ポリシー**: 暗号鍵を地域ごとに分離管理（EU鍵はEU域内KMSで管理等）
- **量子暗号アジリティ**: ポスト量子暗号への移行準備。NIST PQC標準（ML-KEM/ML-DSA）の追跡
- → 暗号詳細は `600_security_privacy.md` を参照

### セクション 73: 地域別Cookie同意実装

- **EU（GDPR/ePrivacy）**: TCF 2.2準拠のCMP（Consent Management Platform）実装。事前同意必須
- **米国（CCPA/各州法）**: GPP（Global Privacy Platform）対応。オプトアウトリンク設置
- **日本（APPI/電気通信事業法）**: 外部送信規律準拠。通知・公表義務
- **技術実装**: CMP SDKのロケール別初期化。同意状態に基づくサードパーティスクリプトの動的制御

### セクション 74: データ越境移転の技術的制御

- **転送中暗号化**: TLS 1.3必須。地域間通信は専用VPN/PrivateLink推奨
- **保存時暗号化**: AES-256-GCM以上。暗号鍵は対象地域のKMSで管理
- **トークン化**: PIIを地域内でトークン化し、トークンのみ越境（データ最小化原則）
- **仮名化**: GDPR第4条5項準拠の仮名化処理。追加情報（復元鍵）はEU域内に保管

---

## Part XV: オブザーバビリティ・FinOps

### セクション 75: i18nオブザーバビリティ

- **i18n固有メトリクス**:

| メトリクス | 説明 | 目標値 |
|---|---|---|
| 翻訳カバレッジ率 | 言語別の翻訳済みキー割合 | Tier 1: 100%, Tier 2: 95%+ |
| Missing Key Rate | 未翻訳キーの発生頻度 | 0件/ビルド |
| LQAスコア（MQM） | 翻訳品質スコア | 98点以上 |
| ロケールエラー率 | フォーマットエラーの発生率 | < 0.01% |
| フォントロード時間 | CJKフォントのロード完了時間 | < 1.5s |

- **アラート設定**: Missing Key Rate > 0 またはロケールエラー率 > 0.1% でアラート発報
- **ダッシュボード**: 言語別の翻訳ステータス・品質スコア・パフォーマンスメトリクスを一元表示

### セクション 76: リージョン別コスト可視化・FinOps

- **CDNコスト**: リージョン別のCDN転送量・コストを可視化
- **翻訳コスト**: AI翻訳APIコール数・コスト・ヒューマンレビューコストを月次トラッキング
- **インフラコスト**: マルチリージョンデプロイメントのリージョン別コスト分析
- **コスト最適化アクション**:
  - CJKフォントサブセット最適化でCDN転送量削減
  - TM再利用率向上で翻訳コスト削減
  - リージョン別トラフィックに基づくインフラ右サイジング

### セクション 77: AI翻訳トークンコスト管理

- **トークンバジェット**: 月次のAI翻訳トークンバジェットを言語ペアごとに設定
- **コスト監視**: LLMベース翻訳のトークン消費をリアルタイムモニタリング
- **最適化**: 翻訳キャッシュ・TM連携でAPI呼び出しを最小化
- → FinOps詳細は `101_revenue_monetization.md` を参照

---

## Part XVI: 組織・プロセス・成熟度

### セクション 78: ローカライゼーション成熟度モデル

| レベル | 名称 | 特徴 | KPI基準 |
|:---:|---|---|---|
| 1 | **Ad-Hoc** | 翻訳は都度対応。ハードコードが残存。TZ未考慮 | 翻訳カバレッジ < 50% |
| 2 | **Reactive** | キー外部化済み。主要言語のみ。手動翻訳 | カバレッジ 50-80%, Missing Key > 10件/月 |
| 3 | **Proactive** | TMS導入。CI/CD統合。擬似ローカライズ。CLDR準拠 | カバレッジ 95%+, MQM 95+, Missing Key < 5件/月 |
| 4 | **Strategic** | 全市場カルチャライズ。マルチリージョンインフラ。LQA定量運用 | カバレッジ 100%, MQM 98+, Missing Key 0件 |
| 5 | **Optimized** | AI翻訳+MTPE統合。クロスリンガルRAG。リアルタイムL10n。継続的最適化 | 上記+AI翻訳品質COMET > 0.85 |

- **目標**: 全プロジェクトはレベル3（Proactive）以上を維持
- **評価頻度**: 四半期ごとに成熟度レベルを評価
- **昇格トリガー**: 新市場参入時・Tier変更時に成熟度レベルを再評価

### セクション 79: グローバルチーム運用・コミュニケーション

- **タイムゾーン配慮**: グローバルチームの非同期コミュニケーション設計
  - 「ゴールデンアワー」（全メンバーの稼働時間重複帯）を活用した同期会議
  - ドキュメント駆動（ADR・RFC・Wiki）による非同期意思決定
- **言語ポリシー**: チーム内の公用語定義（通常英語）と自動翻訳ツールの活用
- **文化的多様性**: グローバルチームメンバーの文化的背景を尊重したコミュニケーションガイドライン
- **i18nチャンピオン**: 各開発チームにi18n推進担当者を配置。i18n教育・レビュー責任

### セクション 80: i18n教育・ナレッジベース

- **オンボーディング**: 新メンバー向けi18nベストプラクティスガイドの提供
- **コードレビュー基準**: i18n違反（ハードコード・物理プロパティ・文字列連結等）をコードレビューで必ず指摘
- **事例データベース**: i18n関連のインシデント・改善事例を蓄積し、チーム全体で共有
- **定期勉強会**: 四半期ごとにi18nトピックの勉強会を実施

---

## Appendix A: 逆引き索引

| 技術・サービス | 関連セクション |
|---|---|
| ICU MessageFormat 2.0 | 6, 7, 67 |
| CLDR | 6, 7, 8, 9, 33 |
| Intl API（JavaScript） | 8, 9, 29 |
| Temporal API | 8 |
| CSS論理プロパティ | 20 |
| BiDi / RTL | 20, 21, 22, 23, 24 |
| CJKフォント | 25, 43 |
| UTF-8 / Unicode 16.0 | 26 |
| IME | 27 |
| Intl.Segmenter | 29, 63 |
| TMS（翻訳管理システム） | 13, 14, 16 |
| AI翻訳 / MTPE | 17, 60, 62 |
| CDN / エッジ | 40, 43, 45 |
| エッジi18n / ミドルウェア | 12, 40 |
| マルチリージョン | 41, 42 |
| Sovereign Cloud | 3, 42 |
| データレジデンシー | 3, 42, 74 |
| Stripe / 決済 | 46, 48, 52 |
| VAT / GST / DST | 47 |
| OSS / IOSS | 48 |
| hreflang / 国際SEO | 53, 56 |
| LLMs.txt / GEO | 54, 71 |
| LLM / RAG 多言語 | 58, 59, 60, 61 |
| Embedding / セマンティック検索 | 59, 63 |
| iOS / Android | 64 |
| Flutter / React Native | 65 |
| Kotlin Multiplatform | 65 |
| 擬似ローカライズ | 4, 67 |
| VRT（ビジュアルリグレッション） | 68 |
| アクセシビリティ / EAA / WCAG 2.2 | 49, 69 |
| Cookie同意 / TCF 2.2 / GPP | 73 |
| 暗号規制 / PQC | 72 |
| PCI DSS / SCA | 52 |
| DMA / EU Data Act | 49 |
| DSA / コンテンツモデレーション | 57 |
| i18nオブザーバビリティ | 75 |
| FinOps / コスト管理 | 19, 76, 77 |
| E-Invoicing | 51 |

---

## クロスリファレンス

| ルールファイル | 関連内容 |
|---|---|
| [100_product_strategy.md](../ja/100_product_strategy.md) | Dynamic Pricing Metadata・ティア戦略 |
| [101_revenue_monetization.md](../ja/101_revenue_monetization.md) | 決済・通貨・FinOps |
| [102_growth_marketing.md](../ja/102_growth_marketing.md) | SEO/GEO・OGP・ASO |
| [200_design_ux.md](../ja/200_design_ux.md) | アクセシビリティ・IME・レイアウト |
| [300_engineering_standards.md](../ja/300_engineering_standards.md) | CI/CD・コーディング規約 |
| [340_web_frontend.md](../ja/340_web_frontend.md) | CSSアーキテクチャ・パフォーマンス |
| [341_headless_cms.md](../ja/341_headless_cms.md) | 多言語コンテンツ管理 |
| [320_supabase_architecture.md](../ja/320_supabase_architecture.md) | DB設計・タイムゾーン |
| [400_ai_engineering.md](../ja/400_ai_engineering.md) | AI/LLM・RAG |
| [502_site_reliability.md](../ja/502_site_reliability.md) | マルチリージョン可用性 |
| [600_security_privacy.md](../ja/600_security_privacy.md) | データ保護・暗号化・暗号規制 |
| [601_data_governance.md](../ja/601_data_governance.md) | GDPR・APPI・データ越境・EU Data Act |
| [700_qa_testing.md](../ja/700_qa_testing.md) | VRT・アクセシビリティテスト |
| [802_language_protocol.md](../ja/802_language_protocol.md) | 日英使い分け・UI用語集 |

### クロスリファレンス

| セクション | 関連ルール |
|-----------|------------|
| §1–§5（i18nアーキテクチャ） | `300_engineering_standards`, `340_web_frontend` |
| §6–§9（ロケール・フォーマット） | `200_design_ux` |
| §17（AI翻訳） | `400_ai_engineering` |
| §20–§24（BiDi / RTL） | `200_design_ux`, `342_mobile_flutter` |
| §40–§42（エッジ / マルチリージョン） | `361_aws_cloud`, `360_firebase_gcp` |
| §46–§48（決済 / 税務） | `101_revenue_monetization`, `103_appstore_compliance` |
| §53–§56（国際SEO） | `102_growth_marketing` |
| §58–§61（LLM多言語） | `400_ai_engineering` |
| §64–§65（モバイルi18n） | `342_mobile_flutter`, `343_native_platforms` |
| §74（データレジデンシー） | `601_data_governance`, `600_security_privacy` |
