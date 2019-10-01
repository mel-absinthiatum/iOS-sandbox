class ServiceViewModel {
    let name: String
    let password: String
    let id: String
    
    init(service: Service) {
        self.name = service.name
        self.password = service.password
        self.id = service.id
    }
}
