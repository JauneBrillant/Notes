import SwiftData
import SwiftUI

struct ListView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = ListViewModel()
    @Binding var showSideMenu: Bool
    @State private var selectedItem: ItemModel?

    init(showSideMenu: Binding<Bool>) {
        _showSideMenu = showSideMenu
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.items) { item in
                    ItemRow(
                        item: item,
                        onTap: {
                            selectedItem = item
                        }
                    )
                    .listRowSeparator(.hidden)
                }
                .onMove(perform: viewModel.moveItems)
                .onDelete(perform: viewModel.deleteItems)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

            .navigationTitle("ITEMS")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(colorScheme == .light ? .white : .black)
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
            viewModel.setModelContext(modelContext)
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
