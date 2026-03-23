#!/bin/bash
# Fetches calendar events for today and the next N days (default: 7)
# Usage: ./get_calendar.sh [days]

DAYS=${1:-7}

osascript << OSASCRIPT
set today to current date
set today to (today - (time of today)) -- strip time, midnight
set endDate to today + ($DAYS * days)

tell application "Calendar"
    set output to ""
    set allEvents to {}

    repeat with cal in every calendar
        set calName to name of cal
        try
            set calEvents to (every event of cal whose start date >= today and start date < endDate)
            repeat with e in calEvents
                set eventStart to start date of e
                set eventEnd to end date of e
                set eventTitle to summary of e
                set allEvents to allEvents & {{eventStart, eventEnd, eventTitle, calName}}
            end repeat
        end try
    end repeat

    -- Simple output (not sorted — AppleScript doesn't sort easily)
    set dayHeaders to {}
    repeat with ev in allEvents
        set evStart to item 1 of ev
        set evEnd to item 2 of ev
        set evTitle to item 3 of ev
        set evCal to item 4 of ev

        -- Format date header
        set dayStr to (evStart as text)

        -- Format time
        set startHour to hours of evStart
        set startMin to minutes of evStart
        set ampm to "AM"
        if startHour >= 12 then
            set ampm to "PM"
            if startHour > 12 then set startHour to startHour - 12
        end if
        if startHour = 0 then set startHour to 12
        set minStr to startMin as text
        if startMin < 10 then set minStr to "0" & minStr
        set timeStr to startHour & ":" & minStr & " " & ampm

        -- Format date as "DayOfWeek, Month Day"
        set dayNames to {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
        set monthNames to {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
        set wDay to item (weekday of evStart as integer) of dayNames
        set mName to item (month of evStart as integer) of monthNames
        set dateLabel to wDay & ", " & mName & " " & (day of evStart as text)

        set output to output & "- [" & dateLabel & "] " & evTitle & " at " & timeStr & " (" & evCal & ")" & linefeed
    end repeat

    if output is "" then
        return "No events found in the next $DAYS days."
    end if
    return output
end tell
OSASCRIPT
