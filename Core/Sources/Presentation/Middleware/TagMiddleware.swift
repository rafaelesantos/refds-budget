import SwiftUI
import RefdsRedux
import RefdsShared
import RefdsInjection
import Domain

public final class TagMiddleware<State>: RefdsReduxMiddlewareProtocol {
    @RefdsInjection private var tagRepository: TagUseCase
    @RefdsInjection private var transactionRepository: TransactionUseCase
    @RefdsInjection private var tagRowViewDataAdapter: TagItemViewDataAdapterProtocol
    
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
        let tags: [TagItemViewDataProtocol] = tagRepository.getTags().compactMap { tag in
            return tagRowViewDataAdapter.adapt(
                model: tag,
                value: nil,
                amount: nil
            )
        }.sorted(by: { $0.name < $1.name })
        
        completion(.updateData(tags: tags))
    }
    
    private func removeTag(
        with id: UUID,
        on completion: @escaping (TagAction) -> Void
    ) {
        guard let tag = tagRepository.getTag(by: id) else {
            return completion(.updateError(.notFoundTag))
        }
        
        do {
            try tagRepository.removeTag(id: tag.id)
        } catch { return completion(.updateError(.cantDeleteTag)) }
        
        fetchData(on: completion)
    }
    
    private func save(
        tag: TagItemViewDataProtocol,
        on completion: @escaping (TagAction) -> Void
    ) {
        if tagRepository.getTag(by: tag.id) == nil,
           tagRepository.getTags().contains(where: { $0.name.lowercased() == tag.name.lowercased() }) {
            return completion(.updateError(.existingTag))
        }
        
        do {
            try tagRepository.addTag(
                id: tag.id,
                name: tag.name,
                color: tag.color,
                icon: tag.icon.rawValue
            )
        } catch { return completion(.updateError(.cantSaveOnDatabase)) }
        
        fetchData(on: completion)
    }
}
