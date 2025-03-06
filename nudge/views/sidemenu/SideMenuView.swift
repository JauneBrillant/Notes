import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Environment(\.dismiss) var dismiss
    @State private var showNotificationSettings = false

    var body: some View {
        ZStack(alignment: .leading) {
            if isShowing {
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isShowing.toggle()
                        }
                    }

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Nudge")
                            .font(.title)
                            .bold()

                        Divider()
                        menuItems
                        Spacer()
                        footerItems
                    }
                    .padding()
                    .frame(width: 220)
                    .background(Color.white)
                    .offset(x: isShowing ? 0 : -280)
                    .animation(.easeInOut, value: isShowing)

                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.bottom)
        .sheet(isPresented: $showNotificationSettings) {
            NotificationView(isPresented: $showNotificationSettings)
        }
    }

    var menuItems: some View {
        VStack(alignment: .leading, spacing: 15) {
            notificationLink()
            //menuLink(icon: "gear", title: "Settings")
        }
    }

    var footerItems: some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
            menuLink(icon: "questionmark.circle", title: "Help & Support")
            //menuLink(icon: "arrow.right.square", title: "Sign Out")
        }
        .padding(.bottom)
    }

    func notificationLink() -> some View {
        Button(action: {
            showNotificationSettings = true
            withAnimation(.easeInOut) {
                isShowing = false
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: "bell.fill")
                    .frame(width: 24, height: 24)

                Text("Notifications")
                    .font(.headline)

                Spacer()
            }
            .foregroundColor(.primary)
            .padding(.vertical, 4)
        }
    }

    func menuLink(icon: String, title: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut) {
                isShowing = false
            }
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .frame(width: 24, height: 24)

                Text(title)
                    .font(.headline)

                Spacer()
            }
            .foregroundColor(.primary)
            .padding(.vertical, 4)
        }
    }
}
