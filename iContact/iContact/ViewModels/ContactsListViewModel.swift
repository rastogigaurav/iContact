import UIKit

protocol ContactsListViewModelProtocol {
    func didLoad()
    
    func screenTitle()-> String
    
    func numberOfRows()->Int
    
    func fullName(forContactAt indexPath: IndexPath)-> String?
    
    func image(forContactAt indexPath: IndexPath)-> UIImage?
    
    func contact(atSelected indexPath: IndexPath?)-> Contact?
    
    func willRefreshScreenData()
}

class ContactsListViewModel {
    var contacts:[Contact] = []
    var reload: (()-> Void) = {}
    private var interactor: DisplayContactsListProtocol
    
    init(with interactor:DisplayContactsListProtocol) {
        self.interactor = interactor
    }
}

extension ContactsListViewModel: ContactsListViewModelProtocol {
    func didLoad() {
        self.interactor.fetchAllContacts { (allContacts, message) in
            self.contacts = allContacts ?? []
            self.reload()
        }
    }
    
    func screenTitle() -> String {
        return "Contacts"
    }
    
    func numberOfRows() -> Int {
        return self.contacts.count
    }
    
    func fullName(forContactAt indexPath: IndexPath) -> String? {
        let firstName = contacts[indexPath.row].firstName ?? ""
        let lastName = contacts[indexPath.row].lastName ?? ""
        return firstName + " " + lastName
    }
    
    func image(forContactAt indexPath: IndexPath) -> UIImage? {
        return nil
    }
    
    func contact(atSelected indexPath: IndexPath?) -> Contact? {
        if let _indexPath = indexPath {
            return contacts[_indexPath.row]
        }
        return nil
    }
    
    @objc func willRefreshScreenData() {
        didLoad()
    }
}
