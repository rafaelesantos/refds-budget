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
        case let action as TagAction: self.handler(with: state.tags, for: action, on: completion)
        default: break
        }
    }
    
    private func handler(
        with state: TagsStateProtocol,
        for action: TagAction,
        on completion: @escaping (TagAction) -> Void
    ) {
        switch action {
        case let .fetchData(date): self.fetchData(from: date, on: completion)
        case let .removeTag(id): self.removeTag(with: id, and: state, on: completion)
        case .save: self.save(tag: state.selectedTag, state: state, on: completion)
        default: break
        }
    }
    
    private func fetchData(
        from date: Date?,
        on completion: @escaping (TagAction) -> Void
    ) {
        var transactions: [TransactionEntity] = []
        
        if let date = date {
            transactions = transactionRepository.getTransactions(from: date, format: .monthYear)
        } else {
            transactions = transactionRepository.getTransactions()
        }
        
        let tags: [TagRowViewDataProtocol] = tagRepository.getBubbles().compactMap { tag in
            guard let tagName = tag.name.applyingTransform(.stripDiacritics, reverse: false) else { return nil }
            let value = transactions.filter {
                $0.message
                    .applyingTransform(.stripDiacritics, reverse: false)?
                    .lowercased()
                    .contains(tagName.lowercased()) ?? false
            }.map { $0.amount }.reduce(.zero, +)
            return tagRowViewDataAdapter.adapt(entity: tag, value: value)
        }
        
        completion(.updateData(tags: tags))
    }
    
    private func removeTag(
        with id: UUID,
        and state: TagsStateProtocol,
        on completion: @escaping (TagAction) -> Void
    ) {
        guard let tag = tagRepository.getBubble(by: id) else {
            return completion(.updateError(.notFoundTag))
        }
        
        do {
            try tagRepository.removeBubble(id: tag.id)
        } catch { return completion(.updateError(.cantDeleteTag)) }
        
        fetchData(from: state.date, on: completion)
    }
    
    private func save(
        tag: TagRowViewDataProtocol,
        state: TagsStateProtocol,
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
        
        fetchData(from: state.date, on: completion)
    }
}
