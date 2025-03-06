import SwiftUI

struct EditView: View {
    @Bindable var item: ItemModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showingDeleteConfirmation = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("aEdit")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black.opacity(0.9))

                TextEditor(text: $item.sentence)
                    .padding()
                    .foregroundStyle(.black.opacity(0.9))
                    .font(.headline)
                    .bold()
                    .border(.black.opacity(0.7), width: 2)
                    .cornerRadius(3)
                    .frame(height: 180)

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete") {
                        showingDeleteConfirmation = true
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .alert("Delete", isPresented: $showingDeleteConfirmation) {
                Button("Cancel", role: .cancel) {}
                Button("Delete", role: .destructive) {
                    deleteItem()
                }
            } message: {
                Text("Are you sure you want to delete this item?")
            }
        }
    }

    private func deleteItem() {
        modelContext.delete(item)
        dismiss()
    }
}
