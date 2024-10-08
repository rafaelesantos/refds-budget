import SwiftUI
import RefdsUI

struct BubbleColorView: View {
    private let color: Color
    private let isSelected: Bool
    private let size: CGFloat
    
    init(
        color: Color,
        isSelected: Bool = false,
        size: CGFloat = 25
    ) {
        self.color = color
        self.isSelected = isSelected
        self.size = size
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(color)
                .frame(width: size, height: size)
            if isSelected {
                Circle()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: size / 3, height: size / 3)
            }
        }
        .animation(.default, value: color)
        .padding(.vertical, .extraSmall)
    }
}

#Preview {
    HStack {
        BubbleColorView(color: .random)
        BubbleColorView(color: .random, isSelected: true)
    }
}
