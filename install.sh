#!/usr/bin/env bash
# Copies the coupon-* skills into ~/.claude/skills and creates the workbook-builder venv.
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

mkdir -p "$DEST"
for dir in "$HERE"/coupon-*/; do
  name="$(basename "$dir")"
  rsync -a --delete --exclude '.venv' --exclude '__pycache__' "$dir" "$DEST/$name/"
  echo "installed $name"
done

CORE="$DEST/coupon-test-core"
if [ ! -x "$CORE/.venv/bin/python" ]; then
  python3 -m venv "$CORE/.venv"
fi
"$CORE/.venv/bin/pip" install -q openpyxl
"$CORE/.venv/bin/python" -c "import openpyxl; print('openpyxl', openpyxl.__version__, 'ready')"
echo "Done. Restart Claude Code and try: /coupon-percentage-discount <requirement>"
