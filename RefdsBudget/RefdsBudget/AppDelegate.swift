import SwiftUI
import RefdsInjection
import BackgroundTasks
import RefdsBudgetPresentation

class AppDelegate: NSObject, UIApplicationDelegate {
    private let taskID = "refds.budget.update.icons"
    private var backgroundTask: UIBackgroundTaskIdentifier? = nil
    private let iconFactory = IconFactory()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        RefdsContainer.register(type: IconFactoryProtocol.self) { iconFactory }
        return true
    }
    
    private func handlerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: taskID, using: nil) { task in
            guard let task = task as? BGProcessingTask else { return }
            self.setIconAnimator(task: task)
        }
    }
    
    private func registerBackgroundTask() {
        BGTaskScheduler.shared.getPendingTaskRequests { request in
            guard request.isEmpty else { return }
            let request = BGProcessingTaskRequest(identifier: self.taskID)
            request.requiresNetworkConnectivity = false
            request.requiresExternalPower = false
            request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            do {
                try BGTaskScheduler.shared.submit(request)
            } catch {
                print("Unable to schedule background task: \(error.localizedDescription)")
            }
        }
    }
    
    func setIconAnimator(task: BGProcessingTask?) {
        backgroundTask = UIApplication.shared.beginBackgroundTask()
        DispatchQueue.main.async {
            self.iconFactory.startAnimation(
                for: .animated,
                frames: 50,
                loops: 1
            ) { [weak self] in
                if let backgroundTask = self?.backgroundTask {
                    UIApplication.shared.endBackgroundTask(backgroundTask)
                }
                self?.backgroundTask = nil
            }
        }
    }
}
