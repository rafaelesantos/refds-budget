import Foundation

public enum FilterItem: Equatable {
    case date
    case categories([FilterItemViewDataProtocol])
    case tags([FilterItemViewDataProtocol])
    case status([FilterItemViewDataProtocol])
    
    public static func == (lhs: FilterItem, rhs: FilterItem) -> Bool {
        switch (lhs, rhs) {
        case (.date, .date): 
            return true
        case let (.categories(lhs), .categories(rhs)):
            return isEqualRowViewData(lhs: lhs, rhs: rhs)
        case let (.status(lhs), .status(rhs)):
            return isEqualRowViewData(lhs: lhs, rhs: rhs)
        case let (.tags(lhs), .tags(rhs)):
            return isEqualRowViewData(lhs: lhs, rhs: rhs)
        default:
            return false
        }
    }
    
    private static func isEqualRowViewData(
        lhs: [FilterItemViewDataProtocol],
        rhs: [FilterItemViewDataProtocol]
    ) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for i in lhs.indices {
            if lhs[safe: i]?.id != rhs[safe: i]?.id {
                return false
            }
        }
        return true
    }
}
