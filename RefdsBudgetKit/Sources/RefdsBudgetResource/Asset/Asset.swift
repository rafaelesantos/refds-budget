import SwiftUI

public enum Asset: String, CaseIterable, Identifiable {
    case `default` = "AppIcon"
    case light = "LightAppIcon"
    case dark = "DarkAppIcon"
    case system = "SystemAppIcon"
    case lightSystem = "LightSystemAppIcon"
    case darkSystem = "DarkSystemAppIcon"
    case lightCrown = "LightCrownAppIcon"
    case darkCrown = "DarkCrownAppIcon"
    
    public var title: String {
        switch self {
        case .`default`: return .localizable(by: .appIconDefault)
        case .light: return .localizable(by: .appIconLight)
        case .dark: return .localizable(by: .appIconDark)
        case .system: return .localizable(by: .appIconSystem)
        case .lightSystem: return .localizable(by: .appIconLightSystem)
        case .darkSystem: return .localizable(by: .appIconDarkSystem)
        case .lightCrown: return .localizable(by: .appIconLightCrown)
        case .darkCrown: return .localizable(by: .appIconDarkCrown)
        }
    }
    
    public var image: Image {
        Image(rawValue, bundle: .module)
    }
    
    public func changeIcon() {
        #if os(iOS)
        if UIApplication.shared.supportsAlternateIcons {
            UIApplication.shared.setAlternateIconName(self == .default ? nil : self.rawValue) { _ in }
        }
        #endif
    }
    
    public var id: String { rawValue }
}
