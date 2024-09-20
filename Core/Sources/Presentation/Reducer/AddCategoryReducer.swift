import Foundation
import RefdsRedux
import Domain

public final class AddCategoryReducer: RefdsReduxReducerProtocol {
    public typealias State = AddCategoryStateProtocol
    
    public init() {}
    
    public var reduce: RefdsReduxReducer<State> = { state, action in
        var state = state
        
        switch action as? AddCategoryAction {
        case let .updateData(id, name, color, icon):
            state.id = id
            state.name = name
            state.color = color
            state.icon = icon
        case let .updateError(error):
            state.error = error
        case .fetchData, .save, nil:
            break
        }
        
        return state
    }
}
