import SwiftUI

struct MainView: View {
    @State private var showSideMenu = false
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .leading) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    LeftView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(
                                    action: {
                                        showSideMenu.toggle()
                                    },
                                    label: {
                                        Image(systemName: "line.3.horizontal")
                                    }
                                )
                            }
                        }
                }
                .tabItem {
                    Image(systemName: "minus")
                }

                NavigationStack {
                    RightView()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button(
                                    action: {
                                        showSideMenu.toggle()
                                    },
                                    label: {
                                        Image(systemName: "line.3.horizontal")
                                    }
                                )
                            }
                        }
                        .navigationTitle("ITEMS")
                        .navigationBarTitleDisplayMode(.large)
                        .toolbarBackground(.white)
                        .toolbarBackground(.white, for: .tabBar)
                }
                .tabItem {
                    Image(systemName: "equal")
                }
            }
            .tint(.black)

            SideMenuView(isShowing: $showSideMenu)
        }
    }
}
