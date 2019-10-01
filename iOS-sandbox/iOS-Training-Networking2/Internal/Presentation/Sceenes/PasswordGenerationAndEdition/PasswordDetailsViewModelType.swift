import RxCocoa
import RxSwift

struct PasswordLengthConstraints {
    let min: Int
    let max: Int
}

struct PasswordGenerationConstants {
    static let passwordLengthBounds = PasswordLengthConstraints(min: 5, max: 20)
    private init() {}
}

enum PasswordGenerationViewModelInfo {
    enum Event {
        case submit
        case cancel
    }
    
    struct Input {
        let name: Driver<String>
        let passwordLength: Driver<Int>
        let generatePassword: Signal<Void>
        let save: Signal<Void>
        let cancel: Signal<Void>
    }
    
    struct Output {
        let constants: Driver<PasswordLengthConstraints>
        let name: Driver<String>
        let password: Driver<String>
        let passwordLength: Driver<Int>
        let passwordLengthLabel: Driver<String>
        let isValid: Driver<Bool>
        let pullcord: Signal<Void>
    }
}

typealias PasswordDetailsViewModel = PasswordDetailsViewModelType

protocol PasswordDetailsViewModelType {
    func transform(_ input: PasswordGenerationViewModelInfo.Input) -> PasswordGenerationViewModelInfo.Output
}

