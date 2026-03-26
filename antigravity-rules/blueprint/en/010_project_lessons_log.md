# Project Lessons Log

This file is an immutable log to aggregate critical lessons, anti-patterns, and newly established operational rules learned throughout the project development.
Based on the "Continuous Improvement" process in `GEMINI.md`, you must update or refer to this file upon completion of tasks.

---

## 📑 Table of Contents

1. [Critical Lessons](#critical-lessons)
2. [Appendix A: Reverse Lookup Index & Cross-References](#appendix-a-reverse-lookup-index--cross-references)

---

## Critical Lessons

> [!TIP]
> **Format for Adding Lessons**
> When adding a new lesson, please use the following format:
>
> ### [YYYY-MM-DD] Lesson Title
> **Context:** The situation or background where the issue occurred.
> **Problem:** Specific issues or failures.
> **Solution/Rule:** The solution or rule established to prevent recurrence.
> **Reference:** Related files or commits (if any).

---

### [Initial] Lesson at Project Start
**Context:** At the start of a new project or rule refresh.
**Rule:** Observe the protocols in `GEMINI.md` and `antigravity-rules` as the absolute truth.

---

## Appendix A: Reverse Lookup Index & Cross-References

### Reverse Lookup Index (Keyword → Usage Guide)

| Keyword | Usage |
|---|---|
| Bug, incident, regression | Record the lesson with root cause and countermeasure |
| Design decision, ADR | Document the context and outcome of key decisions |
| Anti-pattern | Formalize as "things to avoid" |
| Performance issue | Record bottleneck and resolution |
| Security incident | Document discovery, impact scope, and remediation |
| Team operational rule | Record newly established operational rules |

### Cross-References (Related Universal Rules)

| Category | Related Universal Rules |
|---|---|
| Lesson crystallization process | `GEMINI.md` §8 Continuous Improvement |
| Core principle violation lessons | `000_core_mindset` |
| Security lessons | `600_security_privacy` |
| Performance lessons | `300_engineering_standards`, `700_qa_testing` |
| Design decision lessons | Refer to the relevant domain Universal rule |
