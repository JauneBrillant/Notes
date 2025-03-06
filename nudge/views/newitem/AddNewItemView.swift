import SwiftData
import SwiftUI

struct CustomBorderedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.black)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 2)
            )
            .background(Color.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

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
                    .buttonStyle(CustomBorderedButtonStyle())

                    Button("Save") {
                        addItem()
                        isShowing = false
                    }
                    .bold()
                    .buttonStyle(CustomBorderedButtonStyle())
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
