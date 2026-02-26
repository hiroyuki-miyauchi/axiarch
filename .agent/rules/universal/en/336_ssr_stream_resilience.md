# 33. Web Frontend Engineering - Next.js


### 14.9. The SSR Stream Resilience Protocol
*   **Law**: When data fetching fails during Server-Side Rendering (SSR/RSC) streaming, the browser displays generic network errors (404, connection reset, etc.), completely concealing the root cause. Always provide defensive guards for data access within streaming components.
*   **Action**:
    1.  **Strict Null Guards**: After data fetching, always place guards like `if (!data) return notFound()` before accessing properties. Property access on `null` crashes the entire RSC stream.
    2.  **Server Terminal as Primary Source**: When debugging SSR streaming errors, use **server terminal output as the primary diagnostic source** instead of the browser console. Browser-side errors are intentionally sanitized and lack specificity.
    3.  **Gateway Instrumentation**: In data access layer (Gateway) `catch` blocks, explicitly extract and log `code` and `message` from error objects. Outputting `[object Object]` as-is is prohibited.
*   **Rationale**: SSR streaming crashes during HTML generation on the server, so unlike traditional SSR, only a generic "stream was interrupted" error reaches the browser. This makes identifying root causes (missing data, insufficient permissions, schema mismatches, etc.) extremely difficult.

### 14.10. The Non-Blocking Edge Middleware Protocol
*   **Law**: In Edge Middleware (or request pre-processing layers), **non-critical DB writes** such as analytics logging, usage metering, and access statistics updates MUST be made asynchronous using `event.waitUntil()`. Blocking with `await` causes response delay for all requests.
*   **Action**:
    1.  **Classification**: Classify DB operations within Middleware into "Critical (auth checks, etc.)" and "Non-Critical (log recording, etc.)."
    2.  **waitUntil for Non-Critical**: Execute Non-Critical operations in the background via `event.waitUntil(promise)` and return the response immediately.
    3.  **Error Isolation**: Provide independent error handling with `try-catch` within `waitUntil` to ensure failures don't affect the main response.
*   **Rationale**: Edge Middleware sits on the hot path of all requests, so delays here directly impact overall application performance. Asynchronization prevents log recording failures from blocking user page rendering.

*   **The Next.js 15 Async API Protocol**:
*   **Law**: From Next.js 15, `params`, `searchParams`, `headers`, `cookies`, `draftMode` are Awaitable (Promise).
*   **Action**: When referencing these, MUST `await` or use React's `use()` hook. Neglecting async processing causes "Value Missing" or "Infinite Rendering" only in production.
*   **The Frictionless Security UI Protocol (Design Handshake)**:
*   **Law**: Security features (Turnstile/OTP) MUST be implemented only in a way that does not hinder user's "Goal Achievement".
*   **Draft Save Exemption**: Do not require Turnstile or OTP for "Routine Operations" like draft saving (See `60_security_privacy.md` Rule 8.6).
*   **Physical Lock UI**: During security check (Turnstile spinning), set submit button to `loading` instead of `disabled` to indicate progress.
*   **CSP Worker Integrity (blob: permission)**:
*   **Context**: `heic2any` or high-performance image compression libraries generate internal `Web Worker` and use `blob:` URL. This will hang if blocked.
*   **Action**: MUST explicitly include `worker-src 'self' blob:;` in Middleware CSP settings to guarantee availability of image processing processes.
