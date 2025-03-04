import SwiftUI

struct TimePickerView: View {
    @Binding var selectedTime: Date

    var body: some View {
        HStack {
            Text("Notification Time")
            Spacer()
            DatePicker("", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
        }
    }
}
