import Foundation
import RefdsBudgetResource

public protocol IconFactoryProtocol {
    func startAnimation(
        for icon: Asset,
        frames: Int,
        loops: Int,
        on completion: @escaping () -> Void
    )
    func cancelAnimation()
    func setIcon(with name: Asset)
}
