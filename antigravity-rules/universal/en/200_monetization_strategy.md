# 200. Monetization Strategy & Finance

## 1. Unit Economics
*   **LTV > CAC**:
    *   **Principle**: Always monitor that Lifetime Value (LTV) exceeds Customer Acquisition Cost (CAC). Ideally, aim for LTV / CAC > 3.
    *   **Measurement**: Ensure CAC and ROI are measurable for every marketing channel.
*   **Break-even Point**:
    *   Understand fixed costs (servers, tools) and variable costs (API usage) and always be aware of how many paid users are needed to become profitable.

## 2. In-App Purchases (IAP) & Subscriptions
*   **SKU Design**:
    *   **Simplicity**: Limit plans to about three (e.g., Free, Pro, Business) to avoid confusing users.
    *   **Duration**: Offer Monthly and Yearly plans, and provide a clear discount for Yearly plans (e.g., 2 months free) to encourage upsells.
*   **Offer Strategy**:
    *   **Introductory Offer**: Always set a free trial (e.g., 1 week, 2 weeks) for first-time subscriptions to increase conversion rates.
    *   **Win-back**: Prepare a mechanism for comeback campaigns (discount offers) for churned users.

## 3. Freemium Model
*   **Defining the Boundary**:
    *   **Free**: Allow users to experience the "Aha! Moment" (realizing value) for free. However, create paywalls for continuous use or advanced features (e.g., unlimited storage, advanced AI features).
    *   **Paywall**: The paywall screen should visually appeal to the benefits and remove anxiety about cancellation (state "Cancel Anytime" clearly).

## 4. Finance & Expenses
*   **Cost Optimization**:
    *   **Prevent Cloud Bankruptcy**: Always set Budget Alerts for AWS/GCP/Firebase.
    *   **API Costs**: For pay-as-you-go APIs like OpenAI, implement caching strategies and rate limits to prevent cost explosions.
