import UIKit

class ServicesListCell: UITableViewCell {

    @IBOutlet private var serviceNameLabel: UILabel!
    @IBOutlet private var passwordLabel: UILabel!
    
    func configure(withName name: String, password: String) {
        serviceNameLabel.text = name
        passwordLabel.text = password
    }
    
    func configure(with viewModel: ServiceViewModel) {
        serviceNameLabel.text = viewModel.name
        passwordLabel.text = viewModel.password
    }
}
