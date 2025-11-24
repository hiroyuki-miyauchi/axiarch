# 30. Engineering Excellence (General)

## 1. Code Quality & Clean Code
*   **Clean Code Standards**:
    *   **Self-Documenting**: Comments should explain "Why", not "What". Let the code speak for itself.
    *   **Function Size**: Functions should do "one thing". Ideally keep them under **20 lines**.
    *   **Naming**: Variable names must be specific and clear. Vague names like `data`, `temp`, `item` are prohibited (e.g., `userData` -> `authenticatedUserProfile`).
*   **Zero Warnings**:
    *   **Rule**: Treat warnings as errors. CI must fail on a single warning. Prevent the "Broken Windows Theory".
    *   **Strict Error Handling**: Empty `catch` blocks are prohibited. All errors must be logged and handled.
*   **Refactoring (The Boy Scout Rule)**:
    *   **Mandate**: "Leave the campground cleaner than you found it." Always make small improvements (renaming, function extraction) when touching a file.
    *   **No "Later"**: "I'll refactor later" is a lie. Do it now or never.

## 2. Performance Obsession
*   **Speed is a Feature**:
    *   **Latency**: Any interaction taking over **100ms** is "slow".
    *   **N+1 Problem**: Strictly prohibit N+1 queries in database access. Always use eager loading or batch fetching.
*   **Performance Budget**:
    *   Set strict budgets for bundle size (e.g., < 100KB initial load) and enforce them in CI.

## 3. Security by Design
*   **Zero Trust**:
    *   Never trust input from the client. Validate everything on the server side.
*   **Secrets Management**:
    *   Never commit API keys or secrets to Git. Use environment variables (`.env`) and secret managers.

## 4. Technical Debt Management
*   **Definition**: Technical debt is not "bad code", it is a "loan" taken for speed. It must be repaid with interest.
*   **Repayment Plan**: Allocate **20%** of every sprint to debt repayment (refactoring, library updates).
*   **Tech Radar**:
    *   **Regular Updates**: Mandate quarterly dependency updates to stay on the "Bleeding Edge" (safely).

## 5. AI-Native Architecture
*   **AI First**:
    *   When building a feature, first ask "Can AI solve this?".
    *   Design data structures to be "AI-readable" (e.g., meaningful field names, structured logs).
*   **Seiso (Shine) - Refactoring**:
    *   **Continuous Refactoring**: Clean existing code slightly with every feature addition (Boy Scout Rule). Do not set aside large refactoring periods; do it daily.
    *   **Performance Tuning**: Regularly profile and eliminate bottlenecks. Do not optimize by guessing (Premature Optimization is the root of all evil).

## 6. AI-Native Architecture (RAG Optimization)
*   **Context-Aware Coding**:
    *   **Small & Atomic**: Keep functions and classes atomic. To optimize for LLM context windows and RAG accuracy, one file/function must handle only a "single concept".
    *   **Semantic Naming**: Use "Semantic" naming for files and functions to facilitate AI retrieval (e.g., `auth_utils.ts` ❌ -> `user_authentication_flow.ts` ⭕️).
*   **Self-Documenting for AI**:
    *   For complex logic, write comments specifically for "AI" (intent, constraints, dependencies), not just humans. This enables future AI agents to autonomously refactor code.

## 7. The "Zero Bug Policy" & 24-Hour Rule
*   **Zero Bug Policy**:
    *   Never build new features on top of known bugs. "Bug Fixing" always takes priority over "New Features".
    *   When a bug is found, either **Fix Now** or **Close as Won't Fix**. There is no "Fix Later".
*   **The 24-Hour Rule (Critical Issues)**:
    *   **Severity 1 (Critical)**: Critical issues like data loss, security breaches, or core feature outages must be resolved (or mitigated) within **24 hours** of discovery. This is the Silicon Valley standard.

## 8. Observability
*   **Monitor Everything**:
    *   Visualize not just "that it works" but "how it works" (logs, metrics, error tracking).
## 9. Admin Ops & Internal Tools (Retool First)
*   **Build vs Buy**:
    *   **Rule**: Admin panels and internal tools do not generate revenue. Therefore, scratch development (React/Flutter) is prohibited in principle.
    *   **Retool First**: Build admin panels using low-code tools like **Retool** in 1/10th of the time.
    *   **Exception**: Scratch development is allowed only if it is a customer-facing dashboard that serves as a differentiator.

## 10. Mobile-First & Offline Strategy
*   **Offline First**:
    *   Apps must work even in "places with no signal".
    *   **Optimistic UI**: Update the screen without waiting for server communication and sync in the background.
    *   **Caching**: Cache necessary data locally (SQLite/Isar/Hive) to enable offline viewing.
*   **Thumb Zone Architecture**:
    *   Place important action buttons (FAB, navigation) within the "Thumb Zone" for one-handed operation. Avoid placing them at the top of the screen.
