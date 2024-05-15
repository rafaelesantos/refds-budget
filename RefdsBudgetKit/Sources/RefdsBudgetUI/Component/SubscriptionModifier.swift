import SwiftUI
import RefdsUI
import RefdsBudgetPresentation

public struct SubscriptionModifier: ViewModifier {
    @Environment(\.isPro) private var isPro
    @Environment(\.openURL) private var openURL
    
    public init() {}
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        if !isPro {
            SubscriptionRowView()
            
            RefdsButton {
                if let url = Deeplink.url(host: .openPremium) {
                    openURL(url)
                }
            } label: {
                content
                    .refdsRedacted(if: !isPro)
                    .disabled(true)
            }
        } else {
            content
        }
    }
}

public extension View {
    func budgetSubscription() -> some View {
        modifier(SubscriptionModifier())
    }
}
