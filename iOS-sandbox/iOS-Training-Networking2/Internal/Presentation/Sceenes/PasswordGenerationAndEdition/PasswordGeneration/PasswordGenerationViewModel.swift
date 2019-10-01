import RxSwift
import RxCocoa


class PasswordGenerationViewModel: ViewModelType, PasswordDetailsViewModel {
    private let context: Context
    private let router: AnyRouter<PasswordGenerationViewModelInfo.Event>

    // MARK: - Initialization
    
    init(router: AnyRouter<PasswordGenerationViewModelInfo.Event>, context: Context) {
        self.context = context
        self.router = router
    }
}

extension PasswordGenerationViewModel {
    func transform(_ input: PasswordGenerationViewModelInfo.Input) -> PasswordGenerationViewModelInfo.Output {

        let constants = Driver.just(PasswordGenerationConstants.passwordLengthBounds)
        
        let name = input.name.skip(1)

        let initialPasswordLength = Driver.just(PasswordGenerationConstants.passwordLengthBounds.min)
        let passwordLengthInput = input.passwordLength
        let passwordLength = Driver.merge(initialPasswordLength, passwordLengthInput)
        let passwordLengthLabel = passwordLength
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
        
        let generatePassword = input.generatePassword
            .asDriver(onErrorJustReturn: Void())
        
        let password = Driver.merge(passwordLengthInput, generatePassword.withLatestFrom(passwordLength))
            .map { length in String.randomizedString(length: length) }
        
        let isValid: Driver<Bool> = name
            .map { !$0.isEmpty }
            .asDriver(onErrorJustReturn: false)
        
        let result = Driver.combineLatest(name, password)
            .asSignal(onErrorSignalWith: .never())
        
        let saveService: Signal<Void> = input.save
            .withLatestFrom(isValid)
            .filter{ $0 }
            .withLatestFrom(result)
            .asObservable()
            .flatMapLatest({ [weak self] (name, password) -> Observable<Void> in
                guard let `self` = self else {
                    return .never()
                }
                return self.save(name: name, password: password)
            })
            .asSignal(onErrorSignalWith: .never())
        
        let coordination = Signal.merge(
            saveService.map({ PasswordGenerationViewModelInfo.Event.submit }),
            input.cancel.map({ PasswordGenerationViewModelInfo.Event.cancel }))
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

private extension PasswordGenerationViewModel {
    func save(name: String, password: String) -> Observable<Void> {
        let service = Service(withName: name, password: password)
        return self.context.storageManager.addService(service: service)
            .catchError({ _ in return .never() })
            .asObservable()
    }
}
