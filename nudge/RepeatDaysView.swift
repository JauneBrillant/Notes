import SwiftUI

struct RepeatDaysView: View {
    @Binding var selectedDays: [Int]
    let days = [
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday",
    ]

    var body: some View {
        List {
            ForEach(0..<7, id: \.self) { index in
                Button(action: {
                    if selectedDays.contains(index) {
                        selectedDays.removeAll { $0 == index }
                    } else {
                        selectedDays.append(index)
                        selectedDays.sort()
                    }
                }) {
                    HStack {
                        Text(days[index])
                        Spacer()
                        if selectedDays.contains(index) {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Repeat").font(.system(size: 18, weight: .bold))
            }
        }
        .tint(.black)
    }
}
