import UIKit
import RxSwift
import RxCocoa


class ServicesListViewController: UIViewController {
    private static let servicesListCellReuseIdentifier = "ServicesListCell"
    private static let servicesListCellNibName = "ServicesListCell"
    
    @IBOutlet private var listTitleLabel: UILabel!
    @IBOutlet private var tableView: UITableView!
    private let addPasswordButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    private let updatePasswordButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)
    
    var viewModel: ServicesListViewModel! = nil
    
    private let disposeBag = DisposeBag()
    
    private let sceneLoaded = PublishRelay<Void>()
}

// MARK: - VC Lifecycle

extension ServicesListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBindings()
        sceneLoaded.accept(Void())
    }
}

// MARK: - View Configuration

private extension ServicesListViewController {
    
    func setupUI() {
        localize()
        configureNavigationBar()
        configureTableView()
    }
    
    func localize() {
        navigationItem.title = NSLocalizedString("ServicesList.Title", comment: "")
    }
    
    func configureNavigationBar() {
        navigationItem.setHidesBackButton(true, animated:false);
        navigationItem.rightBarButtonItems = [updatePasswordButton, addPasswordButton]
    }
    
    func configureTableView() {
        tableView.register(UINib.init(nibName: ServicesListViewController.servicesListCellNibName, bundle: nil), forCellReuseIdentifier: ServicesListViewController.servicesListCellReuseIdentifier)
    }
}

private extension ServicesListViewController {
    
    func setupBindings() {
        
        let refresh = updatePasswordButton.rx.tap
            .asSignal()
        
        let removeItem = tableView.rx.itemDeleted
            .map({ $0.item })
            .asSignal(onErrorSignalWith: .never())
        
        let add = addPasswordButton.rx.tap
            .asSignal()

        let itemDetails = tableView.rx.modelSelected(ServiceViewModel.self)
            .map({ $0.id })
            .asSignal(onErrorSignalWith: .never())
        
        let input = ServicesListViewModelInfo.Input(
            add: add,
            itemDetails: itemDetails,
            removeItem: removeItem,
            refresh: refresh,
            sceneLoaded: sceneLoaded.asSignal())
        
        let output = viewModel.transform(input)
        
        output.listTitle
            .drive(listTitleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.services
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: ServicesListViewController.servicesListCellReuseIdentifier, cellType: ServicesListCell.self)) { (_, service, cell) in
                cell.configure(with: service)
            }
            .disposed(by: disposeBag)
        
        output.pullcord.emit()
            .disposed(by: disposeBag)
    }
}
