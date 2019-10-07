import UIKit

struct DataManager {
    static let sharedInstance = DataManager()
    private let jsonFileName = "data"
    private let fileType = "json"

    func getAllRecords()-> [Contact]? {
        return [Contact].getObjectFromJSONFile(fileName: jsonFileName, forKey: nil, fileType: fileType)
    }
    
    func addNewRecord(_ contact: Contact)-> Bool {
        if var contacts = getAllRecords() {
            contacts.append(contact)
            return writeToFile(contacts, jsonFileName, fileType: fileType)
        } else {
            return false
        }
    }
    
    func updateRecord(_ contact: Contact)-> Bool {
        let contacts = getAllRecords()
        if var _contacts = contacts, let row = _contacts.firstIndex(where: {$0.id == contact.id}) {
            _contacts[row] = contact
            return writeToFile(_contacts, jsonFileName, fileType: fileType)
        } else {
            return false
        }
    }
    
    private func writeToFile(_ records: [Contact], _ fileName: String, fileType: String)-> Bool {
        if let jsonFilePath = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                let JsonData = try encoder.encode(records)
                try JsonData.write(to: URL(fileURLWithPath: jsonFilePath))
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
}
