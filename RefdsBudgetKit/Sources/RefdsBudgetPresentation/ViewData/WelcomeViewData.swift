import SwiftUI
import RefdsWelcome
import RefdsBudgetResource

public final class WelcomeViewData: ObservableObject {
    public let features: [RefdsWelcomeFeatureViewDataProtocol] = [
        RefdsWelcomeFeatureViewData(
            icon: .squareStack3dForwardDottedlineFill,
            title: .localizable(by: .welcomeCategoryTitle),
            description: .localizable(by: .welcomeCategoryDescription)
        ),
        RefdsWelcomeFeatureViewData(
            icon: .houseFill,
            title: .localizable(by: .welcomeBudgetTitle),
            description: .localizable(by: .welcomeBudgetDescription)
        ),
        RefdsWelcomeFeatureViewData(
            icon: .listBulletRectangleFill,
            title: .localizable(by: .welcomeTransactionTitle),
            description: .localizable(by: .welcomeTransactionDescription)
        )
    ]
    
    @Published public var header: RefdsWelcomeHeaderViewData
    @Published public var footer: RefdsWelcomeFooterViewData
    @Published public var viewData: RefdsWelcomeViewData
    @Published public var isLoading: Bool = true
    
    public init() {
        let header = RefdsWelcomeHeaderViewData(
            applicationIcon: Asset.default.image,
            introduceTitle: .refdsLocalizable(by: .welcomeIntroduction),
            applicationTitle: .localizable(by: .settingsApplicationName),
            description: .localizable(by: .settingsApplicationDescription)
        )
        let footer = RefdsWelcomeFooterViewData(
            detail: .localizable(by: .welcomeFooterDescription),
            buttonTitle: .localizable(by: .welcomeFooterButton),
            action: nil
        )
        
        self.header = header
        self.footer = footer
        self.viewData = RefdsWelcomeViewData(
            header: header,
            features: features,
            footer: footer
        )
    }
}
