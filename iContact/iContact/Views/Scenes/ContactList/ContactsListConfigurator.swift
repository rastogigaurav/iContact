import UIKit

class ContactsListConfigurator {
    static let shared = ContactsListConfigurator()
    
    func configure(_ viewController: ContactsListViewController) {
        let repository  = ContactRepository()
        let interactor = DisplayContactsList(with: repository)
        let viewModel = ContactsListViewModel(with: interactor)
        viewController.viewModel = viewModel
    }
}
