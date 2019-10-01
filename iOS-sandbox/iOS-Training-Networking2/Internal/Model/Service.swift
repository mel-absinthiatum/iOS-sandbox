import CoreData

struct Service: APIResponseModel  {
    var id: String
    let name: String
    var description: String?
    var login: String?
    var url: String?
    let password: String
    var imageUrl: String?
    
    init(withName name: String, password: String, description: String = "", login: String = "", url: String = "") {
        self.id = UUID().uuidString
        self.name = name
        self.password = password
        self.description = description
        self.login = login
        self.url = url
    }
}
