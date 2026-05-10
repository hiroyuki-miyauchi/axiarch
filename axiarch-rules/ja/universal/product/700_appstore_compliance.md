# 13. ストアガイドラインとコンプライアンス (Store Guidelines & Compliance)

> [!CAUTION]
> **このファイルは Universal Rule（不変ルール）です。「憲法改正」の明示的指示がない限り編集禁止。**
> 改定日: 2026-05-06

> [!IMPORTANT]
> **Supreme Directive（最高指令）**
> 「ストアコンプライアンスはオプションではない — ゲートでの拒否はユーザーゼロを意味する」
> すべてのアプリストア提出は最新のプラットフォームガイドラインに準拠しなければならない。
> **プラットフォーム規約 > ユーザー信頼 > 機能ベロシティ** の優先順位を厳守せよ。
> **20 Part / 約 80+ ルール構成。**

---

## 目次 (Table of Contents)

| # | Part | 主要トピック |
|---|---|---|
| 0 | Supreme Directive & Scope Manifesto | 守備範囲・優先順位・除外ドメイン |
| 1 | Apple App Store — HIG & Design Compliance | HIG 準拠・Dark Mode・Dynamic Type |
| 2 | Apple Privacy Stack | ATT / Privacy Manifests / Required Reason API / Privacy Nutrition Labels |
| 3 | Apple In-App Purchase & Subscriptions | IAP 義務・Auto-Renewable・Win-back・StoreKit 2 |
| 4 | Apple Identity | Sign in with Apple / Account Deletion 5.1.1(v) |
| 5 | Apple Submission & Review | TestFlight / Phased Release / Expedited / Appeal |
| 6 | Google Play — Console Policies & Target API Annual | Target API 年次更新・サブスクポリシー |
| 7 | Google Play — Data Safety & Privacy Disclosure | Data Safety section・Privacy Policy URL |
| 8 | Google Play Billing & Subscriptions | Play Billing Library 7+・Real-time Developer Notifications |
| 9 | Google Play — Distribution | AAB 必須化・Closed/Open/Internal Testing・Phased Rollout |
| 10 | Google Play Integrity & Anti-Tamper | Play Integrity API・SafetyNet 廃止 |
| 11 | Children's & Family Apps | COPPA / Apple Kids / Designed for Families |
| 12 | Platform API Terms | Maps / YouTube / APNs / FCM |
| 13 | ASO (App Store Optimization) | キーワード戦略・A/B Test・スクリーンショット・動画 |
| 14 | Localization & Internationalization for Stores | App Store Connect / Play Console ローカライズ |
| 15 | DMA Compliance (EU Digital Markets Act) | Alternative Marketplaces / Sideloading / DMA Core Functions |
| 16 | Generative AI App Compliance | Apple/Google の GenAI 規約・有害コンテンツ防止 |
| 17 | Specialized Verticals | Health / Finance / Crypto / Games |
| 18 | Common Rejections & Pre-Submission Master Checklist | リジェクト多発項目・申請前チェック |
| 19 | Anti-Pattern Catalog | 禁則行為統合表 |
| App A | Reverse Index | キーワード逆引き索引 |
| App B | Cross-References | 他ドメイン Universal Rule との接続 |

---

## Part 0: Supreme Directive & Scope Manifesto（守備範囲）

### 0.1. このファイルの守備範囲

✅ **抽出基準（含める）**:
- アプリストア（Apple App Store / Google Play）への提出に必要なガイドライン準拠
- ストア固有の Privacy / Billing / Identity / Distribution 仕組み
- アプリ単独で完結するコンプライアンス（HIG / Material Design・ASO）
- ストアの審査プロセス・申請前チェック
- DMA（Digital Markets Act）等の地域横断規制

❌ **残置基準（含めない・各ドメインファイル参照）**:
- 一般的な GDPR/CCPA → `security/100_data_governance.md`
- セキュアコーディング・Zero Trust → `security/000_security_privacy.md`
- 決済処理アーキテクチャ → `product/300_revenue_monetization.md`
- ユニットエコノミクス・LTV → `product/000_product_strategy.md`
- 国際化（i18n/L10n）一般論 → `product/800_internationalization.md`
- ネイティブ実装の SDK 詳細 → `engineering/410_native_platforms.md` / `engineering/400_mobile_flutter.md`

### 0.2. 優先順位の階層

**プラットフォーム規約 > ユーザー信頼 > 機能ベロシティ > 開発便利**

理由: ストア審査でリジェクトされた瞬間、ユーザーゼロ。プラットフォーム規約は **法と同等の拘束力**。

---

## Part 1: Apple App Store — HIG & Design Compliance（HIG とデザイン）

### 1.1. Human Interface Guidelines (HIG) 準拠

- **Law**: 全 iOS / iPadOS / visionOS / macOS / watchOS / tvOS アプリは Apple HIG に準拠する。
- **Required Compliance**:
  - **Standard Components 優先**: `UIKit` / `SwiftUI` の標準コンポーネントを優先採用。独自カスタム UI は HIG レビューチェックを通過する根拠を持つこと。
  - **戻る操作の保証**: スワイプ戻る（Edge Swipe）または明示的「戻る」ボタンを必ず提供。Tab Bar 内で戻る経路を奪わない。
  - **タップターゲット**: 最小 44×44pt（Apple 公式仕様）。狭すぎると即リジェクト。
  - **Safe Area & Dynamic Island**: Notch / Dynamic Island / ホームインジケータを覆わない。`safeAreaInset` を遵守。
- **Anti-Pattern**:
  - システム標準と紛らわしい偽ボタン（"設定" を装ったシェアボタン等）→ Guideline 4.0 違反、即リジェクト
  - 戻る経路が無い詰み画面（Dead End Screen）

### 1.2. Dark Mode 義務

- **Law**: iOS 13+ 対応アプリは **Dark Mode 必須**（2026 年現在の事実上の標準）。
- **Implementation**:
  ```swift
  // SwiftUI: Asset Catalog で Light/Dark カラーを定義
  Color("BackgroundPrimary") // 自動切替

  // UIKit
  view.backgroundColor = UIColor(named: "BackgroundPrimary")
  ```
- **Verification**: Xcode の Environment Override で Light/Dark 双方を確認、スクリーンショットも双方提出推奨。

### 1.3. Dynamic Type 義務（アクセシビリティ）

- **Law**: iOS のシステムフォントサイズ設定（最小 xSmall 〜 最大 AX5）に追従する。固定フォントサイズは **EAA 違反** にも該当（§1.10 参照、`security/000_security_privacy` クロスリファレンス）。
- **Implementation**:
  ```swift
  Text("Hello").font(.body)  // SwiftUI: 自動スケール
  label.font = UIFont.preferredFont(forTextStyle: .body)
  label.adjustsFontForContentSizeCategory = true
  ```

### 1.4. Live Activities / Widget / App Intents の準拠

- **Live Activities** (iOS 16.1+): `ActivityKit` を使用。Lock Screen と Dynamic Island の両表示を必須サポート。
- **Widget**: WidgetKit で実装、TimelineProvider で更新ポリシー定義。
- **App Intents** (iOS 16+): Siri / Spotlight / Shortcuts 統合義務（音声 UX 提供アプリ）。

