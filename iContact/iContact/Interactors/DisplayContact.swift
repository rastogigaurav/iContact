import UIKit

protocol DisplayContactProtocol {
    func addContact(_ contact: Contact?, handler: ((_ isAdded: Bool, _ message: String)-> Void))
    
    func updateContact(_ contact: Contact?, handler: ((_ isUpdated: Bool, _ message: String)-> Void))
}

class DisplayContact {
    private var repository: ContactRepositoryProtocol
    
    init(with repository: ContactRepositoryProtocol) {
        self.repository = repository
    }
}

extension DisplayContact: DisplayContactProtocol {
    private func idGenerator(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func addContact(_ contact: Contact?, handler: ((Bool, String) -> Void)) {
        if let _contact = contact, let firstName = _contact.firstName, firstName.isEmpty {
            handler(false, ResponseMessage.failureMissingFirstName.rawValue)
        } else if let _contact = contact, let lastName = _contact.lastName, lastName.isEmpty {
            handler(false, ResponseMessage.falireMissingLastName.rawValue)
        } else if let _contact = contact, let email = _contact.email, email.count>0, !email.validateEmail() {
            handler(false, ResponseMessage.invalidEmail.rawValue)
        } else if var _contact = contact {
            _contact.id = idGenerator(length: 24)
            self.repository.addNewRecord(_contact) { (success, message) in
                handler(success, message)
            }
        } else {
            handler(false, ResponseMessage.unknown.rawValue)
        }
    }
    
    func updateContact(_ contact: Contact?, handler: ((Bool, String) -> Void)) {
        if let _contact = contact, let firstName = _contact.firstName, firstName.isEmpty {
            handler(false, ResponseMessage.failureMissingFirstName.rawValue)
        } else if let _contact = contact, let lastName = _contact.lastName, lastName.isEmpty {
            handler(false, ResponseMessage.falireMissingLastName.rawValue)
        } else if let _contact = contact, let email = _contact.email, email.count>0, !email.validateEmail() {
            handler(false, ResponseMessage.invalidEmail.rawValue)
        } else if let _contact = contact {
            self.repository.updateRecord(_contact) { (success, message) in
                handler(success, message)
            }
        } else {
            handler(false, ResponseMessage.unknown.rawValue)
        }
    }
}
