# 13. Store Guidelines & Compliance

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-05-06

> [!IMPORTANT]
> **Supreme Directive**
> "Store compliance is not optional — rejection at the gate means zero users."
> All app store submissions MUST comply with the latest platform guidelines.
> **Platform Terms > User Trust > Feature Velocity** is the strict priority order.
> **20 Parts / ~80+ rules.**

---

## Table of Contents

| # | Part | Key Topics |
|---|---|---|
| 0 | Supreme Directive & Scope Manifesto | Scope, priorities, excluded domains |
| 1 | Apple App Store — HIG & Design Compliance | HIG, Dark Mode, Dynamic Type |
| 2 | Apple Privacy Stack | ATT / Privacy Manifests / Required Reason API / Privacy Nutrition Labels |
| 3 | Apple In-App Purchase & Subscriptions | IAP mandate, Auto-Renewable, Win-back, StoreKit 2 |
| 4 | Apple Identity | Sign in with Apple, Account Deletion 5.1.1(v) |
| 5 | Apple Submission & Review | TestFlight, Phased Release, Expedited, Appeal |
| 6 | Google Play — Console Policies & Target API Annual | Annual API updates, subscription policies |
| 7 | Google Play — Data Safety & Privacy Disclosure | Data Safety section, Privacy Policy URL |
| 8 | Google Play Billing & Subscriptions | Play Billing Library 7+, RTDN |
| 9 | Google Play — Distribution | AAB mandate, Closed/Open/Internal Testing, Phased Rollout |
| 10 | Google Play Integrity & Anti-Tamper | Play Integrity API, SafetyNet sunset |
| 11 | Children's & Family Apps | COPPA, Apple Kids, Designed for Families |
| 12 | Platform API Terms | Maps, YouTube, APNs, FCM |
| 13 | ASO (App Store Optimization) | Keyword strategy, A/B testing, screenshots, video |
| 14 | Localization & Internationalization for Stores | App Store Connect / Play Console localization |
| 15 | DMA Compliance (EU Digital Markets Act) | Alternative Marketplaces, Sideloading, DMA Core Functions |
| 16 | Generative AI App Compliance | Apple/Google GenAI policies, harmful content prevention |
| 17 | Specialized Verticals | Health / Finance / Crypto / Games |
| 18 | Common Rejections & Pre-Submission Master Checklist | Frequent rejection causes, pre-submission checklist |
| 19 | Anti-Pattern Catalog | Forbidden practices |
| App A | Reverse Index | Keyword reverse index |
| App B | Cross-References | Links to other Universal Rules |

---

## Part 0: Supreme Directive & Scope Manifesto

### 0.1. Scope

✅ **Inclusion Criteria**:
- App store guideline compliance for submission to Apple App Store / Google Play
- Store-specific Privacy / Billing / Identity / Distribution mechanics
- Self-contained app compliance (HIG / Material Design, ASO)
- Store review processes and pre-submission checklists
- Cross-region regulations such as DMA (Digital Markets Act)

❌ **Exclusion Criteria (refer to respective domain files)**:
- General GDPR/CCPA → `security/100_data_governance.md`
- Secure coding / Zero Trust → `security/000_security_privacy.md`
- Payment processing architecture → `product/300_revenue_monetization.md`
- Unit economics / LTV → `product/000_product_strategy.md`
- General i18n/L10n → `product/800_internationalization.md`
- Native SDK implementation → `engineering/410_native_platforms.md` / `engineering/400_mobile_flutter.md`

### 0.2. Priority Hierarchy

**Platform Terms > User Trust > Feature Velocity > Developer Convenience**

Rationale: A rejection at store review = zero users. Platform terms have **the binding force of law**.

---

## Part 1: Apple App Store — HIG & Design Compliance

### 1.1. Human Interface Guidelines (HIG) Compliance

- **Law**: All iOS / iPadOS / visionOS / macOS / watchOS / tvOS apps MUST comply with Apple HIG.
- **Required**:
  - **Standard Components Preferred**: Use `UIKit` / `SwiftUI` standard components first. Custom UIs need a defensible HIG-review rationale.
  - **Back Navigation Guarantee**: Always provide swipe-back (Edge Swipe) or an explicit "Back" button. Do not strip back paths inside Tab Bars.
  - **Tap Targets**: Minimum 44×44pt (Apple official). Smaller = instant rejection.
  - **Safe Area & Dynamic Island**: Don't cover Notch / Dynamic Island / home indicator. Respect `safeAreaInset`.
- **Anti-Patterns**:
  - Fake buttons that mimic system UI ("Settings" disguised as Share) → Guideline 4.0 violation, instant rejection
  - Dead-end screens with no back path

### 1.2. Dark Mode Mandate

- **Law**: iOS 13+ apps MUST support **Dark Mode** (de-facto standard as of 2026).
- **Implementation**:
  ```swift
  // SwiftUI: define Light/Dark colors in Asset Catalog
  Color("BackgroundPrimary") // auto-switches

  // UIKit
  view.backgroundColor = UIColor(named: "BackgroundPrimary")
  ```
- **Verification**: Use Xcode Environment Override to verify both modes; submit screenshots in both.

### 1.3. Dynamic Type Mandate (Accessibility)

- **Law**: Follow iOS system font-size settings (xSmall through AX5). Fixed font sizes are also an **EAA violation** (cross-ref `core/000_core_mindset.md` §1.13).
- **Implementation**:
  ```swift
  Text("Hello").font(.body)  // SwiftUI: auto scales
  label.font = UIFont.preferredFont(forTextStyle: .body)
  label.adjustsFontForContentSizeCategory = true
  ```

### 1.4. Live Activities / Widget / App Intents Compliance

- **Live Activities** (iOS 16.1+): Use `ActivityKit`. Lock Screen and Dynamic Island both required.
- **Widget**: Use WidgetKit; define update policy with TimelineProvider.
- **App Intents** (iOS 16+): Mandatory Siri / Spotlight / Shortcuts integration for voice-UX apps.

