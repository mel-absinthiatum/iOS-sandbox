import UIKit
import RxCocoa
import RxSwift


class AuthorizationViewController: UIViewController{   
    private let disposeBag = DisposeBag()
    
    // TODO: Implement normal initialization with viewModel.
    var viewModel: AuthorizationViewModel!
    
    @IBOutlet private var typeNameLabel: UILabel!
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var confirmButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localize()
        setupBindings()
    }
}

private extension AuthorizationViewController {
    func setupBindings() {
        let username = nameTextField.rx.text.orEmpty
            .asDriver()
        
        let submit = confirmButton.rx.tap
            .asSignal()
        
        let input = AuthorizationViewModelInfo.Input(username: username, submit: submit)
        let output = viewModel.transform(input)
        
        output.isSubmitEnabled
            .drive(confirmButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.pullcord.emit()
            .disposed(by: disposeBag)
    }
    
    func localize() {
        self.navigationItem.title = NSLocalizedString("Authorization.Title", comment: "")
        typeNameLabel.text = NSLocalizedString("Authorization.TypeYourNameLabel", comment: "")
        confirmButton.setTitle(NSLocalizedString("Authorization.ConfirmButton", comment: ""), for: .normal)
    }
}
