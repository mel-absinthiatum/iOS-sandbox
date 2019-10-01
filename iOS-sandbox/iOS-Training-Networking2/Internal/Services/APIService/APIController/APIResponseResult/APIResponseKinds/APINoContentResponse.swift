import Foundation

struct APINoContentResponse: APIResponse {
    
    init(_ rawData: Data) throws {
        if !rawData.isEmpty { throw APIError.mappingError }
    }
}
