import SwiftUI
import RefdsUI
import RefdsShared
import Presentation
import Resource

public struct BudgetLabel: View {
    private let title: LocalizableKey
    private let icon: RefdsIconSymbol
    private let action: (() -> Void)?
    
    public init(
        title: LocalizableKey,
        icon: RefdsIconSymbol,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        RefdsButton {
            withAnimation { action?() }
        } label: {
            Label(
                String.localizable(by: title),
                systemImage: icon.rawValue
            )
        }
    }
}
