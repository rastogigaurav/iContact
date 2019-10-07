import UIKit
@testable import iContact

class DisplayContactMock: DisplayContactProtocol {
    var addContactCalled = false
    var updateContactCalled = false
    
    func addContact(_ contact: Contact?, handler: ((Bool, String) -> Void)) {
        addContactCalled = true
        handler(true, String())
    }
    
    func updateContact(_ contact: Contact?, handler: ((Bool, String) -> Void)) {
        updateContactCalled = true
        handler(true, String())
    }
}
