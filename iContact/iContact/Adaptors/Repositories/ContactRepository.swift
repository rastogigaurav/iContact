import UIKit

protocol ContactRepositoryProtocol {
    func getAllRecords(_ handler:@escaping (_ contacts:[Contact]?, _ message: String?)->Void)-> Void
    
    func addNewRecord(_ contact: Contact, _ handler: ((_ success: Bool, _ message: String)-> Void))-> Void
    
    func updateRecord(_ contact: Contact, _ handler: ((_ success: Bool, _ message: String)-> Void))-> Void
}

struct ContactRepository: ContactRepositoryProtocol {
    func getAllRecords(_ handler: @escaping ([Contact]?, String?) -> Void) {
        if let contacts = DataManager.sharedInstance.getAllRecords() {
            handler(contacts, ResponseMessage.getSuccess.rawValue)
        } else {
            handler(nil, ResponseMessage.failureNoRecordsFound.rawValue)
        }
    }

    func addNewRecord(_ contact: Contact, _ handler: ((Bool, String) -> Void)) {
        if DataManager.sharedInstance.addNewRecord(contact) {
            handler(true, ResponseMessage.addSuccess.rawValue)
        } else {
            handler(false, ResponseMessage.failureAddingContact.rawValue)
        }
    }
    
    func updateRecord(_ contact: Contact, _ handler: ((Bool, String) -> Void)) {
        if DataManager.sharedInstance.updateRecord(contact) {
            handler(true, ResponseMessage.updateSuccess.rawValue)
        } else {
            handler(false, ResponseMessage.failureUpdatingContact.rawValue)
        }
    }
}
