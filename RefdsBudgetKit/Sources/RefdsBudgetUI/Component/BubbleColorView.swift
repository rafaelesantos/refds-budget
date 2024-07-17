import SwiftUI
import RefdsUI

public struct BubbleColorView: View {
    private let color: Color
    private let isSelected: Bool
    private let size: CGFloat
    
    public init(
        color: Color,
        isSelected: Bool = false,
        size: CGFloat = 25
    ) {
        self.color = color
        self.isSelected = isSelected
        self.size = size
    }
    
    public var body: some View {
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
        .padding(.vertical, .padding(.extraSmall))
    }
}

#Preview {
    HStack {
        BubbleColorView(color: .random)
        BubbleColorView(color: .random, isSelected: true)
    }
}
