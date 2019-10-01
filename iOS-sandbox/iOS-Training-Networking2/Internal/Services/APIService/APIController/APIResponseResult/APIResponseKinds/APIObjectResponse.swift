import Foundation

struct APIObjectResponse<ObjectType: APIResponseModel>: APIResponse {
    
    private(set) var object: ObjectType?
    
    init(_ rawData: Data) throws {
        let jsonDecoder = JSONDecoder()
        self.object = try jsonDecoder.decode(ObjectType.self, from: rawData)
    }
}

