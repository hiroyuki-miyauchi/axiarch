# HUMAN_APPROVAL_GATE.md — Human Approval Gate

## Purpose

The Human Approval Gate stops the agent before actions it must not perform autonomously.
Approval to implement is separate from approval to publish, destroy, spend, or mutate data.

Explicit approval remains valid for the actions, scope and conditions it covers during the task. Check existing instructions first; when they cover the intended action, record that basis and proceed without asking for the same approval again. A general implementation request does not authorize a separate publication action. Pause immediately before an action whose target, scope or impact falls outside the approval. If approval is missing, first finish independent investigation, fixes and verification, then present concrete changes and residual risks for the decision.

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
If an action above becomes part of the workflow and its approval is missing, pause before that action.

- Read-only research over the repository, working tree, or already-provided context
- Read-only role passes, audits, reviews, and verification
- User-requested read-only security scans
- Bounded read-only subagent delegation
- Summaries of test output, logs, diffs, and documentation consistency

Do not stop for additional human approval solely because a subagent or scan tool is used.
Pause when moving into actions whose required approval is missing, such as stage, commit, push, deploy, DB apply, production data mutation, external service configuration, increased billing, or sensitive-data retrieval. Ordinary focused edits within the requested scope do not require another approval merely because they write files. Explicit approval remains necessary for the listed actions, including full overwrites, deletion, sensitive boundaries and Universal changes.

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
