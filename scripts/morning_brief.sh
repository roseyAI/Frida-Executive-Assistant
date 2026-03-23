#!/bin/bash
# Morning briefing script for Frida EA
# Run this in the morning to get an overview of your day

TODAY=$(date +"%A, %B %d, %Y")

echo "# Good morning! Here's your briefing for $TODAY"
echo ""

echo "---"
echo "## 📅 Upcoming Calendar Events (next 7 days)"
echo ""
bash "$(dirname "$0")/get_calendar.sh" 7
echo ""

echo "---"
echo "## ✅ Reminders"
echo ""
bash "$(dirname "$0")/get_reminders.sh"
echo ""
echo "---"
echo "_Briefing complete. Have a great day!_"
