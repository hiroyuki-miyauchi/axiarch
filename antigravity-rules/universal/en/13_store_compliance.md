# 13. Store Guidelines & Compliance

## 1. Apple App Store (iOS)
*   **Human Interface Guidelines (HIG)**:
    *   **Design Compliance**: UIs that violate Apple's HIG (buttons confusing with system, lack of back operation) are subject to rejection. Comply thoroughly.
*   **Business Model & Billing**:
    *   **IAP Mandatory**: Always use **In-App Purchase (IAP)** for selling digital content. Links guiding to external payments (purchase on Web, etc.) are strictly prohibited (except for Reader App exceptions).
*   **Privacy & Data**:
    *   **App Tracking Transparency (ATT)**: If acquiring IDFA (Advertising Identifier), always implement a popup asking for user permission.
    *   **Privacy Manifests [2025 Mandatory]**:
        *   Must include `PrivacyInfo.xcprivacy` file and accurately describe data types collected by the app and third-party SDKs and their usage purposes.
        *   **Reason for API Use**: When using APIs such as disk capacity or boot time, the legitimate reason (Required Reason API) must be declared.
    *   **Data Minimization**: Do not collect data not necessary for features.
    *   **The Account Deletion Mandate (Apple 5.1.1(v))**:
        *   **Law**: Apps with account creation MUST implement a feature to **fully delete** the account directly from within the app. "Contact Support" is not acceptable.
        *   **Action**: Place an "Delete Account" button in a clear location in Settings, and implement a confirmation flow. Apply Backend Constitution (`37`) "Right to be Forgotten" exception and physically delete PII.

## 2. Google Play Store (Android)
*   **Target API Level**:
    *   **Keep Updated**: Google regularly requires raising the target API level. If delayed, updates will not be possible, so always support the latest Android version.
*   **Play Integrity API**:
    *   **Tamper Detection**: Introduce **Play Integrity API** to verify if the app has been tampered with or is running on a legitimate device.
*   **Reporting & Blocking**:
    *   **UGC Requirements**: Apps containing User Generated Content (UGC) must implement reporting/blocking features for inappropriate content and have a system to respond within 24 hours (2025 New Policy).

## 3. Platform API Terms
*   **Google Maps Platform**:
    *   **No Caching**: Saving/caching map data is strictly restricted by the terms of service. In principle, acquire from API every time.
    *   **Attribution**: Hiding or altering the Google logo and copyright notice is prohibited.
*   **YouTube Data API**:
    *   **No Background Play**: Implementing background play using the API is a violation of terms.
*   **Sign in with Apple**:
    *   **Obligation**: If implementing third-party authentication like Google Login, implementing **Sign in with Apple** with equal prominence is mandated by guidelines.

## 4. ASO (App Store Optimization)
*   **Keyword Strategy**:
    *   **Metadata**: Strategically place keywords with high search volume and appropriate competitiveness in Title, Subtitle, and Keyword fields.
    *   **Localization**: Not just translation, but select keywords matching search trends in each country.
*   **Creative Optimization**:
    *   **A/B Testing**: Always perform A/B testing on screenshots, app icons, and preview videos using **Product Page Optimization (iOS)** and **Store Listing Experiments (Android)** to maximize Conversion Rate (CVR).
    *   **Video**: Always prepare a preview video that conveys the app's value in the first 3 seconds.

## 5. Common Rejections & Checklist
*   **Pre-Submission Checklist**:
    *   [ ] **Incomplete Features**: Are all "Coming Soon", beta notations, and dummy text (Lorem Ipsum) removed?
    *   [ ] **Crashes**: Confirmed 0% crash rate in TestFlight/Internal Testing?
    *   [ ] **Broken Links**: Are links for Privacy Policy, Support URL, and Terms of Service valid?
    *   [ ] **Inappropriate Content**: Does it contain violence, porn, or discriminatory content? (Is there a filtering function for UGC?)
    *   [ ] **IP Rights**: Does the app icon or name infringe on other companies' trademarks?
    *   [ ] **Login Info**: Did you list the demo account (ID/Password) for reviewers in the notes? (Turn off 2FA or provide test code)
*   **Metadata**:
    *   Do not include features different from the actual app or misleading expressions ("World's No.1" etc. without basis) in screenshots or descriptions.
