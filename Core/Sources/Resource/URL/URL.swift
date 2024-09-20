import Foundation

public extension URL {
    static func budget(for key: URLLocalizableKey) -> URL {
        URL(string: key.rawValue) ?? URL.homeDirectory
    }
}
