# EXECUTION_HARNESS_PROTOCOL.md — Execution Harness

## Purpose

This document defines the operational workflow that turns Axiarch rules into task execution.
After reading `AXIARCH.md` and `axiarch-rules/{lang}/LOADING_PROTOCOL.md`, apply this protocol according to task level.
This protocol is the core task-execution application of Harness Engineering as defined in `AXIARCH.md`. It is not a fourth rule layer; it connects the three-layer model to execution order, audit, evidence, and human approval.

Legacy harness L0–L4 maps to H0–H4 only. Distance D1–D5 and maturity M1–M5 are separate axes with no numeric equivalence.

## Task Levels

| Level | Examples | Required handling |
|:--|:--|:--|
| H0 | Questions, short explanations, read-only checks | Inspect only what is needed; do not implement |
| H1 | Documentation tweaks, pointer cleanup, evidence updates | Update plan and walkthrough briefly; inspect the diff |
| H2 | Small code changes, localized spec updates | Plan, implement, verify, and audit |
| H3 | Cross-domain design changes, rule changes, distribution script changes | Canonical plan or Blueprint, role passes, ja/en parity, health checks |
| H4 | DB apply, stage, commit, push, deploy, release, tag, destructive operations, security boundary changes | Human approval before and after implementation; no autonomous execution |

When `AXIARCH.md` §9 states that "the harness is mandatory procedure for non-trivial work," that "non-trivial" boundary begins at **H2**. H0/H1 (questions, read-only checks, minor documentation edits) do not require the full harness; H2 and above require plan, implementation, verification, and the audit gate (plus the additional H3/H4 requirements).

## Standard Lifecycle

1. Check the latest user instruction and canonical plan.
2. Resolve language and task level.
3. Directly open the required rules and harness files.
4. Sync `task.md`, `implementation_plan.md`, and `walkthrough.md` to the current task.
5. In Codex, also use `update_plan`; in Claude Code, also use Task tools.
6. Compare existing behavior with the canonical plan.
7. Implement with focused diff-based changes.
8. Run relevant verification, record the results, then use that evidence for role passes.
9. Use the Audit Gate to decide `PASS` / `PASS_WITH_NOTES` / `NEEDS_FIX` / `NEEDS_REPLAN` / `NEEDS_HUMAN` / `BLOCKED` / `CRYSTALLIZE_ONLY`.
10. Return `NEEDS_FIX` items to the fix loop and `NEEDS_REPLAN` items to the Plan Gate.
11. Summarize verification in an Evidence Packet.
12. Stop at the Human Approval Gate for stage, commit, push, deploy, release, tag, destructive, or sensitive actions.
13. Check crystallization only for lessons that actually occurred during the task.

## Handling an Implementation Plan

When the user explicitly says an attached implementation plan is canonical, that attachment is the task SSOT.
The local `implementation_plan.md` becomes current-task evidence that maps the canonical plan into this workspace.

## Completion Criteria

- The canonical plan has been implemented or reviewed
- Changed files and reasons are explainable
- Verification has run, or the reason it could not run is recorded
- Residual risks are documented
- Approval-required actions were not executed silently

## Goal and evidence linkage

`axiarch-rules/en/universal/core/300_goal_and_current_state.md` governs content; use the IDs, owners, four states, targets, timestamps and evidence in [TASK_STATE_PROTOCOL.md](./TASK_STATE_PROTOCOL.md). H0/H1 stay lightweight. H2+ separates readiness from completion and audits evidence for every criterion. Structural health alone is not task completion.
