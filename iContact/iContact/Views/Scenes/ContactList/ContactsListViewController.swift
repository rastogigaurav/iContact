import UIKit

class ContactsListViewController: BaseViewController {
    
    var viewModel: ContactsListViewModel!
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    private func setup() {
        ContactsListConfigurator.shared.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        customSetup()
        viewModel.didLoad()
    }
    
    private func customSetup() {
        self.navigationItem.title = viewModel.screenTitle()
        tableView.refreshControl = refreshControl
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.willRefreshScreenData()
    }
    
    private func setupViewModel() {
        self.viewModel.reload = { [unowned self] in
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
        refreshControl.addTarget(viewModel, action: #selector(viewModel.willRefreshScreenData), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showContactDetails" {
            let contactDetailsVC = segue.destination as! ContactDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            if let contact = self.viewModel.contact(atSelected: indexPath) {
                contactDetailsVC.contact = contact
            }
        } else if segue.identifier == "addNewContact" {
            
        }
    }
}

extension ContactsListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactsListTableViewCell.identifier(), for: indexPath) as! ContactsListTableViewCell
        configure(cell, forRowAt: indexPath)
        return cell
    }
    
    private func configure(_ cell: ContactsListTableViewCell, forRowAt indexPath: IndexPath){
        if let contactName = viewModel.fullName(forContactAt: indexPath) {
            cell.contactNameLabel.text = contactName
        } else {
            cell.contactNameLabel = nil
        }
        cell.contactImageView.image = viewModel.image(forContactAt: indexPath)
    }
}
