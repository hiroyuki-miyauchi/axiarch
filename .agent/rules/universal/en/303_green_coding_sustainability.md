# 30. Engineering Excellence (General)

## 6. Green Coding & Sustainability
*   **Energy Efficiency**:
    *   **Algorithm**: Be conscious of computational complexity (O-notation) and write code that doesn't waste CPU cycles. This protects both battery life and the environment.
    *   **Dark Mode**: Recommend True Black (#000000) for OLED power saving.
*   **Data Transfer**:
    *   **Compression**: Always optimize images and video (AVIF/H.265) to prevent network bandwidth waste.
    *   **Cache Maximization**: Target CDN cache hit ratio of **80%+** to minimize origin load for static assets.
    *   **Centralized Storage Shield**: Centralize image entities in BaaS Storage (Origin) and route delivery via CDN Optimization features to balance cost and performance.

## 12. Engineering Quality Protocols

### 13.3. The Service Pattern Mandate
*   **Law**: Do not call DB access functions directly in `page.tsx` or `layout.tsx`.
*   **Action**: Extract logic to `lib/api/gateways/` (Read) or `lib/actions/` (Write). UI should only "call Gateway and display".

### 13.5. The Centralized Logging Protocol
*   **Law**: Leaving `console.log` in production is hygiene failure.
*   **Action**: Use `src/lib/logger.ts` only. Prohibit `console.*` via Linter.

### 13.7. The Unstable Timer Protocol
*   **Law**: `setTimeout`/`setInterval` are prohibited for logic control due to instability in Serverless/Edge. Use Job Queues.

### 13.8. The Type Bridge Mandate
*   **Law**: Never use `as any` for missing DB types.
*   **Action**: Define **Mapped Type** extensions in `database-extensions.ts` and pass to Supabase Client generics.

### 13.9. The API Product Mindset
*   **Law**: All data output is a "Product".
*   **Action**:
    *   **Tiering**: Separate **Tier 1 (Public)** and **Tier 2 (Enterprise)**.
    *   **Usage Recording**: Fire-and-forget `recordApiUsage` on Enterprise endpoints.
    *   **Metadata**: Include `meta` (AI metadata, Tier, TTL) in response.
    *   **Metadata Segregation**: Prefix internal metadata with `app_` to avoid collision with Stripe `metadata`.
    *   **The API Latency Budget (Rule 26.5)**:
        *   **Law (Speed First)**: The design goal for TTI (Time to Interaction) of all Public/Enterprise APIs is **under 200ms**.
        *   **Action**: Processing exceeding 200ms (heavy aggregation, external API integration) MUST NOT be done synchronously; offload to Webhook or Async Queue, and immediately return `202 Accepted` with `request_id`.
