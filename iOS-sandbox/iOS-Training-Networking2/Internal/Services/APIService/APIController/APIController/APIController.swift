import Alamofire
import RxSwift

enum APIControllerError: Error {
    case incorrectBaseUrl
}

class APIController {
    private var configuration: APIControllerConfiguration
    private var sessionManager: SessionManager
    
    init(_ configuration: APIControllerConfiguration) {
        self.configuration = configuration
        self.sessionManager = APIController.configuredSessionManager(configuration)
    }
    
    func updateConfiguration(_ configuration: APIControllerConfiguration) {
        self.configuration = configuration
        self.sessionManager = APIController.configuredSessionManager(configuration)
    }
    
    private static func configuredSessionManager(_ configuration: APIControllerConfiguration) -> SessionManager {
        var headers: [String: String] = [:]
        
        if let (authId, authToken) = Request.authorizationHeader(
            user: configuration.authId, password: configuration.authToken
        ) {
            headers[authId] = authToken
        }
        
        let defaultHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        defaultHeaders.forEach { headers[$0] = $1 }
        configuration.baseHeaders.forEach { headers[$0] = $1 }
        
        let sessionManagerConfiguration = URLSessionConfiguration.default
        sessionManagerConfiguration.httpAdditionalHeaders = headers
        sessionManagerConfiguration.timeoutIntervalForRequest = configuration.timeoutInterval
        return Alamofire.SessionManager(configuration: sessionManagerConfiguration)
    }
}

extension APIController {
    func run<T>(_ task: APITask<T>) -> Single<T> {
        guard let url = configuration.baseUrl?.appendingPathComponent(task.relativeUrl) else {
            return Single.error(APIControllerError.incorrectBaseUrl)
        }
        
        let request = sessionManager.request(url,
            method: task.method,
            parameters: task.parameters,
            encoding:  task.encoding,
            headers: task.headers)
        
        return Single<T>.create { subscriber -> Disposable in
                request.responseJSON { response in
                    switch response.result {
                    case .success:
                        do {
                            let dto: T = try T.init(response.data ?? Data())
                            subscriber(.success(dto))
                        } catch {
                            subscriber(.error(error))
                        }
                    case .failure:
                        subscriber(.error(APIError.networkError))
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
