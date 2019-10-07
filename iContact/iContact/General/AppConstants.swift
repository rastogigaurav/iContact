import UIKit

enum ResponseMessage: String {
    case getSuccess = "Contacts loaded successfully"
    case addSuccess = "Contact has been added successfully"
    case updateSuccess = "Contact has been updated successfully"
    case failureAddingContact = "Error adding contact, re-verify data"
    case failureUpdatingContact = "Error updating contact, Try again later"
    case failureNoRecordsFound = "No records found"
    case failureBlankContact = "Can't add blank contact"
    case failureMissingFirstName = "Missing First Name"
    case falireMissingLastName = "Missing Last Name"
    case invalidEmail = "Email Invalid"
    case unknown = "Unknown error, Try again later"
}
