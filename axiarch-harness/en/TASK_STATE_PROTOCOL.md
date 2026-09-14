# TASK_STATE_PROTOCOL.md — Executable goal and evidence contract

## Scope

The content authority is `axiarch-rules/en/universal/core/300_goal_and_current_state.md`. This document defines storage and checks only. Harness H0 read-only work needs no document creation or readiness gate. H1 needs a short objective, target and result. H2+ uses structured records below. Equivalent external ledgers are allowed; export this format for the supplied checker.

## Storage and ownership

| Location | Responsibility |
|:--|:--|
| `.axiarch/tasks/{task_id}/state.json` | Single authority for the task's goal and current state |
| `.axiarch/tasks/{task_id}/history/{revision}.json` | Previous revisions preserving decisions |
| `.axiarch/sessions/{session_id}/` | Session-specific `task.md`, `implementation_plan.md`, `walkthrough.md` and binding |
| `--mode status` | Reads `.axiarch/tasks/` as a shared view of all owners; no duplicated index authority |
| Three root documents | Preserve legacy evidence; create shared-reference pointers only when absent |

Direct CLI calls resolve session IDs from `--session`, then `AXIARCH_SESSION_ID`, then `CODEX_THREAD_ID`. Hooks first validate supplied `session_id` / `sessionId` fields and require them to agree when both are present. Selection then prefers an intentional `AXIARCH_SESSION_ID` override, followed by the native input ID, with `CODEX_THREAD_ID` only as a fallback. An inherited Codex parent ID must not hide another product's native identity, and environment variables never suppress invalid input-ID errors. Task IDs come from CLI or `AXIARCH_TASK_ID`. Startup without identity generates and prints new IDs; it never selects another session implicitly. Reuse the printed IDs on the next invocation. IDs are not credentials.

UUID folder names are internal keys for collision avoidance and resumption, not work titles. `--mode status` and `--mode sessions` display the canonical task `goal` first. Session listings read bindings and task state directly without duplicating a title registry. Do not manually rename existing folders and break their references. For a new explicit session ID, a unique ASCII name such as `audit-2026-09-13-agent-a` is also supported; the example date and task are not prescribed values.

Session documents, shared task state and history are local records excluded from Git distribution. Use `privacy-check` to inspect tracking and exclusions; ignore rules do not remove already tracked files or historical commits. Summarize sanitized public changes in `CHANGELOG.md` or another reviewed shared document, without copying internal IDs or raw logs.

When hook input provides `cwd`, records and reminders resolve the nearest `AXIARCH.md` above that working directory. The active worktree takes precedence over an environment variable pointing at the starting checkout. An unresolved project warns without bootstrapping another checkout. See `axiarch-scripts/AGENT_COMPATIBILITY.md` for product-specific conditions.

Restarting the same session does not modify its documents. Use a new session ID for another task. Joining an existing task from another session uses `resume --task`; read shared state and the previous owner's evidence before continuing. Each session edits only its own documents. Historical load records do not prove that a new AI has read those files.

An incomplete existing session stops before creating a new task record. A binding whose shared state.json is missing does not silently become a new task. Inspect remaining documents, history and backups to recover; explicitly choose new task/session IDs when starting different work.

Resume also requires all three documents to exist as regular files; missing files, symlinks or directories do not count as a successful startup. Shared state, binding and publication-candidate JSON must be regular files with unique keys and valid JSON numbers; NaN and similar extensions are rejected. FIFOs stop with exit 2 without waiting for a writer. Ambiguous records are not resolved by taking the last value, and invalid files remain available for review and recovery.

Initial setup, session documents and optional commands share language-setting parsing. Fenced, commented and inline-code examples are excluded; duplicate or unknown actual settings stop generation. Explicit language takes precedence; otherwise resolve AXIARCH.md, legacy AGENTS.md, then installed language directories. Status/check/path/snapshot/publish do not generate language-specific templates, so repairing language configuration is not their precondition.

