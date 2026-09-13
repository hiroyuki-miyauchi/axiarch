#!/usr/bin/env bash
# Optional Claude command file adapter. Runtime behavior is not agent-validated.
# Requires Python 3; reads installed canonical prompts in the target project.
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for arg in "$@"; do
  if [[ "$arg" == "--help" || "$arg" == "-h" ]]; then
    cat <<'USAGE'
Usage: bash axiarch-scripts/axiarch-prompts-install.sh [options]
  --target DIR   Adopter project (default: current directory)
  --lang LANG    ja|en|auto (default: detect installed AXIARCH.md)
  --source DIR   Compatibility input; canonical prompts must already be in target
  --clean        Remove only unmodified generated commands
  --dry-run      Preview without changing files

Optional .claude/commands adapter; generation does not validate agent execution.
Requires Python 3. Custom, edited or legacy commands are preserved for review.
USAGE
    exit 0
  fi
done
exec python3 "${SCRIPT_DIR}/axiarch_setup.py" prompts "$@"
