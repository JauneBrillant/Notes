import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            Group {
                HomeView()
                    .tabItem {
                        Image(systemName: "circle")
                    }

                ContentView()
                    .tabItem {
                        Image(systemName: "scribble.variable")
                    }
            }
            .toolbarBackground(.white, for: .tabBar)
        }
        .accentColor(.black)
    }
}
