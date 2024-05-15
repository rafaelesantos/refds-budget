import Foundation

public enum URLLocalizableKey: String {
    case appleStoreReference
    case developerGithub
    case developerImage
    case jointTestFlight
    case privacyPolicy
    case manageSubscription
    
    public var rawValue: String {
        switch self {
        case .appleStoreReference: return "https://apps.apple.com/br/app/budget/id6448043784"
        case .developerGithub: return "https://github.com/rafaelesantos"
        case .developerImage: return "https://gravatar.com/avatar/79e5c1241339f7834a159e6c0f644eaa0914c5d1c60d04f094322c0f0762c6e6"
        case .jointTestFlight: return "https://testflight.apple.com/join/OTXefl2z"
        case .privacyPolicy: return "https://budget.refds.com.br/privacy-policy"
        case .manageSubscription: return "itms-apps://apps.apple.com/account/subscriptions"
        }
    }
}
