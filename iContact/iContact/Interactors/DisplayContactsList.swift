import UIKit

protocol DisplayContactsListProtocol {
    func fetchAllContacts(_ handler:@escaping ([Contact]?, String?)->())->Void
}

struct DisplayContactsList {
    private var repository: ContactRepositoryProtocol
    init(with repository: ContactRepositoryProtocol) {
        self.repository = repository
    }
}

extension DisplayContactsList: DisplayContactsListProtocol {
    func fetchAllContacts(_ handler: @escaping ([Contact]?, String?) -> ()) {
        repository.getAllRecords { records, message in
            handler(records, message)
        }
    }
}
