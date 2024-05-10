import SwiftUI
import RefdsBudgetData
import RefdsBudgetResource

public struct SettingsStateMock: SettingsStateProtocol {
    public var isLoading: Bool = true
    public var colorScheme: ColorScheme? = .allCases.randomElement()
    public var tintColor: Color = .accentColor
    public var icon: ApplicationIcon = .default
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
