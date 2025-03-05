import SwiftData
import SwiftUI

struct AddNewItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemModel]
    @State private var newSentence = ""
    @Binding var isShowing: Bool

    var body: some View {
        VStack {
            Text("New Item")
                .font(.headline)
                .padding(.top, 40)

            Spacer()

            VStack(spacing: 20) {
                TextField("Add: New Sentence", text: $newSentence)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                HStack {
                    Button("Cancel") {
                        newSentence = ""
                        isShowing = false
                    }
                    .buttonStyle(.bordered)

                    Button("Save") {
                        addItem()
                        isShowing = false
                    }
                    .buttonStyle(.bordered)
                    .disabled(newSentence.isEmpty)
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .presentationDetents([.height(200)])
        .tint(.black)
    }

    private func addItem() {
        withAnimation {
            let newItem = ItemModel(sentence: newSentence, order: items.count)
            modelContext.insert(newItem)
            newSentence = ""
        }
    }
}
