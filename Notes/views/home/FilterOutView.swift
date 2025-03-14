import SwiftData
import SwiftUI

struct FilterOutView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = FilterOutViewModel()
    @Binding var showSideMenu: Bool

    @State private var showAddItem: Bool = false
    @State private var selectedItem: ItemModel?
    @State private var hasAppeared = false

    init(showSideMenu: Binding<Bool>) {
        _showSideMenu = showSideMenu
    }

    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    if viewModel.reviewItems.isEmpty {
                        Text("No Item to Filter")
                            .font(.title2)
                            .bold()
                    } else {
                        Text(viewModel.reviewItems[0].sentence)
                            .font(.title2)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .padding()
                            .onTapGesture {
                                selectedItem = viewModel.reviewItems[0]
                            }

                        HStack {
                            Button(action: {
                                viewModel.deleteItem(at: 0)
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(CustomButtonStyle())

                            Button(action: {
                                viewModel.incrementCount(for: 0)
                            }) {
                                Image(systemName: "circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 13, height: 13)
                                    .foregroundStyle(.green)
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                    }
                }

                PlusBtnView(isShowing: $showAddItem)
                    .sheet(isPresented: $showAddItem) {
                        AddNewItemView(
                            isShowing: $showAddItem,
                            onItemAdded: {
                                viewModel.fetchReviewItems()
                            })
                    }
            }
            .sheet(item: $selectedItem) { item in
                EditViewWrapper(item: item)
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
        .onAppear {
            if !hasAppeared {
                viewModel.setModelContext(modelContext)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.fetchReviewItems()
                    hasAppeared = true
                }
            } else {
                viewModel.fetchReviewItems()
            }
        }
    }
}
