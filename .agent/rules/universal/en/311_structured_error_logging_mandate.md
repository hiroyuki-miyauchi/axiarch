# 30. Engineering Excellence (General)

### 13.42. The Structured Error Logging Mandate
*   **Law**: When logging error objects, **direct embedding in string templates** (e.g., `` `Error: ${error}` ``) is prohibited. Error objects must be logged in a **structured format**.
*   **Action**:
    1.  **No Template Embedding**: The pattern `` `Error occurred: ${error}` `` outputs `[object Object]`, completely losing root cause information.
    2.  **Destructured Logging**: Explicitly deconstruct error object properties (`message`, `code`, `details`, `hint`, etc.) for logging (e.g., `Logger.error('Operation failed', { message: error.message, code: error.code, details: error.details })`).
    3.  **JSON Serialization**: When using structured logging systems, serialize the entire error object with `JSON.stringify(error, null, 2)` to preserve all properties.
    4.  **Stack Trace Preservation**: The `stack` property of `Error` instances is lost when included in template literals. Always pass it as a second argument or metadata object.
*   **Rationale**: Errors logged as `[object Object]` make root cause identification virtually impossible. RLS violations, authentication errors, type mismatches, and similar subtle errors contain critical diagnostic information in `code` and `details` — template embedding loses all of this.

### 13.43. The Type Integrity Prohibition Protocol
*   **Law**: Using `as any` or `as never` to silence type errors is defined as "embedding bugs." Making types correctly align is the **only legitimate solution** — circumvention via casting is completely prohibited.
*   **Action**:
    1.  **Zero `as any` Policy**: Prohibit `as any` usage across the entire codebase. Set ESLint rule `@typescript-eslint/no-explicit-any` to `error` and physically block it in CI.
    2.  **Root Cause Resolution**: When type errors occur, resolve the **root cause** through "fixing type definitions," "redesigning DTOs," or "applying generics" — not through casting.
    3.  **Exceptional Cast Documentation**: When type assertions are unavoidable (e.g., external library type definition deficiencies), always add a `// SAFETY: <reason>` comment and require code review approval.
    4.  **Lint Suppression Audit**: Using `// eslint-disable` or `// @ts-ignore` is a "declaration of technical debt." Always note the corresponding Issue number when used, and mandate quarterly inventory reviews.
*   **Rationale**: `as any` completely disables type safety, deferring bugs that should be caught at compile time to runtime. Especially at DTO conversions and API boundaries, its use conceals data inconsistencies and makes root cause identification during incidents extremely difficult.

### 13.44. The Thin Controller Mandate
*   **Law**: API Routes / Controllers / Route Handlers must be designed as a "thin layer" responsible only for request parsing/validation and authorization checks. Business logic must be delegated to the Service layer — direct implementation in Controllers is prohibited.
*   **Action**:
    1.  **Controller Responsibilities**: Code within Controllers is limited to: (a) parsing and validating request body/parameters, (b) authentication/authorization checks, (c) calling Service layer, (d) constructing and returning responses.
    2.  **No DB Access in Controllers**: Direct DB calls (ORM queries, SQL execution, etc.) within Controllers / Route Handlers are prohibited. All data access must go through the Service/Gateway layer.
    3.  **Testability**: The Service layer must be independently unit-testable from Controllers. Logic tightly coupled to Controllers destroys testability.
    4.  **Error Translation**: Exceptions from the Service layer must be translated to HTTP status codes and error response formats at the Controller layer. The Service layer must not know about HTTP status codes.
*   **Rationale**: Bloated Controllers create a triple burden: untestable, non-reusable, and impossible to assess change impact. The separation of thin Controllers + thick Services is the foundation of maintainability and scalability.

### 13.45. The DTO Boundary Casting Protocol
*   **Law**: When converting database or ORM return values (loose types) to strict DTO types, casting via `as any` is prohibited. A safe type conversion strategy is mandated.
*   **Action**:
    1.  **No `as any` Bridge**: Double casting like `dbResult as any as MyDTO` is a complete abandonment of type safety. It is prohibited.
    2.  **Explicit Mapping**: Conversion from DB results to DTOs must use explicit mapping functions (`toDTO(dbResult): MyDTO`) that individually map each field.
    3.  **Validated Cast**: When type assertions are unavoidable, use intentional two-stage conversion via `as unknown as TargetType` to make the conversion intent explicit. However, combining with runtime validation (Zod, etc.) is strongly recommended.
    4.  **Generated Types**: DB type definitions must use auto-generation (Prisma, Drizzle, Supabase CLI, etc.) to physically prevent divergence from hand-written type definitions.
*   **Rationale**: The type boundary between DB and application layers is where data inconsistencies most frequently occur. Casting via `as any` causes silent data loss during column additions/renames, producing the worst kind of bugs — where builds pass but data is corrupted.

### 13.46. The CQRS Separation Mandate
*   **Law**: Mixing Read operations (queries) and Write operations (mutations) in the same function or class is prohibited. Query (Read-only) and Command (Write-only) must be clearly separated.
*   **Action**:
    1.  **Query/Command Split**: The data access layer must be separated into read-only `QueryGateway` (or `ReadService`) and write-only `CommandGateway` (or `WriteService`).
    2.  **No Side Effects in Queries**: Query methods must only perform data reading and transformation — they must have zero side effects such as DB writes or external API calls.
    3.  **Independent Scaling**: Read/Write separation enables independent scaling decisions: adding Read Replicas for high read load, or Write optimization for write-heavy scenarios.
    4.  **Naming Convention**: Method names must explicitly indicate Read/Write intent (e.g., `getUser` / `findUsers` for Read, `createUser` / `updateUser` for Write).
*   **Rationale**: Mixing Read/Write makes cache strategy application difficult and delays performance bottleneck identification. CQRS separation improves code readability, testability, and secures migration paths to future event sourcing or microservice architectures.

### 13.47. The Cache Strategy Layer Protocol
*   **Law**: Uniform cache strategies that ignore data characteristics (fixed TTL for everything / completely disabling cache) are prohibited. Define a **layered cache strategy** based on data change frequency and freshness requirements.
*   **Action**:
    1.  **Data Classification**: Classify application data into the following tiers:
        - **STATIC** (No changes): Legal documents, terms of service, etc. CDN/ISR (rebuild-triggered).
        - **WARM** (Daily to weekly changes): Master data, categories, etc. TTL 5min–1hr + SWR (Stale-While-Revalidate).
        - **HOT** (Minute-level changes): User-generated content, inventory, etc. Short TTL (30s–5min) + on-demand revalidation.
        - **REALTIME** (Immediate reflection): Chat, notifications, payment status, etc. No cache + WebSocket/SSE.
    2.  **No Blind Cache**: Setting `cache: 'force-cache'` or `revalidate: 0` "just because" is prohibited. Document an explicit cache strategy based on tier classification for each data source.
    3.  **Cache Invalidation Strategy**: Design cache invalidation strategies (`revalidateTag` / `revalidatePath` / Purge API, etc.) as an integral part of data update flows.
    4.  **Monitoring**: Measure cache hit rates and flag endpoints below 90% as optimization targets.
*   **Rationale**: Uniform cache strategies cause damage on both fronts: sending unnecessary requests for static data (increased cost) and returning stale information for real-time data (degraded UX). Layering based on data characteristics is the only design pattern that achieves both cost efficiency and user experience.

# 30. Engineering Excellence (General)
