import Alamofire
import RxSwift


private enum APIServiceErrors: Error {
    case requestSerialization
}

private struct PasswordAPIServiceConstants {
    static let requestTimeoutInterval: TimeInterval = 15
    static let baseUrl = "https://passwords.noveogroup.com/api/v1"
    static let authName = "be398b0c-b935-49e0-bb15-7b270a2ea7bd"
    static let authToken = "16d845b04334d0704f0ded1ede04c434a2948cb39b54a3ed"
    static let userIdHeaderKey = "Passwords-User-ID"
    static let defaultHeaders = ["Content-Type":"application/json"]
    private init() {}
}

class APIService: APIServiceType {
    private let apiController: APIController
    private var apiControllerConfiguration: APIControllerConfiguration
    
    convenience init() {
        self.init(userId: "")
    }
    
    init(userId: String) {
        var baseHeaders: [String: String] = [:]
        PasswordAPIServiceConstants.defaultHeaders.forEach { baseHeaders[$0] = $1 }
        baseHeaders[PasswordAPIServiceConstants.userIdHeaderKey] = "\(PasswordAPIServiceConstants.authName)\(userId)"
        
        apiControllerConfiguration = APIControllerConfiguration(baseUrl: URL(string: PasswordAPIServiceConstants.baseUrl),
            baseHeaders: baseHeaders,
            timeoutInterval: PasswordAPIServiceConstants.requestTimeoutInterval,
            authId: PasswordAPIServiceConstants.authName,
            authToken: PasswordAPIServiceConstants.authToken)
        apiController = APIController(apiControllerConfiguration)
    }
    
    func updateServiceUserId(_ id: String) {
        apiControllerConfiguration.baseHeaders[PasswordAPIServiceConstants.userIdHeaderKey] = "\(PasswordAPIServiceConstants.authName)\(id)"
        apiController.updateConfiguration(apiControllerConfiguration)
    }
}

extension APIService {
    func fetchServices() -> Single<[Service]> {
        let task = APITask<APIArrayResponse<Service>>(relativeUrl: "services",
            method: .get,
            parameters: [:],
            headers: [:],
            encoding: URLEncoding.default
        )
        return apiController.run(task).map({ $0.objects ?? [] })
    }
    
    func postService(_ service: Service) -> Single<Void> {
        let task = APITask<APINoContentResponse>(relativeUrl: "services",
            method: .post,
            parameters: service.dictionary ?? [:],
            headers: [:],
            encoding: JSONEncoding.default
        )
        return apiController.run(task).map { _ in () }
    }
    
    func patchService(_ service: Service) -> Single<Void> {
        let id = service.id
        let task = APITask<APINoContentResponse>(relativeUrl: "services/\(id)",
             method: .patch,
             parameters: service.dictionary ?? [:],
             headers: [:],
             encoding: JSONEncoding.default
        )
        return apiController.run(task).map { _ in () }
    }
    
    func fetchService(_ id: String) -> Single<Service?> {
        let task = APITask<APIObjectResponse<Service>>(relativeUrl: "services/\(id)",
            method: .get,
            parameters: [:],
            headers: [:],
            encoding: URLEncoding.default
        )
        return apiController.run(task).map({ $0.object ?? nil })
    }

    func deleteService(_ id: String) -> Single<Void> {
        let task = APITask<APINoContentResponse>(relativeUrl: "services/\(id)",
            method: .delete,
            parameters: [:],
            headers: [:],
            encoding: URLEncoding.default
        )
        return apiController.run(task).map { _ in () }
    }
}

extension APIService: AuthorizationServiceObserver {
    func update(userName: String?) {
        updateServiceUserId(userName ?? "")
    }
}
