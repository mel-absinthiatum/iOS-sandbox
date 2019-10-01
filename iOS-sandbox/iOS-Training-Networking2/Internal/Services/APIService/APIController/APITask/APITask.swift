import Alamofire

struct APITask<T: APIResponse> {
    let relativeUrl: String
    let method: HTTPMethod
    let parameters: [String: Any]
    let headers: [String: String]
    let encoding: ParameterEncoding
}
