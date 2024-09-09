import SwiftUI
import RefdsUI
import RefdsBudgetPresentation

public struct SubscriptionModifier: ViewModifier {
    @Environment(\.isPro) private var isPro
    @Environment(\.navigate) private var navigate
    
    public init() {}
    
    @ViewBuilder
    public func body(content: Content) -> some View {
        if !isPro {
            SubscriptionRowView()
            
            RefdsButton {
                navigate?.to(
                    scene: .premium,
                    view: .none,
                    viewStates: []
                )
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