### 1.5. visionOS / Spatial Computing Compliance (2024+)

- **Required**: For visionOS 1.0+, clarify Window / Volume / Immersive Space usage.
- **Comfort**: Maintain 60fps and avoid abrupt POV shifts to mitigate VR sickness.

### 1.6. Accessibility Mandate (Apple A11y)

- **VoiceOver**: All interactive elements MUST have `accessibilityLabel`. Use `accessibilityIdentifier` for UI tests.
- **Voice Control**: Verify button/link labels are speakable.
- **Switch Control / AssistiveTouch**: Maintain logical focus order.
- **Reduce Motion / Reduce Transparency**: Honor user settings (`accessibilityReduceMotion`).

### 1.7. Cross-References
- §1.13 Accessibility-by-Design Protocol (`core/000_core_mindset.md`)
- `engineering/410_native_platforms.md` SwiftUI implementation details
- `design/000_design_ux.md` HIG/Material Design integration

---

## Part 2: Apple Privacy Stack — ATT / Privacy Manifests / Required Reason API / Privacy Nutrition Labels

### 2.0. Apple Privacy 4-Layer Model (2024+)

| Layer | Mechanism | Mandatory Since |
|---|---|---|
| L1 | **App Privacy Details** (Nutrition Labels) | 2020 — all apps |
| L2 | **App Tracking Transparency (ATT)** | 2021 — required when using IDFA |
| L3 | **Privacy Manifests** (`PrivacyInfo.xcprivacy`) | 2024 — required for third-party SDKs / key APIs |
| L4 | **Required Reason API** | 2024 — declaration required for specific APIs |

These four layers are **defense-in-depth, not duplicates**. All MUST be respected.

### 2.1. App Tracking Transparency (ATT) Protocol

- **Law**: When tracking users across apps/sites (IDFA / 3P cookies / fingerprinting), you MUST request consent via `ATTrackingManager`. Tracking without consent = Guideline 5.1.2 violation = instant rejection.
- **Implementation**:
  ```swift
  import AppTrackingTransparency

  func requestTrackingPermission() async {
    let status = await ATTrackingManager.requestTrackingAuthorization()
    switch status {
    case .authorized: // IDFA available
      let idfa = ASIdentifierManager.shared().advertisingIdentifier
    case .denied, .restricted: // IDFA is zero UUID
      // Fall back to SKAdNetwork / AdAttributionKit
    case .notDetermined: break
    @unknown default: break
    }
  }
  ```
- **NSUserTrackingUsageDescription** (required in `Info.plist`):
  ```xml
  <key>NSUserTrackingUsageDescription</key>
  <string>Permission is requested to deliver personalized ads</string>
  ```
- **Anti-Patterns (Forbidden)**:
  - **Re-prompting** the ATT dialog (OS-controlled; forced re-prompts are a Guideline violation)
  - "App requires consent to function" coercion → instant rejection
  - Fingerprinting (combining device info to identify) → ATT applies even with `IDFV` if used for tracking

### 2.2. Privacy Manifests (`PrivacyInfo.xcprivacy`) Mandate

- **Law**: All apps and third-party SDKs MUST include `PrivacyInfo.xcprivacy` (mandatory for App Store submissions since May 2024).
- **4 Required Sections**:

  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" ...>
  <plist version="1.0">
  <dict>
    <!-- 1. Types of privacy-protected data -->
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

    <!-- 2. Tracking flag -->
    <key>NSPrivacyTracking</key>
    <false/>

    <!-- 3. Tracking domains (blocked when ATT denied) -->
    <key>NSPrivacyTrackingDomains</key>
    <array>
      <string>tracking.example.com</string>
    </array>

    <!-- 4. Required Reason API declaration -->
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
- **Validation**: Xcode 15+ auto-generates a Privacy Report by merging app and all SDK declarations.
- **Responsibility**: If an SDK vendor doesn't ship a Privacy Manifest, **the app cannot be submitted**. Replace the SDK or pressure the vendor.

### 2.3. Required Reason API Declaration

- **Law**: When using APIs in the following categories, you MUST declare a valid reason code in `NSPrivacyAccessedAPITypeReasons`.
- **Target API Categories (4 as of 2026)**:

  | Category | Examples | Reason Code Examples |
  |---|---|---|
  | **File Timestamp** | `creationDate`, `modificationDate` | `C617.1` for display, `DDA9.1` for search index |
  | **System Boot Time** | `mach_absolute_time` | `35F9.1` for performance metrics |
  | **Disk Space** | `volumeAvailableCapacity` | `85F4.1` for storage warnings |
  | **Active Keyboard** | `UIInputView` | `8646.1` for keyboard switch detection |
  | **User Defaults** | `UserDefaults` | `CA92.1` for storing the app's own settings |
- **Anti-Pattern**: "Generating an ad ID" or "fingerprinting" purposes are **explicitly forbidden** (Apple violation).

### 2.4. App Privacy Details (Privacy Nutrition Labels)

- **Law**: Declare **all data the app collects** in App Store Connect (since 2020).
- **Three Categories**:

  | Category | Examples |
  |---|---|
  | **Data Used to Track You** | Ad IDs (IDFA), tracking identifiers |
  | **Data Linked to You** | Email/purchase history tied to an account ID |
  | **Data Not Linked to You** | Aggregate usage stats (not personally identifiable) |
- **Required Categories**: Contact Info / Health & Fitness / Financial Info / Location / Sensitive Info / Contacts / User Content / Browsing History / Search History / Identifiers / Purchases / Usage Data / Diagnostics / Other Data
- **Verification**: If declared content diverges from actual behavior, **risk of account suspension for false declaration**.

### 2.5. SKAdNetwork / AdAttributionKit (Ad Measurement Frameworks)

