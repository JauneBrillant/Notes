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
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 35, height: 35)
                        .foregroundColor(.black)
                }
                .padding(.trailing, 40)
                .padding(.bottom, 40)
            }
        }
    }
}
