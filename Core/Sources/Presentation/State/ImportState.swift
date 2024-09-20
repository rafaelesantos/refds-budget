import Foundation
import Domain

struct ImportState: ImportStateProtocol {
    var url: URL
    var model: FileModelProtocol
    var isLoading: Bool
    var error: RefdsBudgetError?
    
    init(
        url: URL,
        model: FileModelProtocol,
        isLoading: Bool = false
    ) {
        self.url = url
        self.model = model
        self.isLoading = isLoading
    }
}
