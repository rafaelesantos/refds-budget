import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import Domain

public final class ImportMiddleware<State>: RefdsReduxMiddlewareProtocol {
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = (state as? ApplicationStateProtocol)?.importState else { return }
        switch action {
        case let action as ImportAction: self.handler(with: state, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: ImportStateProtocol,
        for action: ImportAction,
        on completion: @escaping (ImportAction) -> Void
    ) {
        switch action {
        case .save: save(with: state, on: completion)
        default: break
        }
    }
    
    private func save(
        with state: ImportStateProtocol,
        on completion: @escaping (ImportAction) -> Void
    ) {
        do {
            try FileFactory.shared.importData(from: state.model, on: state.url)
            completion(.dismiss)
        } catch {
            completion(.updateError(.cantSaveOnDatabase))
        }
    }
}
