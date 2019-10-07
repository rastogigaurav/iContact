import Foundation
@testable import iContact

class ContactRepositoryMock: ContactRepositoryProtocol {
    var getAllRecordsCalledSuccessfully = false
    var addNewRecordCalledSuccessfully = false
    var updateRecordCalledSuccessfully = false
    
    func getAllRecords(_ handler: @escaping ([Contact]?, String?) -> Void) {
        getAllRecordsCalledSuccessfully = true
        handler(nil, nil)
    }
    
    func addNewRecord(_ contact: Contact, _ handler: ((Bool, String) -> Void)) {
        addNewRecordCalledSuccessfully = true
        handler(true, ResponseMessage.addSuccess.rawValue)
    }
    
    func updateRecord(_ contact: Contact, _ handler: ((Bool, String) -> Void)) {
        updateRecordCalledSuccessfully = true
        handler(true, ResponseMessage.updateSuccess.rawValue)
    }
}
