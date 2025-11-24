# 160. Store Guidelines Compliance

## 1. Apple App Store (iOS)
*   **Human Interface Guidelines (HIG)**:
    *   **Design Compliance**: UI violating HIG (confusing buttons, lack of back navigation) will be rejected. Strict adherence is mandatory.
*   **Business Model & Billing**:
    *   **IAP Mandatory**: Must use **In-App Purchase (IAP)** for digital content sales. External links for payment are strictly prohibited (except for Reader Apps).
*   **Privacy & Data**:
    *   **App Tracking Transparency (ATT)**: If you collect IDFA (Identifier for Advertisers), you MUST implement the popup requesting user permission.
    *   **Privacy Manifests [2025 Mandatory]**:
        *   You must include a `PrivacyInfo.xcprivacy` file that accurately describes the data types collected by your app and third-party SDKs, and the purpose of use.
        *   **API Usage Reasons**: When using APIs for disk space or boot time, you must declare the valid reason (Required Reason API).
    *   **Data Minimization**: Do not collect data that is not necessary for functionality.d)

## 2. Google Play Store (Android)
*   **Target API Level**:
    *   **Keep Updated**: Google mandates regular API level updates. Failure to comply blocks updates. Always target the latest Android version.
*   **Play Integrity API**:
    *   **Tamper Detection**: Implement **Play Integrity API** to verify that the app is untampered and running on a genuine device.

## 3. Common Rejections
*   **Incomplete Features**:
    *   Apps with "Coming Soon", beta labels, or dummy text (Lorem Ipsum) will be rejected. Submit only finished products.
*   **User Generated Content (UGC)**:
    *   Apps allowing user posts must implement "Report/Block inappropriate content" features and "Terms of Service agreement".
