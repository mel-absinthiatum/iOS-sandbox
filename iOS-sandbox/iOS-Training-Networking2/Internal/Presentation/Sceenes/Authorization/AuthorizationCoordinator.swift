import UIKit

class AuthorizationCoordinator: CoordinatorType {
    private let context: Context
    private weak var navigation: ModalNavigationControllerType?

    init(context: Context) {
        self.context = context
    }
    
    func makeInitial() -> UIViewController {
        let controller: AuthorizationViewController = ViewControllersFactory.createVC(vcInfo:AuthorizationVCInfo().asAnyVCInfo())
        let router = self
        let viewModel = AuthorizationViewModel(router: router, context: context)
        controller.viewModel = viewModel
        self.navigation = controller as ModalNavigationControllerType
        
        return controller
    }
}

extension AuthorizationCoordinator: RouterType {
    func play(event: AuthorizationViewModelInfo.Event) {
        let coordinator: CoordinatorType
        switch event {
        case .submit:
            let router = AnyRouter(play: self.playServicesList(event:))
            coordinator = ServicesListCoordinator(parentRouter: router, context: context)  
        }
        let controller = coordinator.makeInitial()
        navigation?.present(controller, animated: true)
    }
}

extension AuthorizationCoordinator {
    func playServicesList(event: ServicesListViewModelInfo.Event) {
        // Activate this if it will be neccessary
        /*
        switch event {
        case .close:
            navigation?.dismiss(true)
        }
        */
    }
}

