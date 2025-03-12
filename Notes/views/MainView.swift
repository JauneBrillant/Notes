import SwiftUI

struct MainView: View {
    @State private var showSideMenu = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
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
