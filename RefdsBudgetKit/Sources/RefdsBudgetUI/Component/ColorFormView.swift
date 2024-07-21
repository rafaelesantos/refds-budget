import SwiftUI
import RefdsUI

public struct ColorFormView: View {
    @Binding private var color: Color
    
    let colors = Color.Default.allCases
    
    public init(color: Binding<Color>) {
        self._color = color
    }
    
    public var body: some View {
        RefdsSection {
            rowColorPicker
        } header: {
            RefdsText(
                .localizable(by: .addCategoryColorHeader),
                style: .footnote,
                color: .secondary
            )
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
