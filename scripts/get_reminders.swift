import EventKit
import Foundation

let store = EKEventStore()
let sema = DispatchSemaphore(value: 0)

store.requestFullAccessToReminders { granted, error in
    guard granted else {
        print("Access denied: \(error?.localizedDescription ?? "unknown")")
        sema.signal()
        return
    }

    let calendars = store.calendars(for: .reminder)
    let predicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: calendars)

    store.fetchReminders(matching: predicate) { reminders in
        guard let reminders = reminders else {
            print("No reminders found.")
            sema.signal()
            return
        }

        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short

        // Group by calendar
        var grouped: [String: [EKReminder]] = [:]
        for r in reminders {
            let listName = r.calendar.title
            grouped[listName, default: []].append(r)
        }

        for (list, items) in grouped.sorted(by: { $0.key < $1.key }) {
            print("## \(list)")
            for item in items.sorted(by: { ($0.dueDateComponents?.date ?? Date.distantFuture) < ($1.dueDateComponents?.date ?? Date.distantFuture) }) {
                var dueLine = ""
                if let comps = item.dueDateComponents, let date = comps.date {
                    dueLine = " [Due: \(formatter.string(from: date))]"
                }
                print("- \(item.title ?? "Untitled")\(dueLine)")
            }
            print("")
        }

        sema.signal()
    }
}

sema.wait()
