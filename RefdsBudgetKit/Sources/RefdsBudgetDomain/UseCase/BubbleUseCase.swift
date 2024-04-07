import Foundation
import SwiftUI

public protocol BubbleUseCase {
    func getBubbles() -> [BubbleEntity]
    func getBubble(by id: UUID) -> BubbleEntity?
    
    func removeBubble(id: UUID) throws
    
    func addBubble(
        id: UUID,
        name: String,
        color: Color
    ) throws
}
