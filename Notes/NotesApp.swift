import SwiftData
import SwiftUI

@main
struct NotesApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var dataInitialized = false

    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ItemModel.self
        ])

        do {
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )

            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            return container
        } catch {
            print("SwiftData Error: \(error)")

            do {
                let fallbackConfig = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
                return try ModelContainer(for: schema, configurations: [fallbackConfig])
            } catch {
                print("Even in-memory container failed: \(error)")
                fatalError("Could not create ModelContainer: \(error)")
            }
        }
    }()

    var body: some Scene {
        WindowGroup {
            if dataInitialized {
                MainView()
            } else {
                // Show a loading screen or progress indicator
                ProgressView("Initializing...")
                    .task {
                        await addInitialData(to: sharedModelContainer)
                        dataInitialized = true
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }

    private func addInitialData(to container: ModelContainer) async {
        let context = ModelContext(container)
        var descriptor = FetchDescriptor<ItemModel>()
        descriptor.fetchLimit = 1

        do {
            let existingItems = try context.fetch(descriptor)
            if existingItems.isEmpty {
                let today = Calendar.current.startOfDay(for: Date())

                let initialItems = [
                    ItemModel(sentence: "item0.", order: 0),
                    ItemModel(sentence: "item1", order: 1),
                    ItemModel(sentence: "item2.", order: 2),
                    ItemModel(sentence: "item3.", order: 3),
                ]

                for item in initialItems {
                    item.nextReviewDate = today  // Ensure all items have today's date
                    context.insert(item)
                }

                try context.save()
                print("Initial data added successfully")

                // Add a small delay to ensure the database is ready
                try await Task.sleep(nanoseconds: 500_000_000)  // 0.5 seconds
            }
        } catch {
            print("Failed to check for or add initial data: \(error)")
        }
    }
}