### 1.5. visionOS / Spatial Computing 準拠（2024+）

- **Required**: visionOS 1.0+ 向けには Window / Volume / Immersive Space の使い分けを明確化。
- **Comfort**: VR 酔い対策として 60fps 維持・急激な視点移動を避ける。

### 1.6. アクセシビリティ義務（Apple A11y）

- **VoiceOver 必須対応**: 全インタラクティブ要素に `accessibilityLabel` を設定。`accessibilityIdentifier` で UI test 対応も。
- **Voice Control**: ボタン/リンクのラベルが読み上げ可能か検証。
- **Switch Control / AssistiveTouch**: フォーカス順序を論理的に維持。
- **Reduce Motion / Reduce Transparency**: ユーザー設定を尊重（`accessibilityReduceMotion`）。

### 1.7. クロスリファレンス
- §1.13 Accessibility-by-Design Protocol（`core/000_core_mindset.md`）
- `engineering/410_native_platforms.md` SwiftUI 実装詳細
- `design/000_design_ux.md` HIG/Material Design 統合

---

## Part 2: Apple Privacy Stack — ATT / Privacy Manifests / Required Reason API / Privacy Nutrition Labels

### 2.0. Apple Privacy 4 層モデル（2024+）

| 層 | 仕組み | 必須化時期 |
|---|---|---|
| L1 | **App Privacy Details**（Nutrition Labels） | 2020 年〜全アプリ必須 |
| L2 | **App Tracking Transparency (ATT)** | 2021 年〜IDFA 取得時必須 |
| L3 | **Privacy Manifests** (`PrivacyInfo.xcprivacy`) | 2024 年〜サードパーティ SDK / 主要 API 必須 |
| L4 | **Required Reason API** | 2024 年〜特定 API 使用時に申告必須 |

これら 4 層は **重複ではなく多層防御**。すべて遵守必須。

### 2.1. App Tracking Transparency (ATT) Protocol

- **Law**: 他社アプリ・サイトを横断したユーザー追跡（IDFA / 第三者クッキー / フィンガープリンティング）を行う場合、**`ATTrackingManager` で許諾を取得する義務**。許諾なしの追跡は Guideline 5.1.2 違反 → 即リジェクト。
- **Implementation**:
  ```swift
  import AppTrackingTransparency

  func requestTrackingPermission() async {
    let status = await ATTrackingManager.requestTrackingAuthorization()
    switch status {
    case .authorized: // IDFA 利用可能
      let idfa = ASIdentifierManager.shared().advertisingIdentifier
    case .denied, .restricted: // IDFA はゼロ UUID
      // SKAdNetwork / AdAttributionKit にフォールバック
    case .notDetermined: break
    @unknown default: break
    }
  }
  ```
- **NSUserTrackingUsageDescription**（`Info.plist` 必須）:
  ```xml
  <key>NSUserTrackingUsageDescription</key>
  <string>パーソナライズされた広告を提供するため、許可をお願いします</string>
  ```
- **Anti-Pattern 厳禁**:
  - ATT ダイアログを **再表示しない**（OS 仕様、強制再表示は Guideline 違反）
  - 「許諾しないとアプリが使えない」誘導 → 即リジェクト
  - フィンガープリンティング（Device Info を組み合わせて識別）→ `IDFV` でも追跡目的なら ATT 必須

### 2.2. Privacy Manifests (`PrivacyInfo.xcprivacy`) Mandate

