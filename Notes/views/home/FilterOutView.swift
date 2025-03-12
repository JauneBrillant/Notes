import SwiftData
import SwiftUI

struct FilterOutView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemModel]

    @Binding var showSideMenu: Bool
    @State private var showAddItem: Bool = false
    @State private var currentIndex = 0
    @State private var offset: CGSize = .zero
    @State private var isTransitioning = false

    var reviewItems: [ItemModel] {
        let today = Calendar.current.startOfDay(for: Date())
        return items.filter { item in
            let itemDate = Calendar.current.startOfDay(for: item.nextReviewDate)
            return itemDate == today
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                if reviewItems.isEmpty {
                    Text("No Item to Filter")
                        .font(.title2)
                        .bold()
                } else if currentIndex < reviewItems.count {
                    Text(reviewItems[currentIndex].sentence)
                        .font(.title2)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .multilineTextAlignment(.center)
                        .padding()
                        .offset(x: offset.width, y: 0)
                        .scaleEffect(isTransitioning ? 0.3 : 1.0)
                        .opacity(isTransitioning ? 0.0 : 1.0)
                        .offset(y: isTransitioning ? 50 : 0)
                        .animation(
                            .easeInOut(duration: 0.3), value: isTransitioning
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    if !isTransitioning {
                                        offset = gesture.translation
                                    }
                                }
                                .onEnded { gesture in
                                    if !isTransitioning {
                                        handleSwipe(with: gesture)
                                    }
                                }
                        )
                        .id(reviewItems[currentIndex].id)  // Forces view refresh when item changes
                } else {
                    Text("Fin")
                        .font(.title2)
                        .bold()
                }

                PlusBtnView(isShowing: $showAddItem)
                    .sheet(isPresented: $showAddItem) {
                        AddNewItemView(isShowing: $showAddItem)
                    }
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

    private func handleSwipe(with gesture: DragGesture.Value) {
        let swipeThreshold: CGFloat = 100

        if currentIndex < reviewItems.count {
            if offset.width > swipeThreshold {
                let item = reviewItems[currentIndex]
                item.cnt += 1

                performTransition {
                    moveToNextItem()
                }
            } else if offset.width < -swipeThreshold {
                let item = reviewItems[currentIndex]

                performTransition {
                    modelContext.delete(item)
                }
            } else {
                resetOffset()
            }
        }
    }

    private func performTransition(completion: @escaping () -> Void) {
        isTransitioning = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            completion()
            resetOffset()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isTransitioning = false
            }
        }
    }

    private func moveToNextItem() {
        currentIndex += 1

        if currentIndex >= reviewItems.count {
            // We could reset to 0 here if needed
            // currentIndex = 0
        }
    }

    private func resetOffset() {
        offset = .zero
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: ItemModel.self, configurations: config)
    let context = container.mainContext

    let itemsData: [(sentence: String, order: Int)] = [
        ("First test item", 0),
        ("Second test item", 1),
        ("First test item", 2),
        ("First test item", 3),
        ("First test item", 4),
        ("Second test item", 5),
        ("Second test item", 6),
        ("Second test item", 7),
    ]

    let today = Date()
    for data in itemsData {
        let item = ItemModel(sentence: data.sentence, order: data.order)
        item.nextReviewDate = today
        context.insert(item)
    }

    return FilterOutView(showSideMenu: .constant(false))
        .modelContainer(container)
}
