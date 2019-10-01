import Foundation

struct APIArrayResponse<ObjectType: APIResponseModel>: APIResponse {
    private(set) var objects: [ObjectType]?
    
    init(_ rawData: Data) throws {
        let jsonDecoder = JSONDecoder()
        self.objects = try jsonDecoder.decode([ObjectType].self, from: rawData)
    }
}
