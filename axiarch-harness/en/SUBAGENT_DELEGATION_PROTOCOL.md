# SUBAGENT_DELEGATION_PROTOCOL.md — Subagent Delegation

## Purpose

Subagents are optional execution aids.
Axiarch does not depend on their existence.
When subagents are unavailable, the main agent performs the same work sequentially.

## Delegable Work

- Read-only code research
- Documentation consistency checks
- ja/en parity checks
- Test output or log summaries
- Risk enumeration for proposed changes
- Independent review by audit focus
- Read-only security research, threat modeling, candidate discovery, and evidence organization

## Optional Role Examples

- Architecture Guardian
- Security Reviewer
- Quality Auditor
- Blueprint Auditor
- Crystallization Scribe
- Docs Curator
- Release Warden

## Non-Delegable Work

- Final judgment
- Approval-required actions
- stage, commit, push, deploy, release, tag
- DB apply or production data mutation
- Decisions to amend Universal Rules or `AXIARCH.md`
- Decisions to deviate from the canonical plan

## Approval Boundary

Read-only subagent delegation is not a Human Approval Gate action merely because a subagent is used.
The main agent may delegate without waiting for additional "explicit subagent permission" when all conditions below are true.

1. The user request asks for read-only work such as research, audit, review, verification, or security scan.
2. The delegation scope is limited to the current repository, working tree, or context already provided.
3. The subagent does not write files, stage, commit, push, deploy, tag, apply DB changes, mutate production data, or change external service configuration.
4. The workflow does not require unapproved authentication, installation, increased billing, sensitive-data retrieval, or production access.
5. The main agent keeps synthesis, final judgment, residual-risk acceptance, and the Evidence Packet.

Return to the Human Approval Gate only when one of these conditions is not met.

## Codex Security Deep Security Scan

When the user explicitly invokes Codex Security Deep Security Scan or an equivalent named workflow, that invocation includes the request for the read-only worker fanout required by that workflow.
Do not stop by interpreting the formal Deep Security Scan as requiring separate explicit subagent permission.

If delegation itself is unavailable in the runtime, do not claim that Deep Security Scan ran.
State the limitation and use the documented ordinary Codex Security scan fallback, or the main-agent sequential role passes when that still satisfies the user's goal.

## Main-Agent Responsibilities

1. Bound each delegation scope precisely.
2. Review and synthesize subagent output before using it.
3. Resolve conflicts in the order: canonical plan, `AXIARCH.md`, Universal, Blueprint.
4. Produce the final Evidence Packet as the main agent.

## Fallback

When subagents are unavailable, the main agent runs:

1. Planner pass
2. Implementer pass
3. Reviewer pass
4. QA pass
5. Docs pass
6. Release Safety pass

Subagent unavailability alone is not a reason to mark the work incomplete or stop; only the named workflow's unmet requirement should be reported honestly.
