import SwiftData
import SwiftUI

class FilterOutViewModel: ObservableObject {
    @Published var reviewItems: [ItemModel] = []
    private var modelContext: ModelContext?
    private var hasFetchedInitially = false

    init() {}

    func setModelContext(_ context: ModelContext) {
        self.modelContext = context
        if !hasFetchedInitially {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.fetchReviewItems()
                self.hasFetchedInitially = true
            }
        }
    }

    func fetchReviewItems() {
        guard let modelContext = modelContext else {
            print("Model context is nil when trying to fetch review items")
            return
        }

        do {
            let todayStartOfDay = Calendar.current.startOfDay(for: Date())
            let todayEndOfDay = Calendar.current.date(byAdding: .second, value: -1, to: todayStartOfDay.addingTimeInterval(24 * 60 * 60)) ?? todayStartOfDay

            let descriptor = FetchDescriptor<ItemModel>(
                predicate: #Predicate { item in
                    item.nextReviewDate <= todayEndOfDay
                },
                
                sortBy: [
                    SortDescriptor(\.nextReviewDate, order: .forward),
                    SortDescriptor(\.order, order: .forward),
                ]
            )

            let fetchedItems = try modelContext.fetch(descriptor)

            DispatchQueue.main.async {
                self.reviewItems = fetchedItems
                print("Fetched \(fetchedItems.count) review items")
            }
        } catch {
            print("Failed to fetch review items: \(error)")
        }
    }

    func deleteItem(at index: Int) {
        guard let modelContext = modelContext else { return }
        guard index < reviewItems.count else { return }

        let itemToDelete = reviewItems[index]
        modelContext.delete(itemToDelete)
        try? modelContext.save()
        reviewItems.remove(at: index)
    }

    func incrementCount(for index: Int) {
        guard let modelContext = modelContext else { return }
        guard index < reviewItems.count else { return }

        let item = reviewItems[index]
        item.calculateNextReviewDate()
        item.cnt += 1

        try? modelContext.save()

        let todayStartOfDay = Calendar.current.startOfDay(for: Date())
        if item.nextReviewDate > todayStartOfDay {
            reviewItems.remove(at: index)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.objectWillChange.send()
        }
    }
}
