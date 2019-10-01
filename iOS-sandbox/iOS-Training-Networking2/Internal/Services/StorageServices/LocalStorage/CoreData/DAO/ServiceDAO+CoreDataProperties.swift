import Foundation
import CoreData

extension ServiceDAO {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceDAO> {
        return NSFetchRequest<ServiceDAO>(entityName: "Service")
    }

    @NSManaged public var id: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var login: String?
    @NSManaged public var name: String?
    @NSManaged public var password: String?
    @NSManaged public var serviceDescription: String?
    @NSManaged public var url: String?
}

