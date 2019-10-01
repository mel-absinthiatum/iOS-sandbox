import UIKit

extension UIViewController: ModalNavigationControllerType {
    func present(item: UIViewController, animated: Bool, completion: (() -> Void)?) {
        present(item, animated: animated, completion: completion)
    }
    
    func dismiss(_ animated: Bool, completion: (() -> Void)?) {
        presentedViewController?.dismiss(animated: animated, completion: completion)
    }
}
