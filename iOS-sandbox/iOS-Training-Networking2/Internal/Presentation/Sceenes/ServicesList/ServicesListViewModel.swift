import RxSwift
import RxCocoa


enum ServicesListError: Error {
    case serviceNotFound
}

enum ServicesListViewModelInfo {
    enum Event {
        case add
        case itemDetails(Service)
    }
    
    struct Input {
        let add: Signal<Void>
        let itemDetails: Signal<String>
        let removeItem: Signal<Int>
        let refresh: Signal<Void>
        let sceneLoaded: Signal<Void>
    }
    
    struct Output {
        let listTitle: Driver<String>
        let services: Driver<[ServiceViewModel]>
        let errors: Signal<Error>
        let pullcord: Signal<Void>
    }
}

class ServicesListViewModel: ViewModelType {
    private let context: Context
    private let router: ServicesListCoordinator

    func transform(_ input: ServicesListViewModelInfo.Input) -> ServicesListViewModelInfo.Output {
        let errors = PublishRelay<Error>()
        
        let userString = NSLocalizedString("ServicesList.User", comment: "")
        let userName = context.authorizationService.username ?? ""
        let listTitleString = "\(userString): \(userName)"
        let listTitle = Driver.just(listTitleString)
        
        let servicesList: Driver<[ServiceViewModel]> = context.storageManager.services
            .map { $0.map { ServiceViewModel.init(service: $0) } }
            .asDriver(onErrorJustReturn: [])
        
        let didRemoveItem = input.removeItem.asObservable()
            .withLatestFrom(context.storageManager.services) { ($0, $1) }
            .map({ (index, services) in services[index].id })
            .flatMap({ [unowned self] id -> Observable<Void> in
                return self.context.storageManager.deleteService(id: id)
                    .do(onError: { errors.accept($0) })
                    .catchError { _ in return .never() }
                    .asObservable()
            }).asDriver(onErrorDriveWith: .never())
        
        let updateServices = Signal.merge(input.sceneLoaded, input.refresh)
        
        let didUpdateServices = updateServices.asObservable()
            .flatMapLatest { [unowned self] _ -> Observable<Void> in
                return self.context.storageManager.fetchServices()
                    .do(onError: { errors.accept($0) })
                    .catchError { _ in return .never() }
                    .map { _ in }
                    .asObservable()
            }.asDriver(onErrorDriveWith: .never())

        let services = Driver.merge(servicesList,
            didRemoveItem.flatMap({ Driver<[ServiceViewModel]>.never() }),
            didUpdateServices.flatMap({ Driver<[ServiceViewModel]>.never() }))
        
        let itemDetails =  input.itemDetails.asObservable()
            .flatMap {[weak self] id -> Observable<Service> in
                guard let service = self?.context.storageManager.service(byId: id) else {
                    errors.accept(ServicesListError.serviceNotFound)
                    return .never()
                }
                return Observable.just(service)
            }
            .asSignal(onErrorSignalWith: .never())
        
        let coordination = Signal.merge(
                input.add.map { ServicesListCoordinator.Event.add},
                itemDetails.map { ServicesListCoordinator.Event.itemDetails($0) }
            )
            .route(with: router)
        
        return ServicesListViewModelInfo.Output(
            listTitle: listTitle,
            services: services,
            errors: errors.asSignal(),
            pullcord: coordination)
    }

    init(router: ServicesListCoordinator, context: Context) {
        self.router = router
        self.context = context
    }
}
