import SwiftUI
import RefdsUI

public struct BubbleColorView: View {
    private let color: Color
    private let isSelected: Bool
    private let size: CGFloat
    
    public init(
        color: Color,
        isSelected: Bool = false,
        size: CGFloat = 30
    ) {
        self.color = color
        self.isSelected = isSelected
        self.size = size
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.23)
                .fill(color)
                .frame(width: size, height: size)
            if isSelected {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.7))
                    .frame(width: size / 3, height: size / 3)
            }
        }
        .animation(.default, value: color)
        .padding(.vertical, .padding(.extraSmall))
    }
}

#Preview {
    BubbleColorView(color: .random)
}
