# HUMAN_APPROVAL_GATE.md — Human Approval Gate

## Purpose

The Human Approval Gate stops the agent before actions it must not perform autonomously.
Approval to implement is separate from approval to publish, destroy, spend, or mutate data.

## Actions Requiring Explicit Approval

- `git add` or any other staging operation
- `git commit`
- `git push`
- Release creation, tag creation, package publication
- Deployment, production promotion, external service configuration changes
- DB migration apply, production data changes, manual SQL
- File deletion, broad moves, full overwrite of existing files
- Changes that increase billing, pricing, or external API usage
- Authentication, authorization, personal data, or security boundary changes
- Class S / Universal Rule changes
- Major Blueprint changes or Blueprint updates that require project-owner judgment
- Legal, license, contract, hiring, or market-public decisions
- Non-interactive bulk apply such as `--apply --yes`

## Read-Only Actions Not Requiring Explicit Approval

The actions below are not Human Approval Gate blockers by themselves.
If any action above becomes part of the workflow, stop at that point.

- Read-only research over the repository, working tree, or already-provided context
- Read-only role passes, audits, reviews, and verification
- User-requested read-only security scans
- Bounded read-only subagent delegation
- Summaries of test output, logs, diffs, and documentation consistency

Do not stop for additional human approval solely because a subagent or scan tool is used.
Stop only when moving into approval-required actions such as file writes, stage, commit, push, deploy, DB apply, production data mutation, external service configuration, increased billing, or sensitive-data retrieval.

## How to Ask

Ask for one decision at a time.
Write the request, reason, and residual risk in a language the user can judge.
For users of the Project Native Language, ask in that language by default.

```text
This action requires human approval.
Action: git commit
Target: current branch
Reason: create a local commit from the verified diff
I will not run it until approved.
```

## Prohibited

- Treating "you may implement" as "you may stage, commit, push, or release"
- Treating "you may verify" as "you may deploy"
- Proceeding with destructive actions on ambiguous approval
- Omitting approval-required actions from the Evidence Packet
