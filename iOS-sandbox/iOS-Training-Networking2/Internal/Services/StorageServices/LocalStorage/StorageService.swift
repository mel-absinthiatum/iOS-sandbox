protocol StorageService {
    // TODO: refactor on RX
    func insert(service: Service, completion: ((StorageQueryResult<Void>) -> Void)?)
    func insert(services: [Service], completion: ((StorageQueryResult<Void>) -> Void)?)
    
    func fetchServices(completion: ((StorageQueryResult<[Service]>) -> Void)?)
    func fetchService(id: String, completion: ((StorageQueryResult<Service>) -> Void)?)
    
    func deleteService(id: String, completion: ((StorageQueryResult<Void>) -> Void)?)
    func deleteAllServices(completion: ((StorageQueryResult<Void>) -> Void)?)
}
