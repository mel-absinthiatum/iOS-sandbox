import Foundation

struct APIControllerConfiguration {
    var baseUrl: URL? = URL(string: "")
    var baseHeaders: [String: String] = [:]
    var timeoutInterval: TimeInterval = 15
    var authId: String = ""
    var authToken: String = ""
}