Health uses the same parser: AXIARCH.md, legacy AGENTS.md, then installed rule-language folders. With only en installed it defaults to en; otherwise absence of an actual setting defaults to ja. Comment tokens inside code examples and escaped tokens remain literal and cannot hide later configuration. Write settings at the original start of a line as `Project Native Language:` outside code examples and comments. Invalid, ambiguous or unreadable settings make health exit 1. `AXIARCH_PROCESS_DOC_LANG` overrides generated-document language; it does not hide project configuration from health. Health does not use character scripts in legacy root or other-session records as language-compliance evidence. The AI or reviewer assesses the selected session against user instructions.

Lexical handling is shared with lesson and local-reference checks and preserves source lines and columns. An unclosed real comment hides content through the end of the file. Code markup within an actual language value is retained as an unknown value, not silently removed. Setup staging's `configure-language` changes only the value, preserving surrounding whitespace, trailing HTML comments, LF/CRLF/CR and the presence or absence of a final newline. Embedded comments, code markup and empty values stop with exit 3 without writing. This handles the top-level setting format defined here, not arbitrary HTML or nested Markdown rendering.

Values such as `1e999` that overflow the runtime's floating-point representation are rejected on read; writes also disallow NaN and infinity. This prevents an accepted candidate from being serialized into invalid JSON that makes shared state unreadable. It does not validate the business meaning of a number.

Ordinary generation errors roll back only the task and session newly created by that invocation, preserve existing tasks, sessions and legacy documents, and exit 2. Renderer exit 0 alone is insufficient: all three documents must be nonempty regular files. Explicit legacy import copies regular-file contents into new writable documents without changing the originals or their permissions. Read-only legacy files are supported; symlinks and special files are rejected rather than silently skipped. Failure to create only an optional root pointer produces a warning, prints the usable managed-record IDs and exits 0.

SIGKILL, power loss or failed cleanup can leave partial records. Status reports task directories missing state.json with exit 2 rather than hiding them, and new task creation with the same ID is refused. Inspect state.json, history, binding and documents to recover. If only a valid draft remains, explicitly resume that task ID. Do not overwrite an incomplete session; restore its documents or join the same task with another session ID. Inspect remnants such as `.axiarch/sessions/.session-*` only after the owning process has stopped, and retain any needed content before cleanup. Do not delete the lock file to bypass contention: other processes may still reference its inode.

## Commands

```bash
# New task; choose appropriate IDs and owner
bash axiarch-scripts/axiarch-task-state.sh --mode new --task upgrade-audit --session agent-a --owner Codex
# Resume the same task/session, preserving its documents
bash axiarch-scripts/axiarch-task-state.sh --mode resume --task upgrade-audit --session agent-a
bash axiarch-scripts/axiarch-task-state.sh --mode status
bash axiarch-scripts/axiarch-task-state.sh --mode sessions
bash axiarch-scripts/axiarch-task-state.sh --mode path --session agent-a
# Copy legacy root evidence into a new session without moving or deleting the originals
bash axiarch-scripts/axiarch-task-state.sh --mode new --task migration-review --session agent-b --import-legacy
```

`AXIARCH_PROCESS_DOC_MODE=current|append` remains accepted for compatibility; both preserve existing root documents. Automatic rotation via `AXIARCH_PROCESS_DOC_ARCHIVE` / `AXIARCH_PROCESS_DOC_HISTORY_DIR` is retired; existing `.axiarch/process-doc-history/` remains intact. Language resolution still uses `AXIARCH_PROCESS_DOC_LANG`, `AXIARCH.md`, then legacy `AGENTS.md`. Synchronize native UI separately when available; otherwise record unavailability and continue.

## Structured record

`--mode path --session <ID>` is read-only and checks the binding, referenced shared `state.json` structure and matching IDs before returning the document location. Missing, invalid or mismatched records exit 2 without regenerating existing state. This is structural inspection, not a fresh completion check of historical evidence hashes or timestamps. It does not prove Markdown contents or reading.

