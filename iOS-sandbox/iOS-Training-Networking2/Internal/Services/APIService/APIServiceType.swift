import RxCocoa
import RxSwift

protocol APIServiceType {
    func fetchServices() -> Single<[Service]>
    func postService(_ service: Service) -> Single<Void>
    func patchService(_ service: Service) -> Single<Void>
    func fetchService(_ id: String) -> Single<Service?>
    func deleteService(_ id: String) -> Single<Void> 
}
