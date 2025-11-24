# 260. Data Visualization & Export

## 1. Data Export & Import
*   **PDF / CSV Generation**:
    *   **Client-Side**: For small amounts of data (e.g., single screen, < 100 rows), generate PDF/CSV client-side (using `jspdf`, `papaparse`, etc.) to avoid server load.
    *   **Server-Side**: For large datasets (e.g., full transaction history), generate via background jobs and notify the user with a download link asynchronously.
*   **Encoding & Compatibility**:
    *   **CSV**: Always output **UTF-8 with BOM** to prevent character corruption (mojibake) when opening in Excel.
    *   **PDF**: Properly embed Japanese fonts (e.g., IPA fonts) to prevent character corruption (tofu).

## 2. Charts & Graphs
*   **Library Selection**:
    *   **React**: **Recharts** or **Chart.js** (react-chartjs-2) are recommended for a good balance of performance and customization. Consider **D3.js** for advanced visualization, but weigh the trade-off with learning cost.
*   **UI/UX**:
    *   **Interactive**: Implement interactive elements like tooltips on hover and filtering by clicking legends, rather than static images.
    *   **Responsive**: Adjust aspect ratios and the number of displayed elements based on screen width for optimal mobile viewing.
    *   **Accessibility**: Ensure data is distinguishable not just by color but also by patterns (hatches, dots) and labels to accommodate color blindness (Color Blindness Safe).
