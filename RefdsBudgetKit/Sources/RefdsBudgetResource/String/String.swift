import Foundation

public extension String {
    static func localizable(by key: LocalizableKey) -> Self {
        NSLocalizedString(key.rawValue, tableName: "Localizable", bundle: .module, comment: "")
    }
    
    static func localizable(by key: LocalizableKey, with params: CVarArg...) -> Self {
        String(
            format: NSLocalizedString(key.rawValue, tableName: "Localizable", bundle: .module, comment: ""),
            arguments: params
        )
    }
}
