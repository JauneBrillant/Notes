import SwiftData
import SwiftUI

struct LeftView: View {
    @State private var selectedItem: ItemModel?
    @State private var showAddItem: Bool = false
    @State private var showMenu: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                HorizontalScrollView()
                SideMenuView(isShowing: $showMenu)
                PlusBtnView(isShowing: $showAddItem)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(
                        action: {
                            showMenu.toggle()
                        },
                        label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    )
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            EditView(item: item)
        }
        .sheet(isPresented: $showAddItem) {
            AddNewItemView(isShowing: $showAddItem)
        }
    }
}
