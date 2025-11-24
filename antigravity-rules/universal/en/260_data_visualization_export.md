# 260. Data Visualization & Export

## 1. Data Export
*   **PDF / CSV Generation Strategy**:
    *   **Client-Side**: For small amounts of data (e.g., one screen, within 100 rows), generate PDF/CSV on the client side (`jspdf`, `papaparse`, etc.) to avoid server load.
    *   **Server-Side**: For large amounts of data (e.g., full transaction history), generate via background jobs (Cloud Functions/Cloud Run) and send a download link (Signed URL) via email or notification asynchronously to avoid timeouts (540s).
*   **Character Encoding & Compatibility**:
    *   **CSV**: Always output in **UTF-8 with BOM** to prevent garbled characters when opened in Excel (Windows/Mac).
    *   **PDF**: Embed Japanese fonts (IPA fonts, Noto Sans JP) appropriately to prevent garbled characters (tofu). Recommend server-side generation (Puppeteer, etc.) to prevent layout breakage.

## 2. Data Import
*   **Validation & Error Reporting**:
    *   **Row-by-Row Validation**: When importing CSV, validate all rows and list error line numbers and specific reasons (e.g., "Invalid email format on line 5") to provide feedback to the user.
    *   **Transaction**: Basically "All or Nothing", but consider an option to "Import only successful rows" for large data.
*   **Performance**:
    *   For imports of tens of thousands of rows, do not parse on the frontend; upload the file directly to Cloud Storage and stream process with Cloud Functions.

## 3. Charts & Graphs
*   **Library Selection**:
    *   **React**: Recommend **Recharts** or **Chart.js** (react-chartjs-2) for a good balance of performance and customizability. Consider **D3.js** for advanced visualization, but weigh the learning cost.
*   **UI/UX**:
    *   **Interactive**: Implement interactive elements like tooltips on hover and filtering by clicking legends, rather than static images.
    *   **Responsive**: Adjust aspect ratios and number of display elements according to screen width for mobile visibility.
    *   **Accessibility**: Consider color blindness and use patterns (diagonal lines, dots) and labels in addition to color to distinguish data (Color Blindness Safe).

## 4. Table UI
*   **Large Data Display**:
    *   **Virtualization**: For tables exceeding 100 rows, use `react-window` or `TanStack Virtual` to reduce DOM elements and maintain scroll performance.
*   **Mobile Support**:
    *   **Card View**: On mobile screens, adopt a layout that converts each row into a "Card format" and stacks them vertically (Responsive Table) instead of tables requiring horizontal scrolling.
*   **Sticky Header**:
    *   For long tables, always fix the header row at the top (Sticky Header) so users don't lose track of column meanings.
