import UIKit

protocol ModalNavigationControllerType: AnyObject {
    typealias Item = UIViewController
    
    func present(_ item: Item, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension ModalNavigationControllerType {
    func present(_ item: Item, animated: Bool) {
        present(item, animated: animated, completion: .none)
    }
    
    func dismiss(_ animated: Bool) {
        dismiss(animated: animated, completion: .none)
    }
}