- **Law**: 全アプリ・全サードパーティ SDK は `PrivacyInfo.xcprivacy` を含めなければならない（2024 年 5 月以降の App Store 提出で必須化）。
- **必須 4 セクション**:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" ...>
  <plist version="1.0">
  <dict>
    <!-- 1. プライバシーで保護されたデータの種類 -->
    <key>NSPrivacyCollectedDataTypes</key>
    <array>
      <dict>
        <key>NSPrivacyCollectedDataType</key>
        <string>NSPrivacyCollectedDataTypeEmailAddress</string>
        <key>NSPrivacyCollectedDataTypeLinked</key>
        <true/>
        <key>NSPrivacyCollectedDataTypeTracking</key>
        <false/>
        <key>NSPrivacyCollectedDataTypePurposes</key>
        <array>
          <string>NSPrivacyCollectedDataTypePurposeAppFunctionality</string>
        </array>
      </dict>
    </array>

    <!-- 2. 追跡の有無 -->
    <key>NSPrivacyTracking</key>
    <false/>

    <!-- 3. 追跡ドメイン（ATT 拒否時にブロックすべきドメイン） -->
    <key>NSPrivacyTrackingDomains</key>
    <array>
      <string>tracking.example.com</string>
    </array>

    <!-- 4. Required Reason API の使用申告 -->
    <key>NSPrivacyAccessedAPITypes</key>
    <array>
      <dict>
        <key>NSPrivacyAccessedAPIType</key>
        <string>NSPrivacyAccessedAPICategoryFileTimestamp</string>
        <key>NSPrivacyAccessedAPITypeReasons</key>
        <array>
          <string>C617.1</string>
        </array>
      </dict>
    </array>
  </dict>
  </plist>
  ```
- **Validation**: Xcode 15+ で `Privacy Report` 自動生成。アプリ + 全 SDK の宣言をマージしてレポート化。
- **責任**: SDK ベンダーが Privacy Manifest を提供しない場合、**そのアプリは提出不可**。代替 SDK を選定するか、ベンダーに対応依頼。

### 2.3. Required Reason API（理由必須 API）の宣言

- **Law**: 以下のカテゴリの API を使用する際は、`NSPrivacyAccessedAPITypeReasons` で正当な理由コードを宣言する義務。
- **対象 API カテゴリ（4 種、2026 年現在）**:

  | カテゴリ | 例 | 用途例（Reason Code） |
  |---|---|---|
  | **File Timestamp** | `creationDate`, `modificationDate` | `C617.1` 表示用、`DDA9.1` 検索インデックス用 |
  | **System Boot Time** | `mach_absolute_time` | `35F9.1` パフォーマンス計測 |
  | **Disk Space** | `volumeAvailableCapacity` | `85F4.1` 容量警告表示 |
  | **Active Keyboard** | `UIInputView` | `8646.1` キーボード切替検知 |
  | **User Defaults** | `UserDefaults` | `CA92.1` アプリ自身の設定保存 |
- **Anti-Pattern**: 「広告 ID 生成のため」「フィンガープリンティング」目的での使用は **明確に禁止**（Apple 規約違反）。

### 2.4. App Privacy Details (Privacy Nutrition Labels)

- **Law**: App Store Connect で **アプリが収集するデータ** をすべて申告する義務（2020 年〜）。
- **3 区分**:

  | 区分 | 例 |
  |---|---|
  | **Data Used to Track You** | 広告 ID（IDFA）、追跡用識別子 |
  | **Data Linked to You** | アカウント ID と紐付くメール・購入履歴 |
  | **Data Not Linked to You** | 集計レベルの利用統計（個人特定不可） |
- **Required Categories**: Contact Info / Health & Fitness / Financial Info / Location / Sensitive Info / Contacts / User Content / Browsing History / Search History / Identifiers / Purchases / Usage Data / Diagnostics / Other Data
- **Verification**: 申告内容と実際の挙動が乖離した場合、**虚偽申告でアカウント停止リスク**。

### 2.5. SKAdNetwork / AdAttributionKit（広告計測フレームワーク）

- **Law**: ATT 拒否ユーザーへの広告計測は、Apple 提供の **SKAdNetwork**（v4.0+）または **AdAttributionKit**（iOS 17.4+）を使用する。
- **特徴**:
  - Conversion Value（10/20 ms 後、24-48h 後の段階的ポストバック）
  - 集計レベル（個人特定不可）
  - SKAN 4.0: Source Identifier（4 桁）、Hierarchical Conversion Values
- **設定**:
  - `Info.plist` に `SKAdNetworkItems` を列挙（広告ネットワーク ID）
  - サーバー側で Postback URL を構成

### 2.6. クロスリファレンス
- `security/100_data_governance.md` — GDPR/CCPA 全般
- `security/000_security_privacy.md` — Zero Trust / 暗号化
- `core/000_core_mindset.md` §1.12 Privacy-by-Architecture

---

## Part 3: Apple In-App Purchase & Subscriptions Deep Dive（IAP・サブスク完全ガイド）

### 3.1. IAP 義務（Guideline 3.1.1）

- **Law**: デジタルコンテンツ・機能・サービスの販売は **必ず In-App Purchase (IAP)** を経由する。外部決済への誘導（Web で購入リンク等）は厳禁。
- **例外（Reader App 特例）**: 雑誌・書籍・音楽・動画・クラウドストレージの「コンテンツアクセス」のみ。アプリ内購入オプション提示は必須。
- **2024+ 緩和（米国・EU）**: 米国 Epic 訴訟結果 + EU DMA により、外部決済リンク掲載の限定許可（要 Entitlement 申請）。ただし **規約は地域ごとに異なる** ため法務確認必須。

### 3.2. StoreKit 2（推奨実装）

- **Law**: 新規実装は **StoreKit 2**（iOS 15+）を採用する。StoreKit 1 はレガシー扱い。
- **Implementation Skeleton**:
  ```swift
  import StoreKit

  // 1. Product 取得
  let products = try await Product.products(for: ["com.example.pro_monthly"])

  // 2. 購入実行
  let result = try await product.purchase()
  switch result {
  case .success(let verification):
    let transaction = try checkVerified(verification)
    await transaction.finish()
  case .userCancelled, .pending: break
  @unknown default: break
  }

  // 3. トランザクション監視（Background）
  Task.detached {
    for await result in Transaction.updates {
      let transaction = try checkVerified(result)
      await unlockContent(for: transaction)
      await transaction.finish()
    }
  }
  ```

### 3.3. Auto-Renewable Subscription 設計

- **Law**: 自動更新サブスクリプション（ARS）は以下の規約を遵守:
  - **明確な価格・期間表示**: 価格・更新周期・解約方法を購入前に明示
  - **無料トライアルの明示**: 「7 日間無料、その後 ¥980/月」のように転換価格を併記
  - **解約は アプリ内 から到達可能**: 「設定 > サブスクリプション」へのリンク提供推奨
- **Subscription Groups**: アプリ内で複数プラン（Basic/Pro/Premium）を Group 化。アップグレード/ダウングレードを定義。
- **Family Sharing 対応**: `isFamilyShareable = true` 設定で家族間共有を有効化。

### 3.4. Promotional Offers / Win-back Offers / Introductory Offers

- **Introductory Offer**: 新規ユーザー向けの初回限定割引（Free Trial / Pay-as-you-go / Pay-up-front）。
- **Promotional Offer**: 既存購読者向けの特別オファー（一時離脱者の引き留め）。Server-side で Signature を生成して提示。
- **Win-back Offer** (iOS 18+): 解約後ユーザーへの自動的な再オファー表示（App Store 自動制御）。

### 3.5. Subscription Lifecycle Events

- **App Store Server Notifications V2**: 購読状態変化（DID_RENEW / DID_FAIL_TO_RENEW / EXPIRED / REFUND）を Webhook で受信。
- **Server-side Verification**: クライアント側のレシート検証ではなく、`App Store Server API` で購読状態を権威的に取得。
- **Required Endpoints**:
  - `notifyURL`: App Store Server からの Webhook 受信
  - `transactionID` ベースで購読状態を取得・更新

### 3.6. Refund Handling

- **Apple Refund Process**: ユーザーが返金を申請 → Apple が判定 → 承認時 `REFUND` Notification 送信。
- **Server-side 必須対応**: `REFUND` 受信時、該当ユーザーの権限を即座に剥奪（クレジット返却ロジック等を含む）。
- **2025+ Server Refund Request API**: 開発者側からも返金リクエスト可能（顧客サポート効率化）。

### 3.7. 価格 Tier とローカライズ

- **App Store Connect の Pricing Tiers**: 100+ 段階の価格を地域別に自動換算。
- **Custom Price Points**: 細かい価格制御が可能（2023+）。
- **Tax-Inclusive vs Exclusive**: 多くの国で **Tax-Inclusive 表示** が必須（日本: 税込み）。

### 3.8. Anti-Pattern 厳禁
- 外部決済への誘導（Reader App 例外を除く）→ 即リジェクト
- 「サブスク解約には電話必要」→ Guideline 違反
- ダーク UX で意図せず購読させる → リジェクト + Apple アカウント停止リスク

### 3.9. クロスリファレンス
- `product/300_revenue_monetization.md` — ASC 606 収益認識・Stripe 等外部決済
- `product/400_pricing_strategy.md` — 価格戦略全般

---

## Part 4: Apple Identity — Sign in with Apple / Account Deletion 5.1.1(v)

### 4.1. Sign in with Apple 義務（Guideline 4.8）

- **Law**: 他のサードパーティ認証（Google/Facebook/X/LINE 等）を提供する場合、**Sign in with Apple も同等のプロミネンスで提供する義務**。
- **例外**: 教育機関・企業内認証専用アプリ、独自 SSO のみのアプリ等。
- **Implementation**:
  ```swift
  import AuthenticationServices

  let appleIDProvider = ASAuthorizationAppleIDProvider()
  let request = appleIDProvider.createRequest()
  request.requestedScopes = [.fullName, .email]

  let authorizationController = ASAuthorizationController(authorizationRequests: [request])
  authorizationController.delegate = self
  authorizationController.performRequests()
  ```
- **Email Privacy Relay**: Apple が中継メール（`xxx@privaterelay.appleid.com`）を発行。実在メール非開示が選ばれた場合、ユーザー側でいつでも relay 切断可能。**サーバー側ロジックは relay 切断を想定**。
- **Anti-Pattern**: Sign in with Apple ボタンを小さく目立たない位置に配置 → リジェクト要因（Apple HIG にボタン仕様明記）

### 4.2. Account Deletion 義務（Guideline 5.1.1(v)）

- **Law**: アカウント作成機能があるアプリは、**アプリ内から直接アカウントを完全削除** する機能を実装する義務（2022 年 6 月以降）。
- **Required**:
  - 「サポートに連絡」「ウェブから削除」等の迂回は **禁止**
  - 設定画面の **発見しやすい場所** に「アカウント削除」ボタンを配置
  - タップ → 確認ダイアログ → 削除実行のフローを実装
  - PII（個人特定可能情報）は **物理削除**（論理削除のみは違反）
  - 削除完了の確認メッセージ表示
- **Implementation Pattern**:
  ```
  Settings → アカウント → 「アカウントを削除」
    ↓
  確認ダイアログ「すべてのデータが削除されます。元に戻せません。本当に削除しますか？」
    ↓
  [削除する]
    ↓
  Server: ユーザー PII を物理削除 + Audit Log 記録 + Sign in with Apple 連携解除
    ↓
  「アカウントが削除されました」表示 + ログアウト
  ```
- **Backend 連携**: `core/000_core_mindset.md` §1.12 Privacy-by-Architecture / `security/100_data_governance.md` の「忘れられる権利」と統合。

### 4.3. 多要素認証（MFA / 2FA）

- **Apple ID Sign-in 自体に 2FA 必須**: ユーザー側設定。
- **アプリ独自 MFA**: App-Specific Password / TOTP / Passkey（FIDO2）を推奨。
- **Passkey 統合**（iOS 17+）: `ASAuthorizationPlatformPublicKeyCredentialProvider` で Passkey 登録/認証。

### 4.4. クロスリファレンス
- `security/000_security_privacy.md` — Zero Trust / 認証
- `security/100_data_governance.md` — 「忘れられる権利」/ GDPR Art. 17

---

## Part 5: Apple Submission & Review — TestFlight / Phased Release / Expedited / Appeal

### 5.1. TestFlight ベータテスト

- **Law**: 全 New App / Major Update は **TestFlight 内部テスト → 外部テスト → 本番** の段階を経る。
- **Internal Testing**: チーム最大 100 人、Beta App Review 不要、24h 以内に配信。
- **External Testing**: 最大 10,000 人、初回のみ Beta App Review（24-48h）。
- **TestFlight ビルド有効期限**: 90 日。期限切れ前に再アップロード。
- **Feedback 収集**: TestFlight アプリ内のフィードバック機能 + スクリーンショット添付。

### 5.2. App Store Connect — App Review プロセス

- **Standard Review**: 24-48 時間（通常）。
- **Expedited Review**: 緊急時の優先審査リクエスト（年に数回程度の利用が望ましい）。利用例: クリティカルなクラッシュ修正、重大なセキュリティ脆弱性。
- **Pre-Submission Checklist**: §18 参照。

### 5.3. Phased Release（段階的リリース）

- **Law**: メジャーアップデートは **Phased Release を ON** にして 7 日間で 0% → 100% にロールアウト。
- **配信スケジュール**: Day 1: 1% / Day 2: 2% / Day 3: 5% / Day 4: 10% / Day 5: 20% / Day 6: 50% / Day 7: 100%
- **Pause / Resume**: クラッシュ率が閾値を超えたら **即座に Pause**。修正版を即提出。

### 5.4. Rejection Appeal（拒否異議申立て）

- **Law**: リジェクト理由に異議がある場合、**App Review Board** に Appeal 可能。感情的な反論ではなく **規約条項を引用した論理的反論** を行う。
- **Process**:
  1. App Store Connect → Resolution Center → Reply
  2. Apple がガイドライン解釈を再確認
  3. 必要なら App Review Board に escalation

### 5.5. App Store Connect Roles & Permissions

- **Account Holder**: 1 人のみ、変更困難
- **Admin / App Manager / Developer / Marketing / Sales / Customer Support / Finance**: ロール別権限
- **Two-Factor Authentication**: 全 Admin/Developer に必須化（2018+）
- **Audit Log**: 全操作が App Store Connect API 経由で取得可能

### 5.6. Code Signing & Provisioning Profiles

- **Distribution Certificate**: 1 チーム 1 つ（Apple Distribution）
- **Provisioning Profile**:
  - App Store Distribution
  - Ad Hoc（テスト用、UDID 登録必須）
  - Enterprise（社内配布、Apple Developer Enterprise Program 加入時のみ）
- **automatic vs manual signing**: 大規模チームは Manual + Fastlane Match が標準。

### 5.7. クロスリファレンス
- `engineering/600_git_workflow.md` §7.0 SemVer Tag Discipline
- `operations/400_site_reliability.md` Phased Rollout（GitOps 文脈）

---

## Part 6: Google Play — Console Policies & Target API Annual

### 6.1. Target API Level 年次更新ポリシー

- **Law**: Google Play は毎年 Target API Level の最低値を引き上げる。期限内に対応しないと **アップデート不可・新規提出不可** になる。
- **2026 例**: Target API 35（Android 15）以上必須（既存アプリ更新は 33 以上）。
- **対応サイクル**: 毎年 Q3-Q4 に最低レベル発表 → 翌年 8 月までに対応。

### 6.2. Play Console — Privacy Policy URL 必須

- **Law**: 個人情報を扱う全アプリは Play Console で Privacy Policy URL を設定する義務。リンク切れ・404 は即リジェクト。

### 6.3. UGC（User Generated Content）ポリシー（2025 強化版）

- **Law**: UGC を扱うアプリは以下を実装する義務:
  - **コンテンツのフィルタリング** または モデレーション
  - **報告機能**（不適切コンテンツの通報）
  - **ブロック機能**（特定ユーザーのブロック）
  - **24 時間以内の対応体制**
  - **ガイドライン違反コンテンツの除去フロー**
- **Anti-Pattern**: 報告機能なしで UGC 提供 → 即リジェクト

### 6.4. Subscriptions ポリシー

- **明確な開示**: 価格・更新周期・解約方法を購入前に明示
- **解約は Play Console の購読管理から到達可能**
- **無料トライアル**: 自動課金前に明示通知（Play Billing Library が標準処理）

### 6.5. Play Console Roles & Permissions

- **Account Owner**: 変更困難
- **Admin / Developer / Marketing / Customer Service**: 権限分離
- **2FA Required**: 全管理者に必須

---

## Part 7: Google Play — Data Safety & Privacy Disclosure

### 7.1. Data Safety Section 義務（2022+）

- **Law**: Play Console の **Data Safety** セクションで、アプリが収集・共有するデータをすべて申告する義務（Apple Privacy Nutrition Labels 相当）。
- **必須申告項目**:
  - 収集するデータの種類（Personal info / Financial info / Location / Health / Photos / etc.）
  - 共有先（自社のみ / サードパーティ）
  - 収集目的（アプリ機能 / 広告 / 分析 / etc.）
  - データ暗号化の有無（転送中・保存時）
  - ユーザーが削除をリクエストできるか
- **Verification**: 申告内容と実装が乖離した場合、**ポリシー違反でアプリ停止** リスク。

### 7.2. Permissions の正当化

- **危険権限（Dangerous Permissions）**: ロケーション・連絡先・カメラ・マイク等。
- **Runtime Permission**: Android 6.0+ では実行時許可必須。
- **正当化の必要性**: 申請時に「なぜこの権限が必要か」を Play Console で明確に説明する義務。
- **Anti-Pattern**: 機能と無関係な権限要求（例: 計算機アプリが連絡先アクセス）→ ポリシー違反

### 7.3. Background Location 義務（Android 10+）

- **Law**: バックグラウンドでの位置情報取得は **明確な機能的必要性** があり、Play Console で承認されたアプリのみ許可。
- **Required**: `ACCESS_BACKGROUND_LOCATION` 権限を要求する場合は、申請時に専用フォームで正当化。

---

## Part 8: Google Play Billing & Subscriptions

### 8.1. Play Billing Library 7+ 必須化

- **Law**: 2024 年以降の新規アプリ・既存アプリの大型更新は **Play Billing Library 7.0+** を使用する義務。
- **Implementation Skeleton**:
  ```kotlin
  val billingClient = BillingClient.newBuilder(context)
    .setListener(purchasesUpdatedListener)
    .enablePendingPurchases()
    .build()

  // 購入実行
  val billingFlowParams = BillingFlowParams.newBuilder()
    .setProductDetailsParamsList(productDetailsParamsList)
    .build()
  val billingResult = billingClient.launchBillingFlow(activity, billingFlowParams)
  ```

### 8.2. Real-time Developer Notifications (RTDN)

- **Law**: 購読状態変化を **Google Cloud Pub/Sub** 経由でサーバーに通知。Webhook 同等。
- **Required Setup**:
  - Pub/Sub Topic 作成
  - Play Console で Topic 名を登録
  - サーバー側で Subscription を消費し、`SUBSCRIPTION_RENEWED` / `SUBSCRIPTION_EXPIRED` / `SUBSCRIPTION_CANCELED` 等を処理

### 8.3. Subscription Lifecycle

- **Grace Period**: 課金失敗時の猶予期間（ユーザー側で支払い情報更新可能）
- **Account Hold**: Grace Period 後の停止状態（最大 30 日）
- **Pause**: ユーザーが一時停止（最大 3 ヶ月）

### 8.4. Refund Process

- **Google Play Refund Policy**: 購入後 48 時間以内は自動返金。サブスクは状況により判断。
- **Server-side**: RTDN の `REFUND` 通知で権限剥奪。

### 8.5. Anti-Pattern
- 外部決済への誘導（地域 DMA 例外を除く）→ ポリシー違反
- サブスク解約を妨害する UX → 違反

---

## Part 9: Google Play — Distribution (AAB / Closed-Open-Internal Testing / Phased Rollout)

### 9.1. Android App Bundle (AAB) 必須化（2021+）

- **Law**: 全新規アプリ・更新は **`.aab` 形式** で提出する義務。`.apk` 直接提出は **不可**。
- **Benefits**:
  - **Dynamic Delivery**: デバイス言語・解像度・ABI に最適化された APK を Play が自動生成
  - **App Size 削減**: 平均 35% 縮小
- **Build**:
  ```bash
  ./gradlew bundleRelease   # → app-release.aab を生成
  ```

### 9.2. Testing Tracks

| Track | 用途 | 最大ユーザー数 | 公開速度 |
|---|---|---|---|
| **Internal Testing** | 社内テスト | 100 人 | 即時 |
| **Closed Testing** | 限定 Beta | 任意（メールリスト/Google Group） | 数時間 |
| **Open Testing** | 公開 Beta | 無制限（Play Store で検索可能） | 数時間 |
| **Production** | 本番 | 全ユーザー | 数時間 |

### 9.3. Phased Rollout（段階的ロールアウト）

- **Law**: メジャーアップデートは Phased Rollout で **5% → 100%** に段階的配信。
- **設定**: Play Console → Production → ロールアウトの割合を 5/10/20/50/100% で段階制御。
- **Halted Rollout**: クラッシュ率閾値超で自動停止 + ロールバックオプション。

### 9.4. In-App Updates API

- **Law**: ユーザーに **アプリ内でアップデートを促す UX** を実装することを推奨。
- **2 Modes**:
  - **Flexible**: ユーザーが続行できるバックグラウンド更新
  - **Immediate**: クリティカルアップデートで強制（フルスクリーンブロック）
- **Implementation**:
  ```kotlin
  val appUpdateManager = AppUpdateManagerFactory.create(context)
  val appUpdateInfoTask = appUpdateManager.appUpdateInfo
  appUpdateInfoTask.addOnSuccessListener { appUpdateInfo ->
    if (appUpdateInfo.updateAvailability() == UpdateAvailability.UPDATE_AVAILABLE
        && appUpdateInfo.isUpdateTypeAllowed(AppUpdateType.IMMEDIATE)) {
      appUpdateManager.startUpdateFlowForResult(...)
    }
  }
  ```

### 9.5. Pre-launch Report

- **Play Console 自動機能**: アップロードした AAB を Google が複数デバイスでテストし、クラッシュ・ANR・パフォーマンス・セキュリティ問題を自動検出。
- **Mandatory Action**: 警告を Production 前に解消。

---

## Part 10: Google Play Integrity & Anti-Tamper

### 10.1. Play Integrity API（SafetyNet 後継）

- **Law**: 改ざん・不正端末の検知が必要なアプリ（金融・ゲーム・コンテンツ保護）は **Play Integrity API** を導入する。SafetyNet API は **2024 年廃止済み**。
- **Verdicts**:
  - `MEETS_DEVICE_INTEGRITY`: 正規 Android デバイス
  - `MEETS_BASIC_INTEGRITY`: ルート化等の基本チェック OK
  - `MEETS_STRONG_INTEGRITY`: 最新セキュリティパッチ + GMS 認証
- **Server-side Verification**: クライアント側のレスポンスは信用せず、サーバーで Google API に検証問い合わせ。
- **Anti-Pattern**: クライアントだけで Integrity 判定 → 解析されて bypass される

### 10.2. App Signing by Google Play

- **Law**: Play App Signing を有効化。Google が署名鍵を安全に管理し、開発者は Upload Key で署名のみ。
- **Benefits**: 鍵紛失時のリカバリ可能、Dynamic Delivery の前提条件。

### 10.3. ProGuard / R8 難読化

- **Law**: Production リリースは **R8（ProGuard 後継）** で難読化を有効化。
- **`proguard-rules.pro`**:
  ```
  # 機密ロジック保護
  -keep class com.example.api.** { *; }
  ```

---

## Part 11: Children's & Family Apps（子供向けアプリ規制）

### 11.1. COPPA（Children's Online Privacy Protection Act）米国

- **Law**: 13 歳未満を対象（または「あらゆる年齢層」を含む）アプリは COPPA 遵守必須。
- **Required**:
  - **Verifiable Parental Consent**: 親の同意取得（クレジットカード認証 or 電子署名 or 公的 ID）
  - **データ最小化**: 機能に必要な最小限のみ収集
  - **広告制限**: Behavioral Advertising 禁止、Contextual のみ
- **GDPR-K（EU 子供保護）**: 16 歳未満（加盟国により 13-16 歳）に同様の保護。

### 11.2. Apple Kids Category

- **Law**: 「Kids」カテゴリ申請には特別な要件:
  - サードパーティ広告 **禁止**
  - 外部リンク **禁止**（または「親確認」ゲート必須）
  - アプリ内購入は **親認証必須**（年齢別）
  - 5 歳以下 / 6-8 歳 / 9-11 歳 のサブカテゴリ別準拠
- **Audit**: Apple は Kids 申請を **特に厳格に審査**。

### 11.3. Google Designed for Families

- **Designed for Families Program** 加入時は:
  - 広告 SDK が **Families ポリシー準拠** であること
  - データ収集の制限
  - 親の管理機能（Family Link 連携）

### 11.4. クロスリファレンス
- `security/100_data_governance.md` — 子供 PII 取扱い

---

## Part 12: Platform API Terms — Maps / YouTube / Push

### 12.1. Google Maps Platform 規約

- **キャッシュ禁止**: 地図タイル・地点情報の **永続キャッシュ禁止**（30 日以上保存禁止）。
- **帰属表示義務**: Google ロゴ・著作権表示を隠蔽・改変しない。
- **API 単独使用禁止**: 地図表示なしで API のみ使う「データのみ抽出」禁止。
- **代替検討**: コスト・規約面で MapBox / OpenStreetMap も比較。

### 12.2. YouTube Data API 規約

- **バックグラウンド再生禁止**: API 経由でのバックグラウンド再生は規約違反。
- **広告スキップ・除去禁止**: YouTube 広告を改変・除去する実装は禁止。
- **YouTube Premium 機能の代替実装禁止**: ダウンロード・広告除去等。

### 12.3. Apple Push Notifications (APNs)

- **APNs Provider Authentication Token**: Token-based（推奨）または Certificate-based。Token-based は鍵更新不要・有効期限管理楽。
- **Notification Service Extension**: 通知に画像・カスタム UI を付与する場合に実装。
- **Critical Alerts**: 集中モード突破には Apple の特別 Entitlement 必要。

### 12.4. Firebase Cloud Messaging (FCM)

- **Topic / Token / Condition**: ターゲティング 3 種。
- **HTTP v1 API（推奨）**: Legacy HTTP API は廃止予定。
- **Notification vs Data**: Notification Message は OS が表示、Data Message はアプリで処理。

### 12.5. Push 通知のコンプライアンス

- **Opt-in 義務**: GDPR/CCPA 下でユーザー同意必須。
- **頻度制限**: 過剰通知は OS 側で自動 Opt-out 候補化（iOS Focus / Android DND）。
- **マーケティング通知の明示**: アプリ機能通知とマーケ通知を分離。

### 12.6. クロスリファレンス
- `engineering/100_api_integration.md` API 統合一般
- `engineering/500_firebase_gcp.md` FCM 詳細

---

## Part 13: ASO (App Store Optimization) Deep Dive

### 13.1. キーワード戦略

- **Apple App Store**:
  - **Title**: 30 字以内、最重要 SEO 要素
  - **Subtitle**: 30 字、Title 補完
  - **Keywords Field**: 100 字（カンマ区切り、重複禁止、競合社名禁止）
  - **Promotional Text**: 170 字、リリースなしで更新可（バナー的訴求）
- **Google Play**:
  - **Title**: 30 字
  - **Short Description**: 80 字
  - **Long Description**: 4000 字、本文 SEO 効くため戦略的
- **Tools**: Sensor Tower / data.ai / AppTweak / ASOdesk

### 13.2. クリエイティブ最適化

- **App Icon**: 競合と被らない・5 秒で印象を残す・OS バージョン別最適化（iOS 26+ Liquid Glass 対応など）
- **Screenshots**:
  - iOS: 最大 10 枚 / Localized
  - Android: 最大 8 枚 / Phone・Tablet・TV 別
  - **First 3 が最重要**（カルーセル前半でのコンバージョン）
- **Preview Video**:
  - iOS: 最大 30 秒 × 3 本
  - Android: YouTube Link
  - **最初の 3 秒** で価値訴求

### 13.3. A/B Testing

- **Apple Product Page Optimization (PPO)**: Icon / Screenshots / Video の 3 バリアント比較（最大 3 治療群）。
- **Google Store Listing Experiments**: Default Listing と Custom Store Listings の比較（地域別）。
- **指標**: Tap-Through Rate (TTR) / Conversion Rate (CR) / Retention D7

### 13.4. App Privacy & Trust

- **Privacy Nutrition Labels（Apple）/ Data Safety（Google）** が CR に直接影響。データ収集の最小化が ASO 上有利。

### 13.5. Custom Product Pages（Apple）/ Custom Store Listings（Google）

- **Apple**: 特定マーケティングキャンペーン用の専用ページ（最大 35 種類）。
- **Google**: 国別・URL パラメータ別のカスタマイズ。

### 13.6. App Store Optimization 連携

- **ASA (Apple Search Ads)** と ASO の相互強化。
- **ASO Refresh サイクル**: 月次キーワード見直し、四半期スクリーンショット更新。

### 13.7. クロスリファレンス
- `product/500_growth_marketing.md` — グロース全般・SEO/GEO

---

## Part 14: Localization & Internationalization for Stores

### 14.1. App Store Connect ローカライズ

- **対応言語**: 40+ 言語、Title / Subtitle / Description / Keywords / Screenshots を言語別に登録。
- **Required**: ターゲット市場（日本・米国・EU・中国・東南アジア）は Day 1 から完全ローカライズ。
- **Anti-Pattern**: 機械翻訳を貼るだけ → リジェクト要因（Apple Reviewer がチェックする）

### 14.2. Google Play ローカライズ

- 同様に Title / Description / Screenshots / Video の言語別登録。
- Google Play は機械翻訳補助ツールを提供（精度は限定的、人間ローカライザー必須）。

### 14.3. 価格・通貨ローカライズ

- **Price Tier 自動換算** vs **Custom Price Points**
- **VAT/GST 等の税込み・税別表示** は地域ごとの法令遵守
- **日本**: 税込み表示義務（消費税法）

### 14.4. クロスリファレンス
- `product/800_internationalization.md` — i18n/L10n 一般

---

## Part 15: DMA Compliance (EU Digital Markets Act)

### 15.1. DMA の影響範囲（2024+）

- **Gatekeepers** に指定された企業（Apple / Google / Microsoft / Meta / Amazon / ByteDance）は DMA 規制下。
- **EU Member States** で展開するアプリは以下の新規ポリシーに対応:

### 15.2. Alternative App Marketplaces（iOS）

- **Apple iOS in EU**: Alternative App Marketplaces（AltStore PAL / Setapp Mobile 等）でのアプリ配信が可能化（2024 年 3 月〜）。
- **Core Technology Fee (CTF)**: 1M インストール超で €0.50/install（Apple との契約条件次第で複数モデル）。

### 15.3. Sideloading（Web Distribution）

- **Web Distribution Entitlement**: 開発者の Web サイトから直接配信可能（EU 限定、要 Entitlement 申請）。
- **Notarization**: Apple の署名は維持されるが、配信は外部。

### 15.4. 外部決済リンク

- **Music Streaming Services Entitlement** 等、特定カテゴリで外部決済リンク許可。
- **DMA Core Function**: ブラウザ・検索エンジン・コミュニケーション等の選択画面表示義務。

### 15.5. Browser Choice Screen

- **iOS in EU**: 初回起動時にブラウザ選択画面表示義務（Safari 以外も対等）。
- **Search Engine Choice**: Google だけでなく Bing / DuckDuckGo / Ecosia 等の選択肢提示。

### 15.6. Anti-Pattern
- 「DMA は EU だけだから無視」 → EU 売上比率次第で必須対応
- Alternative Marketplace を装った詐欺アプリ → 早期検知必須

### 15.7. クロスリファレンス
- `security/100_data_governance.md` — GDPR / DMA 整合性

---

## Part 16: Generative AI App Compliance

### 16.1. Apple GenAI ガイドライン（2024+）

- **Disclosure**: GenAI 機能を含むアプリは Privacy Nutrition Labels で明示。
- **Content Moderation**: 有害コンテンツ生成防止フィルター実装義務（児童性的虐待・違法行為・差別等）。
- **Data Source**: 学習データの著作権遵守（Apple は Reviewer に学習データの正当性を問う場合あり）。

### 16.2. Google Play GenAI ポリシー

- **App Tags 必須**: AI Generated Content / AI Chat / AI Image Gen 等の機能タグ申告。
- **Reporting Mechanism**: AI が生成した有害コンテンツの報告機能必須。
- **In-App User Reporting**: ユーザーが不適切な AI 出力を即座に報告できる UI。

### 16.3. AI 出力の境界

- **医療・法律・財務助言の禁止**（または「専門家に相談」明示）
- **未成年保護**: 子供向けアプリでは GenAI 機能を制限・親管理
- **Deepfake / なりすまし防止**: 生成コンテンツに「AI 生成」ウォーターマーク or メタデータ

### 16.4. クロスリファレンス
- `ai/000_ai_engineering.md` — AI 安全性・OWASP LLM Top 10
- `core/000_core_mindset.md` §1.22 Responsible AI Disclosure

---

## Part 17: Specialized Verticals — Health / Finance / Crypto / Games

### 17.1. ヘルスケア・医療系（HealthKit / Health Connect）

- **Apple HealthKit**:
  - データは **デバイス内 + iCloud（暗号化）** のみ、サーバーへの直接送信は要 Special Entitlement
  - 健康データの売却・広告利用 **禁止**（Guideline 5.1.3）
  - HIPAA / FDA 510(k) 必要なケースは別途取得
- **Google Health Connect**:
  - Android 14+ で OS 統合
  - 同様にユーザー同意 + データ用途明示

### 17.2. Financial / Crypto / Crypto Wallet

- **Apple Guideline 3.1.5(b)**: 暗号資産取引は規制対象国でのみ許可、規制ライセンス必須。
- **Crypto Wallet**: Self-Custody Wallet は許容、IAP との競合は不可。
- **Google Play 規制**: 国別ライセンス確認、消費者保護義務。

### 17.3. ゲーム特有規制

- **Loot Box（ガチャ）**: 確率明示義務（日本・中国・韓国・EU）。
- **In-Game Currency**: 換金性のあるトークンは規制対象。
- **Apple Arcade / Google Play Pass**: 専用ストア向けゲームの別規約。

### 17.4. ハイブリッドアプリ（PWA / Capacitor / React Native）

- **Apple**: アプリの主機能は **Native でなくとも OK**、ただし「ブラウザのラッパー」のみは Guideline 4.2 で却下。
- **Google**: PWA のラッパーは Trusted Web Activity 推奨。
- **App Bundle**: React Native / Flutter は AAB 対応必須。

### 17.5. クロスリファレンス
- `engineering/400_mobile_flutter.md` Flutter 実装
- `engineering/410_native_platforms.md` Native 実装

---

## Part 18: Common Rejections & Pre-Submission Master Checklist

### 18.1. リジェクト多発項目 Top 10

| 順位 | 理由 | 規約条項 |
|---|---|---|
| 1 | クラッシュ・バグ | Apple Guideline 2.1 |
| 2 | 申請内容と実装の乖離 | 2.3.1 |
| 3 | 不完全な情報（リンク切れ・サポート不在） | 1.5 |
| 4 | プライバシーポリシー不備 | 5.1.1 |
| 5 | IAP 義務違反（外部決済誘導） | 3.1.1 |
| 6 | サブスク表示不備 | 3.1.2(a) |
| 7 | 悪用可能なデフォルト機能 | 5.1.5 |
| 8 | UI が HIG / Material から大きく逸脱 | 4.0 |
| 9 | アカウント削除機能なし | 5.1.1(v) |
| 10 | ATT / Privacy Manifests 不備 | 5.1.1 / 5.1.2 |

### 18.2. Pre-Submission Master Checklist

```
□ ビルド設定
  □ Release Configuration でビルド
  □ Symbols 含む dSYM をアップロード
  □ Bitcode（廃止済み、不要）
  □ Build Number が前回より大きい

