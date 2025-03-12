import SwiftUI

struct EditView: View {
    @Bindable var item: ItemModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 40) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Edit")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black.opacity(0.9))

                    TextEditor(text: $item.sentence)
                        .padding()
                        .foregroundStyle(.black.opacity(0.9))
                        .font(.headline)
                        .bold()
                        .frame(height: 200)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black.opacity(0.7), lineWidth: 2)
                        )
                }

                VStack(alignment: .leading, spacing: 20) {
                    Text("Details")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black.opacity(0.9))

                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("CreatedAt")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black.opacity(0.9))
                                .frame(width: 100, alignment: .leading)
                            Text(formatDate(item.createdAt))
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black.opacity(0.9))
                        }

                        HStack {
                            Text("Repeat")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black.opacity(0.9))
                                .frame(width: 100, alignment: .leading)
                            Text("\(item.cnt)")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black.opacity(0.9))
                        }
                    }
                    .padding(.leading)
                }
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }

            Spacer()
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

#Preview {
    let previewItem = ItemModel(
        sentence:
            "Every action you take is a vote for the type of person you wish to become.",
        order: 2)
    previewItem.createdAt = Date()
    previewItem.cnt = 3
    return EditView(item: previewItem)
}
