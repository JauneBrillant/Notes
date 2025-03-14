import SwiftData
import SwiftUI

class ListViewModel: ObservableObject {
    @Published var items: [ItemModel] = []
    private var modelContext: ModelContext?

    init() {}

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        fetchItems()
    }

    func fetchItems() {
        guard let modelContext = modelContext else { return }

        do {
            let descriptor = FetchDescriptor<ItemModel>(
                sortBy: [
                    SortDescriptor(\.order, order: .forward)
                ]
            )

            let fetchItems = try modelContext.fetch(descriptor)
            self.items = fetchItems
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    func moveItems(from source: IndexSet, to destination: Int) {
        guard let modelContext = modelContext else { return }

        var itemsToUpdate = items
        itemsToUpdate.move(fromOffsets: source, toOffset: destination)
        for (index, item) in itemsToUpdate.enumerated() {
            item.order = index
        }

        try? modelContext.save()
        fetchItems()
    }

    func deleteItems(at offsets: IndexSet) {
        guard let modelContext = modelContext else { return }

        for index in offsets {
            let item = items[index]
            modelContext.delete(item)
        }
        try? modelContext.save()
        fetchItems()
    }
}
