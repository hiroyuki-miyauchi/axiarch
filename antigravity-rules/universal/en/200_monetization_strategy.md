# 200. Monetization Strategy & Finance

## 1. Unit Economics
*   **LTV > CAC**:
    *   **Principle**: Constantly monitor that Customer Lifetime Value (LTV) exceeds Customer Acquisition Cost (CAC). Ideally aim for LTV / CAC > 3.
    *   **Measurement**: Make CAC and ROI measurable for each channel in all marketing initiatives.
*   **Break-even Point**:
    *   Understand fixed costs (server fees, tool fees) and variable costs (API usage fees), and always be conscious of how many paid users are needed to become profitable.

## 2. In-App Purchases & Subscriptions (IAP)
*   **SKU Design**:
    *   **Simplicity**: Narrow down plans to about 3 (e.g., Free, Pro, Business) so users don't get lost.
    *   **Duration**: Prepare Monthly and Yearly plans, and offer a clear discount for the Yearly plan (e.g., 2 months free) to aim for upsells.
*   **Offer Strategy**:
    *   **Introductory Offer**: Always set a free trial (e.g., 1 week, 2 weeks) at initial registration to increase conversion rates.
    *   **Win-back**: Prepare a comeback campaign (discount offer) mechanism for cancelled users.

## 3. Freemium Model
*   **Defining Boundaries**:
    *   **Free**: Let users experience for free until the "Aha! Moment" (the moment they realize value). However, create charging points for continuous use or advanced features (e.g., unlimited saves, advanced AI features).
    *   **Paywall**: Design the Paywall to visually appeal to benefits and remove anxiety about cancellation (state "Cancel Anytime").

## 4. Finance & Expenses
*   **Cost Optimization**:
    *   **Cloud Bankruptcy Prevention**: Always set Budget Alerts for AWS/GCP/Firebase.
    *   **API Costs**: Set caching strategies and rate limits for pay-as-you-go APIs like OpenAI to prevent cost explosions.
