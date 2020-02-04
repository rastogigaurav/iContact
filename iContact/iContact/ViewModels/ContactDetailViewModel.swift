import UIKit

protocol ContactDetailViewModelProtocol {
    func didLoad()
    
    func numberOfSections()-> Int
    
    func numberOfRow(inSectionAt index: Int)-> Int
    
    func didEndEditing(forRowAt indexPath: IndexPath, newValue: String)
    
    func title(forSectionAt index: Int)-> String
    
    func description(forRowAt indexPath: IndexPath)-> String
    
    func detail(forRowAt indexPath: IndexPath, handler: ((_ text: String, _ isPlaceholder: Bool, _ keyboardType: UIKeyboardType?)-> Void))
    
    func returnKeyType(forRowAt indexPath:IndexPath)-> UIReturnKeyType
    
    func nextIndexPath(for indexPath: IndexPath)-> IndexPath?
    
    func fullName()-> String
    
    func didTapLeftNavigation(_ handler: ((_ message: String?)->Void)?)
    
    func didTapRightNavigation(_ handler: ((_ message: String?)->Void)?)
}

class ContactDetailViewModel {
    enum ScreenState {
        case add
        case edit
    }
    
    enum SectionType: Int {
        case main = 0
        case sub
        
        func title()-> String {
            switch self {
            case .main:
                return "Main Information"
            case .sub:
                return "Sub Information"
            }
        }
    }
    
    enum RowType: Int {
        case firstName = 0
        case lastName
        case email
        case phone
        
        func description()-> String {
            switch self {
            case .firstName:
                return "First Name"
            case .lastName:
                return "Last Name"
            case .email:
                return "Email"
            case .phone:
                return "Phone"
            }
        }
        
        func placeHolder()-> String {
            switch self {
            case .firstName:
                return "Enter your First Name"
            case .lastName:
                return "Enter your Last Name"
            case .email:
                return "Enter your Email Address"
            case .phone:
                return "Enter your Phone Number"
            }
        }
        
        func keyboardType()-> UIKeyboardType {
            switch self {
            case .firstName:
                return .default
            case .lastName:
                return .default
            case .email:
                return .emailAddress
            case .phone:
                return .phonePad
            }
        }
    }
    
    typealias VisibleRow = (section: SectionType, mappingRows: [RowType])
    
    private var state: ScreenState = .add {
        didSet {
            var leftBtnTitle = ""
            switch self.state {
            case .add, .edit:
                leftBtnTitle = "Cancel"
            }
            
            var rightBtnTitle = ""
            switch self.state {
            case .add:
                rightBtnTitle = "Add"
            case .edit:
                rightBtnTitle = "Save"
            }
            reload()
            updateLeftBarItemStats(leftBtnTitle)
            updateRightBarItemStats(rightBtnTitle)
        }
    }
    private var interactor: DisplayContactProtocol
    var updateRightBarItemStats: ((String)-> Void) = { _  in }
    var updateLeftBarItemStats: ((String)-> Void) = { _ in }
    var reload: (()-> Void) = {}
    var contact: Contact!
    private var visibleSections: [VisibleRow] = [(section: .main, mappingRows: [.firstName, .lastName]), (section: .sub, mappingRows: [.email, .phone])]
    init(with interactor: DisplayContactProtocol) {
        self.interactor = interactor
    }
}

extension ContactDetailViewModel: ContactDetailViewModelProtocol {
    func didLoad() {
        if let id = contact?.id, !id.isEmpty {
            self.state = .edit
        } else {
            self.state = .add
        }
        reload()
    }
    
    func numberOfSections() -> Int {
        return visibleSections.count
    }
    
    func numberOfRow(inSectionAt index: Int) -> Int {
        return visibleSections[index].mappingRows.count
    }
    
    func didEndEditing(forRowAt indexPath: IndexPath, newValue: String) {
        if let visibleRow = visibleSections.first(where: {$0.section == SectionType(rawValue: indexPath.section)}) {
            let rowType = visibleRow.mappingRows[indexPath.row]
            switch (rowType) {
            case .firstName:
                contact.firstName = newValue
            case .lastName:
                contact.lastName = newValue
            case .email:
                contact.email = newValue
            case .phone:
                contact.phone = newValue
            }
        }
    }
    
    func title(forSectionAt index: Int) -> String {
        return visibleSections[index].section.title()
    }
    
    func description(forRowAt indexPath: IndexPath) -> String {
        return visibleSections[indexPath.section].mappingRows[indexPath.row].description()
    }
    
    func fullName() -> String {
        let firstName = contact?.firstName ?? ""
        let lastName = contact?.lastName ?? ""
        return firstName + " " + lastName
    }
    
    func didTapLeftNavigation(_ handler: ((String?)-> Void)?) {
        guard let _handler = handler else { return }
        _handler(nil)
    }
    
    func didTapRightNavigation(_ handler: ((String?) -> Void)?) {
        guard let _handler = handler else { return }
        if self.state == .edit {
            self.interactor.updateContact(contact) { (isUpdated, message) in
                if isUpdated {
                    reload()
                }
                _handler(message)
            }
        } else if self.state == .add {
            self.interactor.addContact(contact) { (isAdded, message) in
                if isAdded {
                    reload()
                }
                _handler(message)
            }
        } else {
            self.state = .edit
        }
    }
    
    func detail(forRowAt indexPath: IndexPath, handler: ((String, Bool, UIKeyboardType?) -> Void)) {
        let rowType = visibleSections[indexPath.section].mappingRows[indexPath.row]
        switch rowType {
        case .firstName:
            if let contact = contact, let firstName = contact.firstName, !firstName.isEmpty {
                handler(firstName, false, rowType.keyboardType())
            } else {
                handler(rowType.placeHolder(), true, rowType.keyboardType())
            }
        case .lastName:
            if let contact = contact, let lastName = contact.lastName, !lastName.isEmpty {
                handler(lastName, false, rowType.keyboardType())
            } else {
                handler(rowType.placeHolder(), true, rowType.keyboardType())
            }
        case .email:
            if let contact = contact, let email = contact.email, !email.isEmpty {
                handler(email, false, rowType.keyboardType())
            } else {
                handler(rowType.placeHolder(), true, rowType.keyboardType())
            }
        case .phone:
            if let contact = contact, let phone = contact.phone, !phone.isEmpty {
                handler(phone, false, rowType.keyboardType())
            } else {
                handler(rowType.placeHolder(), true, rowType.keyboardType())
            }
        }
    }
    
    func nextIndexPath(for indexPath: IndexPath) -> IndexPath? {
        var nextRow = 0
        var nextSection = 0
        var iteration = 0
        var startRow = indexPath.row
        for section in indexPath.section ..< numberOfSections() {
            nextSection = section
            for row in startRow ..< numberOfRow(inSectionAt: section) {
                nextRow = row
                iteration += 1
                if iteration == 2 {
                    let nextIndexPath = IndexPath(row: nextRow, section: nextSection)
                    return nextIndexPath
                }
            }
            startRow = 0
        }
        return nil
    }
    
    func returnKeyType(forRowAt indexPath: IndexPath) -> UIReturnKeyType {
        let lastSection = visibleSections.count - 1
        let lastRow = visibleSections[lastSection].mappingRows.count - 1
        let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
        if indexPath == lastIndexPath {
            return .done
        } else {
            return .next
        }
    }
}
