import SwiftUI

struct PlusBtnView: View {
    @Binding var isShowing: Bool

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isShowing = true
                }) {
                    Image(systemName: "plus.circle")
                        .font(.title)
                }
                .padding(.trailing, 40)
                .padding(.bottom, 40)
            }
        }
    }
}
