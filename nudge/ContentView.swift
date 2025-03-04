import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ItemModel.order, order: .forward) private var items: [ItemModel]
    @State private var selectedItem: ItemModel?
    @State private var isShowingSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    HStack {
                        Image(
                            systemName:
                                "\((item.order + 1) % 50).circle\(item.isActive ? ".fill" : "")")
                        Text(item.sentence)
                            .onTapGesture {
                                selectedItem = item
                                isShowingSheet = true
                            }
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
                }
                .onMove(perform: moveItems)
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .navigationTitle("ITEMS")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(.white)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedItem) { item in
                EditView(item: item)
            }
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
