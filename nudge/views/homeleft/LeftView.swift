import SwiftData
import SwiftUI

struct LeftView: View {
    @State private var selectedItem: ItemModel?
    @State private var showAddItem: Bool = false

    var body: some View {
        ZStack {
            HorizontalScrollView(selectedItem: $selectedItem)
            PlusBtnView(isShowing: $showAddItem)
        }
        .sheet(item: $selectedItem) { item in
            EditView(item: item)
        }
        .sheet(isPresented: $showAddItem) {
            AddNewItemView(isShowing: $showAddItem)
        }
    }
}
