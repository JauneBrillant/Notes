import SwiftData
import SwiftUI

struct RightView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ItemModel.order, order: .forward) private var items: [ItemModel]
    @State private var selectedItem: ItemModel?
    @State private var isShowingEditSheet = false
    @State private var showSideMenu = false

    var body: some View {
        ZStack {
            List {
                ForEach(items) { item in
                    ItemRow(
                        item: item,
                        onTap: {
                            selectedItem = item
                            isShowingEditSheet = true
                        })
                }
                .onMove(perform: moveItems)
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .navigationTitle("ITEMS")
            .navigationBarTitleDisplayMode(.large)
            //.toolbarBackground(.white)
            .scrollContentBackground(.hidden)
        }
        .sheet(item: $selectedItem) { item in
            EditView(item: item)
        }
    }

    private func moveItems(from source: IndexSet, to destination: Int) {
        var itemsToUpdate = items
        itemsToUpdate.move(fromOffsets: source, toOffset: destination)

        for (index, item) in itemsToUpdate.enumerated() {
            item.order = index
        }
    }

    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            modelContext.delete(item)
        }
    }
}

struct ItemRow: View {
    let item: ItemModel
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "app.fill")
                .font(.system(size: 5))
                .frame(width: 5, height: 5)
                .foregroundColor(.primary)

            Text(item.sentence)
                .bold()
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .onTapGesture(perform: onTap)
        }
        .padding(.vertical, 8)
        .listRowInsets(EdgeInsets(top: 0, leading: 18, bottom: 0, trailing: 20))
        .listRowSeparator(.hidden)
    }
}