- **Law**: For ATT-denied users, use Apple's **SKAdNetwork** (v4.0+) or **AdAttributionKit** (iOS 17.4+) for ad measurement.
- **Features**:
  - Conversion Value (postbacks at 10/20 ms, then 24-48h)
  - Aggregated (non-individually identifying)
  - SKAN 4.0: Source Identifier (4 digits), Hierarchical Conversion Values
- **Setup**:
  - List `SKAdNetworkItems` in `Info.plist` (ad network IDs)
  - Configure Postback URL on the server

### 2.6. Cross-References
- `security/100_data_governance.md` — GDPR/CCPA in general
- `security/000_security_privacy.md` — Zero Trust / encryption
- `core/000_core_mindset.md` §1.12 Privacy-by-Architecture

---

## Part 3: Apple In-App Purchase & Subscriptions Deep Dive

### 3.1. IAP Mandate (Guideline 3.1.1)

- **Law**: Sale of digital content / features / services MUST go through **In-App Purchase (IAP)**. Routing to external payments (e.g., "buy on web" links) is forbidden.
- **Exception (Reader App)**: Magazines, books, music, video, cloud storage — "content access only". Offering in-app purchase is required.
- **2024+ Relaxation (US/EU)**: Limited external-payment-link permission per Epic ruling (US) and EU DMA (Entitlement application required). **Rules differ by region**, so legal review is mandatory.

### 3.2. StoreKit 2 (Recommended Implementation)

- **Law**: New implementations MUST use **StoreKit 2** (iOS 15+). StoreKit 1 is legacy.
- **Implementation Skeleton**:
  ```swift
  import StoreKit

  // 1. Fetch products
  let products = try await Product.products(for: ["com.example.pro_monthly"])

  // 2. Execute purchase
  let result = try await product.purchase()
  switch result {
  case .success(let verification):
    let transaction = try checkVerified(verification)
    await transaction.finish()
  case .userCancelled, .pending: break
  @unknown default: break
  }

  // 3. Background transaction monitoring
  Task.detached {
    for await result in Transaction.updates {
      let transaction = try checkVerified(result)
      await unlockContent(for: transaction)
      await transaction.finish()
    }
  }
  ```

### 3.3. Auto-Renewable Subscription Design

- **Law**: Auto-renewable subscriptions (ARS) MUST follow these rules:
  - **Clear price/period disclosure**: Price, renewal cadence, and cancellation method shown before purchase
  - **Free Trial transparency**: "7 days free, then ¥980/month" with conversion price shown
  - **In-app cancellation reachable**: Recommended to provide a link to "Settings > Subscriptions"
- **Subscription Groups**: Group multiple plans (Basic/Pro/Premium); define upgrade/downgrade.
- **Family Sharing**: Set `isFamilyShareable = true` to enable family sharing.

### 3.4. Promotional Offers / Win-back Offers / Introductory Offers

- **Introductory Offer**: First-time-buyer discount (Free Trial / Pay-as-you-go / Pay-up-front).
- **Promotional Offer**: Special offer for existing subscribers (server-side signed).
- **Win-back Offer** (iOS 18+): Auto-presented re-offers to churned users (App Store-controlled).

### 3.5. Subscription Lifecycle Events

- **App Store Server Notifications V2**: Webhook-based delivery of subscription state changes (DID_RENEW / DID_FAIL_TO_RENEW / EXPIRED / REFUND).
- **Server-side Verification**: Don't trust client receipts — query subscription state authoritatively via the App Store Server API.
- **Required Endpoints**:
  - `notifyURL`: receive Webhook
  - Use `transactionID` to fetch and update state

### 3.6. Refund Handling

- **Apple Refund Process**: User requests refund → Apple decides → on approval, sends `REFUND` notification.
- **Server-side Mandatory Action**: On `REFUND`, immediately revoke the user's entitlement (including credit-return logic).
- **2025+ Server Refund Request API**: Developers can also initiate refund requests (improves customer-support efficiency).

### 3.7. Pricing Tiers & Localization

- **App Store Connect Pricing Tiers**: 100+ tiers auto-converted across regions.
- **Custom Price Points**: Granular price control (2023+).
- **Tax-Inclusive vs Exclusive**: Many countries require **tax-inclusive display** (Japan: tax-included).

### 3.8. Anti-Patterns (Forbidden)
- Routing to external payments (outside Reader App exception) → instant rejection
- "Subscription cancellation requires phone call" → Guideline violation
- Dark UX that subscribes users without clear consent → rejection + risk of Apple account suspension

### 3.9. Cross-References
- `product/300_revenue_monetization.md` — ASC 606 revenue recognition, external payments (Stripe)
- `product/400_pricing_strategy.md` — pricing strategy in general

---

## Part 4: Apple Identity — Sign in with Apple / Account Deletion 5.1.1(v)

### 4.1. Sign in with Apple Mandate (Guideline 4.8)

- **Law**: When offering third-party authentication (Google/Facebook/X/LINE/etc.), you MUST also offer **Sign in with Apple with equal prominence**.
- **Exceptions**: Education-institution / enterprise-internal-only auth, apps using only proprietary SSO, etc.
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
- **Email Privacy Relay**: Apple may issue a relay email (`xxx@privaterelay.appleid.com`). When the user opts to hide their real email, they can sever the relay anytime. **Server-side logic must assume relay severance**.
- **Anti-Pattern**: Hiding the Sign in with Apple button or making it tiny → rejection trigger (Apple HIG specifies button design).

### 4.2. Account Deletion Mandate (Guideline 5.1.1(v))

- **Law**: Apps with account creation MUST implement **complete in-app account deletion** (since June 2022).
- **Required**:
  - Detours like "contact support" or "delete via web" are **forbidden**
  - Place "Delete account" in a **discoverable location** in Settings
  - Tap → confirmation dialog → execute deletion flow
  - **Physically delete** PII (logical deletion alone violates the rule)
  - Show confirmation message after deletion
