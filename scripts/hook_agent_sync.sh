#!/bin/bash
# PostToolUse hook: runs sync_agents.sh when an agent file is written/edited

input=$(cat)
file_path=$(echo "$input" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

if [[ "$file_path" == *".claude/agents/"* ]]; then
  bash "/Users/roseyrr/Frida - EA/scripts/sync_agents.sh"
fi
