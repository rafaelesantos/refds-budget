import SwiftUI
import RefdsUI

public struct ColorFormView: View {
    @Binding private var color: Color
    
    public init(color: Binding<Color>) {
        self._color = color
    }
    
    public var body: some View {
        RefdsSection {
            rowColors
            rowColorPicker
        } header: {
            RefdsText(
                .localizable(by: .addCategoryColorHeader),
                style: .footnote,
                color: .secondary
            )
        }
    }
    
    private var rowColors: some View {
        HStack(spacing: .padding(.medium)) {
            BubbleColorView(color: color, isSelected: true)
            Divider().frame(height: 30)
            ScrollView(.horizontal) {
                HStack {
                    let colors = Color.Default.allCases.sorted(by: { $0.id < $1.id })
                    ForEach(colors, id: \.self) { color in
                        RefdsButton {
                            self.color = color.rawValue
                        } label: {
                            BubbleColorView(color: color.rawValue)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
            }
            .scrollIndicators(.never)
            .padding(.horizontal, -20)
        }
    }
    
    private var rowColorPicker: some View {
        ColorPicker(selection: $color) {
            RefdsText(
                .localizable(by: .addCategoryInputHex),
                style: .callout
            )
        }
    }
}

#Preview {
    ColorFormView(color: .constant(.random))
}
