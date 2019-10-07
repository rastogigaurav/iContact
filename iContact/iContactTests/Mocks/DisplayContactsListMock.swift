import UIKit
@testable import iContact

class DisplayContactsListMock: DisplayContactsListProtocol {
    var fetchAllContactsCalled = false
    func fetchAllContacts(_ handler: @escaping ([Contact]?, String?) -> ()) {
        fetchAllContactsCalled = true
        handler(nil, nil)
    }
}
