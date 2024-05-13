import SwiftUI
import RefdsBudgetData
import RefdsBudgetResource

public struct SettingsStateMock: SettingsStateProtocol {
    public var isLoading: Bool = true
    public var colorScheme: ColorScheme? = .allCases.randomElement()
    public var tintColor: Color = .accentColor
    public var hasAuthRequest: Bool = true
    public var hasPrivacyMode: Bool = true
    public var icon: Asset = .default
    public var icons: [Asset] = Asset.allCases
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
