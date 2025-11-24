# 150. E-Commerce & Finance Strategy

## 1. E-Commerce Strategy
*   **Cart & Checkout**:
    *   **Cart Abandonment**: Always allow "Guest Checkout". Forced registration drastically lowers CVR.
    *   **1-Click Payment**: Implement Apple Pay / Google Pay to minimize input friction.
*   **Payment Gateway**:
    *   **Stripe First**: Use **Stripe** as the default choice for developer experience and scalability.
    *   **PCI-DSS**: Never store or pass credit card info on your own servers. Use tokenization to avoid PCI-DSS compliance costs.

## 2. Finance & Accounting
*   **Invoicing**:
    *   **Invoice System**: Automatically issue invoices compliant with local tax regulations (e.g., Japan's Invoice System).
    *   **Automation**: Send invoices via email immediately upon payment completion. Zero manual work.
*   **PL Management (Profit & Loss)**:
    *   **Real-time PL**: Visualize estimated PL daily by fetching Revenue, Server Costs (COGS), and Ad Spend (CAC) via APIs.
    *   **Unit Economics**: Constantly monitor that the Unit Contribution Margin per transaction is positive.

## 3. Tax & Compliance
*   **Consumption Tax / VAT**:
    *   Automatically apply the correct tax rate based on the user's location (IP/Billing Address).
    *   **Stripe Tax**: Use automation tools like Stripe Tax for complex cross-border taxation.
*   **Legal Disclosure**:
    *   Strictly display "Specified Commercial Transactions Law" (Japan) or equivalent disclosures required by local law.
