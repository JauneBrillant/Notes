import SwiftUI

struct MainView: View {
    @State private var showSideMenu = false

    var body: some View {
        ZStack {
            TabView {
                FilterOutView(showSideMenu: $showSideMenu)
                        .tabItem {
                            Image(systemName: "minus")
                        }

                ListView(showSideMenu: $showSideMenu)
                        .tabItem {
                            Image(systemName: "equal")
                        }
            }
            .accentColor(.primary)

            SideMenuView(isShowing: $showSideMenu)
        }
    }
}

#Preview {
    MainView()
}
