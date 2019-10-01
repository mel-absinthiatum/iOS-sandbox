import UIKit

class PasswordEditionCoordinator: CoordinatorType {
    private let context: Context
    private weak var navigation: StackNavigationController?
    private let service: Service
    
    init(service: Service, navigation: StackNavigationController, context: Context) {
        self.context = context
        self.service = service
        self.navigation = navigation
    }

    func makeInitial() -> UIViewController {
        let controller: PasswordGenerationViewController = ViewControllersFactory.createVC(vcInfo: PasswordGenerationVCInfo().asAnyVCInfo())
        let router = self
        let viewModel = PasswordEditionViewModel(
            router: router, context: context, service: self.service)
        controller.viewModel = viewModel

        return controller
    }
}

extension PasswordEditionCoordinator: RouterType {
    func play(event: PasswordGenerationViewModelInfo.Event) {
        guard let navigation = self.navigation else {
            return
        }
        switch event {
        case .submit:
            navigation.pop(animated: true)
        case .cancel:
            navigation.pop(animated: true)
        }
    }
}
