import CoreData

enum CoreDataServiceError: Error {
    case noValue
}


class CoreDataStorageService {
    var controller: CoreDataController
    var managedContext: NSManagedObjectContext {
        return controller.viewMOC
    }
    
    init() {
        self.controller = CoreDataController(completionClosure: nil)
    }
}


extension CoreDataStorageService: StorageService {
    
    private func fetchServiceDAO(id: String, completion: ((StorageQueryResult<ServiceDAO>) -> Void)?) {
        performAsync({ context in
                let servicesFetch: NSFetchRequest<ServiceDAO> = ServiceDAO.fetchRequest()
                servicesFetch.predicate =  NSPredicate(format: "id == %@", id)
                servicesFetch.fetchLimit = 1
                let servicesDAO = try? context.fetch(servicesFetch)
                
                guard let serviceDAO = servicesDAO?.first else {
                    return .failure(CoreDataServiceError.noValue)
                }
                return .success(serviceDAO)
            },
            completion: completion)
    }
    
    func fetchServices(completion: ((StorageQueryResult<[Service]>) -> Void)?) {
        performAsync({ context in
                let servicesFetch: NSFetchRequest<ServiceDAO> = ServiceDAO.fetchRequest()
                var services: [Service] = []
                let servicesDAO = try context.fetch(servicesFetch)
                for serviceDAO in servicesDAO {
                    let service = Service(dao: serviceDAO)
                    if let service = service {
                        services.append(service)
                    }
                }
                return .success(services)
        },
        completion: completion)
    }
    
    func fetchService(id: String, completion: ((StorageQueryResult<Service>) -> Void)?) {
        fetchServiceDAO(id: id, completion: { result in
                guard case let .success(serviceDAO) = result, let service: Service = Service(dao: serviceDAO) else {
                    completion?(.failure(CoreDataServiceError.noValue))
                    return
                }
                completion?(.success(service))
            })
    }
    
    func insert(service: Service, completion: ((StorageQueryResult<Void>) -> Void)?) {
        performAsync({ context in
                let serviceDao = service.mapToDAO(context: context)
                context.insert(serviceDao)
                return .success(Void())
            },
            completion: completion)
    }
    
    func insert(services: [Service], completion: ((StorageQueryResult<Void>) -> Void)?) {
        performAsync({ context in
                for service in services {
                    let serviceDao = service.mapToDAO(context: context)
                    context.insert(serviceDao)
                }
                return .success(Void())
            },
            completion: completion)
    }
    
    func deleteService(id: String, completion: ((StorageQueryResult<Void>) -> Void)?) {
        fetchServiceDAO(id: id,
            completion: { [unowned self] result in
                guard case let .success(serviceDAO) = result else {
                    completion?(.failure(CoreDataServiceError.noValue))
                    return
                }
                self.performAsync({ context in
                        context.delete(serviceDAO)
                        return .success(Void())
                    },
                    completion: completion)
            })
    }
    
    func deleteAllServices(completion: ((StorageQueryResult<Void>) -> Void)?) {
        performAsync({ context in
                let servicesFetch: NSFetchRequest<ServiceDAO> = ServiceDAO.fetchRequest()
                let servicesDAO = try context.fetch(servicesFetch)
                for serviceDAO in servicesDAO {
                    context.delete(serviceDAO)
                }
                return .success(Void())
            },
            completion: completion)
    }
}

private extension CoreDataStorageService {
    func performAsync<T>(_ perform: @escaping (NSManagedObjectContext) throws -> (StorageQueryResult<T>), completion: ((StorageQueryResult<T>) -> ())?) {
        let moc = managedContext
        
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = moc
        
        privateMOC.perform {
            do {
                let result = try perform(privateMOC)
                guard privateMOC.hasChanges else {
                    completion?(result)
                    return
                }
                
                try privateMOC.save()
                moc.performAndWait {
                    do {
                        try moc.save()
                        completion?(result)
                    } catch {
                        completion?(.failure(error))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion?(.failure(error))
                }
            }
        }
    }
}
