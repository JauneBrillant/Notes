import SwiftData
import SwiftUI

struct ListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemModel]
    @State private var selectedItem: ItemModel?

    @Binding var showSideMenu: Bool

    var body: some View {
        NavigationStack {
            List {
                ForEach(items) { item in
                    ItemRow(
                        item: item,
                        onTap: {
                            selectedItem = item
                        }
                    )
                    .listRowSeparator(.hidden)
                }
                .onMove(perform: moveItems)
                .onDelete(perform: deleteItems)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

            .navigationTitle("ITEMS")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(colorScheme == .light ? .white : .black)
            .sheet(item: $selectedItem) { item in
                EditView(item: item)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            showSideMenu.toggle()
                        },
                        label: {
                            Image(systemName: "line.3.horizontal")
                                .resizable()
                                .frame(width: 18, height: 15)
                        }
                    )
                    .padding(.trailing, 5)
                }
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

struct ItemRow: View {
    @Environment(\.colorScheme) private var colorScheme

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
                .onTapGesture(perform: onTap)
        }
        .padding(12)
        .background(colorScheme == .light ? .white : .black)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colorScheme == .light ? .black : .white, lineWidth: 2)
        )
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: ItemModel.self, configurations: config)
    let context = container.mainContext

    let itemsData: [(sentence: String, order: Int)] = [
        ("Less is more.", 0),
        ("Success is doing ordinary things extraordinarily well.", 1),
        (
            "Every action you take is a vote for the type of person you wish to become.",
            2
        ),
        ("First test item", 3),
        ("First test item", 4),
        ("Second test item", 5),
        ("Second test item", 6),
        ("Second test item", 7),
    ]

    for data in itemsData {
        let item = ItemModel(sentence: data.sentence, order: data.order)
        context.insert(item)
    }

    return ListView(showSideMenu: .constant(false))
        .modelContainer(container)
}
