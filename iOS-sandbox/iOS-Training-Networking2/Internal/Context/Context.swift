protocol Contextual {
    var context: Context! {get set}
}

class Context {
    let authorizationService: AuthorizationService
    let storageService: StorageService
    let apiService: APIService
    let storageManager: StorageManager
    
    init() {
        apiService = APIService()
        authorizationService = AuthorizationService()
        authorizationService.registerObserver(apiService)
        authorizationService.install()
        storageService = CoreDataStorageService()
        storageManager = StorageManager(apiService: apiService)
    }
}
