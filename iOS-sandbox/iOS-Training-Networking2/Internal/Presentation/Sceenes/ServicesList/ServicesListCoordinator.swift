import UIKit

class ServicesListCoordinator: CoordinatorType {
    private let context: Context
    private weak var navigation: StackNavigationControllerType?
    typealias Router = AnyRouter<ServicesListViewModelInfo.Event>
    private let parentRouter: Router?       // Use for delegate dismision.

    init(parentRouter: Router?, context: Context) {
        self.parentRouter = parentRouter
        self.context = context
    }
    
    func makeInitial() -> UIViewController {
        let controller: ServicesListViewController = ViewControllersFactory.createVC(vcInfo: ServicesListVCInfo().asAnyVCInfo())
        let router = self
        let viewModel = ServicesListViewModel(router:router, context: context)
        controller.viewModel = viewModel
        let navigationController = UINavigationController(rootViewController: controller)
        navigation = navigationController as StackNavigationController
        return navigationController
    }
}

extension ServicesListCoordinator: RouterType {
    func play(event: ServicesListViewModelInfo.Event) {
        guard let navigation = self.navigation else {
            return
        }
        let coordinator: CoordinatorType
        switch event {
            case .add:
                coordinator = PasswordGenerationCoordinator(
                    navigation: navigation, context: context)
            case let .itemDetails(service):
                coordinator = PasswordEditionCoordinator(
                    service: service, navigation: navigation, context: context)
        }
        let controller = coordinator.makeInitial()
        navigation.push(controller, animated: true)
    }
}

