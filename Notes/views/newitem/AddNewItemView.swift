import SwiftData
import SwiftUI

struct AddNewItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemModel]
    @State private var newSentence = ""
    @Binding var isShowing: Bool

    var onItemAdded: (() -> Void)?

    var body: some View {
        VStack {
            Text("New Item")
                .font(.headline)
                .padding(.top, 40)

            Spacer()

            VStack(spacing: 20) {
                TextField("sentence", text: $newSentence)
                    .padding(10)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .cornerRadius(8)
                    .padding(.horizontal)

                HStack {
                    Button("×") {
                        newSentence = ""
                        isShowing = false
                    }
                    .buttonStyle(CustomButtonStyle())

                    Button("Save") {
                        addItem()
                        isShowing = false
                    }
                    .bold()
                    .buttonStyle(CustomButtonStyle(width: 50))
                    .disabled(newSentence.isEmpty)
                }
            }
            .padding(.horizontal)
            Spacer()
        }
        .presentationDetents([.height(200)])
        .tint(.primary)
    }

    private func addItem() {
        withAnimation {
            let newItem = ItemModel(sentence: newSentence, order: items.count)
            modelContext.insert(newItem)
            newSentence = ""

            onItemAdded?()
        }
    }
}
