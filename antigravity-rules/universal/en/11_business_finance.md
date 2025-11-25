# 11. Business, Finance & Monetization Strategy

## 1. Unit Economics & Finance
*   **LTV > CAC (The Golden Rule)**:
    *   **Principle**: Always monitor that Customer Lifetime Value (LTV) exceeds Customer Acquisition Cost (CAC). Ideally aim for **LTV / CAC > 3**.
    *   **Measurement**: Make CAC and ROI measurable for each channel in all marketing measures.
*   **Real-time P&L**:
    *   **Visualization**: Acquire not just sales but server costs (COGS) and ad expenses (CAC) via API to visualize an estimated daily P&L (Profit and Loss statement).
    *   **Unit Contribution Margin**: Always monitor that the Unit Contribution Margin per transaction is positive.
*   **FinOps (Cost Management)**:
    *   **Budget Alerts**: Must set Budget Alerts for AWS/GCP/Firebase to prevent cloud bankruptcy.
    *   **Cost Allocation**: Clarify costs per feature/team using tagging.

## 2. Monetization Models
*   **Subscription**:
    *   **SKU Design**: Limit plans to 3 (e.g., Free, Pro, Business) to prevent Decision Paralysis.
    *   **Annual Plans**: Offer clear discounts (e.g., 2 months free) for annual plans to improve cash flow.
*   **Freemium**:
    *   **Aha! Moment**: Let users experience for free until the moment they realize value.
    *   **Paywall**: On the payment screen, visually appeal to the benefits and clearly state "Cancel anytime" to remove anxiety.
*   **E-Commerce**:
    *   **Cart Abandonment**: Allow guest purchases and eliminate forced membership registration.
    *   **1-Click Payment**: Introduce Apple Pay / Google Pay to minimize input effort to the limit.

## 3. Payment & Compliance
*   **Payment Gateway**:
    *   **Stripe First**: From the perspective of developer experience and scalability, strictly use **Stripe** as the first choice.
    *   **PCI-DSS Avoidance**: Do not hold credit card information on our own servers at all; use token payments.
*   **Tax**:
    *   **Auto-Application**: Automatically apply the appropriate tax rate (Consumption Tax, VAT, GST) based on the user's country of residence (Stripe Tax recommended).
    *   **Invoice System**: Automatically issue receipts in a format fully compliant with Japan's Invoice System (Qualified Invoice Storage Method).
*   **Legal Notation**:
    *   **Act on Specified Commercial Transactions**: Based on Japanese law, set up a page that correctly discloses operator information, return policies, etc.
    *   **Payment Services Act**: Be cautious when issuing prepaid payment instruments (points) and use Apple/Google IAP in principle.