Codex/Claude reminders report resolution failure for the selected existing session as bilingual `TASK STATE WARNING` and restore the full reminder even within the short-display TTL. Disabling optional scope detection does not suppress this anomaly. Stored JSON and raw parser diagnostics are not copied into the reminder. An uncreated session is not an anomaly, and H0 reading needs no record creation or repair gate. Before reusing existing evidence, inspect the binding, shared state and history directly and reconcile them without automatically moving, deleting or replacing originals. Antigravity or environments without hooks can use the same CLI to resolve records; this does not mean the same reminder is automatically injected.

`schema_version=1`. Each task has `task_id`, integer `revision`, `owner`, `goal`, `phase` (draft / active / complete), positive `max_age_seconds` (default 86400) and a `criteria` array.

Each criterion has a unique `id`, `owner`, `description`, `verification`, `state`, `verified`, `target`, `checked_at` and `evidence`. States are `not_started`, `in_progress`, `done`, `discarded`. Discarded requires `reason` and never substitutes for meeting a completion criterion. Record agreement and rationale for changed/removed criteria in the plan.

When `verified=false`, use `checked_at=null`, `target=null` and `evidence=[]`; historical evidence stays in history. `verified=true` requires a timestamp and at least one evidence reference. `done` requires `verified=true`. The target and each evidence reference use `{"path":"project-relative-file","sha256":"64-character digest"}`. For multiple targets, record the target list in a file and add individual snapshots to the evidence array. For external checks, store retrieved results locally without secrets. Hashes do not prove the live external state.

```bash
bash axiarch-scripts/axiarch-task-state.sh --mode snapshot --input axiarch-scripts/axiarch-task-state.sh
# Read state.json, prepare candidate JSON in your session, then publish at the revision read
bash axiarch-scripts/axiarch-task-state.sh --mode publish --session agent-a --input candidate.json --expected-revision 0
```

Use `publish` instead of overwriting shared state directly. Python 3 standard-library POSIX `flock`, temporary files and rename protect local filesystem updates. Busy locks or stale revisions return code 2. The AI rereads, reconciles and retries. Process exit releases the lock. Interrupted publication leaves either the old or new complete JSON; history supports recovery. Remove abandoned staging directories only after verifying their writer is no longer active. Network filesystems, multiple hosts, direct writes, malicious local writers and power loss are outside this atomicity guarantee.

The task lock must be a regular file owned by the current execution user with a link count of one. FIFOs, links and foreign ownership are rejected without waiting. Atomic replacement applies per JSON file, not to simultaneous commitment of tasks, sessions and root pointers. If updating current state fails after history was saved, the old state.json remains; retry can reuse identical history.

## Runtime artifact protection

The upgrade shell's `check-paths` and Python helper's `copy` apply the same preflight to the selected source, adopter and base trees. Reject control characters, symlinks, special files, reserved paths and name aliases before copying. Copy-time I/O failures return 5, while earlier successful copies remain. Use `axiarch-scripts/axiarch-upgrade.sh` for the overall lock, protection policy, diagnosis and outcome records. Internal `copy` exit 0 alone does not mean the upgrade is complete; the shell's aggregation/finalization handles pending REVIEW and TYPE-CONFLICT outcomes.

Compare distribution names using casefold and NFD canonical Unicode normalization. Reject differently spelled aliases among selections, parent directories and expanded descendants before application, so an alternate name cannot update a preserved path. Compare the selected scope across source, adopter and base; apply the same name check to installation sources and staged payloads. This conservative portability constraint also applies on case-sensitive hosts. Ordinary Unicode names and spaces remain supported. Do not automatically merge case-only renames: retain original data, align the distribution copy and manifest spelling, preview, then retry. Renaming adopter files must remain within owner authorization. This check does not identify every shared physical object, such as hardlinks.

Upgrade wildcard expansion validates original filenames before converting them to line-delimited selections. Paths containing control characters or Unicode line separators (NEL, LINE SEPARATOR, PARAGRAPH SEPARATOR) are rejected. Legacy manifest Blueprint discovery also preserves filename boundaries to avoid splitting a name into different paths or log records. Ordinary spaces, non-ASCII names, explicit hidden-file selections and exclusions remain supported. Review rejected names in a dedicated distribution source; do not automatically rename or delete adopter records.

