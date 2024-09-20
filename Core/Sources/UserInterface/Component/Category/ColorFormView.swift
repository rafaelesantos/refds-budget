import SwiftUI
import RefdsUI

struct ColorFormView: View {
    @Binding private var color: Color
    private let colors = Color.Default.allCases
    
    init(color: Binding<Color>) {
        self._color = color
    }
    
    var body: some View {
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
            HStack(spacing: .medium) {
                RefdsIconRow(
                    .paintpaletteFill,
                    color: color
                )
                RefdsText(
                    .localizable(by: .addCategoryInputHex),
                    style: .callout
                )
            }
        }
    }
}

#Preview {
    struct ContentView: View {
        @State private var selectedColor: Color = .random
        var body: some View {
            List {
                ColorFormView(color: $selectedColor)
            }
        }
    }
    return ContentView()
}
