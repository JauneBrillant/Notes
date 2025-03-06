import SwiftData
import SwiftUI

struct HorizontalScrollView: View {
    @Query private var items: [ItemModel]
    @Binding var selectedItem: ItemModel?

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(items) { item in
                    VStack {
                        Text(item.sentence)
                            .font(.title2)
                            .bold()
                            .padding(.bottom)
                            .foregroundStyle(.black.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onTapGesture {
                                selectedItem = item
                            }
                    }
                    .containerRelativeFrame(.horizontal, count: 1, spacing: 16.0)
                    .scrollTransition { content, phase in
                        content
                            .opacity(phase.isIdentity ? 1.0 : 0.0)
                            .scaleEffect(
                                x: phase.isIdentity ? 1.0 : 0.3,
                                y: phase.isIdentity ? 1.0 : 0.3
                            )
                            .offset(y: phase.isIdentity ? 0 : 50)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(16, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
}
