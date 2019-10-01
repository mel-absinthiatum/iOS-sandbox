import UIKit

protocol SingleNavigationControllerType: AnyObject {
    typealias Item = UIViewController
    func put(_ item: Item)
}