An upstream manifest does not acquire ownership of Git internals or local managed records. Installation/upgrade payloads cannot select the whole project `.` or contain `.git` / `.axiarch` path components, including case variants. Upgrades inspect expanded selections and descendants; installation checks distribution folders and staged payloads. Dedicated lifecycle operations create/update managed records. Do not delete existing records to bypass a refusal: prepare a distribution-only source, or review upgrade exclusions where applicable. This checks path boundaries, not secret content under other filenames, and performs no automatic redaction.

`axiarch-rules/en/universal/core/300_goal_and_current_state.md` §4.6 remains authoritative for secrets and personal data in state. Fresh installation, applied upgrades and session creation/resume supplement `.axiarch/.gitignore` with exclusions for managed records: the tasks, sessions, upgrades, conflicts, process-doc-history and process-doc-state directories, plus task-state.lock, privacy.lock, upgrade-result.json, install-result.json and install-health.log, all under `.axiarch/`. Existing policy and the root `.gitignore` are preserved; custom negations that defeat protection in a Git worktree fail diagnosis. Dry-runs and read-only checks do not modify the policy.

Policy updates use `.axiarch/privacy.lock` and atomic temporary-file replacement. Links, special files and foreign ownership are rejected. Supplemented exclusions can remain after an ordinary failure; existing records are not deleted. New upgrade run directories use mode 0700; installation diagnostic logs and compatibility conflict copies use 0600. Existing directory permissions are not recursively changed. Review older artifacts' permissions and retention, ACLs and synchronization settings separately.

`bash axiarch-scripts/axiarch-task-state.sh --mode privacy-check` checks tracked records, unignored files and required exclusions. Inside a Git worktree the Git executable is required; failed checks or unavailable required tracking checks return 2, and health returns 1. Outside a Git worktree, successful local exclusion-policy validation returns 0 with index tracking explicitly unassessed. This standalone use does not require installing Git. Contents, Git history and external synchronization destinations are not inspected. Already tracked files are not automatically untracked and history is never rewritten.

Backups, conflicts and diagnostic output retain original information for recovery and are not automatically anonymized. Exclusions are not encryption or authentication, and do not block forced staging, IDE synchronization, conversation pastes or external uploads. Remove sensitive information before sharing and define storage, readers and retention in project rules. Never delete recovery or evidence records unconditionally. Anomalies are reported through terminal output, exit status and local records, with no automatic external notification. Monitoring/CI consumers should connect nonzero status to notifications without forwarding raw logs.

## Validation phases

Structure checks validate historical record shape and internal claim consistency. Age or later target changes alone do not make historical completion records structurally invalid. Readiness/completion checks used for current decisions, and every new `publish`, compare actual target/evidence snapshots and freshness. When marking an item unverified, also use `target=null`; its previous target remains in history. Resume and completion check the task/session/binding ID relationship.

| Phase | Command | Meaning |
|:--|:--|:--|
| Distribution structure | `bash axiarch-scripts/check-axiarch-health.sh --phase structure` | Existing 16-stage structure/wiring checks; unfinished work is not failure |
| Record structure | `bash axiarch-scripts/axiarch-task-state.sh --mode check --task ID --phase structure` | Empty draft goals allowed; inconsistent IDs, states and evidence claims rejected |
| Readiness | `bash axiarch-scripts/check-axiarch-health.sh --phase readiness --task ID` | Requires goal, owners, criteria and verification methods; unmet criteria allowed |
| Completion | `bash axiarch-scripts/check-axiarch-health.sh --phase completion --session ID` | Every criterion done; matching evidence/target hashes, timestamps, freshness and no remaining templates |

After passing completion checks, perform audit, evidence packet and final reconciliation. Checks validate record consistency, not semantic understanding, evidence sufficiency, absence of omissions or safety of every operation. Role review judges target selection and conclusions. Never ask users to inspect facts or logs the AI can access itself.

Changing the goal, criterion IDs, descriptions or verification methods after active requires `scope_change` with `reason` and `approval_ref` in the candidate JSON. The checker validates that the reference is recorded; the human approval gate judges its authenticity.
