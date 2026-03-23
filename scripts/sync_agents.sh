#!/bin/bash
# Scans .claude/agents/ and updates the Sub-Agents table in CLAUDE.md

AGENTS_DIR="/Users/roseyrr/Frida - EA/.claude/agents"
CLAUDE_MD="/Users/roseyrr/Frida - EA/CLAUDE.md"

# Build table rows
rows=""
for f in "$AGENTS_DIR"/*.md; do
  [ -f "$f" ] || continue
  name=$(grep '^name:' "$f" | head -1 | sed 's/^name:[[:space:]]*//')
  desc=$(grep '^description:' "$f" | head -1 | sed 's/^description:[[:space:]]*//' | cut -c1-100)
  [ -n "$name" ] && rows="${rows}| ${name} | ${desc} |\n"
done

# Replace the auto-generated block in CLAUDE.md
python3 - <<EOF
import re

with open("$CLAUDE_MD", "r") as f:
    content = f.read()

table = "| Agent | Purpose |\n|-------|---------|"
rows = """$rows""".strip()
if rows:
    table += "\n" + rows

new_block = "<!-- AUTO-GENERATED: do not edit manually, updated by scripts/sync_agents.sh -->\n" + table + "\n<!-- END AUTO-GENERATED -->"
content = re.sub(
    r"<!-- AUTO-GENERATED.*?-->.*?<!-- END AUTO-GENERATED -->",
    new_block,
    content,
    flags=re.DOTALL
)

with open("$CLAUDE_MD", "w") as f:
    f.write(content)

print("sync_agents: CLAUDE.md updated")
EOF