- **Implementation Pattern**:
  ```
  Settings → Account → "Delete Account"
    ↓
  Confirm: "All data will be deleted. This is irreversible. Are you sure?"
    ↓
  [Delete]
    ↓
  Server: physically delete user PII + audit log + sever Sign in with Apple
    ↓
  Show "Account deleted" + sign out
  ```
- **Backend Integration**: Aligns with `core/000_core_mindset.md` §1.12 Privacy-by-Architecture and `security/100_data_governance.md` "right to be forgotten."

### 4.3. Multi-Factor Authentication (MFA / 2FA)

- **Apple ID 2FA**: User-side setting (mandatory).
- **App-Specific MFA**: Recommend App-Specific Password / TOTP / Passkey (FIDO2).
- **Passkey Integration** (iOS 17+): `ASAuthorizationPlatformPublicKeyCredentialProvider` for Passkey registration/auth.

### 4.4. Cross-References
- `security/000_security_privacy.md` — Zero Trust / authentication
- `security/100_data_governance.md` — Right to be forgotten / GDPR Art. 17

---

## Part 5: Apple Submission & Review — TestFlight / Phased Release / Expedited / Appeal

### 5.1. TestFlight Beta Testing

- **Law**: All New Apps / Major Updates MUST progress through **TestFlight Internal → External → Production**.
- **Internal Testing**: ≤100 team members, no Beta App Review, distributed within 24h.
- **External Testing**: ≤10,000 testers, initial Beta App Review (24-48h).
- **TestFlight Build Lifetime**: 90 days. Re-upload before expiry.
- **Feedback Collection**: TestFlight in-app feedback + screenshot attachments.

### 5.2. App Store Connect — App Review Process

- **Standard Review**: 24-48 hours typical.
- **Expedited Review**: For emergencies (use sparingly — a few times per year). Examples: critical crash fixes, severe security vulnerabilities.
- **Pre-Submission Checklist**: see §18.

### 5.3. Phased Release

- **Law**: Major updates MUST enable **Phased Release**, ramping 0% → 100% over 7 days.
- **Schedule**: Day 1: 1% / Day 2: 2% / Day 3: 5% / Day 4: 10% / Day 5: 20% / Day 6: 50% / Day 7: 100%
- **Pause / Resume**: When crash rate exceeds threshold, **pause immediately**. Submit fix ASAP.

### 5.4. Rejection Appeal

- **Law**: When you disagree with rejection, appeal to the **App Review Board**. Use **logical, guideline-citing rebuttals**, not emotional arguments.
- **Process**:
  1. App Store Connect → Resolution Center → Reply
  2. Apple re-confirms guideline interpretation
  3. Escalate to App Review Board if needed

### 5.5. App Store Connect Roles & Permissions

- **Account Holder**: Single, hard to change.
- **Admin / App Manager / Developer / Marketing / Sales / Customer Support / Finance**: Per-role permissions.
- **Two-Factor Authentication**: Mandatory for all Admin/Developer (since 2018).
- **Audit Log**: Full operations retrievable via App Store Connect API.

### 5.6. Code Signing & Provisioning Profiles

- **Distribution Certificate**: One per team (Apple Distribution).
- **Provisioning Profile**:
  - App Store Distribution
  - Ad Hoc (testing; UDID registration required)
  - Enterprise (in-house only; Apple Developer Enterprise Program)
- **Automatic vs Manual signing**: Large teams use Manual + Fastlane Match.

### 5.7. Cross-References
- `engineering/600_git_workflow.md` §7.0 SemVer Tag Discipline
- `operations/400_site_reliability.md` Phased Rollout (GitOps context)

---

## Part 6: Google Play — Console Policies & Target API Annual

### 6.1. Annual Target API Level Update Policy

- **Law**: Google Play raises the minimum Target API Level annually. Failing to comply = **cannot update or submit new apps**.
- **2026 Example**: Target API 35+ (Android 15) required (existing app updates: 33+).
- **Cycle**: Annual minimum announced Q3-Q4 → must comply by August of the following year.

### 6.2. Play Console — Privacy Policy URL Mandatory

- **Law**: Apps handling personal data MUST set a Privacy Policy URL in Play Console. Broken or 404 links = instant rejection.

### 6.3. UGC (User-Generated Content) Policy (2025 Strengthened)

- **Law**: Apps handling UGC MUST implement:
  - Content **filtering** or moderation
  - **Reporting** (flag inappropriate content)
  - **Block** function (block specific users)
  - **24-hour response posture**
  - Removal flow for guideline-violating content
- **Anti-Pattern**: Offering UGC without a reporting feature → instant rejection

### 6.4. Subscriptions Policy

- **Clear disclosure**: Price, period, cancellation method shown before purchase
- **Cancellation reachable** from Play Console subscription management
- **Free trial**: Notify before automatic billing (Play Billing Library handles this)

### 6.5. Play Console Roles & Permissions

- **Account Owner**: Hard to change.
- **Admin / Developer / Marketing / Customer Service**: Permission split.
- **2FA Required**: Mandatory for all admins.

---

## Part 7: Google Play — Data Safety & Privacy Disclosure

### 7.1. Data Safety Section Mandate (2022+)

- **Law**: Declare **all data the app collects/shares** in Play Console's Data Safety section (analog of Apple's Privacy Nutrition Labels).
- **Required Items**:
  - Data types collected (Personal info / Financial info / Location / Health / Photos / etc.)
  - Recipients (own only / third parties)
  - Purposes (App functionality / Ads / Analytics / etc.)
  - Encryption status (in transit / at rest)
  - Whether users can request data deletion
- **Verification**: Divergence between declaration and implementation → **policy violation, app suspension** risk.

### 7.2. Permission Justification

