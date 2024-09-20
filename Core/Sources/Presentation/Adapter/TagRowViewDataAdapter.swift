import SwiftUI
import RefdsShared
import Domain

public protocol TagItemViewDataAdapterProtocol {
    func adapt(
        model: TagModelProtocol,
        value: Double?,
        amount: Int?
    ) -> TagItemViewDataProtocol
}

public final class TagItemViewDataAdapter: TagItemViewDataAdapterProtocol {
    public init() {}
    
    public func adapt(
        model: TagModelProtocol,
        value: Double?,
        amount: Int?
    ) -> TagItemViewDataProtocol {
        TagItemViewData(
            id: model.id,
            name: model.name,
            color: Color(hex: model.color),
            icon: model.icon,
            value: value,
            amount: amount
        )
    }
}
