import RxSwift
import RxCocoa


class PasswordEditionViewModel: ViewModelType, PasswordDetailsViewModel {
    private let context: Context
    private let router: PasswordEditionCoordinator
    
    private var _service: Service
    
    // MARK: - Initialization
    
    init(router: PasswordEditionCoordinator, context: Context, service: Service) {
        self.context = context
        self.router = router
        self._service = service
    }
}

extension PasswordEditionViewModel {
    func transform(_ input: PasswordGenerationViewModelInfo.Input) -> PasswordGenerationViewModelInfo.Output {
        
        /* Constants. */
        let constants = Driver.just(PasswordGenerationConstants.passwordLengthBounds)
        
        /* Name. */
        let initialName = Driver<String>.just(_service.name)
        let nameInput = input.name.skip(1)
        let name = Driver.merge(initialName, nameInput)
        
        /* Password length. */
        let initialPasswordLength = Driver.just(_service.password.lengthOfBytes(using: .utf8))
        let passwordLengthInput = input.passwordLength.skip(1)
        let passwordLength = Driver.merge(initialPasswordLength, passwordLengthInput)
        let passwordLengthLabel = passwordLength
            .map{ "\($0)" }
            .asDriver(onErrorJustReturn: "")
        
        /* Password. */
        let initialPassword = Driver.just(_service.password)
        let generatePassword = input.generatePassword
            .asDriver(onErrorJustReturn: Void())
        
        let randomPassword = Driver.merge(passwordLengthInput, generatePassword.withLatestFrom(passwordLength))
            .map{ length in String.randomizedString(length: length) }
        
        let password = Driver.merge(initialPassword, randomPassword)
        
        /* Validation. */
        let isValid: Driver<Bool> = name
            .map { !$0.isEmpty }

        /* Saving. */
        let result = Driver.combineLatest(name, password)
            .asSignal(onErrorSignalWith: .never())
        
        let saveService: Signal<Void> = input.save
            .withLatestFrom(isValid)
            .filter{ $0 }
            .withLatestFrom(result)
            .asObservable()
            .flatMapLatest{ [weak self] (name, password) -> Observable<Void> in
                guard let `self` = self else {
                    return .never()
                }
                return self.save(name: name, password: password)
            }
            .asSignal(onErrorSignalWith: .never())
        
        /* Coordination. */
        let coordination = Signal.merge(
            saveService.map{ PasswordGenerationViewModelInfo.Event.submit },
            input.cancel.map{ PasswordGenerationViewModelInfo.Event.cancel })
            .route(with: router)
        
        return PasswordGenerationViewModelInfo.Output(
            constants: constants,
            name: name,
            password: password,
            passwordLength: passwordLength,
            passwordLengthLabel: passwordLengthLabel,
            isValid: isValid,
            pullcord: coordination)
    }
}

// MARK: - Auxilaries

private extension PasswordEditionViewModel {
    func save(name: String, password: String) -> Observable<Void> {
        var service = Service(withName: name, password: password)
        service.id = (_service.id)
        return context.storageManager.updateService(service: service)
            .catchError{ _ in .never() }
            .asObservable()
    }
}
