import CoreData

class CoreDataController {
    var viewMOC: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    
    init(completionClosure: (() -> Void)?) {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completionClosure?()
        }
        self.viewMOC = self.persistentContainer.viewContext
    }
}
