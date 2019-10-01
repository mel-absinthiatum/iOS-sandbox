import UIKit


extension UINavigationController: NavigationControllerType {
    private func attachToTransitioningCoordinator(_ completion: (() -> Void)?) {
        let completion = completion ?? {}
        guard let coordinator = self.transitionCoordinator,
            coordinator.animate(alongsideTransition: nil, completion: {
                context in
                completion()
            })
            else {
                return completion()
        }
    }
}

extension UINavigationController: StackNavigationControllerType {
    func push(_ item: UIViewController, animated: Bool, completion: (() -> Void)?) {
        pushViewController(item, animated: animated)
        attachToTransitioningCoordinator(completion)
    }
    
    func pop(animated: Bool, completion: (() -> Void)?) {
        popViewController(animated: animated)
        attachToTransitioningCoordinator(completion)
    }
}

extension UINavigationController: SingleNavigationControllerType {
    func put(_ item: UIViewController) {
        setViewControllers([item], animated: false)
    }
}


// TODO: Implement other navigation types when it is neccessary.

/*extension UINavigationController: ListNavigationControllerType {
 func navigate(to items: [UIViewController], animated: Bool, completion: (() -> Void)?) {
 setViewControllers(items, animated: animated)
 attachToTransitioningCoordinator(completion)
 }
 }*/
