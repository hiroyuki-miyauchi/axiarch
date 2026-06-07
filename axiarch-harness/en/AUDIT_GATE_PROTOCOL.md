# AUDIT_GATE_PROTOCOL.md — Audit Gate

## Purpose

The Audit Gate determines whether work can proceed after implementation or review.
Audits are read-only by default. The agent enters a fix loop only when the user requested implementation or remediation.

## Verdicts

| Verdict | Meaning | Next action |
|:--|:--|:--|
| PASS | Requirements are met and no material concern remains | Proceed to Evidence Packet |
| PASS_WITH_NOTES | Work can proceed with minor residual risk or notes | State the risk and proceed to Evidence Packet |
| NEEDS_FIX | Implementation, quality, verification, or compatibility needs remediation | Return to the fix loop |
| NEEDS_REPLAN | The canonical plan, scope, or assumptions are wrong | Return to the Plan Gate |
| NEEDS_HUMAN | The decision or approval belongs to the human owner | Stop at the Human Approval Gate |
| BLOCKED | An external or unresolved blocker prevents progress | Stop with the blocker, options, and required human decision |
| CRYSTALLIZE_ONLY | No implementation change is needed, but a real task lesson must be crystallized | Follow CRYSTALLIZATION_PROTOCOL, then proceed to Evidence Packet |

Compatibility note: legacy `WARN` maps to `PASS_WITH_NOTES`, legacy `BLOCK` maps to `NEEDS_FIX` or `BLOCKED`, and legacy `NEEDS HUMAN` maps to `NEEDS_HUMAN`.

## Checks

- Implementation matches the canonical plan
- Existing behavior, autonomous loading, current-task docs, and Safe Upgrade flows remain intact
- ja/en documents preserve meaning where parity is required
- Pointers do not duplicate canonical rules
- New files are reflected in distribution, manifest, health, and README paths
- Verification commands ran, and failures were investigated
- If lessons occurred, Crystallization Step 5 was checked
- stage, commit, push, deploy, release, tag, DB apply, and other approval-required actions were not executed silently

## Fix Loop

When verdict is `NEEDS_FIX`, use the sequence below.
For `BLOCKED`, use the same sequence only when the blocker can be resolved inside the current approved scope without additional approval. Otherwise stop at the Human Approval Gate or report the blocker.

1. Identify the failed check in one line.
2. Fix with the narrowest viable change.
3. Re-run the same verification.
4. Record the updated result in `walkthrough.md`.
5. If unresolved, state residual risk and options for human judgment.
