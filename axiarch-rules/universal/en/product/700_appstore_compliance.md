# 13. Store Guidelines & Compliance

> [!CAUTION]
> **This file is a Universal Rule (Immutable). Editing is prohibited unless an explicit "Amend Constitution" instruction is given.**
> Last Updated: 2026-03-24

> [!IMPORTANT]
> **Supreme Directive**
> "Store compliance is not optional — rejection at the gate means zero users."
> All app store submissions must comply with the latest platform guidelines.
> Strictly follow: **Platform Rules > User Trust > Feature Velocity**.
> **5 Sections.**

---


## Table of Contents

1. [§1. Apple App Store (iOS)](#1-apple-app-store-ios)
2. [§2. Google Play Store (Android)](#2-google-play-store-android)
3. [§3. Platform API Terms](#3-platform-api-terms)
4. [§4. ASO (App Store Optimization)](#4-aso-app-store-optimization)
5. [§5. Common Rejections & Checklist](#5-common-rejections--checklist)
6. [Appendix A: Quick Reference Index](#appendix-a-quick-reference-index)

---

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

---

## Appendix A: Quick Reference Index

### Reverse Lookup Index (Keyword → Section)

| Keyword | Section |
|---|---|
| HIG, IAP, ATT, Privacy Manifests | §1 Apple App Store |
| Account Deletion Mandate | §1 Apple 5.1.1(v) |
| Target API, Play Integrity, UGC | §2 Google Play Store |
| Google Maps, YouTube API, Sign in with Apple | §3 Platform API Terms |
| Keyword strategy, A/B testing, ASO | §4 ASO |
| Rejection, pre-submission checklist | §5 Common Rejections |

### Cross-References (Section → Related Rules)

| Section | Related Universal Rules |
|---|---|
| §1 Apple App Store | `200_design_ux`, `600_security_privacy`, `601_data_governance` |
| §2 Google Play | `343_native_platforms`, `600_security_privacy` |
| §3 API Terms | `301_api_integration`, `600_security_privacy` |
| §4 ASO | `102_growth_marketing`, `800_internationalization` |
| §5 Checklist | `700_qa_testing`, `603_ip_due_diligence` |
