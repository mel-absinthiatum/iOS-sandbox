import UIKit
import RxSwift
import RxCocoa


private struct PasswordGenerationViewControllerConstants {
    static let sliderAnimationDuration = 0.2
    private init() {}
}


class PasswordGenerationViewController: UIViewController {   
    var viewModel: PasswordDetailsViewModel!
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet private var serviceNameInput: UITextField!
    @IBOutlet private var generateButton: UIButton!
    @IBOutlet private var passwordLabel: UILabel!
    @IBOutlet private var passwordLengthSlider: UISlider!
    @IBOutlet private var passwordLengthLabel: UILabel!
    @IBOutlet private var doneButton: UIButton!
    private let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
}

// MARK: - public

extension PasswordGenerationViewController {
    
    // MARK: - VC Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
}

// MARK: - private

private extension PasswordGenerationViewController {

    func setupViews() {
        navigationItem.title = NSLocalizedString("PasswordGeneration.Title", comment: "")
        generateButton.setTitle(NSLocalizedString("PasswordGeneration.GenerateButton", comment: ""), for: .normal)
        doneButton.setTitle(NSLocalizedString("PasswordGeneration.DoneButton", comment: ""), for: .normal)
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func setupBindings() {
        let nameDriver = serviceNameInput.rx.text.orEmpty.asDriver()
        let passwordLengthDriver:Driver<Int> = passwordLengthSlider.rx.value.asDriver()
            .map({ lroundf($0) })
            .distinctUntilChanged()
        let generatePassword = generateButton.rx.tap
            .asSignal()
        let save = doneButton.rx.tap
            .asSignal()
        let cancel = cancelButton.rx.tap
            .asSignal()
        
        let input = PasswordGenerationViewModelInfo.Input(
            name: nameDriver,
            passwordLength: passwordLengthDriver,
            generatePassword: generatePassword,
            save: save,
            cancel: cancel)
        
        let output = viewModel.transform(input)
        
        output.constants
            .drive(onNext: { [weak self] constants in
                self?.passwordLengthSlider.minimumValue = Float(constants.min)
                self?.passwordLengthSlider.maximumValue = Float(constants.max)
            } )
            .disposed(by: disposeBag)
        
        output.name
            .drive(serviceNameInput.rx.text)
            .disposed(by: disposeBag)
        
        output.password
            .drive(passwordLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.passwordLength
            .map({ Float($0) })
            .drive(passwordLengthSlider.rx.value)
            .disposed(by: disposeBag)
        
        output.passwordLengthLabel
            .drive(passwordLengthLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isValid
            .drive(doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.pullcord.emit()
            .disposed(by: disposeBag)

    }
}

// MARK: - PasswordLengthSlider actions

extension PasswordGenerationViewController {
    private func fixSliderPosition() {
        UIView.animate(withDuration: PasswordGenerationViewControllerConstants.sliderAnimationDuration, animations: {
            self.passwordLengthSlider.setValue(Float(lroundf(self.passwordLengthSlider.value)), animated:true)
        })
    }
    
    @IBAction func passwordLengthSliderTouchUpInside(_ sender: UISlider) {
        fixSliderPosition()
    }
    
    @IBAction func passwordLengthSliderTouchUpOutside(_ sender: UISlider) {
        fixSliderPosition()
    }
}
