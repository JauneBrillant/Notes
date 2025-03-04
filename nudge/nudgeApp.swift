import SwiftData
import SwiftUI

@main
struct nudgeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ItemModel.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])

            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    Task {
                        await addInitialData(to: sharedModelContainer)
                    }
                }
        }
        .modelContainer(sharedModelContainer)
    }
}

private func addInitialData(to container: ModelContainer) async {
    let context = ModelContext(container)
    var descriptor = FetchDescriptor<ItemModel>()
    descriptor.fetchLimit = 1

    do {
        let existingItems = try context.fetch(descriptor)
        if existingItems.isEmpty {
            let initialItems = [
                ItemModel(sentence: "Less is more.", order: 0),
                ItemModel(
                    sentence: "Success is doing ordinary things extraordinarily well.", order: 1),
                ItemModel(
                    sentence:
                        "Every action you take is a vote for the type of person you wish to become.",
                    order: 2),
            ]

            for item in initialItems {
                context.insert(item)
            }

            try context.save()
        }
    } catch {
        print("Failed to check for or add initial data: \(error)")
    }
}