- **Dangerous Permissions**: Location, Contacts, Camera, Microphone, etc.
- **Runtime Permission**: Mandatory at runtime since Android 6.0+.
- **Justification Required**: Explain "why this permission is needed" in Play Console at submission.
- **Anti-Pattern**: Requesting permissions unrelated to features (e.g., calculator app accessing Contacts) → policy violation

### 7.3. Background Location Mandate (Android 10+)

- **Law**: Background location access requires **clear functional necessity** and Play Console approval.
- **Required**: When requesting `ACCESS_BACKGROUND_LOCATION`, justify via Play Console's dedicated form at submission.

---

## Part 8: Google Play Billing & Subscriptions

### 8.1. Play Billing Library 7+ Mandate

- **Law**: New apps and major updates from 2024+ MUST use **Play Billing Library 7.0+**.
- **Implementation Skeleton**:
  ```kotlin
  val billingClient = BillingClient.newBuilder(context)
    .setListener(purchasesUpdatedListener)
    .enablePendingPurchases()
    .build()

  // Execute purchase
  val billingFlowParams = BillingFlowParams.newBuilder()
    .setProductDetailsParamsList(productDetailsParamsList)
    .build()
  val billingResult = billingClient.launchBillingFlow(activity, billingFlowParams)
  ```

### 8.2. Real-time Developer Notifications (RTDN)

- **Law**: Subscription state changes are pushed to your server via **Google Cloud Pub/Sub** (Webhook equivalent).
- **Required Setup**:
  - Create Pub/Sub Topic
  - Register Topic name in Play Console
  - Server-side: consume Subscription, handle `SUBSCRIPTION_RENEWED` / `SUBSCRIPTION_EXPIRED` / `SUBSCRIPTION_CANCELED` etc.

### 8.3. Subscription Lifecycle

- **Grace Period**: Buffer when billing fails (user updates payment info)
- **Account Hold**: Suspended state after Grace Period (max 30 days)
- **Pause**: User-initiated pause (max 3 months)

### 8.4. Refund Process

- **Google Play Refund Policy**: Auto-refund within 48 hours; subscription refunds case-by-case.
- **Server-side**: Revoke entitlement on RTDN `REFUND` notification.

### 8.5. Anti-Patterns
- Routing to external payments (outside regional DMA exceptions) → policy violation
- UX that obstructs subscription cancellation → violation

---

## Part 9: Google Play — Distribution (AAB / Closed-Open-Internal Testing / Phased Rollout)

### 9.1. Android App Bundle (AAB) Mandate (2021+)

- **Law**: All new apps and updates MUST submit in **`.aab` format**. Direct `.apk` submission is **not allowed**.
- **Benefits**:
  - **Dynamic Delivery**: Play auto-generates APKs optimized per device language/resolution/ABI
  - **App Size Reduction**: ~35% on average
- **Build**:
  ```bash
  ./gradlew bundleRelease   # → app-release.aab
  ```

### 9.2. Testing Tracks

| Track | Use Case | Max Users | Speed |
|---|---|---|---|
| **Internal Testing** | Internal | 100 | Instant |
| **Closed Testing** | Limited Beta | Email list / Google Group | Hours |
| **Open Testing** | Public Beta | Unlimited (Play Store searchable) | Hours |
| **Production** | Live | All users | Hours |

### 9.3. Phased Rollout

- **Law**: Major updates MUST use Phased Rollout, ramping **5% → 100%** stepwise.
- **Setup**: Play Console → Production → set rollout percentage to 5/10/20/50/100%.
- **Halted Rollout**: Auto-halt on crash threshold + rollback option.

### 9.4. In-App Updates API

- **Law**: Recommended to surface **in-app update prompts**.
- **Two Modes**:
  - **Flexible**: Background update with continued use
  - **Immediate**: Full-screen block for critical updates
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

- **Play Console Auto-Feature**: Google tests uploaded AAB on multiple devices, auto-detecting crashes / ANR / performance / security issues.
- **Mandatory Action**: Resolve warnings before Production.

---

## Part 10: Google Play Integrity & Anti-Tamper

### 10.1. Play Integrity API (SafetyNet successor)

- **Law**: Apps requiring tamper / unauthorized-device detection (financial, gaming, content protection) MUST use **Play Integrity API**. SafetyNet was **sunset in 2024**.
- **Verdicts**:
  - `MEETS_DEVICE_INTEGRITY`: legitimate Android device
  - `MEETS_BASIC_INTEGRITY`: passes basic checks (rooting etc.)
  - `MEETS_STRONG_INTEGRITY`: latest security patch + GMS-certified
- **Server-side Verification**: Don't trust client responses — verify with Google API server-side.
- **Anti-Pattern**: Client-only Integrity decisions → can be bypassed via reverse engineering

### 10.2. App Signing by Google Play

- **Law**: Enable Play App Signing. Google manages the signing key; developer signs only with Upload Key.
- **Benefits**: Recoverable on key loss; prerequisite for Dynamic Delivery.

### 10.3. ProGuard / R8 Obfuscation

- **Law**: Production releases MUST enable **R8 (ProGuard successor)** obfuscation.
- **`proguard-rules.pro`**:
  ```
  # Protect sensitive logic
  -keep class com.example.api.** { *; }
  ```

---

## Part 11: Children's & Family Apps

### 11.1. COPPA (US)

- **Law**: Apps targeting under-13 (or "all ages including children") MUST comply with COPPA.
- **Required**:
  - **Verifiable Parental Consent**: parental consent (credit card / e-signature / official ID)
  - **Data Minimization**: collect only the minimum required for functionality
  - **Ad restrictions**: No behavioral advertising; contextual only
- **GDPR-K (EU child protection)**: Same protections for under-16 (13–16 by member state).

### 11.2. Apple Kids Category

