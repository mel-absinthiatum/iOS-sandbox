import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var context: Context!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        context = Context()
        
        let launcher = Launcher(context: context)
        window = launcher.compoundedWindow()
        window?.makeKeyAndVisible()

        return true
    }
}

