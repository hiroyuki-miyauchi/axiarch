# EVIDENCE_PACKET_PROTOCOL.md — Evidence Packet

## Purpose

An Evidence Packet makes the closeout reproducible: what changed, what was verified, and what remains.

## Required Items

| Item | Content |
|:--|:--|
| Scope | Work performed |
| Canonical Plan | Source of truth for the task or implementation decision |
| Loaded Rules | Rule files actually opened and key sections read |
| Changed Files | Files changed and their roles |
| Verification | Commands run and results |
| Audit Verdict | `PASS` / `PASS_WITH_NOTES` / `NEEDS_FIX` / `NEEDS_REPLAN` / `NEEDS_HUMAN` / `BLOCKED` / `CRYSTALLIZE_ONLY` |
| Residual Risks | Remaining risks, unverified points, known caveats |
| Approval Boundary | Unexecuted approval-required actions such as stage, commit, push, deploy, release, tag, or DB apply |
| Crystallization | Lesson candidates, duplication check, and threshold result |

## Template

```markdown
## Evidence Packet

- Scope:
- Canonical Plan:
- Loaded Rules:
- Changed Files:
- Verification:
- Audit Verdict:
- Residual Risks:
- Approval Boundary:
- Crystallization:
```

## Note

An Evidence Packet is not a long activity log.
It should be short, concrete, and sufficient for the user to make the next decision.
Closeout without evidence is prohibited.

## Goal and evidence linkage

`axiarch-rules/en/universal/core/300_goal_and_current_state.md` governs content; use the IDs, owners, four states, targets, timestamps and evidence in [TASK_STATE_PROTOCOL.md](./TASK_STATE_PROTOCOL.md). H0/H1 stay lightweight. H2+ separates readiness from completion and audits evidence for every criterion. Structural health alone is not task completion.
