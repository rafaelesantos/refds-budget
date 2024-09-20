import WidgetKit
import AppIntents
import SwiftUI
import Presentation
import Domain
import Resource

struct WidgetAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "WidgetAppIntent"
    static var description = IntentDescription("WidgetAppIntent")

    @Parameter(title: "Filter by date", default: true)
    var isFilterByDate: Bool?
    
    @Parameter(title: "Category", optionsProvider: CategoriesOptionsProvider())
    var category: String?
    
    @Parameter(title: "Tag", optionsProvider: TagsOptionsProvider())
    var tag: String?
    
    @Parameter(title: "Status", optionsProvider: StatusOptionsProvider())
    var status: String?
    
    private struct CategoriesOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetIntentPresenterProtocol = RefdsBudgetIntentPresenter.shared
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategoriesAllSelected)
        }
        
        func results() async throws -> [String] {
            presenter.getCategories()
        }
    }
    
    private struct TagsOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetIntentPresenterProtocol = RefdsBudgetIntentPresenter.shared
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategoriesAllSelected)
        }
        
        func results() async throws -> [String] {
            presenter.getTags()
        }
    }
    
    private struct StatusOptionsProvider: DynamicOptionsProvider {
        private let presenter: RefdsBudgetIntentPresenterProtocol = RefdsBudgetIntentPresenter.shared
        
        func defaultResult() async -> String? {
            .localizable(by: .transactionsCategoriesAllSelected)
        }
        
        func results() async throws -> [String] {
            let status: [TransactionStatus] = [.pending, .cleared]
            return status.map { $0.description } + [.localizable(by: .transactionsCategoriesAllSelected)]
        }
    }
}
