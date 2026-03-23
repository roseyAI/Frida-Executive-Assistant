#!/usr/bin/env python3
"""Fetch incomplete reminders via EventKit (faster than AppleScript)."""

import sys
import threading
from datetime import datetime

import EventKit

store = EventKit.EKEventStore.alloc().init()
done = threading.Event()

def handle_access(granted, error):
    if not granted:
        print(f"Reminders access denied: {error}", file=sys.stderr)
        done.set()
        return

    calendars = store.calendarsForEntityType_(EventKit.EKEntityTypeReminder)
    predicate = store.predicateForIncompleteRemindersWithDueDateStarting_ending_calendars_(
        None, None, calendars
    )

    def handle_fetch(reminders):
        if reminders is None:
            print("No reminders returned.", file=sys.stderr)
            done.set()
            return

        grouped = {}
        for r in (reminders or []):
            list_name = r.calendar().title()
            grouped.setdefault(list_name, []).append(r)

        for list_name in sorted(grouped.keys()):
            print(f"## {list_name}")
            items = grouped[list_name]

            def due_key(r):
                comps = r.dueDateComponents()
                if comps:
                    y = comps.year() or 9999
                    mo = comps.month() or 12
                    d = comps.day() or 31
                    h = comps.hour() or 0
                    m = comps.minute() or 0
                    return (y, mo, d, h, m)
                return (9999, 12, 31, 23, 59)

            for item in sorted(items, key=due_key):
                due_str = ""
                comps = item.dueDateComponents()
                if comps and comps.year() and comps.year() != 9999:
                    try:
                        dt = datetime(
                            comps.year(), comps.month() or 1, comps.day() or 1,
                            comps.hour() or 0, comps.minute() or 0
                        )
                        due_str = f" [Due: {dt.strftime('%A, %B %-d, %Y at %-I:%M %p')}]"
                    except Exception:
                        pass
                print(f"- {item.title()}{due_str}")
            print()

        done.set()

    store.fetchRemindersMatchingPredicate_completion_(predicate, handle_fetch)

store.requestFullAccessToRemindersWithCompletion_(handle_access)
done.wait(timeout=15)
