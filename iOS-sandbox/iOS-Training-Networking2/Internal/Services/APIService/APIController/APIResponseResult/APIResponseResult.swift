import Foundation

protocol APIResponse {
    init(_ rawData: Data) throws
}

enum APIResponseResult<T: APIResponse> {
    case success(T)
    case failure(Error)
}

