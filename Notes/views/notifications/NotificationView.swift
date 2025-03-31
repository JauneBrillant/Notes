import SwiftData
import SwiftUI
import UserNotifications

struct NotificationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var items: [ItemModel] = []
    @State private var isNotificationsEnabled = false
    @State private var showTimePicker = false
    @AppStorage("remindTime") private var selectedTime = Date()

    private func loadItems() {
        do {
            let descriptor = FetchDescriptor<ItemModel>()
            items = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Notifications")
                    .font(.title)
                    .bold()

                VStack(alignment: .leading, spacing: 16) {
                    Toggle("Enable Notifications", isOn: $isNotificationsEnabled)
                        .onChange(of: isNotificationsEnabled) { _, newValue in
                            if newValue {
                                requestNotificationPermission()
                                showTimePicker = true
                            } else {
                                cancelAllNotifications()
                                showTimePicker = false
                            }
                        }
                        .font(.headline)

                    if showTimePicker || isNotificationsEnabled {
                        VStack(alignment: .leading) {
                            Text("Time")
                                .font(.headline)

                            DatePicker(
                                "", selection: $selectedTime, displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            .onChange(of: selectedTime) { _, _ in
                                scheduleNotification()
                            }
                            .padding(.leading)
                        }
                    }
                }
                .padding(.leading)

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadItems()
                checkNotificationStatus()
            }
        }
    }

    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                if settings.authorizationStatus == .authorized {
                    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                        DispatchQueue.main.async {
                            self.isNotificationsEnabled = !requests.isEmpty
                            if self.isNotificationsEnabled {
                                self.showTimePicker = true
                            }
                        }
                    }
                } else {
                    self.isNotificationsEnabled = false
                }
            }
        }
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted, error in
            DispatchQueue.main.async {
                if granted {
                    self.scheduleNotification()
                } else {
                    self.isNotificationsEnabled = false
                }
            }
        }
    }

    private func scheduleNotification() {
        cancelAllNotifications()

        guard let randomItem = items.randomElement() else {
            return
        }

        let content = UNMutableNotificationContent()
        content.title = "Notes"
        content.body = randomItem.sentence
        content.sound = .default

        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: selectedTime)

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }

        scheduleNextDayNotification()
    }

    private func scheduleNextDayNotification() {
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedTime) ?? Date()
        let delay = nextDate.timeIntervalSinceNow

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.scheduleNotification()
        }
    }

    private func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
