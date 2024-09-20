import Foundation
import SwiftUI

public protocol CategoryUseCase {
    func getAllCategories() -> [CategoryModelProtocol]
    func getCategories(from date: Date) -> [CategoryModelProtocol]
    
    func getCategory(by id: UUID) -> CategoryModelProtocol?
    
    func removeCategory(id: UUID) throws
    
    func addCategory(
        id: UUID,
        name: String,
        color: Color,
        budgets: [UUID],
        icon: String
    ) throws
}
