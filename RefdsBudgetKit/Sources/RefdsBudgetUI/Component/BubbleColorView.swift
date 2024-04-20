import SwiftUI
import RefdsUI

public struct BubbleColorView: View {
    private let color: Color
    private let isSelected: Bool
    
    public init(color: Color, isSelected: Bool = false) {
        self.color = color
        self.isSelected = isSelected
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 30, height: 30)
            if isSelected {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 10, height: 10)
            }
        }
        .animation(.default, value: color)
        .padding(.vertical, .padding(.extraSmall))
    }
}

#Preview {
    BubbleColorView(color: .random)
}
