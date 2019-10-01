import UIKit

protocol StackNavigationControllerType: AnyObject {
    typealias Item = UIViewController
    
    func push(_ item: Item, animated: Bool, completion: (() -> Void)?)
    func pop(animated: Bool, completion: (() -> Void)?)
}

extension StackNavigationControllerType {
    func push(_ item: Item, animated: Bool) {
        push(item, animated: animated, completion: .none)
    }
    func pop(animated: Bool) {
        pop(animated: animated, completion: .none)
    }
}

