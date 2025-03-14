import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var width: CGFloat = 24

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.black)
            .frame(width: width, height: 24)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.black, lineWidth: 4)
            )
            .background(Color.white)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(
                .easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}
