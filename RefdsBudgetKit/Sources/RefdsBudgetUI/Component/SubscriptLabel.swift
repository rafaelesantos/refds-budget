import SwiftUI
import RefdsUI
import RefdsShared
import RefdsBudgetPresentation
import RefdsBudgetResource

public struct BudgetLabel: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.isPro) private var isPro
    
    private let title: LocalizableKey
    private let icon: RefdsIconSymbol
    private let isProFeature: Bool
    private let action: (() -> Void)?
    
    public init(
        title: LocalizableKey,
        icon: RefdsIconSymbol,
        isProFeature: Bool,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.isProFeature = isProFeature
        self.action = action
    }
    
    private var showIcon: Bool {
        if isProFeature { return isPro }
        return true
    }
    
    private var showPro: Bool {
        if isProFeature && !isPro { return true }
        return false
    }
    
    public var body: some View {
        RefdsButton {
            if showPro, let url = Deeplink.url(host: .openPremium) {
                openURL(url)
            } else {
                withAnimation { action?() }
            }
        } label: {
            Label(
                String.localizable(by: title),
                systemImage: showIcon ? icon.rawValue : RefdsIconSymbol.lockFill.rawValue
            )
        }
    }
}
