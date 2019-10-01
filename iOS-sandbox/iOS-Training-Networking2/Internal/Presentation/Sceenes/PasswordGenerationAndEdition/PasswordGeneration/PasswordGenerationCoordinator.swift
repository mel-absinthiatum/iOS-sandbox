import UIKit

class PasswordGenerationCoordinator: CoordinatorType {
    private let context: Context
    private weak var navigation: StackNavigationController?

    init(navigation: StackNavigationController, context: Context) {
        self.navigation = navigation
        self.context = context
    }
    
    func makeInitial() -> UIViewController {
        let controller: PasswordGenerationViewController = ViewControllersFactory.createVC(vcInfo: PasswordGenerationVCInfo().asAnyVCInfo())
        let router = self.asRouter()
        let viewModel = PasswordGenerationViewModel(router: router, context: context)
        controller.viewModel = viewModel
        
        return controller
    }
}

extension PasswordGenerationCoordinator: RouterType {
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