□ 機能完成度
  □ "Coming Soon" / "Beta" / Lorem Ipsum / Placeholder を全削除
  □ TestFlight でクラッシュ率 < 0.1%
  □ 主要 OS バージョン（最新 + n-2）で動作確認
  □ 全画面で戻る経路あり

□ プライバシー
  □ Privacy Policy URL が有効（200 OK）
  □ App Privacy Details 入力完了
  □ NSUserTrackingUsageDescription 記述（ATT 使用時）
  □ Privacy Manifests 含む（PrivacyInfo.xcprivacy）
  □ Required Reason API 申告済み
  □ Data Safety section 入力（Google Play）

□ 認証・アカウント
  □ Sign in with Apple 提供（他社認証併用時）
  □ アカウント削除フローが UI から到達可能（5.1.1(v)）
  □ 2FA 対応（Apple / Google Account）

□ メタデータ
  □ Title / Subtitle / Keywords 適合（虚偽・誇大表現なし）
  □ Screenshots と実機の整合性
  □ Preview Video が App と一致
  □ App Description が機能を正確に説明
  □ デモアカウント情報を備考欄に記載（Apple 審査用）

□ ガイドライン特有
  □ HIG / Material Design 準拠
  □ Dark Mode 対応（iOS）
  □ Dynamic Type 対応（iOS）
  □ アクセシビリティ（VoiceOver / TalkBack）

