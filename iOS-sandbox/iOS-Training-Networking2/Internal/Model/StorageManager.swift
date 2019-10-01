import RxSwift
import RxCocoa


class StorageManager {
    var apiService: APIService
    
    private let disposeBag = DisposeBag()
    
    private var _services = BehaviorRelay<[Service]>(value: [Service]())
    lazy var services: Observable<[Service]> = _services.asObservable()
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchServices() -> Single<[Service]> {
        return apiService.fetchServices()
            .do(onSuccess: { [weak self] services in
                self?.updateServicesList(services)
            })
    }
    
    func service(byId id:String) -> Service? {
        return _services.value.first(where: { $0.id == id })
    }
    
    func deleteService(id: String) -> Single<Void> {
        return apiService.deleteService(id).do(
            onSuccess: { [weak self] _ in
               self?.deleteFromServices(id: id)
            },
            onError: { error in
                    print("error", error)
            })
    }
    
    func addService(service: Service) -> Single<Void> {
        return apiService.postService(service).do(
            onSuccess: { [weak self] _ in
                var tempServicesArray = self?._services.value ?? []
                tempServicesArray.append(service)
                self?.updateServicesList(tempServicesArray)
            },
            onError: { error in
                    print("error", error)
            })
    }
    
    func updateService(service: Service) -> Single<Void> {
        return apiService.patchService(service).do(
            onSuccess: { [weak self] _ in
                self?.updateServicesList((self?._services.value ?? []).filter {$0.id != service.id})
                var tempServicesArray = self?._services.value ??  []
                tempServicesArray.append(service)
                self?.updateServicesList(tempServicesArray)
            },
            onError: { error in
                print("error", error)
            })
    }
}

private extension StorageManager {
    func addToServices(service: Service) {
        var tempServicesArray = _services.value
        tempServicesArray.append(service)
        self.updateServicesList(tempServicesArray)
    }
    
    func deleteFromServices(id: String) {
        self.updateServicesList(self._services.value.filter {$0.id != id})
    }
    
    func updateServicesList(_ services: [Service]) {
        self._services.accept(services)
    }
}
