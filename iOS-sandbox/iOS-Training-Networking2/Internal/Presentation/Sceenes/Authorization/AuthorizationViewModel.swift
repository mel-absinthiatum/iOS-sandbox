import RxSwift
import RxCocoa

enum AuthorizationViewModelInfo {
    enum Event {
        case submit
    }
    
    struct Input {
        let username: Driver<String>
        let submit: Signal<Void>
    }
    
    struct Output {
        let isSubmitEnabled: Driver<Bool>
        let pullcord: Signal<Void>
    }
}


class AuthorizationViewModel: ViewModelType {
    private let context: Context
    private let router: AuthorizationCoordinator

    init(router: AuthorizationCoordinator, context: Context) {
        self.router = router
        self.context = context
    }
    
    func transform(_ input: AuthorizationViewModelInfo.Input) -> AuthorizationViewModelInfo.Output {
        
        let isSubmitEnabled = input.username
            .map { !$0.isEmpty }
            .asDriver()
        
        let submited = input.submit.withLatestFrom(input.username)
            .filter { !$0.isEmpty }
            .do(onNext: { [weak self] in
                self?.context.authorizationService.username = $0
            })
        
        let coordination = submited
            .map { _ in AuthorizationViewModelInfo.Event.submit }
            .route(with: router)
        
        let output = AuthorizationViewModelInfo.Output(
            isSubmitEnabled: isSubmitEnabled, pullcord: coordination)
        return output
    }

}
