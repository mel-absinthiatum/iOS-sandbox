import KeychainSwift


protocol AuthorizationServiceObserver: AnyObject {
    func update(userName: String?)
}

protocol AuthorizationServiceObservable {
    associatedtype ObservingObjectType
    
    // TODO: Array of weak links
    var observers: [AuthorizationServiceObserver] { get set }
    
    func registerObserver(_ observer: AuthorizationServiceObserver)
    func removeObserver(_ observer: AuthorizationServiceObserver)
    
    func notifyObservers(userName: ObservingObjectType?)
}


class AuthorizationService {
    private let usernameKey = "username"
    
    var observers: [AuthorizationServiceObserver] = []
    
    lazy var keychain = KeychainSwift()
    
    var username: String? {
        didSet {
            if let user = username  {
                keychain.set(user, forKey: usernameKey)
            }
            else {
                keychain.delete(usernameKey)
            }
            notifyObservers(userName: username)
        }
    }
    
    var userIsAuthorized: Bool {
        return username != nil
    }

    func install() {
        self.username = keychain.get(usernameKey)
    }
}

extension AuthorizationService: AuthorizationServiceObservable {
    typealias ObservingObjectType = String

    func notifyObservers(userName: ObservingObjectType?) {
        observers.forEach { $0.update(userName: userName) }
    }
    
    func registerObserver(_ observer: AuthorizationServiceObserver) {
        observers.append(observer)
    }
    
    func removeObserver(_ observer: AuthorizationServiceObserver) {
        observers = observers.filter {
            $0 !== observer
        }
    }
}
