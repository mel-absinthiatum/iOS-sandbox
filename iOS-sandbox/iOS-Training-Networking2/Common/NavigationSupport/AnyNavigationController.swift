final class AnyNavigationController: NavigationControllerType {
    private let _box: NavigationControllerType
    
    init(_ controller: NavigationControllerType) {
        self._box = controller
    }
    
    //  Activate methods in appropriate time
    /* func navigate(to items: [Item], animated: Bool,
                  completion: (() -> Void)?) {
        _box.navigate(to: items, animated: animated,
                      completion: completion)
    }*/
    
    func push(_ item: Item, animated: Bool,
              completion: (() -> Void)?) {
        _box.push(item, animated: animated,
                  completion: completion)
    }
    
   func present(_ item: Item, animated: Bool,
                 completion: (() -> Void)?) {
        _box.present(item, animated: animated,
                     completion: completion)
    }
    
    func pop(animated: Bool, completion: (() -> Void)?) {
        _box.pop(animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {
        _box.dismiss(animated: animated, completion: completion)
    }
    
    func put(_ item: SingleNavigationControllerType.Item) {
        _box.put(item)
    }
}

extension NavigationControllerType {
    func asNavigationController() -> AnyNavigationController {
        return .init(self)
    }
}
