# 160. Store Guidelines Compliance

## 1. Apple App Store (iOS)
*   **Human Interface Guidelines (HIG)**:
    *   **Design Compliance**: UI that violates Apple's HIG (buttons confusing with system, lack of back operation) is subject to rejection. Comply thoroughly.
*   **Business Model & Billing**:
    *   **IAP Mandatory**: Always use **In-App Purchase (IAP)** for selling digital content. Links guiding to external payments (purchase on Web, etc.) are strictly prohibited (except for Reader App exceptions).
*   **Privacy & Data**:
    *   **App Tracking Transparency (ATT)**: When acquiring IDFA (Advertising Identifier), always implement a popup asking for user permission.
    *   **Privacy Manifests [2025 Mandatory]**:
        *   Must include a `PrivacyInfo.xcprivacy` file and accurately describe data types collected by the app and third-party SDKs and their usage purposes.
        *   **Reason for API Use**: When using APIs for disk space or startup time, you must declare a valid reason (Required Reason API).
    *   **Data Minimization**: Do not collect data not necessary for features.

## 2. Google Play Store (Android)
*   **Target API Level**:
    *   **Maintain Latest**: Google periodically requires raising the target API level. Delaying this prevents updates, so always support the latest Android version.
*   **Play Integrity API**:
    *   **Tamper Detection**: Introduce **Play Integrity API** to verify if the app has been tampered with and is running on a legitimate device.
*   **Reporting & Blocking**:
    *   **UGC Requirements**: Apps containing User Generated Content (UGC) must implement features to report and block inappropriate content and have a system to respond within 24 hours (2025 New Policy).

## 3. Common Rejections
*   **Incomplete Features**:
    *   Apps containing "Coming Soon", beta version notations, or dummy text (Lorem Ipsum) will be rejected. Submit only finished products.
*   **Metadata**:
    *   Do not include features different from the actual app or misleading expressions ("World's No.1" etc. without basis) in screenshots or descriptions.
