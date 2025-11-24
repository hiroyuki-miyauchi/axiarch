# 150. E-Commerce & Finance Strategy

## 1. EC Strategy
*   **Cart & Checkout**:
    *   **Cart Abandonment**: Always allow Guest Checkout. Forced member registration drastically lowers Conversion Rate (CVR).
    *   **1-Click Payment**: Introduce Apple Pay / Google Pay to minimize input effort.
*   **Payment Gateway**:
    *   **Stripe First**: In principle, make **Stripe** the first choice from the perspective of developer experience and scalability.
    *   **PCI-DSS**: Do not hold or pass credit card information on your own servers at all; use token payment from the payment gateway to avoid PCI-DSS compliance costs.

## 2. Finance & Accounting
*   **Invoicing**:
    *   **Invoice System**: Automatically issue invoices in a format fully compliant with Japan's Invoice System (Qualified Invoice Storage Method).
    *   **Automation**: Send by email simultaneously with payment completion to eliminate manual issuance effort.
*   **PL Management (Profit & Loss)**:
    *   **Real-time PL**: Visualize estimated PL on a daily basis by acquiring not only sales but also server costs (COGS) and advertising costs (CAC) via API.
    *   **Contribution Margin**: Constantly monitor that the Unit Contribution Margin per transaction is positive.

## 3. Tax & Compliance
*   **Consumption Tax / VAT**:
    *   Automatically apply the appropriate tax rate (Consumption Tax, VAT, GST) based on the user's country of residence (IP address / Billing address).
    *   **Stripe Tax**: Use automation tools like Stripe Tax for complex cross-border taxation.
*   **Specified Commercial Transactions Act**:
    *   Based on Japanese law, always set up a "Notation based on the Specified Commercial Transactions Act" page and correctly disclose operator information.
