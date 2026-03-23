#!/bin/bash
# Fetches all incomplete reminders via EventKit (Python/pyobjc — faster than AppleScript)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
python3 "$SCRIPT_DIR/get_reminders.py"
