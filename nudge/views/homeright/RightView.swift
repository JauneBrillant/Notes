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
                        }
                    )
                    .listRowSeparator(.hidden)
                }
                .onMove(perform: moveItems)
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            //.background(Color(.systemGroupedBackground))  // リストの背景色を統一
            //List {
            //    ForEach(items) { item in
            //        ItemRow(
            //            item: item,
            //            onTap: {
            //                selectedItem = item
            //                isShowingEditSheet = true
            //            })
            //    }
            //    .onMove(perform: moveItems)
            //    .onDelete(perform: deleteItems)
            //}
            //.listStyle(.plain)
            //.scrollContentBackground(.hidden)
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
            Image(systemName: "circle")
                .font(.system(size: 8))

            Text(item.sentence)
                .bold()
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 4)
                .contentShape(Rectangle())
                .onTapGesture(perform: onTap)
                .foregroundColor(.black.opacity(0.9))
        }
        .padding(12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black, lineWidth: 2)
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}
