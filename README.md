# Frida — Executive Assistant

Personal AI EA powered by Claude Code. Connects to macOS Calendar and Reminders to deliver a clean morning briefing.

## Features
- Morning briefing via `/morningbrief` in Claude Code
- Reads Google Calendar (via macOS Calendar sync)
- Reads macOS Reminders (lists: Reminders, Girl Stuff, Gamot)
- Flags overdue items and surfaces today's priorities

## Usage

Open this project in Claude Code (VSCode) and type:
```
/morningbrief
```

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/get_calendar.sh` | Fetches upcoming calendar events via AppleScript |
| `scripts/get_reminders.sh` | Fetches incomplete reminders via AppleScript |
| `scripts/morning_brief.sh` | Runs both scripts combined |

## Requirements
- macOS with Calendar and Reminders apps
- Google Calendar synced via System Preferences → Internet Accounts
- [Claude Code](https://claude.ai/code) VSCode extension
