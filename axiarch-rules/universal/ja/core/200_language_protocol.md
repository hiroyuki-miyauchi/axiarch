# 74. 言語プロトコル (Language Protocol)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> プロジェクト設定言語（Native Language）の絶対遵守。
> - **基本原則**: ユーザー・開発者間のコミュニケーションは、`AGENTS.md` の `Project Native Language` で定められた言語で行わなければならない。文化的文脈・ニュアンスを含めた「高度な言語運用」を要求する。
> - **適用範囲**: 思考・計画（`task.md`, `implementation_plan.md`）、報告・対話（`notify_user`）、成果物（UI・ドキュメント・エラーメッセージ）。
> - **英語の制限**: 英語の使用は、ソースコード・変数名・技術用語・コミットメッセージのSubjectのみに厳格制限。不自然な翻訳調や文脈を無視した英語の使用は**バグ**と見なす。
> **11パート・43セクション構成。**

---

## 目次

- [Part I: 基本原則・言語階層モデル](#part-i-基本原則言語階層モデル)
- [Part II: コード言語規約](#part-ii-コード言語規約)
- [Part III: ドキュメント・仕様書言語戦略](#part-iii-ドキュメント仕様書言語戦略)
- [Part IV: Git・バージョン管理言語規約](#part-iv-gitバージョン管理言語規約)
- [Part V: UI/UXローカライゼーション義務](#part-v-uiuxローカライゼーション義務)
- [Part VI: UI用語集・表記揺れ防止](#part-vi-ui用語集表記揺れ防止)
- [Part VII: バリデーション・フォーム言語プロトコル](#part-vii-バリデーションフォーム言語プロトコル)
- [Part VIII: エラーハンドリング言語階層](#part-viii-エラーハンドリング言語階層)
- [Part IX: API応答言語ポリシー](#part-ix-api応答言語ポリシー)
- [Part X: 通知・コミュニケーション言語ポリシー](#part-x-通知コミュニケーション言語ポリシー)
- [Part XI: AIエージェント通信言語プロトコル](#part-xi-aiエージェント通信言語プロトコル)
- [Part XII: ログ・監査・可観測性の言語ポリシー](#part-xii-ログ監査可観測性の言語ポリシー)
- [Part XIII: テスト言語ポリシー](#part-xiii-テスト言語ポリシー)
- [Part XIV: CMS・コンテンツ言語ガバナンス](#part-xiv-cmsコンテンツ言語ガバナンス)
- [Part XV: SEO・構造化データ言語](#part-xv-seo構造化データ言語)
- [Part XVI: アクセシビリティ言語要件](#part-xvi-アクセシビリティ言語要件)
- [Part XVII: 翻訳除外ポリシー](#part-xvii-翻訳除外ポリシー)
- [Part XVIII: CI/CD言語品質ゲート](#part-xviii-cicd言語品質ゲート)
- [Part XIX: 型安全i18n・翻訳キー設計](#part-xix-型安全i18n翻訳キー設計)
- [Part XX: AI間通信・Agent-to-Agent言語プロトコル](#part-xx-ai間通信agent-to-agent言語プロトコル)
- [Part XXI: 多言語安全性ガードレール](#part-xxi-多言語安全性ガードレール)
- [Part XXII: PDF・CSV・帳票エクスポート言語](#part-xxii-pdfcsv帳票エクスポート言語)
- [Part XXIII: 法務・契約・規約文書言語ガバナンス](#part-xxiii-法務契約規約文書言語ガバナンス)
- [Part XXIV: モバイル固有言語プロトコル](#part-xxiv-モバイル固有言語プロトコル)
- [Part XXV: 成熟度モデル・アンチパターン](#part-xxv-成熟度モデルアンチパターン)
- [Part XXVI: DB・インフラ言語ポリシー](#part-xxvi-dbインフラ言語ポリシー)
- [Part XXVII: デザインシステム・デザイントークンi18n](#part-xxvii-デザインシステムデザイントークンi18n)
- [Part XXVIII: エラーリカバリ・グレースフルデグラデーション言語](#part-xxviii-エラーリカバリグレースフルデグラデーション言語)
- [Part XXIX: パフォーマンス最適化・バンドル戦略](#part-xxix-パフォーマンス最適化バンドル戦略)
- [Part XXX: チーム教育・オンボーディング言語プロトコル](#part-xxx-チーム教育オンボーディング言語プロトコル)
- [Part XXXI: 文字エンコーディング・Unicode安全性](#part-xxxi-文字エンコーディングunicode安全性)
- [Part XXXII: ジェンダーインクルーシブ・インクルーシブ言語](#part-xxxii-ジェンダーインクルーシブインクルーシブ言語)
- [Part XXXIII: リアルタイム・WebSocket・SSE言語プロトコル](#part-xxxiii-リアルタイムwebsocketsse言語プロトコル)
- [Part XXXIV: マイクロフロントエンド・モジュールフェデレーションi18n](#part-xxxiv-マイクロフロントエンドモジュールフェデレーションi18n)
- [Part XXXV: AI翻訳品質保証・LQA](#part-xxxv-ai翻訳品質保証lqa)
- [Part XXXVI: 音声UI・TTS/SSML言語プロトコル](#part-xxxvi-音声uittsssml言語プロトコル)
- [Part XXXVII: サーバーレス・エッジコンピューティング言語ポリシー](#part-xxxvii-サーバーレスエッジコンピューティング言語ポリシー)
- [Part XXXVIII: 3D・メタバース・空間コンピューティング言語](#part-xxxviii-3dメタバース空間コンピューティング言語)
- [Part XXXIX: ヘルスケア・規制対象ドメイン固有言語](#part-xxxix-ヘルスケア規制対象ドメイン固有言語)
- [Part XL: サードパーティSDK・ウィジェット言語統制](#part-xl-サードパーティsdkウィジェット言語統制)
- [Part XLI: 翻訳コスト管理・FinOps言語](#part-xli-翻訳コスト管理finops言語)
- [Part XLII: 言語関連インシデント対応](#part-xlii-言語関連インシデント対応)
- [Part XLIII: 音声認識（STT）入力言語プロトコル](#part-xliii-音声認識stt入力言語プロトコル)
- [Part XLIV: 逆引き索引（Appendix A）](#part-xliv-逆引き索引appendix-a)

---

## Part I: 基本原則・言語階層モデル

### 1.1. プロジェクト設定言語の定義

- **Rule 74.1**: 全プロジェクトは `AGENTS.md` の `Project Native Language` で**一つの権威言語**を定義しなければならない
- **Rule 74.2**: 権威言語は全ての意思決定文書・ユーザー対面テキスト・チーム内コミュニケーションの**デフォルト言語**として機能する
- **Rule 74.3**: 権威言語の変更は「憲法改正」に準ずる手続きが必要（→ [801_governance.md](./801_governance.md) Part IV参照）

### 1.2. 言語使用の三層モデル

全テキストを以下の三層に分類し、各層で言語ポリシーを適用する：

| 層 | 対象 | 言語 | 根拠 |
|---|---|---|---|
| **L1: ユーザー層** | UI・通知・メール・エラーメッセージ・ヘルプ | **プロジェクト設定言語（必須）** | 認知負荷ゼロ原則 |
| **L2: 開発者層** | 設計書・PR・タスク・コミット要約・コードコメント | **プロジェクト設定言語（必須）**、コード自体は英語 | チーム内意思疎通の正確性 |
| **L3: システム層** | ログ・メトリクス・監査証跡・外部API | **英語（推奨）** | 国際相互運用性・ツール互換 |

```
┌─────────────────────────────────────┐
│  L1: ユーザー層                      │ → プロジェクト設定言語
│  (UI, 通知, メール, エラー)           │
├─────────────────────────────────────┤
│  L2: 開発者層                        │ → プロジェクト設定言語 + コードは英語
│  (設計書, PR, タスク, コメント)       │
├─────────────────────────────────────┤
│  L3: システム層                      │ → 英語
│  (ログ, メトリクス, 監査, 外部API)    │
└─────────────────────────────────────┘
```

### 1.3. 認知負荷ゼロ原則

- **Rule 74.4**: ユーザーが「翻訳」という認知作業を行わなければならない状況は、**実装漏れバグ**として扱う
- **Rule 74.5**: system生成の英語（`"Invalid input"`, `"Required"`, `"Unknown"`）がユーザーの目に触れることは**ゼロ・トレランス**で禁止
- **Rule 74.6**: 翻訳の質も対象。直訳調の不自然な表現（`"それは成功しました"`, `"無効な値です"`）も禁止。自然なプロフェッショナル表現（`"保存しました"`, `"正しい形式で入力してください"`）を義務付ける

### 1.4. 言語ネゴシエーション戦略

- **Rule 74.7**: ユーザーの言語を決定する際の**優先順位チェーン**を以下に定める：

```
1. DB保存のユーザー言語設定（最優先）
2. セッション/Cookie に保存された言語選択
3. HTTP `Accept-Language` ヘッダー
4. `navigator.language` / `navigator.languages`
5. GeoIPベースの推定（フォールバック）
6. プロジェクトデフォルト言語（最終フォールバック）
```

- **Rule 74.8**: 単一言語プロジェクト（`Project Native Language`が一言語のみ）の場合、ネゴシエーションは不要。プロジェクト設定言語を常時適用する
- **Rule 74.9**: 言語切替時のUI状態保持（フォーム入力値・スクロール位置・モーダル状態）を保証する
- **Rule 74.9A**: Service Worker を用いた言語インターセプター戦略を推奨する。リクエストレベルで言語を検出し、適切なロケールリソースをプリフェッチ・キャッシュする
- **Rule 74.9B**: Temporal API（TC39 Stage 3）を使用する場合、`Temporal.Now.zonedDateTimeISO()` の `calendar` と `timeZone` はユーザーロケールに基づいて設定する

### 1.5. 言語ポリシーガバナンス

- **Rule 74.10A**: 言語ポリシーの変更提案は、以下のRACIマトリクスに従う：

| 役割 | 責任 |
|---|---|
| **Responsible** | テックリード / フロントエンドリード |
| **Accountable** | プロダクトオーナー |
| **Consulted** | UXライター / ローカライゼーションエンジニア |
| **Informed** | 開発チーム全体 |

- **Rule 74.10B**: 言語ポリシーの変更はPRベースで提案し、最低2名のレビューを必須とする

---

## Part II: コード言語規約

### 2.1. ソースコード基本規約

- **Rule 74.10**: ソースコード・変数名・関数名・クラス名・インターフェース名は**英語**で記述する
- **Rule 74.11**: 英語として文法的に正しく、意味が明確な命名を使用する
  - ✅ `getUserProfile`, `calculateTotalPrice`, `isAuthenticated`
  - ❌ `getUsrPrf`, `calc`, `flg`（意味不明な短縮）
  - ❌ `shutokuUserJyouhou`（ローマ字）
  - ❌ `kensaku`, `touroku`, `sakujo`（ローマ字動詞）
  - ❌ `handleKakunin`（日英混合）

### 2.2. 型定義・インターフェース

- **Rule 74.12**: TypeScript/JSDocの型名・プロパティ名は**英語**
- **Rule 74.13**: 型のJSDoc説明文（`@description`, `@param`, `@returns`）は**英語**で記述（国際標準のコードベース可読性を優先）
- **Rule 74.14**: ビジネスドメイン固有の概念で英語に適切な訳語がない場合は、コメントでプロジェクト設定言語の補足説明を付与可

```typescript
/**
 * Represents a pet health checkup record.
 * @param petId - The unique identifier of the pet
 * @param checkupDate - Date of the health checkup (ISO 8601)
 * @param veterinarianId - ID of the attending veterinarian
 */
interface HealthCheckup {
  petId: string;
  checkupDate: string;
  veterinarianId: string;
}
```

### 2.3. コード内コメント

- **Rule 74.15**: インラインコメント（`//`, `/* */`）は**英語**で記述する
- **Rule 74.16**: 複雑なビジネスロジックの意図説明が英語では不正確になる場合に限り、プロジェクト設定言語の補足コメントを許可する
- **Rule 74.17**: TODOコメントのフォーマット：
  - `// TODO: [英語の技術的説明]`（コード内）
  - タスク管理ツール側の詳細説明はプロジェクト設定言語

### 2.4. マジックストリング・定数命名

- **Rule 74.18**: 定数名（`const`, `enum`）は**英語のSCREAMING_SNAKE_CASE**
- **Rule 74.19**: 定数値がユーザーに表示される場合は、必ず表示ラベルマッピングを経由する（Part VII参照）

```typescript
// ✅ 正しいパターン
const SUBSCRIPTION_STATUS = {
  ACTIVE: 'active',
  CANCELLED: 'cancelled',
  PAST_DUE: 'past_due',
} as const;

const STATUS_LABELS: Record<string, string> = {
  active: '有効',
  cancelled: '解約済み',
  past_due: '支払い遅延',
};

// ❌ 禁止パターン: 定数値を直接UIに表示
// <span className="uppercase">{status}</span>
```

### 2.5. 正規表現・DSLリテラル

- **Rule 74.19A**: 正規表現リテラル内のコメントやエラーメッセージは英語
- **Rule 74.19B**: Prisma Schema、GraphQL SDL等のDSL内のフィールド名・型名は**英語**、コメントは英語を基本とする

---

## Part III: ドキュメント・仕様書言語戦略

### 3.1. 設計書・仕様書（Blueprint）

- **Rule 74.20**: Blueprint（`axiarch-rules/blueprint/`配下）は**プロジェクト設定言語**で記述する
- **Rule 74.21**: 技術用語・固有名詞（React, Supabase, Next.js等）は原則英語表記を維持
- **Rule 74.22**: ADR（Architecture Decision Record）もプロジェクト設定言語で記述し、意思決定の背景・根拠を母語で正確に記録する

### 3.2. タスク管理・Issue

- **Rule 74.23**: `task.md`, `implementation_plan.md`, `walkthrough.md` は**プロジェクト設定言語**
- **Rule 74.24**: GitHub/GitLab Issue のタイトル・説明文も**プロジェクト設定言語**
- **Rule 74.25**: ラベル名は英語を許容（`bug`, `feature`, `priority:high` 等）

### 3.3. README・CHANGELOG

- **Rule 74.26**: プロジェクト内部向け README は**プロジェクト設定言語**
- **Rule 74.27**: OSSとして公開する場合のREADMEは英語、またはバイリンガル（英語+プロジェクト設定言語）
- **Rule 74.28**: CHANGELOG はプロジェクト設定言語。ただし、セマンティックバージョニングのタグ（`feat:`, `fix:`, `BREAKING CHANGE:`）は英語を維持

---

## Part IV: Git・バージョン管理言語規約

### 4.1. コミットメッセージ

- **Rule 74.30**: Conventional Commits のプレフィックスは**英語**を維持：
  - `feat:`, `fix:`, `docs:`, `style:`, `refactor:`, `test:`, `chore:`
- **Rule 74.31**: Subjectライン（1行目）は**英語**で簡潔に記述（50文字以内推奨）
- **Rule 74.32**: Bodyセクション（詳細説明）は**プロジェクト設定言語**で、変更の「意図」と「影響」を記述
- **Rule 74.33**: Breaking Change のフッターは英語プレフィックス + プロジェクト設定言語の説明

```
feat: add pet health checkup reminder notification

定期健診のリマインダー通知機能を追加。
ユーザーが設定した間隔（30/60/90日）に基づいて
プッシュ通知とメールを自動送信する。

対象テーブル: pet_health_checkups, notification_schedules
関連Issue: #1234

BREAKING CHANGE: notification_schedules テーブルのスキーマが変更。
マイグレーション `20260318_add_reminder_interval` の適用が必要。
```

### 4.2. ブランチ・タグ命名

- **Rule 74.34**: ブランチ名は**英語**（`feature/add-checkup-reminder`, `fix/login-validation`）
- **Rule 74.35**: タグ名はセマンティックバージョニング準拠（`v1.2.3`）
- **Rule 74.36**: リリースノートは**プロジェクト設定言語**で記述

### 4.3. PR/MR（プルリクエスト/マージリクエスト）

- **Rule 74.37**: PRタイトルは**プロジェクト設定言語**（チーム内レビューの効率化のため）
- **Rule 74.38**: PR説明文は**プロジェクト設定言語**で、以下を含む：
  - 変更の目的・背景
  - 実装方針の概要
  - テスト方法
  - 影響範囲
- **Rule 74.39**: PRテンプレートはプロジェクト設定言語で定義

---

## Part V: UI/UXローカライゼーション義務

### 5.1. 包括的UIローカライゼーション

- **Rule 74.40**: 公開・非公開を問わず、**全UIテキスト**をプロジェクト設定言語でローカライズしなければならない
- 対象：ボタン、ラベル、プレースホルダー、ヘルプ文言、ステータス表示、ツールチップ、モーダル、ドロップダウン選択肢、パンくずリスト、ページタイトル
- **Rule 74.41**: 視覚的に隠れたテキストも**例外なし**でローカライズ：
  - アイコンの `alt` 属性
  - `aria-label`, `aria-describedby`
  - `title` 属性
  - `<meta>` の `content`
  - `placeholder`

### 5.2. マイクロコピー品質基準（UXライティング）

- **Rule 74.42**: マイクロコピーは「おもてなし精神」を体現し、以下の基準を満たすこと：

| 基準 | ❌ 禁止例 | ✅ 正しい例 |
|---|---|---|
| 直訳調の排除 | 「このフィールドは必須です」 | 「入力してください」 |
| 過剰な敬語の排除 | 「ご入力いただけますでしょうか」 | 「入力してください」 |
| 体言止めの活用 | 「保存をします」 | 「保存」（ボタン） |
| 主語の省略 | 「あなたのプロフィール」 | 「プロフィール」 |
| ポジティブ表現 | 「入力が間違っています」 | 「正しい形式で入力してください」 |

- **Rule 74.43**: エラーメッセージは「何が起きたか」＋「どうすればよいか」の2要素を含む
  - ❌ `「エラーが発生しました」`
  - ✅ `「メールアドレスの形式が正しくありません。例: user@example.com」`

### 5.3. Voice & Tone ガイドライン

- **Rule 74.44**: プロジェクトごとに**Voice（ブランドの人格）**と**Tone（文脈に応じた語調）**を定義する：
  - **Voice**: 一貫したブランドパーソナリティ（例：「親しみやすく、専門的で、信頼できる」）
  - **Tone**: 文脈による変動（成功時→祝福的、エラー時→共感的、警告時→慎重）
- **Rule 74.45**: Tone マトリクス例：

| 状況 | Tone | 例 |
|---|---|---|
| 成功 | 祝福・肯定 | 「保存しました ✓」 |
| エラー | 共感・解決志向 | 「保存できませんでした。もう一度お試しください」 |
| 警告 | 慎重・明確 | 「この操作は取り消せません」 |
| 案内 | 親切・簡潔 | 「まずはプロフィールを設定しましょう」 |
| 待機 | 安心・進捗示唆 | 「処理しています...」 |

### 5.4. Empty State・フォールバックテキスト

- **Rule 74.46**: データ欠落時のフォールバックテキスト（`"Unknown"`, `"N/A"`, `"null"`, `"undefined"`）がユーザーに表示されることは**バグ**
- **Rule 74.47**: Empty State 表示の言語品質基準：
  - ❌ `「データがありません」`
  - ✅ `「まだ登録がありません」`（状況に応じた自然な表現）
- **Rule 74.48**: ローディング表示も対象：
  - ❌ `"Loading..."`
  - ✅ `「読み込み中...」`

### 5.5. インタラクティブ要素

- **Rule 74.49**: 確認ダイアログの選択肢は文脈に応じた動詞系ラベルを使用：
  - ❌ `「OK」/「キャンセル」`（全ダイアログ共通）
  - ✅ `「削除する」/「やめる」`（削除確認の場合）
  - ✅ `「保存する」/「破棄する」`（未保存警告の場合）
- **Rule 74.50**: Toast/Snackbar 通知メッセージの品質基準：
  - 成功: `「保存しました」`（過去形・簡潔）
  - エラー: `「保存できませんでした。もう一度お試しください」`（原因＋対策）

### 5.6. テキスト伸縮率・レイアウト対応

- **Rule 74.51**: 多言語対応UIでは以下のテキスト伸縮率を設計時に考慮する：

| 変換方向 | 伸縮率 | 例 |
|---|---|---|
| 英語→日本語 | 約70-80%に短縮 | "Save changes" → 「変更を保存」 |
| 英語→ドイツ語 | 約130-150%に拡大 | "Save" → "Speichern" |
| 英語→アラビア語 | 約120-130%に拡大 + RTL | — |
| 日本語→英語 | 約120-150%に拡大 | 「保存」→ "Save" |

- **Rule 74.52**: ボタン・ラベルは固定幅を避け、テキスト伸縮に耐えうる柔軟なレイアウトを使用する
- **Rule 74.53**: Pseudo-localization テスト（擬似ローカライゼーション）でレイアウト崩壊を事前検出する（Part XIII参照）

---

## Part VI: UI用語集・表記揺れ防止

### 6.1. 用語集策定義務

- **Rule 74.55**: プロジェクトごとに**UI用語集（Terminology Glossary）**を策定し、Blueprint内に配置する
- **Rule 74.56**: 同一概念に対する表記揺れは**バグ**として扱う

| カテゴリ | ❌ 禁止（表記揺れ） | ✅ 標準表現 |
|---|---|---|
| 認証 | ログイン/サインイン混在 | プロジェクトで**一つ**に統一 |
| 操作 | 登録/追加/作成 混在 | 文脈に応じた統一 |
| 状態 | 削除済み/無効/非アクティブ 混在 | プロジェクトで統一 |
| 通貨 | ¥/円/JPY 混在 | プロジェクトで統一 |

### 6.2. 表記揺れ検知と運用

- **Rule 74.57**: 新規UIテキスト作成時は、必ず用語集を参照し既存の用語との整合性を確認
- **Rule 74.58**: PRレビューに用語集との整合性チェックを必須項目として含める
- **Rule 74.59**: 可能な場合、CIで用語集との自動照合を実装（Part XVIII参照）

### 6.3. 略語・頭字語ポリシー

- **Rule 74.60**: プロジェクト設定言語で一般的でない略語の初出には、フルスペルまたは説明を併記
- **Rule 74.61**: 技術略語（API, URL, CSS, HTML等）は英語表記を維持
- **Rule 74.62**: ビジネスドメイン固有の略語は用語集に登録し、一貫性ある展開形を定義

---

## Part VII: バリデーション・フォーム言語プロトコル

### 7.1. バリデーションメッセージ

- **Rule 74.65**: バリデーションライブラリ（Zod, Yup, React Hook Form等）のデフォルト英語メッセージをユーザーに表示することは**バグ**
- **Rule 74.66**: 全バリデーションルールに対し、明示的な `message` をプロジェクト設定言語で設定する
- **Rule 74.66A**: Zodを使用する場合は `z.setErrorMap()` でグローバルエラーマップを設定し、デフォルトメッセージの漏出を構造的に防止する

```typescript
// ✅ 正しいパターン: グローバルエラーマップ
const customErrorMap: z.ZodErrorMap = (issue, ctx) => {
  switch (issue.code) {
    case z.ZodIssueCode.too_small:
      return { message: `${issue.minimum}文字以上で入力してください` };
    case z.ZodIssueCode.invalid_type:
      return { message: '入力形式が正しくありません' };
    default:
      return { message: ctx.defaultError };
  }
};
z.setErrorMap(customErrorMap);

// ✅ 個別メッセージ
const emailSchema = z.string()
  .min(1, { message: 'メールアドレスを入力してください' })
  .email({ message: 'メールアドレスの形式が正しくありません' });

// ❌ 禁止パターン: デフォルトメッセージに依存
const emailSchema = z.string().email(); // "Invalid email" が表示される
```

### 7.2. フォームラベル・ヘルプテキスト

- **Rule 74.67**: フォームの `<label>` は100%プロジェクト設定言語
- **Rule 74.68**: ヘルプテキスト・入力補助テキストは具体的かつ文脈に合致した表現
  - ❌ `「値を入力してください」`（汎用的すぎる）
  - ✅ `「例: 090-1234-5678」`（期待する形式を明示）
- **Rule 74.69**: プレースホルダーはフィールドが期待するデータ型とビジネス文脈に100%合致させる

### 7.3. Enum/ステータスの表示ラベルマッピング

- **Rule 74.70**: DB値・内部定数・Enum値を直接UIに表示することは**厳禁**
- **Rule 74.71**: `Display Label Map` を経由して必ずプロジェクト設定言語に変換する
- **Rule 74.72**: CSSの `uppercase`/`capitalize` で英語定数を体裁調整して表示するパターンは**厳禁**

```typescript
// ✅ 正しいパターン: ラベルマップ経由
const ORDER_STATUS_LABELS: Record<OrderStatus, string> = {
  pending: '処理待ち',
  confirmed: '確認済み',
  shipped: '発送済み',
  delivered: '配達完了',
  cancelled: 'キャンセル',
};

// UIコンポーネント
<Badge>{ORDER_STATUS_LABELS[order.status]}</Badge>

// ❌ 厳禁パターン
<Badge className="uppercase">{order.status}</Badge>
```

### 7.4. 数値・日付・通貨のロケール対応

- **Rule 74.73**: 数値フォーマットはロケールに準拠（`Intl.NumberFormat`使用）
- **Rule 74.74**: 日付フォーマットはロケールに準拠（`Intl.DateTimeFormat`または `date-fns/locale`使用）
- **Rule 74.75**: 通貨表示は通貨記号＋ロケール準拠フォーマット

```typescript
// ✅ 日本語ロケール対応
const price = new Intl.NumberFormat('ja-JP', {
  style: 'currency',
  currency: 'JPY',
}).format(1980); // "￥1,980"

const date = new Intl.DateTimeFormat('ja-JP', {
  year: 'numeric',
  month: 'long',
  day: 'numeric',
}).format(new Date()); // "2026年3月18日"
```

### 7.5. 複数形・序数ルール

- **Rule 74.76**: 複数形（plural）処理は `Intl.PluralRules` または ICU MessageFormat を使用し、言語固有のルールに準拠する
- **Rule 74.77**: 文字列結合による複数形処理（`count + "個のアイテム"`）は**禁止**。テンプレートリテラルまたはメッセージ関数を使用する

```typescript
// ✅ ICU MessageFormat 使用
// messages.json: "itemCount": "{count, plural, =0 {アイテムなし} one {1件} other {{count}件}}"

// ❌ 禁止: 文字列結合
const label = `${count}個のアイテムがあります`;
```

### 7.6. Intl.DurationFormat・高度なロケールフォーマット

- **Rule 74.78**: 時間経過の表示には `Intl.DurationFormat`（Stage 3）または同等のポリフィルを使用し、ロケール固有の表現を保証する
- **Rule 74.79**: 相対時間の表示には `Intl.RelativeTimeFormat` を使用し、手動の文字列構築（`"3日前"`）を**禁止**する

```typescript
// ✅ Intl.RelativeTimeFormat
const rtf = new Intl.RelativeTimeFormat('ja', { numeric: 'auto' });
rtf.format(-3, 'day'); // "3日前"
rtf.format(1, 'hour'); // "1時間後"

// ❌ 禁止: 手動構築
const label = `${days}日前`;
```

- **Rule 74.79A**: ICU MessageFormat 2.0（2025年3月 Stableリリース、CLDR 47 / ICU 77統合）の使用を推奨する。MF 1.0 からの移行計画を策定すること

---

## Part VIII: エラーハンドリング言語階層

### 8.1. Layer別言語ポリシー

- **Rule 74.80**: エラーメッセージの言語は、そのメッセージが**最終的に誰に到達するか**で決定する

| レイヤー | 到達先 | 言語 | 例 |
|---|---|---|---|
| **UIコンポーネント** | エンドユーザー | プロジェクト設定言語 | Toast, Alert, インライン |
| **Server Action / API Route** | フロントエンド経由でユーザー | プロジェクト設定言語 | `return { error: '...' }` |
| **Service層** | フロントエンド経由でユーザー | プロジェクト設定言語 | `return { message: '...' }` |
| **Domain/Logic層** | 開発者ログのみ | 英語 | `throw new Error('...')` |
| **Infrastructure層** | 運用チーム | 英語 | Logger出力 |

### 8.2. エラーメッセージの二重化パターン

- **Rule 74.81**: ユーザー向けとシステム向けのメッセージを分離する

```typescript
// ✅ 推奨パターン: 二重化
class AppError extends Error {
  constructor(
    public readonly userMessage: string,    // プロジェクト設定言語
    public readonly systemMessage: string,  // 英語（ログ用）
    public readonly code: string,           // エラーコード
  ) {
    super(systemMessage);
  }
}

throw new AppError(
  'プロフィールの更新に失敗しました。もう一度お試しください',
  'Failed to update user profile: constraint violation on email field',
  'USER_PROFILE_UPDATE_FAILED'
);
```

### 8.3. エラーコード体系

- **Rule 74.82**: エラーコードは**英語のSCREAMING_SNAKE_CASE**（`AUTH_INVALID_TOKEN`, `QUOTA_EXCEEDED`）
- **Rule 74.83**: エラーコードからプロジェクト設定言語のユーザーメッセージへのマッピング辞書を維持する

### 8.4. Error Boundary の言語フォールバック

- **Rule 74.84**: React Error BoundaryやNext.js `error.tsx` 等のフォールバックUIは**必ずプロジェクト設定言語**でレンダリングする
- **Rule 74.85**: Error Boundaryが翻訳ファイル読み込み自体に失敗した場合のハードコード済みフォールバックメッセージもプロジェクト設定言語で用意する

```typescript
// ✅ Error Boundary のフォールバック
export default function GlobalError() {
  return (
    <html lang="ja">
      <body>
        <h1>問題が発生しました</h1>
        <p>しばらくしてからもう一度お試しください</p>
        <button onClick={() => window.location.reload()}>
          再読み込み
        </button>
      </body>
    </html>
  );
}
```

---

## Part IX: API応答言語ポリシー

### 9.1. 内部API vs 外部API

- **Rule 74.90**: **内部API**（フロントエンドが消費するAPI）のエラーメッセージ `detail` / `message` フィールドは**プロジェクト設定言語**
- **Rule 74.91**: **外部公開API**（`/api/v1/*` 等の第三者向け）は**英語**を維持
- **Rule 74.92**: PRレビュー時にエラーレスポンス関数の引数が対象言語と一致しているか確認する

### 9.2. GraphQL/gRPC

- **Rule 74.93**: GraphQL の `errors[].message` はフロントエンドでの表示有無に応じて言語を選択
- **Rule 74.94**: gRPC の `status.message` は英語を基本とし、フロントエンド側でローカライズ

### 9.3. Webhook・イベントペイロード

- **Rule 74.95**: 外部向けWebhookペイロードは**英語**
- **Rule 74.96**: 内部イベントバスのメッセージは**英語**（システム層として扱う）

### 9.4. APIドキュメント・非推奨通知

- **Rule 74.97**: 外部公開APIドキュメントは**英語**
- **Rule 74.98**: 内部APIドキュメントは**プロジェクト設定言語**
- **Rule 74.99**: Deprecation Warning ヘッダーは**英語**（HTTP標準準拠）

---

## Part X: 通知・コミュニケーション言語ポリシー

### 10.1. トランザクションメール

- **Rule 74.100**: 自動送信メール（パスワードリセット、注文確認、領収書等）は**プロジェクト設定言語**
- **Rule 74.101**: メール件名・本文・フッターすべてをローカライズ
- **Rule 74.102**: メールテンプレート内のプレースホルダーURL（`example.com`等）は**厳禁**。実ドメインを使用する

### 10.2. SMS・プッシュ通知

- **Rule 74.103**: SMS/プッシュ通知は**プロジェクト設定言語**
- **Rule 74.104**: 文字数制限のある通知では、略語・省略形はプロジェクト設定言語の自然な形で使用

### 10.3. In-App通知

- **Rule 74.105**: アプリ内通知バナー、インライン通知はすべて**プロジェクト設定言語**
- **Rule 74.106**: リアルタイム通知（WebSocket/SSE経由）もローカライゼーション対象

### 10.4. チーム向け通知（Slack/Teams等）

- **Rule 74.107**: チーム向け運用通知（障害アラート、デプロイ通知等）は**プロジェクト設定言語**を基本とする
- **Rule 74.108**: 外部との統合（PagerDuty, Opsgenie等）は**英語**を許容

---

## Part XI: AIエージェント通信言語プロトコル

### 11.1. AIエージェントの言語遵守義務

- **Rule 74.110**: AIエージェントの**全出力**（思考プロセス、計画、報告、質問）はプロジェクト設定言語で行う
- **Rule 74.111**: `task.md`, `implementation_plan.md`, `walkthrough.md` の生成・更新は**プロジェクト設定言語**
- **Rule 74.112**: `notify_user` によるユーザーへの報告・質問は**プロジェクト設定言語**
- **Rule 74.113**: AIが英語で思考・報告した場合、それは**プロトコル違反**として即座に是正する

### 11.2. AI生成テキストの言語品質

- **Rule 74.114**: AI生成のUI向けテキスト（マイクロコピー、エラーメッセージ等）は、Part Vの品質基準を満たさなければならない
- **Rule 74.115**: AIが生成した翻訳テキストには以下のアンチパターンがないか検証する：
  - 直訳調（英語の語順をそのまま日本語にしたもの）
  - 過剰な敬語・不自然な丁寧語
  - カタカナ語の多用（日本語で自然な表現があるにもかかわらず）
  - 曖昧な主語の残存

### 11.3. プロンプト・システム指示

- **Rule 74.116**: ユーザー対面のAIシステム（チャットボット、AIアシスタント等）のシステムプロンプトには**言語指定**を含める
- **Rule 74.117**: AI応答の言語はユーザーの入力言語またはプロジェクト設定言語に従う
- **Rule 74.118**: AI応答が意図しない言語で返される場合の**フォールバック機構**を実装する

### 11.4. RAG・ナレッジベースの多言語対応

- **Rule 74.119**: RAGのソースドキュメントがプロジェクト設定言語以外の場合、AI応答はプロジェクト設定言語に翻訳して出力する
- **Rule 74.120**: ナレッジベースの検索クエリは、プロジェクト設定言語とソース言語の両方で実行してリコールを最大化する

### 11.5. 言語ドリフト自動検知

- **Rule 74.121**: AI出力の言語を自動検知し、プロジェクト設定言語以外の出力が混入した場合にアラートを発する機構を推奨する
- **Rule 74.122**: 言語ドリフト検知手法：
  - 文字コードベース（Unicode Script Property でのスクリプト判定）
  - 言語検出ライブラリ（`franc`, `cld3` 等）によるサンプリング検査
  - LLM自己検証プロンプト（「あなたの出力はプロジェクト設定言語ですか？」）

### 11.6. AIコードレビュー・開発ツール言語設定

- **Rule 74.123**: AI Code Review（GitHub Copilot PR Review等）のフィードバック言語はプロジェクト設定言語に設定する
- **Rule 74.124**: AI開発補助ツール（Copilot, Cursor等）のコメント生成言語は英語（コード内コメントのため）

### 11.7. MCP・A2A・ACPプロトコル対応言語メタデータ

- **Rule 74.124A**: MCP（Model Context Protocol）の Tool manifest に言語メタデータを含める。Toolの `description` は英語、ユーザー対面の出力テンプレートはプロジェクト設定言語
- **Rule 74.124B**: A2A（Agent-to-Agent）の Agent Card に `supportedLanguages` フィールドを定義し、エージェントの言語能力を明示する
- **Rule 74.124C**: ACP（Agent Communication Protocol）の REST ヘッダーに `Accept-Language` / `Content-Language` を含め、エージェント間の言語期待を明確にする
- **Rule 74.124D**: エージェントチェーン（複数エージェントが順次処理）において、言語コンテキストはチェーン全体で伝搬されなければならない

```json
// A2A Agent Card 例
{
  "name": "translation-agent",
  "description": "Handles document translation tasks",
  "supportedLanguages": ["ja", "en"],
  "defaultLanguage": "ja",
  "capabilities": ["translate", "summarize"]
}
```

---

## Part XII: ログ・監査・可観測性の言語ポリシー

### 12.1. アプリケーションログ

- **Rule 74.125**: アプリケーションログメッセージは**英語**で記述する
  - 根拠: ログ分析ツール（Datadog, Loki, CloudWatch等）との互換性、国際チーム対応、パターンマッチの容易さ
- **Rule 74.126**: ログに含まれるユーザー入力データはサニタイズし、言語に関わらずそのまま記録（翻訳しない）

```typescript
// ✅ 正しいパターン
logger.error('Failed to process payment', {
  userId: user.id,
  amount: payment.amount,
  error: err.message,
});

// ❌ 禁止パターン
logger.error('支払い処理に失敗しました', { ... });
```

### 12.2. 構造化ログのフィールド命名

- **Rule 74.127**: 構造化ログ（JSON）のフィールド名は**英語の camelCase または snake_case** で統一する
- **Rule 74.128**: OpenTelemetry Span/Trace 属性名は英語（セマンティック規約準拠）

### 12.3. 監査証跡（Audit Trail）

- **Rule 74.129**: 監査証跡のアクション名・イベント名は**英語**（`user.login`, `record.create`, `permission.change`）
- **Rule 74.130**: 監査ログの詳細説明（管理者向けUI表示）は**プロジェクト設定言語**でのラベルマッピングを経由

### 12.4. メトリクス・ダッシュボード

- **Rule 74.131**: メトリクス名は**英語**（Prometheus/Grafana互換）：`http_request_duration_seconds`, `db_connection_pool_active`
- **Rule 74.132**: ダッシュボードのタイトル・説明は**チーム言語**（通常プロジェクト設定言語）
- **Rule 74.133**: アラート通知はチーム設定言語（Part X.4参照）

---

## Part XIII: テスト言語ポリシー

### 13.1. テストコード

- **Rule 74.135**: テスト関数名・`describe`/`it` ブロックの説明は**英語**

```typescript
// ✅ 正しいパターン
describe('UserProfileService', () => {
  it('should return user profile with localized status labels', () => {
    // ...
  });

  it('should throw AppError when email already exists', () => {
    // ...
  });
});
```

### 13.2. テストデータ言語

- **Rule 74.136**: テストデータ（フィクスチャ、シードデータ）のユーザー向けフィールドは**プロジェクト設定言語**
  - 名前、説明文、住所等はプロジェクト設定言語のリアルなデータを使用
  - 根拠: ローカライゼーションバグの早期発見
- **Rule 74.137**: テストデータのシステムフィールド（ID、ステータスコード等）は英語

### 13.3. E2E/VRTテスト

- **Rule 74.138**: E2Eテスト（Playwright等）はプロジェクト設定言語のロケールで実行し、UIの言語正確性を検証する
- **Rule 74.139**: VRT（Visual Regression Test）のスナップショットはプロジェクト設定言語のロケールで取得
- **Rule 74.140**: ロケール依存のフォーマット（日付、数値、通貨）がテストで正しく表示されることを検証する

### 13.4. Pseudo-localization テスト

- **Rule 74.141**: 多言語対応プロジェクトでは、Pseudo-localization（擬似ローカライゼーション）テストをCI/CDに組み込む
- **Rule 74.142**: 擬似ローカライゼーションで検出すべき項目：
  - テキスト伸縮によるレイアウト崩壊
  - ハードコードされた文字列の残存
  - 文字エンコーディングの問題（アクセント文字、CJK文字の表示崩壊）
  - 翻訳リソースから漏れた文字列

---

## Part XIV: CMS・コンテンツ言語ガバナンス

### 14.1. CMS管理画面言語

- **Rule 74.145**: CMS管理画面のUI言語は**プロジェクト設定言語**（Part V準拠）
- **Rule 74.146**: CMSのフィールドラベル・ヘルプテキストはプロジェクト設定言語

### 14.2. コンテンツモデリング

- **Rule 74.147**: CMSのフィールド名（API名）は**英語**（`title`, `description`, `published_at`）
- **Rule 74.148**: CMSの表示ラベルは**プロジェクト設定言語**（`タイトル`, `説明文`, `公開日`）
- **Rule 74.149**: 翻訳キー命名規約：

```
# 翻訳キーの命名規約
{scope}.{component}.{element}

# 例
common.button.save        → 「保存」
common.button.cancel      → 「キャンセル」
auth.login.title          → 「ログイン」
auth.login.email_label    → 「メールアドレス」
pet.profile.name_label    → 「ペットの名前」
error.network.timeout     → 「接続がタイムアウトしました」
```

### 14.3. コンテンツバージョニング

- **Rule 74.150**: 多言語コンテンツのバージョン管理は、権威言語版を「正」とし、他言語版は派生と位置付ける
- **Rule 74.151**: 権威言語版が更新された場合、他言語版に「要翻訳更新」フラグを自動的に立てる

### 14.4. 翻訳メモリ・用語ベース統合

- **Rule 74.152**: TMS（Translation Management System: Crowdin/Lokalise/Phrase等）と連携する場合、翻訳メモリ（TM）と用語ベース（TB）を活用し、翻訳品質と一貫性を担保する
- **Rule 74.153**: TMS連携フローは以下を標準とする：
  1. ソースコードから翻訳キーを自動抽出
  2. TMS にプッシュ（CI/CD連携）
  3. 翻訳完了後、翻訳ファイルをリポジトリに自動プル
  4. PRを自動生成し、レビューサイクルに組み込む

---

## Part XV: SEO・構造化データ言語

### 15.1. メタデータ

- **Rule 74.155**: `<title>` タグと `<meta name="description">` は**プロジェクト設定言語**
- **Rule 74.156**: OGP（`og:title`, `og:description`）は**プロジェクト設定言語**
- **Rule 74.157**: Twitter Card (`twitter:title`, `twitter:description`) も**プロジェクト設定言語**

### 15.2. 構造化データ（JSON-LD）

- **Rule 74.158**: JSON-LDの `name`, `description` フィールドは**プロジェクト設定言語**
- **Rule 74.159**: JSON-LDの `@type`, `@context` 等のスキーマ定義は**英語**（Schema.org準拠）
- **Rule 74.160**: `inLanguage` プロパティに正確なBCP 47言語タグを設定（`ja`, `en`等）

### 15.3. Sitemap・robots.txt

- **Rule 74.161**: 多言語サイトの場合、`hreflang` 属性を全ページに正確に設定（→ [800_internationalization.md](./800_internationalization.md) Part X参照）
- **Rule 74.162**: `robots.txt` は言語非依存（英語で記述）

---

## Part XVI: アクセシビリティ言語要件

### 16.1. HTML言語属性

- **Rule 74.165**: `<html lang="ja">` のように、ページのプライマリ言語をBCP 47タグで正確に設定する（WCAG 2.2 SC 3.1.1 準拠）
- **Rule 74.166**: ページ内で言語が切り替わる箇所（英語の引用等）は `<span lang="en">` で明示する（WCAG 2.2 SC 3.1.2 準拠）

### 16.2. ARIA属性

- **Rule 74.167**: `aria-label`, `aria-describedby`, `aria-placeholder` は**プロジェクト設定言語**
- **Rule 74.168**: スクリーンリーダーが適切に読み上げられるよう、略語展開を提供する
  - ❌ `<abbr>RLS</abbr>`
  - ✅ `<abbr title="行レベルセキュリティ">RLS</abbr>`
- **Rule 74.168A**: `aria-labelledby` を `aria-label` より優先して使用する。`aria-labelledby` は可視テキストを参照するため、翻訳漏れリスクが低い

```html
<!-- ✅ 推奨: aria-labelledby で可視テキストを参照 -->
<h2 id="section-title">ユーザー設定</h2>
<section aria-labelledby="section-title">...</section>

<!-- △ 次善: aria-label は翻訳対象として管理が必要 -->
<button aria-label="メニューを開く">☰</button>
```

### 16.3. 画像・メディアのアクセシビリティ

- **Rule 74.169**: 画像の `alt` テキストは**プロジェクト設定言語**で、装飾画像は `alt=""` で空にする
- **Rule 74.170**: `<figcaption>` は**プロジェクト設定言語**
- **Rule 74.171**: 動画の字幕・トランスクリプションは**プロジェクト設定言語**を提供する

### 16.4. ライブリージョン・動的コンテンツ

- **Rule 74.172**: `aria-live` リージョンに挿入されるテキストは**プロジェクト設定言語**
- **Rule 74.173**: 動的に更新されるカウンター、ステータス、通知もプロジェクト設定言語でローカライズ

### 16.5. Plain Language原則・EAA対応

- **Rule 74.173A**: UIテキストはPlain Language（平易な言葉）原則に従い、専門用語の使用を最小化する（WCAG 2.2 Understandable原則）
- **Rule 74.173B**: EAA（European Accessibility Act、2025年6月施行）対象の製品・サービスは、WCAG 2.2 AA以上への準拠を必須とする
- **Rule 74.173C**: 言語属性の欠落はアクセシビリティ監査で**ブロッキング項目**とする（`lang` 属性の欠落はスクリーンリーダーの誤読み上げを引き起こす）
- **Rule 74.173D**: Cognitive Accessibility（認知アクセシビリティ）の観点から、文章は短文・會意的・一貫性のある表現を用いる

| 確認項目 | 基準 |
|---|---|
| `<html lang>` 設定 | WCAG 2.2 SC 3.1.1（Level A） |
| 部分的言語切替 `<span lang>` | WCAG 2.2 SC 3.1.2（Level AA） |
| Plain Language | WCAG 2.2 SC 3.1.5（Level AAA） |
| EAA準拠 | WCAG 2.2 AA + EN 301 549 |

---

## Part XVII: 翻訳除外ポリシー

### 17.1. 翻訳対象判定フローチャート

```
テキストはユーザーに表示される？
├── Yes → プロジェクト設定言語で翻訳する
│         ├── UI上のラベル・ボタン・メッセージ → 翻訳対象
│         ├── エラーメッセージ（Toast/Alert表示） → 翻訳対象
│         ├── メール・通知の本文 → 翻訳対象
│         └── PDFレポート・CSV出力のヘッダー → 翻訳対象
└── No → 以下の分岐で判断
         ├── プログラム定数/条件分岐の比較対象 → 翻訳しない
         ├── 外部API送受信値 → 翻訳しない
         ├── ログメッセージ → 翻訳しない
         ├── DB保存値（enum, status等） → 翻訳しない
         └── 開発者専用エラー（throw内部） → 翻訳しない
```

### 17.2. 明示的除外パターン

- **Rule 74.175**: 以下は**翻訳除外**として明示的に扱う：
  1. **プログラム定数**: フロントエンドの条件分岐で使用される文字列（`'QUOTA_EXCEEDED'`）
  2. **フロー制御文字列**: 認証フロー等の状態管理文字列（`'OTP Required'`）
  3. **外部API送信値**: サードパーティAPI仕様に依存する文字列（Stripe `status: 'active'`）
  4. **内部例外**: try-catch内で処理され、UIに到達しない `throw new Error()`
  5. **JSONキー・APIパス**: `userId`, `/api/v1/users`
  6. **技術用語**: `HTML`, `CSS`, `JSON`, `OAuth`, `JWT`

### 17.3. グレーゾーン判定

- **Rule 74.176**: 以下のパターンは判断が分かれるため、**翻訳する方向で安全側に倒す**：

| パターン | 判定 | 根拠 |
|---|---|---|
| `return { error: '...' }` | ✅ 翻訳する | ユーザー表示される可能性あり |
| `return { message: '...' }` | ✅ 翻訳する | Toast/Alert経由で表示 |
| `console.error('...')` | ❌ 翻訳しない | 開発者ツールのみ |
| `logger.warn('...')` | ❌ 翻訳しない | 運用ログのみ |
| 管理者専用UIのエラー | ✅ 翻訳する | 管理者もユーザーの一種 |

---

## Part XVIII: CI/CD言語品質ゲート

### 18.1. 未翻訳文字列自動スキャン

- **Rule 74.180**: UIコンポーネント（`.tsx`, `.vue`等）内に、プロジェクト設定言語以外の文字列リテラルが残存していないかをCI/PRレビューで検出する
- **Rule 74.181**: スキャン対象層（Deep Layer Scan）：
  - UIコンポーネント層
  - Server Action / API Route のエラーメッセージ
  - Service層の return 値
  - `title` / `description` プロパティ
  - メールテンプレート
  - 通知メッセージ

### 18.2. スキャン除外設定

- **Rule 74.182**: 以下はスキャン除外：
  - コンポーネント名・変数名
  - import文・export文
  - 外部公開API（`/api/v1/*`）
  - Logger向けメッセージ
  - `console.*` 呼び出し
  - テストファイル（`*.test.*`, `*.spec.*`）
  - 型定義ファイル（`*.d.ts`）

### 18.3. PR/デプロイゲート

- **Rule 74.183**: 未翻訳文字列の検出はPRレビューの**ブロッキング項目**として設定する
- **Rule 74.184**: 新規追加された文字列が用語集と整合しているかの自動チェックを推奨
- **Rule 74.185**: 定期的な全体スキャン（週次/月次）で「仮置き英語」の残存を監視
- **Rule 74.185A**: PRに翻訳カバレッジをコメントとして自動挿入し、進捗を可視化する

### 18.4. ESLint / Biome カスタムルール

- **Rule 74.186**: 言語品質の自動検出に ESLint または Biome のカスタムルールを導入する

```typescript
// eslint-plugin-language-protocol の設定例
module.exports = {
  rules: {
    'no-raw-english-in-jsx': 'error',     // JSX内の英語リテラル禁止
    'require-label-map': 'error',          // Enum直接表示の検知
    'no-default-validation-msg': 'error',  // Zodデフォルトメッセージ検知
    'require-aria-lang': 'warn',           // aria-label言語チェック
  },
};
```

### 18.5. 言語品質スコアリング

- **Rule 74.187**: 以下の指標で言語品質を計測することを推奨：
  - **ローカライゼーションカバレッジ率**: 全文字列中、プロジェクト設定言語でローカライズ済みの割合
  - **用語集準拠率**: 用語集に登録された標準表現との一致率
  - **未翻訳文字列数**: CIで検出された未翻訳文字列の推移
- **Rule 74.187A**: 翻訳diffをPRに可視化し、レビュアーが言語変更を容易に確認できるようにする

---

## Part XIX: 型安全i18n・翻訳キー設計

### 19.1. 翻訳リソースの外部化義務

- **Rule 74.190**: 全てのユーザー向けテキストは、ソースコードから**外部翻訳リソースファイル**（JSON/YAML/PO等）に分離しなければならない
- **Rule 74.191**: 翻訳リソースファイルの配置規約：

```
src/
  locales/
    ja/
      common.json      # 共通テキスト
      auth.json         # 認証関連
      errors.json       # エラーメッセージ
      validation.json   # バリデーション
    en/                 # 英語版（必要な場合）
      common.json
      ...
```

### 19.2. TypeScript型安全翻訳キー

- **Rule 74.192**: 翻訳キーは TypeScript の型システムで**コンパイル時に安全性を保証**する
- **Rule 74.193**: 存在しない翻訳キーの参照は**コンパイルエラー**として検出する

```typescript
// ✅ 型安全な翻訳キー（next-intl の例）
import { useTranslations } from 'next-intl';

function LoginForm() {
  const t = useTranslations('auth.login');
  return (
    <form>
      <label>{t('email_label')}</label>  {/* 型チェック済み */}
      <button>{t('submit')}</button>     {/* 型チェック済み */}
    </form>
  );
}

// ❌ 型安全でない翻訳キー
const label = t('auth.login.emial_label'); // タイポ → コンパイルエラーで検知
```

### 19.3. ICU MessageFormat 2.0 準拠

- **Rule 74.194**: 動的メッセージ（複数形・性別・日付等を含むもの）は ICU MessageFormat 2.0 を使用する
- **Rule 74.195**: 文字列結合による動的メッセージ構築は**禁止**

```json
{
  "itemCount": "{count, plural, =0 {アイテムなし} one {1件のアイテム} other {{count}件のアイテム}}",
  "greeting": "{time, select, morning {おはようございます} afternoon {こんにちは} evening {こんばんは}}、{name}さん"
}
```

### 19.4. 翻訳キーの孤児検出

- **Rule 74.196**: コードから参照されていない翻訳キー（孤児キー）は、CIで自動検出し定期的に削除する
- **Rule 74.197**: 翻訳キーの追加・削除はPRレビューの対象とし、用語集との整合性を維持する

### 19.5. 翻訳リソースのスキーマ検証

- **Rule 74.198**: 翻訳リソースファイルに対しJSONスキーマ検証を実施し、必須キーの欠落・型不整合を検出する

### 19.6. i18nライブラリ選定基準

- **Rule 74.199**: i18nライブラリの選定は以下の基準で評価する：

| 基準 | 評価ポイント |
|---|---|
| 型安全性 | TypeScript型推論による翻訳キーの自動補完・検証 |
| ICU MF2.0対応 | 複数形・性別・序数の完全サポート |
| SSR/RSC対応 | Server Components / SSR での翻訳解決 |
| バンドルサイズ | Tree Shaking対応、言語別分割ロード |
| エコシステム | コミュニティサイズ、メンテナンス頻度 |

---

## Part XX: AI間通信・Agent-to-Agent言語プロトコル

### 20.1. マルチエージェント環境の言語規約

- **Rule 74.200**: マルチエージェントシステム（複数のAIエージェントが協調動作する環境）において、エージェント間通信の言語は以下のルールに従う：
  - **ユーザー対面出力**: プロジェクト設定言語（Part XI準拠）
  - **エージェント間の内部通信**: 英語を推奨（構造化データ交換の標準性確保）
  - **エージェント→人間の報告**: プロジェクト設定言語

### 20.2. A2A / MCP / ACP プロトコルの言語規約

- **Rule 74.201**: Agent-to-Agent（A2A）、Model Context Protocol（MCP）、Agent Communication Protocol（ACP）等の標準プロトコルを使用する場合：
  - プロトコル自体のメタデータ・スキーマ定義は**英語**
  - ペイロード内のユーザー向けコンテンツは**プロジェクト設定言語**
  - エージェントの能力記述（Agent Card等）は**英語**で国際互換性を確保

### 20.3. エージェント出力の言語検証

- **Rule 74.202**: エージェントからの最終出力をユーザーに届ける前に、言語適合性をゲートウェイ層で検証する
- **Rule 74.203**: 言語検証に失敗した出力は、フォールバックメッセージ（プロジェクト設定言語）に置換する

---

## Part XXI: 多言語安全性ガードレール

### 21.1. LLM出力の言語強制

- **Rule 74.205**: ユーザー対面のLLMアプリケーションでは、出力言語をプロジェクト設定言語に強制する**ガードレール**を実装する
- **Rule 74.206**: ガードレール実装手法：
  1. **システムプロンプトでの言語指定**（第一防御線）
  2. **出力後の言語検証ミドルウェア**（第二防御線）
  3. **ユーザーフィードバックによる言語修正**（第三防御線）

### 21.2. 多言語プロンプトインジェクション防御

- **Rule 74.207**: 異なる言語でのプロンプトインジェクション攻撃（言語切替によるガードレール回避）に対する防御策を実装する
- **Rule 74.208**: 防御手法：
  - 入力言語の検出と検証
  - 言語非依存のセマンティック安全性分類
  - 多言語セーフティベンチマーク（PolyGuard等）による定期的な評価

### 21.3. 多言語コンテンツモデレーション

- **Rule 74.209**: ユーザー生成コンテンツ（UGC）のモデレーションは、プロジェクト設定言語に加え、想定入力言語全てに対応する
- **Rule 74.210**: 多言語の毒性検出・禁止語フィルタリングはプロジェクト設定言語で安全基準を定義する

---

## Part XXII: PDF・CSV・帳票エクスポート言語

### 22.1. PDFエクスポート

- **Rule 74.215**: PDF帳票のテキストは**プロジェクト設定言語**で出力する
- **Rule 74.216**: PDFフォントは、プロジェクト設定言語の全文字セットを正確にレンダリングできるフォントを使用する
  - 日本語プロジェクト: Noto Sans JP / Noto Serif JP 等のUnicode対応フォントを埋め込む
  - **禁止**: システムフォントへの依存（環境差異によるレンダリング崩壊リスク）
- **Rule 74.217**: PDF内のヘッダー・フッター・ページ番号表記もプロジェクト設定言語

### 22.2. CSVエクスポート

- **Rule 74.218**: CSVのカラムヘッダーは**プロジェクト設定言語**
- **Rule 74.219**: CSVのエンコーディングは UTF-8 BOM 付き（Excel互換性のため）を推奨
- **Rule 74.220**: 日付・数値フォーマットはプロジェクト設定言語のロケールに準拠

### 22.3. Excelエクスポート

- **Rule 74.221**: Excelシート名・カラムヘッダーは**プロジェクト設定言語**
- **Rule 74.222**: Excelのセルフォーマット（日付、通貨等）はプロジェクト設定言語のロケールに設定する

### 22.4. レシート・領収書

- **Rule 74.223**: 領収書・レシートのテンプレートは**プロジェクト設定言語**
- **Rule 74.224**: 法的要件のある文書（消費税表記等）は、該当法域の言語要件にも準拠する

---

## Part XXIII: 法務・契約・規約文書言語ガバナンス

### 23.1. 利用規約・プライバシーポリシー

- **Rule 74.225**: 利用規約・プライバシーポリシーの**法的に有効な権威版**の言語を明示的に定義する
- **Rule 74.226**: 多言語版を提供する場合、「矛盾がある場合は[権威言語]版が優先する」旨を各翻訳版に明記する
- **Rule 74.227**: 法務文書の翻訳はAI生成のみに依存せず、法律専門家のレビューを必須とする

### 23.2. SLA・契約書

- **Rule 74.228**: SLA（Service Level Agreement）の権威版言語を定義し、翻訳版との法的優先順位を明記する
- **Rule 74.229**: 契約書の翻訳不能な法律用語は、原語を併記する方式を採用する

### 23.3. Cookie同意・法的通知

- **Rule 74.230**: Cookie同意バナー・法的通知は**プロジェクト設定言語**で表示する
- **Rule 74.231**: GDPR/APPI等のプライバシー規制で要求される告知文は、対象ユーザーの言語で提供する

---

## Part XXIV: モバイル固有言語プロトコル

### 24.1. iOS言語プロトコル

- **Rule 74.235**: iOS向けの翻訳リソースは `Localizable.strings` / `Localizable.stringsdict`（複数形用）/ Xcode String Catalogs を使用する
- **Rule 74.236**: `Info.plist` の `CFBundleDisplayName`, `CFBundleShortVersionString` 等のローカライズ対象プロパティはプロジェクト設定言語で設定する
- **Rule 74.237**: App Store Connect のアプリ名・サブタイトル・説明文・キーワードはプロジェクト設定言語で提供する

### 24.2. Android言語プロトコル

- **Rule 74.238**: Android向けの翻訳リソースは `res/values-{locale}/strings.xml` に配置する
- **Rule 74.239**: `res/values/strings.xml`（デフォルト）はプロジェクト設定言語で記述する
- **Rule 74.240**: Google Play のストアリスティング（タイトル・短い説明・詳しい説明）はプロジェクト設定言語で提供する

### 24.3. Flutter / React Native / KMP

- **Rule 74.241**: Flutter向けは ARB（Application Resource Bundle）ファイルを使用し、`intl` パッケージまたは `slang` で型安全な翻訳を実装する
- **Rule 74.242**: React Native向けは `react-i18next` + `i18next` で翻訳リソースを管理する
- **Rule 74.243**: KMP（Kotlin Multiplatform）向けは `moko-resources` 等のマルチプラットフォーム翻訳ライブラリを使用する

### 24.4. 端末言語設定の検知と適用

- **Rule 74.244**: モバイルアプリの起動時に、端末の言語設定を検知し、サポート対象言語と照合する
- **Rule 74.245**: サポート対象外の言語の場合、プロジェクトデフォルト言語にフォールバックする

---

## Part XXV: 成熟度モデル・アンチパターン

### 25.1. 言語プロトコル成熟度モデル（5段階）

| レベル | 名称 | 特徴 |
|---|---|---|
| **L1: Ad-hoc** | 場当たり的 | 言語ポリシーなし。開発者の好みで英語/母語が混在 |
| **L2: Basic** | 基本対応 | UI層のローカライゼーションのみ実施。バリデーション・エラーは英語残存 |
| **L3: Standardized** | 標準化 | 三層モデル適用。用語集策定。CIスキャン導入。Enum/ステータスのラベルマップ完備 |
| **L4: Managed** | 管理統制 | 全層で言語ポリシー適用。品質スコアリング導入。翻訳ドリフト自動検知 |
| **L5: Optimized** | 最適化 | AI活用の言語品質自動検証。ゼロ未翻訳維持。マイクロコピーA/Bテスト。型安全i18n完備。MTPEワークフロー完成 |

### 25.1A. MTPE（機械翻訳ポストエディット）品質分類

- **Rule 74.252**: MTPEはコンテンツの重要度に応じてLight/Fullの2段階で運用する：

| レベル | 対象 | 基準 |
|---|---|---|
| **Light PE** | 内部ツール、開発者ドキュメント、FAQ | 意味の正確性と可読性の確保に留める |
| **Full PE** | UIテキスト、法務文書、マーケティング | ネイティブ同等の品質、文体・トーンの最適化を含む |

### 25.2. 20大アンチパターン

| # | アンチパターン名 | 説明 | 対策Section |
|---|---|---|---|
| 1 | **Lazy Translation** | 開発中の仮置き英語がそのまま本番に残存 | Part XVIII |
| 2 | **CSS Uppercase Trick** | CSS `uppercase`で英語定数を体裁調整して表示 | Part VII §7.3 |
| 3 | **Validation Leak** | Zodデフォルト英語メッセージがユーザーに漏出 | Part VII §7.1 |
| 4 | **Terminology Chaos** | 同一概念に複数の表記が混在 | Part VI |
| 5 | **Fallback Exposure** | `"Unknown"`, `"N/A"` がユーザーに表示 | Part V §5.4 |
| 6 | **Ghost English** | `aria-label`, `alt`, `title`等の隠しテキストが英語のまま | Part XVI |
| 7 | **Log Language Confusion** | ログにプロジェクト設定言語と英語が混在 | Part XII |
| 8 | **AI Language Drift** | AIエージェントが意図せず英語で応答 | Part XI |
| 9 | **Commit Message Chaos** | コミットメッセージの言語が不統一 | Part IV |
| 10 | **Error Layer Bleed** | 内部エラー英語メッセージがUIに漏出 | Part VIII |
| 11 | **Plural Blindness** | 複数形ルールを無視した文字列結合 | Part VII §7.5 |
| 12 | **Font Fallback Hell** | PDFやCJK環境でフォント未埋め込みにより文字化け | Part XXII §22.1 |
| 13 | **Translation Key Orphan** | コードから参照されない翻訳キーの蓄積 | Part XIX §19.4 |
| 14 | **Hardcoded String** | 翻訳リソースを使わずソースコードに直書き | Part XIX §19.1 |
| 15 | **Legal Translation Gap** | 利用規約の翻訳版が権威版と乖離 | Part XXIII |
| 16 | **DB Mixed Language** | DBテーブル/カラム名に英語と母語が混在 | Part XXVI |
| 17 | **Design Token Gap** | デザイントークンがi18n非対応でレイアウト崩壊 | Part XXVII |
| 18 | **Translation Bundle Bloat** | 全言語リソースを一括ロードしパフォーマンス劣化 | Part XXIX |
| 19 | **Unicode Normalization Mismatch** | NFC/NFD不整合で検索・比較が失敗 | Part XXXI |
| 20 | **Gender Bias Leakage** | AI生成テキストにジェンダーバイアスが残存 | Part XXXII |

### 25.3. 定期監査プロトコル

- **Rule 74.250**: 四半期ごとに言語プロトコル準拠状況の監査を実施する
- **Rule 74.251**: 監査項目：
  1. 未翻訳文字列のスキャン結果
  2. 用語集の最新性
  3. 新規追加コンポーネントの言語品質
  4. アンチパターンの検出数推移
  5. 翻訳キーの孤児数
  6. 法務文書の同期状況
  7. DBスキーマの言語整合性（Part XXVI）
  8. デザイントークンのi18n対応状況（Part XXVII）

---

## Part XXVI: DB・インフラ言語ポリシー

### 26.1. データベーススキーマ言語規約

- **Rule 74.260**: テーブル名・カラム名・インデックス名・制約名は**英語の snake_case** で統一する
- **Rule 74.261**: テーブル名は英語の**複数形**を使用する（`users`, `pet_health_checkups`）
- **Rule 74.262**: カラム名は英語で**降順に具体化**する（`user_id`, `created_at`, `is_active`）
- **Rule 74.263**: 日本語（ローマ字含む）のテーブル名・カラム名は**厳禁**
  - ❌ `kensaku_rireki`, `user_jouhou`, `shouhin`
  - ✅ `search_history`, `user_info`, `products`

### 26.2. マイグレーション・シード言語

- **Rule 74.264**: マイグレーションファイル名は**英語**（`20260318_add_reminder_interval`）
- **Rule 74.265**: マイグレーション内のコメントは**英語**
- **Rule 74.266**: シードデータのユーザー向けフィールド（名前、説明等）は**プロジェクト設定言語**のリアルなデータを使用

### 26.3. Enum型・ステータス値

- **Rule 74.267**: DBに保存するEnum値・ステータスコードは**英語の小文字 snake_case**
  - ✅ `active`, `pending_review`, `cancelled`
  - ❌ `有効`, `確認待ち`, `キャンセル済み`
- **Rule 74.268**: DB保存値とUI表示ラベルのマッピングはアプリケーション層で行う（Part VII §7.3 準拠）

### 26.4. インフラ定義（IaC）言語

- **Rule 74.269**: Terraform / AWS CDK / Pulumi 等のリソース名・変数名は**英語**
- **Rule 74.270**: IaCのコメントは**英語**（システム層として扱う）
- **Rule 74.271**: CloudFormation / Kubernetes YAML のラベル・アノテーションは**英語**

### 26.5. 環境変数・設定ファイル

- **Rule 74.272**: 環境変数名は**英語のSCREAMING_SNAKE_CASE**（`DATABASE_URL`, `API_SECRET_KEY`）
- **Rule 74.273**: 設定ファイル（`.env`, `config.yaml`等）のコメントは**英語**

---

## Part XXVII: デザインシステム・デザイントークンi18n

### 27.1. デザイントークンの言語対応

- **Rule 74.275**: デザイントークンは言語・ロケールに応じた値のオーバーライドをサポートする設計とする
- **Rule 74.276**: 以下のトークンカテゴリはi18n対応を必須とする：

| カテゴリ | i18n対応内容 |
|---|---|
| **Typography** | 言語別フォントスタック（CJK用: Noto Sans JP, Latin用: Inter等） |
| **Spacing** | テキスト伸縮に対応した最小幅・パディング |
| **Direction** | `ltr`/`rtl` に応じた論理プロパティ（`margin-inline-start`等） |
| **Line Height** | CJK文字に最適化された行間（CJK: ≥1.8, Latin: ≥1.5） |

### 27.2. コンポーネントAPIの言語設計

- **Rule 74.277**: コンポーネントのProps名は**英語**（`label`, `placeholder`, `errorMessage`）
- **Rule 74.278**: コンポーネントのデフォルトテキストは設定せず、必ず翻訳リソースから注入する
  - ❌ `<Button>Submit</Button>`（ハードコード）
  - ✅ `<Button>{t('common.button.submit')}</Button>`（翻訳キー経由）

### 27.3. Figma連携・翻訳フロー

- **Rule 74.279**: Figmaデザインのテキストレイヤーには翻訳キーをメタデータとして付与し、デザイン→実装の翻訳整合性を保つ
- **Rule 74.280**: デザインレビュー時に、テキストがプロジェクト設定言語であることを確認する

---

## Part XXVIII: エラーリカバリ・グレースフルデグラデーション言語

### 28.1. 翻訳ファイル読み込み失敗時のフォールバック

- **Rule 74.285**: 翻訳リソースファイルの読み込みに失敗した場合のフォールバック戦略を定義する：

```
1. キャッシュ済み翻訳リソースを使用（Service Worker / localStorage）
2. インライン埋め込みのクリティカル翻訳（最小限のUI文字列）を使用
3. 最終手段: ハードコード済みフォールバックメッセージを表示
```

- **Rule 74.286**: フォールバックメッセージは**プロジェクト設定言語**でハードコードする

### 28.2. CDN障害時の言語リソース可用性

- **Rule 74.287**: 翻訳リソースをCDNから配信する場合、CDN障害時のフォールバック（オリジンサーバー直接配信等）を設定する
- **Rule 74.288**: クリティカルな翻訳リソース（エラーページ、認証フロー等）はバンドルに含める

### 28.3. オフライン時の言語リソースキャッシュ

- **Rule 74.289**: PWA/オフライン対応アプリでは、Service Worker による翻訳リソースのプリキャッシュを実装する
- **Rule 74.290**: オフラインで利用可能な翻訳の範囲を明示的に定義する

---

## Part XXIX: パフォーマンス最適化・バンドル戦略

### 29.1. 翻訳リソースのCode Splitting

- **Rule 74.295**: 翻訳リソースは**ページ/ルート単位**でCode Splitし、必要な翻訳のみをロードする
- **Rule 74.296**: 共通翻訳（`common.json`）とページ固有翻訳（`auth.json`, `dashboard.json`等）を分離する

```typescript
// ✅ 推奨: ルート単位での翻訳ロード
// next-intl の例
export async function getMessages(locale: string) {
  return {
    ...(await import(`@/locales/${locale}/common.json`)).default,
    ...(await import(`@/locales/${locale}/${getCurrentRoute()}.json`)).default,
  };
}
```

### 29.2. バンドルサイズ管理

- **Rule 74.297**: 翻訳リソースのバンドルサイズを監視し、言語あたり**50KB以下**を目標とする
- **Rule 74.298**: 未使用翻訳キーのTree Shakingを可能な限り実装する

### 29.3. 翻訳リソースのキャッシュ戦略

- **Rule 74.299**: 翻訳リソースには**コンテンツハッシュベースのキャッシュバスティング**を適用する
- **Rule 74.300**: `Cache-Control: public, max-age=31536000, immutable` を翻訳リソースに設定する

---

## Part XXX: チーム教育・オンボーディング言語プロトコル

### 30.1. 新規メンバーオンボーディング

- **Rule 74.305**: 新規メンバーのオンボーディング資料に、言語プロトコルの概要と必読セクションを含める
- **Rule 74.306**: 最初のPRレビューで言語プロトコル準拠を重点的にフィードバックする

### 30.2. PRレビュー言語チェックリスト

- **Rule 74.307**: PRレビューに以下の言語チェックリストを適用する：
  - [ ] UIテキストはプロジェクト設定言語か？
  - [ ] バリデーションメッセージに明示的な `message` が設定されているか？
  - [ ] Enum/ステータスはラベルマップ経由で表示されているか？
  - [ ] `aria-label` / `alt` はプロジェクト設定言語か？
  - [ ] ログメッセージは英語か？
  - [ ] 新規翻訳キーは用語集と整合しているか？

### 30.3. 言語プロトコル違反の段階的是正

- **Rule 74.308**: 言語プロトコル違反の是正は以下の優先順位で行う：
  1. **P0（即座修正）**: ユーザー対面の英語漏出（バリデーション、エラーメッセージ）
  2. **P1（次スプリント）**: 隠しテキストの英語残存（`aria-label`, `alt`）
  3. **P2（計画的）**: ログ言語の不統一、コミットメッセージの不統一

---

## Part XXXI: 文字エンコーディング・Unicode安全性

### 31.1. エンコーディング基本規約

- **Rule 74.310**: プロジェクト全体で **UTF-8** をデフォルトエンコーディングとして統一する
- **Rule 74.311**: BOM（Byte Order Mark）は、Excel互換が必要なCSV出力を除き**使用しない**
- **Rule 74.312**: ファイル保存時に**UTF-8（BOMなし）**を自動適用する `.editorconfig` 設定を必須とする

```ini
# .editorconfig
[*]
charset = utf-8

[*.csv]
charset = utf-8-bom
```

### 31.2. Unicode正規化

- **Rule 74.313**: ユーザー入力のテキストは、保存前に **NFC（Canonical Decomposition followed by Canonical Composition）** で正規化する
- **Rule 74.314**: 検索・比較処理では、NFCに正規化した上で実行する
  - 根拠: macOSはNFD、WindowsはNFCを使用するため、正規化しないと「が」（U+304C）と「か」+「゛」（U+304B + U+3099）が不一致になる

### 31.3. 危険文字・制御文字の排除

- **Rule 74.315**: ユーザー入力からゼロ幅文字（ZWJ, ZWNJ, ZWSP等）を除去または検知する
- **Rule 74.316**: ユーザー名・表示名でのHomograph Attack（同形異義文字攻撃）対策を実装する
  - 例: ラテン文字の `a` とキリル文字の `а`（見た目同一だが異なるコードポイント）
- **Rule 74.317**: 双方向テキスト制御文字（RLO, LRO, RLE, LRE, PDF等）のサニタイズを実施する

### 31.4. 絵文字の整合性

- **Rule 74.318**: 絵文字のクロスプラットフォーム表示差異を考慮し、重要な意味を持つUIで絵文字のみに依存しない
- **Rule 74.319**: 絵文字を使用する場合は `aria-label` でテキスト代替を提供する

---

## Part XXXII: ジェンダーインクルーシブ・インクルーシブ言語

### 32.1. ジェンダーニュートラル表現

- **Rule 74.320**: UIテキスト・ドキュメントでジェンダーニュートラル表現を使用する
  - 英語: `they/them` を単数代名詞として使用、`chairman` → `chairperson`
  - 日本語: 性別を前提としない表現を使用（「彼/彼女」→ 「その方」「ご本人」）

### 32.2. インクルーシブ技術用語

- **Rule 74.321**: 技術用語でインクルーシブな代替を使用する：

| ❌ 旧来の用語 | ✅ インクルーシブな代替 |
|---|---|
| master/slave | primary/replica, leader/follower |
| whitelist/blacklist | allowlist/denylist |
| sanity check | confidence check, validation |
| dummy | placeholder, sample |

### 32.3. AI生成テキストのバイアス検出

- **Rule 74.322**: AI生成のUIテキスト・コンテンツに対し、ジェンダーバイアス・文化的バイアスの検出を実施する
- **Rule 74.323**: バイアス検出ツール（Dottxt/Guardrails等）との統合を推奨する

### 32.4. 文化的配慮ガイドライン

- **Rule 74.324**: 多文化対応プロジェクトでは、以下の文化的配慮を遵守する：
  - 色彩の文化的意味（赤=危険は普遍的ではない）
  - ジェスチャー・アイコンの文化依存性
  - 日付形式の順序（MM/DD vs DD/MM vs YYYY/MM/DD）
  - 名前の構造（姓→名 vs 名→姓、ミドルネームの有無）

### 32.5. インターセクショナリティ考慮

- **Rule 74.324A**: 個人は複数のアイデンティティを持つ（intersectionality）ことを認識し、単一のAttributeで人を分類する表現を避ける
- **Rule 74.324B**: Identity-first言語（「障害者」）と Person-first言語（「障害のある人」）の選択は、対象コミュニティの好みを尊重する
- **Rule 74.324C**: フォームの個人情報入力欄は、自由記述オプションを提供し、回答しない選択肢も用意する。「Full name」をデフォルトとし、姓・名の分離を強制しない

---

## Part XXXIII: リアルタイム・WebSocket・SSE言語プロトコル

### 33.1. リアルタイムイベントの言語

- **Rule 74.330**: WebSocket/SSE経由で送信されるリアルタイムイベントは以下のルールに従う：
  - **ユーザー向けメッセージ**: プロジェクト設定言語
  - **システムイベント（heartbeat, reconnect等）**: 英語
  - **イベントタイプ名**: 英語（`message`, `notification`, `status_change`）

### 33.2. チャット・メッセージの言語検出

- **Rule 74.331**: マルチユーザーチャット機能では、各メッセージの言語は送信者の言語設定に依存する（翻訳不要）
- **Rule 74.332**: システム生成のチャットメッセージ（参加通知、退出通知等）は受信者のプロジェクト設定言語で表示する

### 33.3. ライブ翻訳フロー

- **Rule 74.333**: リアルタイム翻訳が必要な場合、翻訳はサーバーサイドで実行し、翻訳済みテキストをクライアントに配信する
- **Rule 74.334**: 翻訳遅延が発生する場合、原文を先に表示し翻訳完了後に差し替えるプログレッシブ表示を実装する

---

## Part XXXIV: マイクロフロントエンド・モジュールフェデレーションi18n

### 34.1. 翻訳リソースの共有戦略

- **Rule 74.340**: マイクロフロントエンドアーキテクチャでは、翻訳リソースの共有レイヤーを定義する：
  - **共有層**: 全マイクロフロントエンドで共通の翻訳（ナビゲーション、フッター、共通ボタン等）
  - **固有層**: 各マイクロフロントエンド固有の翻訳

### 34.2. 翻訳キー名前空間の衝突回避

- **Rule 74.341**: 各マイクロフロントエンドの翻訳キーにプレフィックスを付与し、名前空間の衝突を防止する
  - `mfe-auth.login.title`, `mfe-dashboard.overview.title`
- **Rule 74.342**: 共有翻訳キーは `shared.` プレフィックスを使用する

### 34.3. Module Federation での翻訳ロード

- **Rule 74.343**: Module Federation使用時は、翻訳リソースをリモートエントリーとして公開し、ホストアプリケーションが動的にロードする
- **Rule 74.344**: 翻訳リソースのバージョン不整合を検出し、新しいバージョンの自動取得を実装する

---

## Part XXXV: AI翻訳品質保証・LQA

### 35.1. AI翻訳の品質基準

- **Rule 74.350**: AI（LLM）による翻訳出力は、以下のLQA（Linguistic Quality Assurance）基準を満たさなければならない：
  - **正確性**: 原文の意味が正確に伝わること
  - **流暢性**: ターゲット言語として自然で読みやすいこと
  - **用語一貫性**: プロジェクト用語集との整合
  - **文体適合性**: Voice & Tone ガイドライン（Part V §5.3）への準拠

### 35.2. MQMスコアリング

- **Rule 74.351**: 多言語品質メトリクス（MQM: Multidimensional Quality Metrics）フレームワークに基づき翻訳品質を定量評価する
- **Rule 74.352**: MQMエラー分類：

| カテゴリ | サブカテゴリ | 重大度 |
|---|---|---|
| 正確性 | 誤訳・追加・省略 | Critical/Major |
| 流暢性 | 文法・句読点・スペル | Major/Minor |
| 用語 | 一貫性・プロジェクト用語 | Major |
| スタイル | ガイドライン違反 | Minor |
| ロケール | フォーマット・単位 | Major |

### 35.3. 人間レビューとのハイブリッドワークフロー

- **Rule 74.353**: AI翻訳のワークフローは以下の3段階を標準とする：
  1. **AI翻訳**: LLMによる初期翻訳生成
  2. **自動QA**: 用語集チェック・スタイルチェック・MQMスコアリング
  3. **人間レビュー**: ドメイン専門家またはUXライターによる最終確認
- **Rule 74.354**: クリティカルなUI文言（法務関連・安全関連・ブランドメッセージ）は**人間レビュー必須**

### 35.4. AI翻訳のフィードバックループ

- **Rule 74.355**: AI翻訳の修正履歴をフィードバックデータとして蓄積し、翻訳品質の継続的改善に活用する
- **Rule 74.356**: 頻出する修正パターンを翻訳メモリ（TM）に登録し、同一パターンの再発を防止する

### 35.5. LLM-as-Judge自動品質評価

- **Rule 74.356A**: LLMを品質判定者（Judge）として使用し、MQMスコアの自動予測やエラータイプの文レベル検出を行う
- **Rule 74.356B**: LLM-as-Judgeの評価結果は参考値であり、最終判断は人間レビュアーが行う（特に法務・安全・ブランド関連）

### 35.6. 翻訳リスク分類とポートフォリオ戦略

- **Rule 74.356C**: コンテンツのリスクレベルに応じて翻訳戦略を分類する：

| リスク | コンテンツ例 | 翻訳戦略 |
|---|---|---|
| **Critical** | 法務文書、安全警告、医療情報 | 人間翻訳必須＋Full PE |
| **High** | UIテキスト、マーケティング、ブランド | AI翻訳＋Full PE＋人間レビュー |
| **Medium** | ヘルプテキスト、FAQ、トゥールチップ | AI翻訳＋Light PE |
| **Low** | 内部ツール、開発者ドキュメント | AI翻訳のみ（監視付き） |

- **Rule 74.356D**: 複数の翻訳エンジンを併用するポートフォリオ戦略を推奨する。コンテンツタイプ・言語ペアに応じた自動ルーティングで品質とコストを最適化する

---

## Part XXXVI: 音声UI・TTS/SSML言語プロトコル

### 36.1. TTS（Text-to-Speech）言語制御

- **Rule 74.360**: TTS出力の言語はプロジェクト設定言語をデフォルトとする
- **Rule 74.361**: セッション中の言語切替が発生する場合、SSML `<lang>` タグで明示的に言語を指定する
- **Rule 74.362**: TTS音声の選択はプロジェクト設定言語のネイティブスピーカー音声を使用する

### 36.2. SSMLマークアップ言語要件

- **Rule 74.363**: SSML（Speech Synthesis Markup Language）を使用する場合、`xml:lang` 属性を必ず設定する
- **Rule 74.364**: 外国語固有名詞の読み上げには `<phoneme>` タグまたは `<say-as>` タグで発音を制御する

```xml
<!-- ✅ SSML 言語切替例 -->
<speak xml:lang="ja-JP">
  こんにちは。
  <lang xml:lang="en-US">Welcome to our service.</lang>
  ご利用ありがとうございます。
</speak>

<!-- ✅ 外国語固有名詞の発音制御 -->
<speak xml:lang="ja-JP">
  <phoneme alphabet="ipa" ph="ɡuːɡl">Google</phoneme>のサービスです。
</speak>
```

### 36.3. 音声アシスタントプラットフォーム対応

- **Rule 74.365**: Alexa Skills / Google Actions の対話モデルはプロジェクト設定言語で定義する
- **Rule 74.366**: 音声アシスタントのインテント名・スロットタイプ名は**英語**（技術レイヤー）
- **Rule 74.367**: ユーザーインタラクションの発話モデル（サンプル発話）は**プロジェクト設定言語**

### 36.4. 音声UIのエラーメッセージ

- **Rule 74.368**: 音声UIのエラーメッセージはPart VIIIの階層に従い、ユーザー向けメッセージはプロジェクト設定言語
- **Rule 74.369**: 聞き取りやすさを考慮し、音声用メッセージは短文・明瞭・繰り返し構造を推奨する

---

## Part XXXVII: サーバーレス・エッジコンピューティング言語ポリシー

### 37.1. Edge Functions言語リソース管理

- **Rule 74.370**: Edge Functions（Cloudflare Workers, Vercel Edge Functions, Lambda@Edge等）での翻訳リソースは、エッジキャッシュに言語バリアントとして保持する
- **Rule 74.371**: エッジでの言語検出は `Accept-Language` ヘッダーまたは Geo-IP に基づく
- **Rule 74.372**: 翻訳リソースのエッジキャッシュキーに言語コードを含める（`cache-key: /page:ja`, `/page:en`）

### 37.2. Geo-based言語ルーティング

- **Rule 74.373**: CDN / Edge Router レベルでの言語ルーティングはユーザー設定言語を優先し、Geo-IPはフォールバックとする
- **Rule 74.374**: Geo-based言語推定の上書きオプション（言語切替UI）を必ず提供する

### 37.3. サーバーレス関数の言語コンテキスト

- **Rule 74.375**: サーバーレス関数のイベントペイロードに言語コンテキスト（`locale`, `language`）を含める
- **Rule 74.376**: 関数チェーン（Step Functions, Workflows）では言語コンテキストをステート全体で伝搬する

### 37.4. エッジSSR/ISRの言語対応

- **Rule 74.377**: Edge SSR（Server-Side Rendering）でのページ生成時、翻訳リソースのロードはCold Start時間に影響するため、クリティカル翻訳のみバンドルに含める
- **Rule 74.378**: ISR（Incremental Static Regeneration）では言語別にキャッシュを分離する

---

## Part XXXVIII: 3D・メタバース・空間コンピューティング言語

### 38.1. Spatial UIテキストの言語

- **Rule 74.380**: visionOS / Meta Quest / WebXR 等の3D空間UIテキストは**プロジェクト設定言語**
- **Rule 74.381**: 3D空間でのテキストレンダリングは、フォント埋め込みによりCJKグリフの欠落を防止する
- **Rule 74.382**: 空間UIのテキストサイズは視距離に応じた可読性を保証する（最小角度サイズ基準）

### 38.2. XRコンテンツの言語メタデータ

- **Rule 74.383**: glTF / USD 等の3Dアセットメタデータに言語情報を含める
- **Rule 74.384**: AR（拡張現実）オーバーレイのテキストはプロジェクト設定言語

### 38.3. 空間音声の言語

- **Rule 74.385**: 空間オーディオの音声ガイド・ナレーションはプロジェクト設定言語
- **Rule 74.386**: 字幕・キャプション表示は空間UI内でユーザーの視界に追従し、プロジェクト設定言語で表示する

---

## Part XXXIX: ヘルスケア・規制対象ドメイン固有言語

### 39.1. 医療ドメイン言語要件

- **Rule 74.390**: HL7 FHIR リソースの `language` フィールドはプロジェクト設定言語のBCP 47タグを設定する
- **Rule 74.391**: 医療用語の翻訳は SNOMED CT / ICD-11 の公式日本語版に準拠する
- **Rule 74.392**: 患者向けUI（ポータル、検査結果表示）は**プロジェクト設定言語**必須。医学略語の展開を提供する

### 39.2. 金融ドメイン言語要件

- **Rule 74.393**: SWIFT / ISO 20022 メッセージのフィールドは**英語**（国際標準）
- **Rule 74.394**: 金融規制文書（重要事項説明書等）は法令で定められた言語で提供する
- **Rule 74.395**: 通貨表示は `Intl.NumberFormat` によるロケール対応（Part VII §7.5準拠）

### 39.3. 規制コンプライアンス言語

- **Rule 74.396**: GDPR / APPI / CCPA 等のプライバシーポリシーは対象ユーザーの言語で提供する義務がある
- **Rule 74.397**: FDA / PMDA 等の規制当局への提出文書の言語は規制要件に従う

---

## Part XL: サードパーティSDK・ウィジェット言語統制

### 40.1. 決済SDK言語設定

- **Rule 74.400**: Stripe Elements の `locale` パラメータをプロジェクト設定言語に設定する
- **Rule 74.401**: PayPal / Square 等の決済ウィジェットの表示言語をプロジェクト設定言語に統一する
- **Rule 74.402**: 決済SDKのエラーメッセージがデフォルト英語で表示される場合、カスタムエラーハンドリングで翻訳する

### 40.2. 地図・位置情報SDK

- **Rule 74.403**: Google Maps JavaScript API の `language` パラメータをプロジェクト設定言語に設定する
- **Rule 74.404**: Mapbox / leaflet 等の地図SDKも同様に言語設定を統一する

### 40.3. 認証・セキュリティウィジェット

- **Rule 74.405**: reCAPTCHA の `hl` パラメータをプロジェクト設定言語に設定する
- **Rule 74.406**: OAuth同意画面のカスタマイズ可能なテキストはプロジェクト設定言語

### 40.4. カスタマーサポートウィジェット

- **Rule 74.407**: Intercom / Zendesk / Freshdesk 等のチャットウィジェットの表示言語をプロジェクト設定言語に設定する
- **Rule 74.408**: サードパーティウィジェットの言語設定が不可能な場合、ドキュメントに制約として記録する

### 40.5. 言語設定の一元管理

- **Rule 74.409**: すべてのサードパーティSDKの言語設定を一元管理する設定ファイルまたは環境変数を定義する

```typescript
// ✅ サードパーティSDK言語設定の一元管理
const LOCALE_CONFIG = {
  projectLanguage: 'ja',
  stripe: { locale: 'ja' },
  googleMaps: { language: 'ja', region: 'JP' },
  recaptcha: { hl: 'ja' },
  intercom: { language_override: 'ja' },
} as const;
```

---

## Part XLI: 翻訳コスト管理・FinOps言語

### 41.1. 翻訳API利用量監視

- **Rule 74.410**: 翻訳API（Google Translate API, DeepL API, OpenAI等）の利用量・コストを月次で監視する
- **Rule 74.411**: 翻訳APIコストの予算上限（バジェットアラート）を設定する
- **Rule 74.412**: 不要な翻訳API呼び出し（同一テキストの重複翻訳等）をキャッシュで防止する

### 41.2. AI翻訳 vs 人間翻訳 コスト比較

- **Rule 74.413**: コンテンツタイプ別のAI翻訳/人間翻訳のコスト対効果を定期的に評価する

| 指標 | AI翻訳 | 人間翻訳 |
|---|---|---|
| 1語あたりコスト | 低（$0.001〜0.02） | 高（$0.05〜0.30） |
| ターンアラウンド | 秒〜分 | 時間〜日 |
| 品質（一般テキスト） | 高 | 最高 |
| 品質（法務/ブランド） | 中〜高 | 最高 |
| スケーラビリティ | 高 | 低 |

### 41.3. 翻訳ROI測定

- **Rule 74.414**: 翻訳投資のROIを以下の指標で測定する：
  - ユーザー満足度（NPS/CSATの言語別比較）
  - サポートチケット削減率（言語品質向上による）
  - コンバージョン率の言語別差異
- **Rule 74.415**: 翻訳コストダッシュボードを構築し、言語別・コンテンツタイプ別のコスト推移を可視化する

---

## Part XLII: 言語関連インシデント対応

### 42.1. インシデント定義

- **Rule 74.420**: 以下を言語関連インシデントとして定義する：
  - **P0（緊急）**: 法務文書・安全警告の翻訳欠落が本番に流出
  - **P1（重大）**: ユーザー対面のUI全体で英語が大量に残存
  - **P2（中）**: 特定画面のバリデーションメッセージが英語で表示
  - **P3（軽微）**: `aria-label` や `alt` テキストの翻訳漏れ

### 42.2. インシデント対応フロー

- **Rule 74.421**: 言語関連インシデントの対応フロー：

```
1. 検知 → CI/ユーザー報告/モニタリングアラート
2. トリアージ → 重大度分類（P0〜P3）
3. 即時対応 → フォールバックテキスト適用 or ホットフィックス
4. 根本対応 → 翻訳リソース追加・CIルール強化
5. ポストモーテム → 再発防止策の文書化
```

### 42.3. ポストモーテムと再発防止

- **Rule 74.422**: P0/P1インシデントでは必ずポストモーテムを実施し、以下を文書化する：
  - 発生原因（CIゲートの欠落、レビュー漏れ等）
  - 影響範囲（影響を受けたユーザー数・画面数）
  - 再発防止策（CIルール追加、チェックリスト更新等）
- **Rule 74.423**: ポストモーテムの教訓は `010_project_lessons_log.md` に記録する

---

## Part XLIII: 音声認識（STT）入力言語プロトコル

### 43.1. 音声入力の言語検出

- **Rule 74.430**: 音声入力機能では、認識対象言語を明示的に指定する（自動言語検出に依存しない）
- **Rule 74.431**: デフォルトの認識言語はプロジェクト設定言語とする
- **Rule 74.432**: 多言語音声入力が必要な場合、言語切替UIを提供する

### 43.2. STT結果のテキスト変換

- **Rule 74.433**: 音声認識結果のテキストはNFC正規化を適用する（Part XXXI §31.2準拠）
- **Rule 74.434**: 音声認識の確信度が低い場合、ユーザーに確認UIを表示する（プロジェクト設定言語）

### 43.3. 音声コマンドの言語設計

- **Rule 74.435**: 音声コマンド（ウェイクワード、アクションコマンド）はプロジェクト設定言語で設計する
- **Rule 74.436**: 技術用語の音声入力に対しては、発音バリエーション（「ワイファイ」「WiFi」等）を辞書登録する

---

## Appendix A: 逆引き索引

### トピック別クイックリファレンス

| やりたいこと | 参照先 |
|---|---|
| UI/ボタン/ラベルの言語を知りたい | Part V: UI/UXローカライゼーション義務 |
| バリデーションエラーメッセージの書き方 | Part VII §7.1 |
| Enumやステータスの表示方法 | Part VII §7.3 |
| エラーメッセージの言語判断 | Part VIII: エラーハンドリング言語階層 |
| APIレスポンスの言語 | Part IX: API応答言語ポリシー |
| ログの言語 | Part XII §12.1 |
| コミットメッセージの書き方 | Part IV §4.1 |
| PRの言語 | Part IV §4.3 |
| AIエージェントの言語 | Part XI |
| テストコードの言語 | Part XIII |
| 翻訳すべきか判断に迷う | Part XVII: 翻訳除外ポリシー |
| CIで言語品質を担保したい | Part XVIII: CI/CD言語品質ゲート |
| メール/通知の言語 | Part X: 通知ポリシー |
| SEOメタデータの言語 | Part XV: SEO・構造化データ言語 |
| アクセシビリティの言語 | Part XVI: アクセシビリティ言語要件 |
| 型安全な翻訳キーを設計したい | Part XIX: 型安全i18n・翻訳キー設計 |
| AI間通信の言語ルール | Part XX: AI間通信・A2A言語プロトコル |
| LLM出力の言語を強制したい | Part XXI: 多言語安全性ガードレール |
| PDF/CSV出力の言語 | Part XXII: PDF・CSV・帳票エクスポート言語 |
| 利用規約の翻訳ルール | Part XXIII: 法務文書言語ガバナンス |
| モバイルアプリの言語設定 | Part XXIV: モバイル固有言語プロトコル |
| DB/テーブル/カラム名の言語 | Part XXVI: DB・インフラ言語ポリシー |
| デザイントークンのi18n対応 | Part XXVII: デザインシステムi18n |
| 翻訳ファイル障害時の対応 | Part XXVIII: エラーリカバリ |
| 翻訳リソースのパフォーマンス | Part XXIX: パフォーマンス最適化 |
| チームへの言語ルール教育 | Part XXX: チーム教育 |
| 文字エンコーディングの安全対策 | Part XXXI: Unicode安全性 |
| ジェンダーインクルーシブ表現 | Part XXXII: インクルーシブ言語 |
| リアルタイムの言語ルール | Part XXXIII: WebSocket言語プロトコル |
| マイクロフロントエンドの翻訳共有 | Part XXXIV: MFE i18n |
| AI翻訳の品質保証 | Part XXXV: AI翻訳品質保証・LQA |
| 音声UI・TTS/SSMLの言語ルール | Part XXXVI: 音声UI・TTS/SSML言語プロトコル |
| エッジコンピューティングの言語設定 | Part XXXVII: サーバーレス・エッジ言語ポリシー |
| 3D/XR空間の言語ルール | Part XXXVIII: 3D・メタバース言語 |
| 医療・金融の言語要件 | Part XXXIX: ヘルスケア・規制ドメイン言語 |
| 外部SDKの言語設定 | Part XL: サードパーティSDK言語統制 |
| 翻訳コストの管理 | Part XLI: 翻訳コストFinOps |
| 言語インシデントへの対応 | Part XLII: インシデント対応 |
| 音声認識入力の言語ルール | Part XLIII: 音声認識STT言語プロトコル |
| 言語プロトコルの成熟度評価 | Part XXV §25.1 |
| よくあるアンチパターン | Part XXV §25.2 |

### クロスリファレンス（関連ルール）

| 関連ルール | 参照内容 | 本ルールとの境界 |
|---|---|---|
| [000_core_mindset.md](./000_core_mindset.md) | ゼロ・トレランス原則 | 本ルールは言語面でのゼロ・トレランスを具体化 |
| [200_design_ux.md](./200_design_ux.md) | アクセシビリティ・UX基準 | 本ルールは言語側面のアクセシビリティに特化 |
| [300_engineering_standards.md](./300_engineering_standards.md) | コーディング規約 | 本ルールは言語選択基準に特化 |
| [301_api_integration.md](./301_api_integration.md) | API設計基準 | 本ルールはAPIの言語ポリシーに特化 |
| [320_supabase_architecture.md](./320_supabase_architecture.md) | DB設計基準 | 本ルールはDB命名の言語ポリシーに特化 |
| [400_ai_engineering.md](./400_ai_engineering.md) | AI実装戦略 | 本ルールはAI通信の言語プロトコルに特化 |
| [501_customer_experience.md](./501_customer_experience.md) | メール送信基準 | 本ルールは通知の言語ポリシーに特化 |
| [600_security_privacy.md](./600_security_privacy.md) | セキュリティ基準 | 本ルールは多言語安全性ガードレールに特化 |
| [800_internationalization.md](./800_internationalization.md) | i18nアーキテクチャ・L10n基盤 | 71=国際展開のインフラ、74=言語使い分けルール |
| [801_governance.md](./801_governance.md) Part XXII | ルール翻訳ガバナンス | 72=ルール自体の翻訳管理、74=プロダクトの言語プロトコル |

---
