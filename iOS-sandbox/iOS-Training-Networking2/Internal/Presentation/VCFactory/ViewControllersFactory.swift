import UIKit

// MARK: - View Controllers Factory

class ViewControllersFactory {
    static func createVC<M>(vcInfo: AnyVCInfo<M>) -> M {
        let storyboard = UIStoryboard(name: vcInfo.storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: vcInfo.vcId)
            as! M
        return controller
    }
}

// MARK: - Controllers meta infos.

private let mainStoryboardName = "Main"

struct AuthorizationVCInfo: VCInfo {
    typealias ViewControllerType = AuthorizationViewController
    var storyboardName = mainStoryboardName
    var vcId = "AuthorizationViewController"
}

struct ServicesListVCInfo: VCInfo {
    typealias ViewControllerType = ServicesListViewController
    var storyboardName = mainStoryboardName
    var vcId = "ServicesListViewController"
}

struct PasswordGenerationVCInfo: VCInfo {
    typealias ViewControllerType = PasswordGenerationViewController
    var storyboardName = mainStoryboardName
    var vcId = "PasswordGenerationViewController"
}
