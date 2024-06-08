import SwiftUI

public enum Asset: String, CaseIterable, Identifiable {
    case appIcon = "MainCornerIcon"
    case proCornerIcon = "ProCornerIcon"
    case systemCornerIcon = "SystemCornerIcon"
    
    case developerMainIcon = "DeveloperMainIcon"
    case developerProIcon = "DeveloperProIcon"
    case developerSystemIcon = "DeveloperSystemIcon"
    
    case mainIcon = "AppIcon"
    case proIcon = "ProIcon"
    case systemIcon = "SystemIcon"
    
    case lightMainCornerIcon = "LightMainCornerIcon"
    case lightProCornerIcon = "LightProCornerIcon"
    case lightSystemCornerIcon = "LightSystemCornerIcon"
    
    case developerLightMainIcon = "DeveloperLightMainIcon"
    case developerLightProIcon = "DeveloperLightProIcon"
    case developerLightSystemIcon = "DeveloperLightSystemIcon"
    
    case lightMainIcon = "LightMainIcon"
    case lightProIcon = "LightProIcon"
    case lightSystemIcon = "LightSystemIcon"
    
    case darkMainCornerIcon = "DarkMainCornerIcon"
    case darkProCornerIcon = "DarkProCornerIcon"
    case darkSystemCornerIcon = "DarkSystemCornerIcon"
    
    case developerDarkMainIcon = "DeveloperDarkMainIcon"
    case developerDarkProIcon = "DeveloperDarkProIcon"
    case developerDarkSystemIcon = "DeveloperDarkSystemIcon"
    
    case darkMainIcon = "DarkMainIcon"
    case darkProIcon = "DarkProIcon"
    case darkSystemIcon = "DarkSystemIcon"
    
    case animated = "AnimatedIcon"
    
    public var title: String {
        switch self {
        case .mainIcon: return .localizable(by: .appIconAppIcon)
        case .darkMainCornerIcon: return .localizable(by: .appIconDarkMainCornerIcon)
        case .darkMainIcon: return .localizable(by: .appIconDarkMainIcon)
        case .darkProCornerIcon: return .localizable(by: .appIconDarkProCornerIcon)
        case .darkProIcon: return .localizable(by: .appIconDarkProIcon)
        case .darkSystemCornerIcon: return .localizable(by: .appIconDarkSystemCornerIcon)
        case .darkSystemIcon: return .localizable(by: .appIconDarkSystemIcon)
        case .developerDarkMainIcon: return .localizable(by: .appIconDeveloperDarkMainIcon)
        case .developerDarkProIcon: return .localizable(by: .appIconDeveloperDarkProIcon)
        case .developerDarkSystemIcon: return .localizable(by: .appIconDeveloperDarkSystemIcon)
        case .developerLightMainIcon: return .localizable(by: .appIconDeveloperLightMainIcon)
        case .developerLightProIcon: return .localizable(by: .appIconDeveloperLightProIcon)
        case .developerLightSystemIcon: return .localizable(by: .appIconDeveloperLightSystemIcon)
        case .developerMainIcon, .animated: return .localizable(by: .appIconDeveloperMainIcon)
        case .developerProIcon: return .localizable(by: .appIconDeveloperProIcon)
        case .developerSystemIcon: return .localizable(by: .appIconDeveloperSystemIcon)
        case .lightMainCornerIcon: return .localizable(by: .appIconLightMainCornerIcon)
        case .lightMainIcon: return .localizable(by: .appIconLightMainIcon)
        case .lightProCornerIcon: return .localizable(by: .appIconLightProCornerIcon)
        case .lightProIcon: return .localizable(by: .appIconLightProIcon)
        case .lightSystemCornerIcon: return .localizable(by: .appIconLightSystemCornerIcon)
        case .lightSystemIcon: return .localizable(by: .appIconLightSystemIcon)
        case .appIcon: return .localizable(by: .appIconMainCornerIcon)
        case .proCornerIcon: return .localizable(by: .appIconProCornerIcon)
        case .proIcon: return .localizable(by: .appIconProIcon)
        case .systemCornerIcon: return .localizable(by: .appIconSystemCornerIcon)
        case .systemIcon: return .localizable(by: .appIconSystemIcon)
        }
    }
    
    public var image: Image {
        Image(rawValue, bundle: .module)
    }
    
    public var id: String { rawValue }
}