□ Billing
  □ IAP 経由の課金（外部決済誘導なし、Reader App 例外を除く）
  □ サブスクの価格・期間・解約方法明示
  □ Restore Purchase ボタン提供（iOS）

□ ストア固有
  □ Google Play: Target API Level 最新値以上
  □ Google Play: AAB 形式で提出
  □ Apple: Phased Release ON
  □ Apple: TestFlight Beta 完了

□ 法令
  □ GDPR / CCPA 対応（プライバシーポリシー記載）
  □ 子供向けは COPPA / GDPR-K 対応
  □ 暗号資産は規制ライセンス取得済み
  □ ヘルス系は FDA / 医療機器規制確認

□ 連絡先
  □ Support URL 有効
  □ Privacy Policy URL 有効
  □ App Review 連絡先（メール / 電話）正確
```

### 18.3. Rejection 後の対応フロー

1. **規約条項を引用** して理由を理解
2. **修正実装** + **修正の証明（テストビデオ・スクリーンショット）**
3. Resolution Center で **正式に Reply**（感情的反論禁止）
4. 判定が変わらない場合 **App Review Board に Appeal**

---

## Part 19: Anti-Pattern Catalog（アンチパターン統合表）

### 19.0. Forbidden Practices Quick Reference

| カテゴリ | アンチパターン | 検出手段 | 関連 |
|---|---|---|---|
| **Build** | "Coming Soon" / Lorem Ipsum 残存 | Pre-Submission Checklist | §18 |
| **Build** | クラッシュ率 > 0.1% | TestFlight / Play Console | §5, §9 |
| **Privacy** | Privacy Manifests 欠如 | Xcode Privacy Report | §2 |
| **Privacy** | ATT 取得なしで IDFA 使用 | App Review | §2.1 |
| **Privacy** | 申告と実態の乖離 | Apple/Google 監査 | §2.4, §7.1 |
| **IAP** | 外部決済への誘導（Reader App 例外外） | App Review | §3.1 |
| **IAP** | サブスク解約妨害 UX | Resolution Center | §3.3 |
| **Identity** | アカウント削除機能なし | App Review | §4.2 |
| **Identity** | Sign in with Apple 提供なし（他社認証併用時） | App Review | §4.1 |
| **HIG/Material** | 戻る経路の欠落 | App Review | §1.1 |
| **HIG** | Dark Mode 未対応 | App Review（推奨） | §1.2 |
| **HIG** | 固定フォントサイズ | App Review / EAA 違反 | §1.3 |
| **Distribution** | APK 形式で Google Play 提出 | Play Console reject | §9.1 |
| **Distribution** | Target API Level 未対応 | Play Console reject | §6.1 |
| **UGC** | 報告機能なし | App Review | §6.3 |
| **UGC** | 24h 対応体制なし | App Review | §6.3 |
| **API** | Google Maps の永続キャッシュ | API 規約違反 | §12.1 |
| **API** | YouTube バックグラウンド再生 | API 規約違反 | §12.2 |
| **Children** | Apple Kids カテゴリで広告 | App Review | §11.2 |
| **Children** | 親同意なしで PII 収集 | COPPA 違反 | §11.1 |
| **GenAI** | コンテンツモデレーションなし | App Review / 法的リスク | §16 |
| **Crypto** | 規制ライセンスなしで取引 | App Review reject | §17.2 |
| **Health** | HealthKit データの広告利用 | Apple Guideline 5.1.3 | §17.1 |
| **Localization** | 機械翻訳のまま提出 | App Review reject | §14.1 |
| **DMA** | EU で旧 IAP 義務維持 | DMA 違反 | §15 |
| **Hybrid App** | Web ラッパーのみ | Apple Guideline 4.2 | §17.4 |

---

## Appendix A: 逆引き索引（キーワード → セクション）

| キーワード | セクション |
|---|---|
| HIG / Human Interface Guidelines | §1.1 |
| Dark Mode / Dynamic Type | §1.2, §1.3 |
| visionOS / Spatial UI | §1.5 |
| App Tracking Transparency / ATT / IDFA | §2.1 |
| Privacy Manifests / PrivacyInfo.xcprivacy | §2.2 |
| Required Reason API | §2.3 |
| Privacy Nutrition Labels / App Privacy Details | §2.4 |
| SKAdNetwork / AdAttributionKit | §2.5 |
| In-App Purchase / IAP | §3.1 |
| StoreKit 2 | §3.2 |
| Auto-Renewable Subscription | §3.3 |
| Promotional / Win-back / Introductory Offer | §3.4 |
| App Store Server Notifications V2 | §3.5 |
| Sign in with Apple | §4.1 |
| Account Deletion 5.1.1(v) | §4.2 |
| TestFlight / Phased Release | §5.1, §5.3 |
| App Review Appeal | §5.4 |
| Code Signing / Provisioning Profiles | §5.6 |
| Google Play Target API | §6.1 |
| Data Safety section | §7.1 |
| Play Billing Library | §8.1 |
| Real-time Developer Notifications (RTDN) | §8.2 |
| Android App Bundle (AAB) | §9.1 |
| Closed/Open/Internal Testing | §9.2 |
| Phased Rollout (Google) | §9.3 |
| In-App Updates API | §9.4 |
| Play Integrity API | §10.1 |
| App Signing by Google Play | §10.2 |
| COPPA / GDPR-K | §11.1 |
| Apple Kids Category | §11.2 |
| Designed for Families | §11.3 |
| Google Maps API 規約 | §12.1 |
| YouTube Data API 規約 | §12.2 |
| APNs / FCM | §12.3, §12.4 |
| ASO / キーワード戦略 / A/B Test | §13 |
| ローカライズ（Store） | §14 |
| DMA / Alternative Marketplace / Sideloading | §15 |
| Generative AI コンプライアンス | §16 |
| HealthKit / Health Connect | §17.1 |
| Crypto / Crypto Wallet | §17.2 |
| Loot Box / In-Game Currency | §17.3 |
| ハイブリッドアプリ / PWA / Capacitor | §17.4 |
| Pre-Submission Checklist | §18.2 |
| Anti-Pattern Catalog | §19.0 |

---

## Appendix B: クロスリファレンス（セクション → 関連 Universal ルール）

| セクション | 関連 Universal ルール |
|---|---|
| §1 HIG/Material Design | `design/000_design_ux.md` / `core/000_core_mindset.md` §1.13 Accessibility |
| §2 Privacy Stack | `security/100_data_governance.md` / `security/000_security_privacy.md` / `core/000_core_mindset.md` §1.12 Privacy-by-Architecture |
| §3 IAP & Subscriptions | `product/300_revenue_monetization.md` / `product/400_pricing_strategy.md` |
| §4 Identity / Sign in with Apple | `security/000_security_privacy.md` / `security/100_data_governance.md` |
| §5 Submission / Code Signing | `engineering/600_git_workflow.md` §7.0 SemVer / `operations/400_site_reliability.md` |
| §6-§10 Google Play 全般 | `engineering/410_native_platforms.md` |
| §11 子供保護 | `security/100_data_governance.md` / GDPR-K |
| §12 API 規約 | `engineering/100_api_integration.md` / `engineering/500_firebase_gcp.md` |
| §13 ASO | `product/500_growth_marketing.md` |
| §14 ローカライズ | `product/800_internationalization.md` |
| §15 DMA | `security/100_data_governance.md` (規制全般) |
| §16 GenAI | `ai/000_ai_engineering.md` / `core/000_core_mindset.md` §1.22 Responsible AI |
| §17 業種特化 | `engineering/400_mobile_flutter.md` / `engineering/410_native_platforms.md` / `security/100_data_governance.md` |

---

**Last Updated**: 2026-05-06
**Authority**: Universal Constitution (axiarch core)
**Classification**: Product — Store Guidelines & Compliance
