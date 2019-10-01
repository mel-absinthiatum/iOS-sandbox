import UIKit

enum LauncherCoordinationEvent {
    case authorization
    case servicesList
}

class Launcher {
    private let context: Context
    private let window: UIWindow
    
    init(context: Context) {
        self.context = context
        self.window = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func compoundedWindow() -> UIWindow {
        if !context.authorizationService.userIsAuthorized {
            play(event: .authorization)
        }
        else {
            play(event: .servicesList)
        }
        return window
    }
}

extension Launcher: SingleNavigationController {
    func put(_ item: UIViewController) {
        window.rootViewController = item
    }
}

extension Launcher: RouterType {
    func play(event: LauncherCoordinationEvent) {
        let coordinator: CoordinatorType
        switch event {
        case .authorization:
            coordinator = AuthorizationCoordinator(context: context)
        case .servicesList:
            coordinator = ServicesListCoordinator(parentRouter: nil, context: context)
        }
        let controller = coordinator.makeInitial()
        put(controller)
    }
}
