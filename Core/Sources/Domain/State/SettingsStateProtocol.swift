import SwiftUI
import RefdsRedux
import Resource

public protocol SettingsStateProtocol: RefdsReduxState {
    var isLoading: Bool { get set }
    var hasAuthRequest: Bool { get set }
    var hasPrivacyMode: Bool { get set }
    var colorScheme: ColorScheme? { get set }
    var tintColor: Color { get set }
    var icon: Asset { get set }
    var icons: [Asset] { get set }
    var share: URL? { get set }
    var showDocumentPicker: Bool { get set }
    var error: RefdsBudgetError? { get set }
}
