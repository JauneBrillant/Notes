import SwiftUI

struct SideMenuView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) var dismiss

    @Binding var isShowing: Bool
    @State private var showNotificationSettings = false

    var body: some View {
        ZStack(alignment: .leading) {
            if isShowing {
                (colorScheme == .light ? Color.black : Color.gray)
                    .opacity(colorScheme == .light ? 0.4 : 0.3)
                    .ignoresSafeArea(.all)
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            isShowing.toggle()
                        }
                    }

                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Notes")
                            .font(.title)
                            .bold()

                        Divider()
                        menuItems
                        Spacer()
                        footerItems
                    }
                    .padding()
                    .frame(width: 220)
                    .background(colorScheme == .light ? .white : .black)
                    .offset(x: isShowing ? 0 : -280)
                    .animation(.easeInOut, value: isShowing)

                    Spacer()
                }
                .padding(.top, 62)
                .transition(.move(edge: .leading))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.vertical)
        .sheet(isPresented: $showNotificationSettings) {
            NotificationView()
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

#Preview {
    SideMenuView(isShowing: .constant(true))
}
