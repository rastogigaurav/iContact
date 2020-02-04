import UIKit

class ContactDetailsConfigurator {
    static let shared = ContactDetailsConfigurator()
    
    func configure(_ viewController: ContactDetailsViewController) {
        let repository  = ContactRepository()
        let interactor = DisplayContact(with: repository)
        let viewModel = ContactDetailViewModel(with: interactor)
        viewController.viewModel = viewModel
    }
}
