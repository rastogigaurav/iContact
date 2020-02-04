import UIKit

class ContactDetailsViewController: BaseViewController {

    var contact = Contact()
    var viewModel: ContactDetailViewModel!
    @IBOutlet weak var leftNavigationBarButton: UIBarButtonItem!
    @IBOutlet weak var rightNavigationBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    
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
        ContactDetailsConfigurator.shared.configure(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        customSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if let newFrame = (notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            var inset: UIEdgeInsets
            inset = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height, right: 0 )
            tableView.contentInset = inset
            tableView.scrollIndicatorInsets = inset

        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        tableView.contentInset = UIEdgeInsets.zero
    }
    
    private func setupViewModel() {
        viewModel.contact = self.contact
        viewModel.updateLeftBarItemStats = { [unowned self] title in
            let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.didTapLeftNavigation))
            button.tintColor = UIColor.AppTheme.orange
            self.navigationItem.leftBarButtonItem = button
        }
        viewModel.updateRightBarItemStats = { [unowned self] title in
            let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(self.didTapRightNavigation))
            button.tintColor = UIColor.AppTheme.orange
            self.navigationItem.rightBarButtonItem = button
        }
        viewModel.reload = { [unowned self] in
            self.updateStats()
            self.tableView.reloadData()
        }
        viewModel.didLoad()
    }
    
    private func customSetup() {
        self.headerImageView.backgroundColor = UIColor.AppTheme.orange
        self.headerImageView.layer.cornerRadius = self.headerImageView.frame.size.height/2;
        self.headerImageView.layer.masksToBounds = true;
        self.headerImageView.layer.borderColor = UIColor.AppTheme.orange.cgColor
        self.headerImageView.layer.borderWidth = 2;
    }
    
    private func updateStats() {
        self.fullNameLabel.text = viewModel.fullName()
    }
    
    @IBAction func didTapRightNavigation() {
        view.endEditing(true)
        viewModel.didTapRightNavigation { message in
            if let _message = message {
                UIUtils.showCustomAlert(with: "", messge: _message, viewControllertoPresent: self)
            }
        }
    }
    
    @IBAction func didTapLeftNavigation() {
        viewModel.didTapLeftNavigation { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension ContactDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRow(inSectionAt: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactDetailTableViewCell.identifier(), for: indexPath) as! ContactDetailTableViewCell
        configure(cell, forRowAt: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(forSectionAt: section)
    }
    
    private func configure(_ cell: ContactDetailTableViewCell, forRowAt indexPath: IndexPath){
        cell.didEndEditing = { [unowned self] newValue in
            self.viewModel.didEndEditing(forRowAt: indexPath, newValue: newValue)
        }
        cell.didTapReturnKey = {
            if let nextIndexPath = self.viewModel.nextIndexPath(for: indexPath), let nextRow = self.tableView.cellForRow(at: nextIndexPath) as? ContactDetailTableViewCell {
                nextRow.textField.becomeFirstResponder()
            }
        }
        cell.descriptionLabel.text = viewModel.description(forRowAt: indexPath)
        viewModel.detail(forRowAt: indexPath) { (text, isPlaceHolder, keyboardType) in
            if isPlaceHolder {
                cell.textField.placeholder = text
            } else {
                cell.textField.text = text
            }
            cell.textField.keyboardType = keyboardType ?? .default
        }
        cell.textField.returnKeyType = viewModel.returnKeyType(forRowAt: indexPath)
    }
}
