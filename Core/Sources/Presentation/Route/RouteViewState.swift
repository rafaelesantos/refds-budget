import Foundation

public enum RouteViewState {
    case id(UUID)
    case date(Date)
    case isDateFilter(Bool)
    case selectedItems(Set<String>)
    case hasAI(Bool)
    case baseBudgetDate(String)
    case compareBudgetDate(String)
    
    init?(queryItem: URLQueryItem) {
        guard let value = queryItem.value else { return nil }
        switch queryItem.name {
        case RouteViewStateKey.id.rawValue:
            guard let id = UUID(uuidString: value) else { return nil }
            self = .id(id)
        case RouteViewStateKey.date.rawValue:
            guard let date = value.asDate(withFormat: .monthYear) else { return nil }
            self = .date(date)
        case RouteViewStateKey.isDateFilter.rawValue:
            guard let isDateFilter = value.lowercased() == "false" ? false : true else { return nil }
            self = .isDateFilter(isDateFilter)
        case RouteViewStateKey.selectedItems.rawValue:
            let selectedItems = value.components(separatedBy: ",")
            guard !selectedItems.isEmpty else { return nil }
            self = .selectedItems(Set(selectedItems))
        case RouteViewStateKey.hasAI.rawValue:
            guard let hasAI = value.lowercased() == "false" ? false : true else { return nil }
            self = .hasAI(hasAI)
        case RouteViewStateKey.baseBudgetDate.rawValue:
            self = .baseBudgetDate(value)
        case RouteViewStateKey.compareBudgetDate.rawValue:
            self = .compareBudgetDate(value)
        default:
            return nil
        }
    }
    
    public var key: String {
        switch self {
        case .id: return RouteViewStateKey.id.rawValue
        case .date: return RouteViewStateKey.date.rawValue
        case .isDateFilter: return RouteViewStateKey.isDateFilter.rawValue
        case .selectedItems: return RouteViewStateKey.selectedItems.rawValue
        case .hasAI: return RouteViewStateKey.hasAI.rawValue
        case .baseBudgetDate: return RouteViewStateKey.baseBudgetDate.rawValue
        case .compareBudgetDate: return RouteViewStateKey.compareBudgetDate.rawValue
        }
    }
    
    public var value: String {
        switch self {
        case .id(let id): return id.uuidString
        case .date(let date): return date.asString(withDateFormat: .monthYear)
        case .isDateFilter(let isDateFilter): return isDateFilter.asString
        case .selectedItems(let items): return items.joined(separator: ",")
        case .hasAI(let hasAI): return hasAI.asString
        case .baseBudgetDate(let date): return date
        case .compareBudgetDate(let date): return date
        }
    }
}

extension Collection where Element == RouteViewState {
    public var rawValue: String {
        "?\(self.map { "\($0.key)=\($0.value)" }.joined(separator: "&"))"
    }
}
