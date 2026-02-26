# 10. Product & Business Strategy
## 8. Search & Discovery Architecture

### 8.1. The Tag-Based Attribute Protocol
*   **Law**: Variable attributes of entities (products, stores, articles, etc.) such as features and conditions MUST be structured as **Tags (M:N relations)** rather than adding dedicated columns.
*   **Action**:
    1.  **Master Table**: Prepare a master table for tag types, defining `category` (classification) and `slug` (search key).
    2.  **Junction Table**: Manage entity-tag associations via a Junction Table, enabling dynamic filtering and search.
    3.  **No Column Explosion**: Proliferating Boolean columns like "supports_feature_A", "supports_feature_B" is prohibited as it causes schema bloat and query complexity.

### 8.2. The Structured Business Hours Protocol
*   **Law**: Business hours MUST be managed as **structured data in JSONB format**, not free text.
*   **Schema Standard**:
    *   Store opening/closing times per day of the week as an array, supporting multiple time slots (lunch, dinner, etc.).
    *   Closed days are represented as `null` or empty arrays, flexibly accommodating temporary closures.
*   **Timezone Strategy**: The display layer should show times based on the target market's timezone. Internal storage uses UTC as the standard, converting at display time.
*   **Holiday Priority**: Prepare a holidays/temporary closures table (e.g., `entity_holidays`) and **prioritize holiday settings over regular weekly schedules** when determining availability.
*   **Search Optimization**: For real-time searches like "Currently Open," instead of calculating against the current time per request, leverage pre-computed columns (e.g., `next_open_at`, `is_currently_open`) updated via triggers or batch processes.

### 8.3. The Search Freshness SLA
*   **Law**: Define an SLA (Service Level Agreement) for the delay (Staleness) until user-updated data is reflected in search results.
*   **Standard**:
    *   **Critical Data** (inventory, price, status): Reflected in search index within **5 minutes**.
    *   **Content Data** (descriptions, images): Reflected within **1 hour**.
*   **Action**: Design appropriate search index update triggers (Webhooks, Realtime Subscriptions, scheduled batches) to build an architecture that meets the SLA.
*   **Cache Purge Sync**: Even if immediate search index reflection is achieved, stale data may be displayed due to missed CDN or application cache purges. Execute cache tag purges (e.g., `revalidateTag`) synchronously upon data updates.

## 9. Review & Trust System

### 9.1. The Bayesian Average Protocol
*   **Law**: For aggregating review ratings, use **Bayesian Average instead of simple arithmetic mean**.
*   **Reason**: With few reviews, a single extreme rating (5-star or 1-star) can significantly skew the average. Bayesian Average incorporates the global average as a prior distribution, mitigating bias from small sample sizes.
*   **Formula**: `bayesian_score = (C × m + Σ(ratings)) / (C + n)` (C: confidence threshold, m: global average, n: review count)
*   **Pre-calculation**: Calculation should NOT be performed per-request. Pre-calculate via batch or trigger on review submission/update and store in an entity table column (e.g., `bayesian_score`).

### 9.2. The Pre-Moderation Protocol
*   **Law**: User-Generated Content (UGC), especially reviews, MUST **pass moderation (review) before publication** as the standard.
*   **Action**:
    1.  **Status Flow**: Manage review status as `pending → approved / rejected` (3 states).
    2.  **Visibility**: Include only `approved` reviews in public queries; display unreviewed content as "Under Review" to users.
    3.  **Automation**: Automate spam detection and prohibited word filtering to reduce human moderation costs.
    4.  **Self-Review Ban**: Systematically block entity owners (e.g., store owners) from posting reviews on their own entities. Self-reviews by stakeholders undermine trust and credibility.
    5.  **Trusted User Exception**: For users who have achieved a certain trust score (e.g., N or more previously approved reviews), allow an exception to skip pre-moderation, balancing review costs with user experience.

### 9.3. The Immutable Deletion Protocol
*   **Law**: Once published, review data MUST use **Soft Delete** as the standard; physical deletion is prohibited in principle.
*   **Reason**: To maintain integrity of aggregate scores (Bayesian Average) and to enable auditing of irregular operations (deletion of unfavorable reviews).
*   **Action**: Set a deletion flag (`deleted_at`) to exclude from public queries while retaining the record in the database.
*   **Destructive Action Confirmation**: Since soft deletion of reviews has irreversible impacts (e.g., aggregate score recalculation), require **confirmation word input** (e.g., typing "delete") in the admin panel for deletion operations to prevent accidental actions.

## 10. Interactive Engine

### 10.1. The Unified Interactive Schema
*   **Law**: Interactive content such as polls, diagnostics, quizzes, and surveys MUST be managed using a **unified schema (Polymorphic Pattern)** rather than individual tables.
*   **Action**:
    1.  **Single Table**: Use an `interactive_contents` table with a `type` column (`poll`, `quiz`, `survey`, etc.), storing questions and options in JSONB.
    2.  **Responses Table**: Aggregate responses in an `interactive_responses` table, linked by `content_id`.
    3.  **Extensibility**: Maintain a design where adding new interactive types requires only adding a `type` value, without creating new tables.
    4.  **Deterministic Logic**: Implement diagnosis and quiz result calculation algorithms as **deterministic (score-based, etc.), not random**. Even when using AI, ensure reproducibility of results for the same inputs, enabling result traceability for user inquiries.
