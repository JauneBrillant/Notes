import SwiftUI

struct MainView: View {
    @State private var isBouncing: Bool = false

    var body: some View {
        TabView {
            Group {
                LeftView()
                    .tabItem {
                        Image(systemName: "minus")
                    }

                RightView()
                    .tabItem {
                        Image(systemName: "equal")
                    }
            }
            .toolbarBackground(.white, for: .tabBar)
        }
        .accentColor(.black)
    }
}
