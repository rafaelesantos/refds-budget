import SwiftUI
import Domain
import Resource

public struct SettingsStateMock: SettingsStateProtocol {
    public var isLoading: Bool = true
    public var colorScheme: ColorScheme? = .none
    public var tintColor: Color = .green
    public var hasAuthRequest: Bool = true
    public var hasPrivacyMode: Bool = true
    public var icon: Asset = .appIcon
    public var icons: [Asset] = Asset.allCases
    public var share: URL?
    public var showDocumentPicker: Bool = false
    public var error: RefdsBudgetError? = nil
    
    public init() {}
}
