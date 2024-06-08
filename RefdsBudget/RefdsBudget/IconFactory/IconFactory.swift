import Foundation
import QuartzCore
import RefdsShared
import RefdsBudgetResource
import RefdsBudgetPresentation

class IconFactory: IconFactoryProtocol {
    private var currentLoopCount = 0
    private var isCancelled = false
    private var animationStartTime: CFTimeInterval = 0
    private var completion: (() -> Void)?
    
    private let appProxy: LSApplicationProxy = LSBundleProxy.bundleProxyForCurrentProcess()
    private let queue = DispatchQueue(
        label: "refds.budget.icon.animation",
        qos: .userInteractive
    )
    
    init() {}
    
    func setIcon(with name: Asset) {
        setIcon(with: name.rawValue)
    }
    
    func startAnimation(
        for icon: Asset,
        frames: Int,
        loops: Int,
        on completion: @escaping () -> Void
    ) {
        animationStartTime = CACurrentMediaTime()
        currentLoopCount = 0
        isCancelled = false
        self.completion = completion
        startAnimationOnQueue(
            for: icon,
            frames: CGFloat(integerLiteral: frames),
            loops: loops
        )
    }
    
    func cancelAnimation() {
        isCancelled = true
        completion?()
    }


    private func startAnimationOnQueue(
        for icon: Asset,
        frames: CGFloat,
        loops: Int
    ) {
        let frameDuration = 1.0 / frames
        var lastFrameTime: CFTimeInterval = 0

        queue.async {
            while (true) {
                if self.isCancelled { break }
                let currentTime = CACurrentMediaTime()
                if currentTime - lastFrameTime < frameDuration {
                    Thread.sleep(forTimeInterval: 0.001)
                    continue
                }

                lastFrameTime = currentTime
                let shouldContinue = self.updateFrame(
                    for: icon,
                    frames: frames,
                    loops: loops
                )
                
                if (!shouldContinue) {
                    self.completion?()
                    break
                }
            }
        }
    }

    private func updateFrame(
        for icon: Asset,
        frames: CGFloat,
        loops: Int
    ) -> Bool {
        let timeSinceStart = CACurrentMediaTime() - animationStartTime
        let currentFrame = Int(timeSinceStart * frames) % Int(frames)
        let name = String(format: "\(icon.rawValue)%d", currentFrame)
        
        setIcon(with: name)
        
        if currentFrame == 0 {
            guard currentLoopCount != loops else { return false }
            currentLoopCount += 1
        }

        return true
    }
    
    private func setIcon(with name: String) {
        appProxy.setAlternateIconName(name) { success, error in
            guard success || error == nil else {
                return RefdsError.custom(message: error?.localizedDescription ?? "").logger()
            }
        }
    }
}
