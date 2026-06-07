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
