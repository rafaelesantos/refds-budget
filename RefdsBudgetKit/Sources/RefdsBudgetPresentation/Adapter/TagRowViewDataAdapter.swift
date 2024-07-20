import SwiftUI
import RefdsShared
import RefdsBudgetDomain

public protocol TagRowViewDataAdapterProtocol {
    func adapt(
        model: TagModelProtocol,
        value: Double?,
        amount: Int?
    ) -> TagRowViewDataProtocol
}

public final class TagRowViewDataAdapter: TagRowViewDataAdapterProtocol {
    public init() {}
    
    public func adapt(
        model: TagModelProtocol,
        value: Double?,
        amount: Int?
    ) -> TagRowViewDataProtocol {
        TagRowViewData(
            id: model.id,
            name: model.name,
            color: Color(hex: model.color),
            icon: model.icon,
            value: value,
            amount: amount
        )
    }
}
