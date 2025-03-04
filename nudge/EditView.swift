import SwiftUI

struct EditView: View {
    @Bindable var item: ItemModel

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Sentence")) {
                    TextField("Enter text", text: $item.sentence)
                }

                Section(header: Text("Notifications")) {

                    TimePickerView(
                        selectedTime: Binding(
                            get: { item.notificationTime ?? Date() },
                            set: { item.notificationTime = $0 }
                        )
                    )

                    NavigationLink(
                        destination: RepeatDaysView(selectedDays: $item.notificationDays)
                    ) {
                        HStack {
                            Text("Repeat Days")
                            Spacer()
                            Text(notificationDaysText())
                        }
                    }

                    Toggle(item.isActive ? "On" : "Off", isOn: $item.isActive)
                }
                .listRowSeparator(.hidden)
            }
            .navigationTitle("EDIT")
            .toolbarBackground(.white)
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle())
        }
        .tint(.black)
        .onDisappear {
            if item.isActive {
                scheduleNotification()
            }
        }
    }

    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        guard let notificationTime = item.notificationTime else { return }

        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = item.sentence
        content.sound = .default

        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: notificationTime)
        let minute = calendar.component(.minute, from: notificationTime)

        if item.notificationDays.isEmpty {
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            dateComponents.hour = hour
            dateComponents.minute = minute

            let trigger = UNCalendarNotificationTrigger(
                dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(
                identifier: "notification_today", content: content, trigger: trigger)

            center.add(request) { error in
                if let error = error {
                    print("Notification Error: \(error.localizedDescription)")
                }
            }
        } else {
            for day in item.notificationDays {
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute
                dateComponents.weekday = day + 1

                let trigger = UNCalendarNotificationTrigger(
                    dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(
                    identifier: "notification_\(day)", content: content, trigger: trigger)

                center.add(request) { error in
                    if let error = error {
                        print("Notification Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    private func notificationDaysText() -> String {
        let days = item.notificationDays
        if days.isEmpty {
            return "None"
        }

        if days.count == 7 {
            return "Everyday"
        } else if days == [1, 2, 3, 4, 5] {
            return "weekday"
        } else {
            let dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            return days.map { dayNames[$0] }.joined(separator: "・")
        }
    }
}