- **Law**: Special requirements for "Kids" category submission:
  - Third-party ads **forbidden**
  - External links **forbidden** (or "parent gate" required)
  - In-app purchases require **parent authentication** (age-tiered)
  - Sub-category-specific compliance: Ages 5 & under / 6-8 / 9-11
- **Audit**: Apple reviews Kids submissions **especially strictly**.

### 11.3. Google Designed for Families

- When enrolled in Designed for Families:
  - Ad SDKs MUST comply with **Families policy**
  - Restricted data collection
  - Parental controls (Family Link integration)

### 11.4. Cross-References
- `security/100_data_governance.md` — Children's PII handling

---

## Part 12: Platform API Terms — Maps / YouTube / Push

### 12.1. Google Maps Platform Terms

- **Caching forbidden**: No persistent cache of map tiles / place data (>30 days banned).
- **Attribution mandatory**: Don't hide or alter Google logo / copyright.
- **No data-only API use**: "Extract data without map display" is forbidden.
- **Alternatives**: Compare MapBox / OpenStreetMap on cost / license.

### 12.2. YouTube Data API Terms

- **Background playback forbidden**: API-based background playback violates terms.
- **No ad skip / removal**: Modifying or removing YouTube ads is forbidden.
- **No alternative implementation of YouTube Premium features**: download, ad-free, etc.

### 12.3. Apple Push Notifications (APNs)

- **APNs Provider Authentication Token**: Token-based (recommended) or Certificate-based. Token-based avoids cert renewal hassle.
- **Notification Service Extension**: Implement when adding images / custom UI.
- **Critical Alerts**: Bypassing Focus mode requires special Apple Entitlement.

### 12.4. Firebase Cloud Messaging (FCM)

- **Topic / Token / Condition**: Three targeting modes.
- **HTTP v1 API (recommended)**: Legacy HTTP API is being deprecated.
- **Notification vs Data**: Notification Message displayed by OS; Data Message handled in app.

### 12.5. Push Notification Compliance

- **Opt-in mandatory** under GDPR/CCPA.
- **Frequency limits**: Excessive notifications auto-tier to Opt-out (iOS Focus / Android DND).
- **Marketing notifications explicit**: Separate functional notifications from marketing.

### 12.6. Cross-References
- `engineering/100_api_integration.md` API integration general
- `engineering/500_firebase_gcp.md` FCM details

---

## Part 13: ASO (App Store Optimization) Deep Dive

### 13.1. Keyword Strategy

- **Apple App Store**:
  - **Title**: ≤30 chars, most important SEO factor
  - **Subtitle**: 30 chars, complements Title
  - **Keywords Field**: 100 chars (comma-separated; no duplicates; no competitor names)
  - **Promotional Text**: 170 chars; updatable without release (banner-style)
- **Google Play**:
  - **Title**: 30 chars
  - **Short Description**: 80 chars
  - **Long Description**: 4000 chars; body SEO works — strategic
- **Tools**: Sensor Tower / data.ai / AppTweak / ASOdesk

### 13.2. Creative Optimization

- **App Icon**: differentiated; 5-second recall; OS-specific (iOS 26+ Liquid Glass, etc.)
- **Screenshots**:
  - iOS: max 10 / Localized
  - Android: max 8 / Phone, Tablet, TV
  - **First 3 are most important** (carousel front conversion)
- **Preview Video**:
  - iOS: max 30s × 3
  - Android: YouTube link
  - **First 3 seconds** for value proposition

### 13.3. A/B Testing

- **Apple Product Page Optimization (PPO)**: 3 variants of Icon / Screenshots / Video (max 3 treatments).
- **Google Store Listing Experiments**: Default Listing vs Custom Store Listings (regional).
- **Metrics**: Tap-Through Rate (TTR) / Conversion Rate (CR) / Retention D7

### 13.4. App Privacy & Trust

- **Privacy Nutrition Labels (Apple) / Data Safety (Google)** directly affect CR. ASO favors data minimization.

### 13.5. Custom Product Pages (Apple) / Custom Store Listings (Google)

- **Apple**: Marketing-campaign-specific dedicated pages (≤35).
- **Google**: Per-country / URL-parameter customization.

### 13.6. ASO + ASA Synergy

- Mutual reinforcement between **ASA (Apple Search Ads)** and ASO.
- **ASO Refresh Cycle**: monthly keyword review, quarterly screenshot updates.

### 13.7. Cross-References
- `product/500_growth_marketing.md` — growth in general / SEO/GEO

---

## Part 14: Localization & Internationalization for Stores

### 14.1. App Store Connect Localization

- **Supported Languages**: 40+, Title / Subtitle / Description / Keywords / Screenshots per language.
- **Required**: Target markets (Japan / US / EU / China / SEA) MUST have full Day-1 localization.
- **Anti-Pattern**: Pasting machine translation as-is → rejection trigger (Apple Reviewer checks).

### 14.2. Google Play Localization

- Same: per-language Title / Description / Screenshots / Video.
- Google Play offers machine-translation aids (limited accuracy; human localizer required).

### 14.3. Pricing & Currency Localization

- **Price Tier auto-conversion** vs **Custom Price Points**
- **Tax-inclusive vs Exclusive display** — region-by-region legal compliance
- **Japan**: Tax-inclusive display mandatory (Consumption Tax Law)

### 14.4. Cross-References
- `product/800_internationalization.md` — i18n/L10n in general

---

## Part 15: DMA Compliance (EU Digital Markets Act)

### 15.1. DMA Scope (2024+)

- **Gatekeepers**: Apple / Google / Microsoft / Meta / Amazon / ByteDance fall under DMA.
- **EU Member States**: Apps deployed in EU must comply with the new policies:

### 15.2. Alternative App Marketplaces (iOS)

- **Apple iOS in EU**: Distribution via Alternative App Marketplaces (AltStore PAL, Setapp Mobile, etc.) became available in March 2024.
- **Core Technology Fee (CTF)**: €0.50/install above 1M installs (multiple models per Apple contract).

