import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import RefdsBudgetDomain

public final class TagMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: BubbleUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var tagRowViewDataAdapter: TagRowViewDataAdapterProtocol
    
    public init() {}
    
    public lazy var middleware: RefdsReduxMiddleware<State> = { state, action, completion in
        guard let state = state as? ApplicationStateProtocol else { return }
        switch action {
        case let action as TagAction: self.handler(with: state.tagsState, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: TagsStateProtocol,
        for action: TagAction,
        on completion: @escaping (TagAction) -> Void
    ) {
        switch action {
        case .fetchData: self.fetchData(on: completion)
        case let .removeTag(id): self.removeTag(with: id, on: completion)
        case .save: self.save(tag: state.selectedTag, on: completion)
        default: break
        }
    }
    
    private func fetchData(on completion: @escaping (TagAction) -> Void) {
        let tags: [TagRowViewDataProtocol] = tagRepository.getBubbles().compactMap { tag in
            return tagRowViewDataAdapter.adapt(
                entity: tag,
                value: nil,
                amount: nil
            )
        }
        
        completion(.updateData(tags: tags))
    }
    
    private func removeTag(
        with id: UUID,
        on completion: @escaping (TagAction) -> Void
    ) {
        guard let tag = tagRepository.getBubble(by: id) else {
            return completion(.updateError(.notFoundTag))
        }
        
        do {
            try tagRepository.removeBubble(id: tag.id)
        } catch { return completion(.updateError(.cantDeleteTag)) }
        
        fetchData(on: completion)
    }
    
    private func save(
        tag: TagRowViewDataProtocol,
        on completion: @escaping (TagAction) -> Void
    ) {
        if tagRepository.getBubble(by: tag.id) == nil,
           tagRepository.getBubbles().contains(where: { $0.name.lowercased() == tag.name.lowercased() }) {
            return completion(.updateError(.existingTag))
        }
        
        do {
            try tagRepository.addBubble(
                id: tag.id,
                name: tag.name,
                color: tag.color
            )
        } catch { return completion(.updateError(.cantSaveOnDatabase)) }
        
        fetchData(on: completion)
    }
}
