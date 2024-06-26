import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol TagRowViewDataAdapterProtocol {
    func adapt(entity: BubbleEntity, value: Double?, amount: Int?) -> TagRowViewDataProtocol
}

public final class TagRowViewDataAdapter: TagRowViewDataAdapterProtocol {
    public init() {}
    
    public func adapt(entity: BubbleEntity, value: Double?, amount: Int?) -> TagRowViewDataProtocol {
        TagRowViewData(
            id: entity.id,
            name: entity.name,
            color: Color(hex: entity.color),
            value: value,
            amount: amount
        )
    }
}
