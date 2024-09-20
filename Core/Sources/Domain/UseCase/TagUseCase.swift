import Foundation
import SwiftUI

public protocol TagUseCase {
    func getTags() -> [TagModelProtocol]
    func getTag(by id: UUID) -> TagModelProtocol?
    
    func removeTag(id: UUID) throws
    
    func addTag(
        id: UUID,
        name: String,
        color: Color,
        icon: String
    ) throws
}