### 15.3. Sideloading (Web Distribution)

- **Web Distribution Entitlement**: Direct distribution from developer's website (EU only; Entitlement application required).
- **Notarization**: Apple's signature retained, but distribution external.

### 15.4. External Payment Links

- **Music Streaming Services Entitlement** etc.: external payment links permitted in specific categories.
- **DMA Core Function**: Required choice screens for browsers / search engines / communication.

### 15.5. Browser Choice Screen

- **iOS in EU**: Browser choice on first launch (Safari is one of many).
- **Search Engine Choice**: Google + Bing / DuckDuckGo / Ecosia options.

### 15.6. Anti-Patterns
- "DMA is EU-only, ignore it" → required if EU revenue share matters
- Fraudulent apps masquerading as Alternative Marketplaces → early detection required

### 15.7. Cross-References
- `security/100_data_governance.md` — GDPR / DMA alignment

---

## Part 16: Generative AI App Compliance

### 16.1. Apple GenAI Guidelines (2024+)

- **Disclosure**: Apps with GenAI features MUST disclose in Privacy Nutrition Labels.
- **Content Moderation**: Mandatory filters preventing harmful generation (CSAM, illegal acts, discrimination).
- **Data Source**: Compliance with training-data copyright (Apple Reviewers may probe training-data legitimacy).

### 16.2. Google Play GenAI Policy

- **App Tags Required**: Declare AI Generated Content / AI Chat / AI Image Gen feature tags.
- **Reporting Mechanism**: Mandatory user-report function for harmful AI output.
- **In-App User Reporting**: UI for users to instantly report inappropriate AI output.

### 16.3. Boundaries of AI Output

- **No medical / legal / financial advice** (or explicitly say "consult an expert")
- **Minor Protection**: Limit GenAI in kids' apps; parental controls
- **Deepfake / Impersonation Prevention**: Watermark or metadata "AI-generated" on output

### 16.4. Cross-References
- `ai/000_ai_engineering.md` — AI safety / OWASP LLM Top 10
- `core/000_core_mindset.md` §1.22 Responsible AI Disclosure

---

## Part 17: Specialized Verticals — Health / Finance / Crypto / Games

### 17.1. Healthcare / Medical (HealthKit / Health Connect)

- **Apple HealthKit**:
  - Data lives on **device + iCloud (encrypted)** only; direct server transmission requires Special Entitlement
  - Sale or ad-targeting using health data **forbidden** (Guideline 5.1.3)
  - HIPAA / FDA 510(k) acquired separately if applicable
- **Google Health Connect**:
  - OS integration in Android 14+
  - Same: user consent + data-purpose disclosure

### 17.2. Financial / Crypto / Crypto Wallet

- **Apple Guideline 3.1.5(b)**: Crypto-asset trading allowed only in regulated countries with required licenses.
- **Crypto Wallet**: Self-custody wallets allowed; conflicts with IAP forbidden.
- **Google Play Regulation**: Country-specific licenses; consumer-protection obligations.

### 17.3. Games-Specific Regulation

- **Loot Boxes (gacha)**: Probability disclosure mandatory (Japan / China / Korea / EU).
- **In-Game Currency**: Convertible tokens are regulated.
- **Apple Arcade / Google Play Pass**: Separate terms for store-exclusive games.

### 17.4. Hybrid Apps (PWA / Capacitor / React Native)

- **Apple**: Main features need not be native, **but pure browser wrappers fail Guideline 4.2**.
- **Google**: Trusted Web Activity recommended for PWA wrappers.
- **App Bundle**: React Native / Flutter apps need AAB compatibility.

### 17.5. Cross-References
- `engineering/400_mobile_flutter.md` Flutter implementation
- `engineering/410_native_platforms.md` Native implementation

---

## Part 18: Common Rejections & Pre-Submission Master Checklist

### 18.1. Top 10 Rejection Reasons

| Rank | Reason | Guideline |
|---|---|---|
| 1 | Crash / bug | Apple Guideline 2.1 |
| 2 | Submission-implementation drift | 2.3.1 |
| 3 | Incomplete info (broken links / missing support) | 1.5 |
| 4 | Privacy policy issues | 5.1.1 |
| 5 | IAP violation (external payment routing) | 3.1.1 |
| 6 | Subscription disclosure issues | 3.1.2(a) |
| 7 | Exploitable default features | 5.1.5 |
| 8 | UI deviates significantly from HIG / Material | 4.0 |
| 9 | No account-deletion function | 5.1.1(v) |
| 10 | ATT / Privacy Manifests issues | 5.1.1 / 5.1.2 |

### 18.2. Pre-Submission Master Checklist

```
□ Build configuration
  □ Built with Release Configuration
  □ dSYM with symbols uploaded
  □ Bitcode (deprecated; not needed)
  □ Build Number larger than previous

□ Feature completeness
  □ All "Coming Soon" / "Beta" / Lorem Ipsum / placeholders removed
  □ TestFlight crash rate < 0.1%
  □ Verified on key OS versions (latest + n-2)
  □ Back path on every screen

□ Privacy
  □ Privacy Policy URL valid (200 OK)
  □ App Privacy Details filled in
  □ NSUserTrackingUsageDescription set (when using ATT)
  □ Privacy Manifests included (PrivacyInfo.xcprivacy)
  □ Required Reason API declared
  □ Data Safety section filled (Google Play)

□ Auth & accounts
  □ Sign in with Apple offered (when offering 3P auth)
  □ Account-deletion flow reachable from UI (5.1.1(v))
  □ 2FA support (Apple / Google Account)

□ Metadata
  □ Title / Subtitle / Keywords compliant (no false / exaggerated claims)
  □ Screenshots match real app
  □ Preview Video matches app
  □ App Description accurately describes features
  □ Demo account credentials in submission notes (Apple review)

□ Guideline-specific
  □ HIG / Material Design compliance
  □ Dark Mode (iOS)
  □ Dynamic Type (iOS)
  □ Accessibility (VoiceOver / TalkBack)

□ Billing
  □ IAP-routed billing (no external payments outside Reader App exception)
  □ Subscription price / period / cancellation method shown
  □ Restore Purchase button (iOS)

□ Store-specific
  □ Google Play: latest Target API Level
  □ Google Play: AAB submission
  □ Apple: Phased Release ON
  □ Apple: TestFlight Beta complete

□ Legal
  □ GDPR / CCPA disclosure (in privacy policy)
  □ COPPA / GDPR-K for kids' apps
  □ Crypto: regulatory license obtained
  □ Health: FDA / medical-device confirmation

□ Contacts
  □ Support URL valid
  □ Privacy Policy URL valid
  □ App Review contact (email / phone) accurate
```

