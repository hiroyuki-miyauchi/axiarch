# 30. Engineering Excellence (General)

### 1.2. Supreme Directive: Realism First Protocol (Anti-Haribote)
*   **Definition**:
    *   **Haribote (Facade)**: Features where UI (skin) exists but "data persistence" and "re-fetch (Hydration)" are not completely done behind it are defined as **"Deceptive Implementation"** for any reason, and NOT considered implementation complete.
*   **Mandate (The Vein Check)**:
    *   **Rule**: Feature completion is NOT UI rendering, but verifying that data vessels (Round-Trip) of **"UI → Action → DB → Action → UI"** are connected before committing.
    *   **Physical Verification**: Obligation to verify **values are physically written** in DB (psql/Table Editor), not just dev tools. "Looks like it's working" is prohibited.
*   **Deception Penalty**:
    *   Including settings screens that don't save or input forms that disappear on reload in PRs is **Betrayal** to reviewers and users; freeze all work until fix is complete.
