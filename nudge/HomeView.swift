import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [ItemModel]
    @State private var isShowingInputSheet = false
    @State private var newSentence = ""
    @State private var selectedItem: ItemModel?

    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(items) { item in
                            VStack {
                                Text(item.sentence)
                                    .font(.headline)
                                    .padding()
                                    .multilineTextAlignment(.center)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .onTapGesture {
                                        selectedItem = item
                                    }
                            }
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 16.0)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(
                                        x: phase.isIdentity ? 1.0 : 0.3,
                                        y: phase.isIdentity ? 1.0 : 0.3
                                    )

                                    .offset(y: phase.isIdentity ? 0 : 50)
                            }
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(16, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
            }

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        isShowingInputSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(.black)
                    }
                    .padding(.trailing, 40)
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            EditView(item: item)
        }
        .sheet(isPresented: $isShowingInputSheet) {
            VStack {
                Text("Add: New Item")
                    .font(.headline)
                    .padding(.top, 40)

                Spacer()

                VStack(spacing: 20) {
                    TextField("Add: New Sentence", text: $newSentence)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    HStack {
                        Button("Cancel") {
                            newSentence = ""
                            isShowingInputSheet = false
                        }
                        .buttonStyle(.bordered)

                        Button("Save") {
                            addItem()
                            isShowingInputSheet = false
                        }
                        .buttonStyle(.bordered)
                        .disabled(newSentence.isEmpty)
                    }
                }
                .padding(.horizontal)
                Spacer()
            }
            .presentationDetents([.height(200)])
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = ItemModel(sentence: newSentence, order: items.count)
            modelContext.insert(newItem)
            newSentence = ""
        }
    }
}