### 18.3. Post-Rejection Flow

1. **Cite the guideline clause** to understand the reason
2. **Implement fix** + **proof of fix (test video / screenshots)**
3. **Reply formally** in Resolution Center (no emotional rebuttals)
4. **Appeal to App Review Board** if the verdict doesn't change

---

## Part 19: Anti-Pattern Catalog

### 19.0. Forbidden Practices Quick Reference

| Category | Anti-Pattern | Detection | Reference |
|---|---|---|---|
| **Build** | "Coming Soon" / Lorem Ipsum left in | Pre-Submission Checklist | §18 |
| **Build** | Crash rate > 0.1% | TestFlight / Play Console | §5, §9 |
| **Privacy** | Missing Privacy Manifests | Xcode Privacy Report | §2 |
| **Privacy** | Using IDFA without ATT | App Review | §2.1 |
| **Privacy** | Declaration vs reality drift | Apple/Google audit | §2.4, §7.1 |
| **IAP** | External payment routing (outside Reader exception) | App Review | §3.1 |
| **IAP** | Subscription cancellation obstruction | Resolution Center | §3.3 |
| **Identity** | No account-deletion function | App Review | §4.2 |
| **Identity** | Sign in with Apple missing (with 3P auth) | App Review | §4.1 |
| **HIG/Material** | Missing back path | App Review | §1.1 |
| **HIG** | No Dark Mode support | App Review (recommended) | §1.2 |
| **HIG** | Fixed font size | App Review / EAA violation | §1.3 |
| **Distribution** | APK submission to Google Play | Play Console reject | §9.1 |
| **Distribution** | Target API Level not met | Play Console reject | §6.1 |
| **UGC** | No reporting function | App Review | §6.3 |
| **UGC** | No 24h response posture | App Review | §6.3 |
| **API** | Persistent Google Maps cache | API terms violation | §12.1 |
| **API** | YouTube background playback | API terms violation | §12.2 |
| **Children** | Ads in Apple Kids category | App Review | §11.2 |
| **Children** | PII collection without parental consent | COPPA violation | §11.1 |
| **GenAI** | No content moderation | App Review / legal risk | §16 |
| **Crypto** | Trading without regulatory license | App Review reject | §17.2 |
| **Health** | HealthKit data for ads | Apple Guideline 5.1.3 | §17.1 |
| **Localization** | Submitting raw machine translation | App Review reject | §14.1 |
| **DMA** | Maintaining old IAP exclusivity in EU | DMA violation | §15 |
| **Hybrid App** | Pure web wrapper | Apple Guideline 4.2 | §17.4 |

---

## Appendix A: Reverse Index (Keyword → Section)

| Keyword | Section |
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
| Google Maps API terms | §12.1 |
| YouTube Data API terms | §12.2 |
| APNs / FCM | §12.3, §12.4 |
| ASO / keyword strategy / A/B Test | §13 |
| Localization (Store) | §14 |
| DMA / Alternative Marketplace / Sideloading | §15 |
| Generative AI compliance | §16 |
| HealthKit / Health Connect | §17.1 |
| Crypto / Crypto Wallet | §17.2 |
| Loot Box / In-Game Currency | §17.3 |
| Hybrid app / PWA / Capacitor | §17.4 |
| Pre-Submission Checklist | §18.2 |
| Anti-Pattern Catalog | §19.0 |

---

## Appendix B: Cross-References (Section → Related Universal Rules)

| Section | Related Universal Rules |
|---|---|
| §1 HIG/Material Design | `design/000_design_ux.md` / `core/000_core_mindset.md` §1.13 Accessibility |
| §2 Privacy Stack | `security/100_data_governance.md` / `security/000_security_privacy.md` / `core/000_core_mindset.md` §1.12 Privacy-by-Architecture |
| §3 IAP & Subscriptions | `product/300_revenue_monetization.md` / `product/400_pricing_strategy.md` |
| §4 Identity / Sign in with Apple | `security/000_security_privacy.md` / `security/100_data_governance.md` |
| §5 Submission / Code Signing | `engineering/600_git_workflow.md` §7.0 SemVer / `operations/400_site_reliability.md` |
| §6-§10 Google Play in general | `engineering/410_native_platforms.md` |
| §11 Children | `security/100_data_governance.md` / GDPR-K |
| §12 API Terms | `engineering/100_api_integration.md` / `engineering/500_firebase_gcp.md` |
| §13 ASO | `product/500_growth_marketing.md` |
| §14 Localization | `product/800_internationalization.md` |
| §15 DMA | `security/100_data_governance.md` (regulation in general) |
| §16 GenAI | `ai/000_ai_engineering.md` / `core/000_core_mindset.md` §1.22 Responsible AI |
| §17 Specialized | `engineering/400_mobile_flutter.md` / `engineering/410_native_platforms.md` / `security/100_data_governance.md` |

---

**Last Updated**: 2026-05-06 (v1.5.0)
**Authority**: Universal Constitution (axiarch core)
**Classification**: Product — Store Guidelines & Compliance
