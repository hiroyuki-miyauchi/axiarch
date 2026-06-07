# ROLE_PASS_PROTOCOL.md — Role Passes

## Purpose

Role passes let a single main agent execute multiple review perspectives sequentially.
If subagents are available, some passes may be delegated. If not, the main agent runs the same passes in order.

## Standard Passes

| Pass | Focus | Output |
|:--|:--|:--|
| Planner | Canonical plan, scope, existing value, risks | `implementation_plan.md` and native plan |
| Implementer | Minimal diff, compatibility, structural fit | Code or documentation diff |
| Verifier | Commands, links, syntax, health, reproducibility | Verification results |
| Auditor | Drift from canonical plan, regression, overreach, approval boundary | Findings or verdict |
| Blueprint Drift | Drift among Universal, Blueprint, canonical plan, and implementation diff | Drift findings or PASS |
| QA | Commands, links, syntax, health | Verification results |
| Docs | README, CHANGELOG, ROADMAP, evidence | Public docs and current-task docs |
| Crystallizer | Real task lessons, duplication, threshold, promotion need | Crystallization candidates or not-needed judgment |
| Release Safety | stage, commit, push, deploy, release, tag, DB, destructive actions | Human Approval Gate verdict |

## Main-Agent Execution

When subagents are unavailable, the main agent executes the passes above sequentially.
The task is not incomplete merely because no subagent was available.
Audit Pass is read-only by default; when remediation is needed, return explicitly through a Fix Pass.
If the plan is wrong, return to Planner rather than continuing through Implementer.

## With Subagents

Subagents may handle bounded work such as research, read-only audit, test-result summary, or documentation parity checks.
Final judgment, approval-required actions, and deviation from the canonical plan remain with the main agent.
