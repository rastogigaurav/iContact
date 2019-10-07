import XCTest
@testable import iContact

class ContactDetailViewModelTest: XCTestCase {

    let repository = ContactRepositoryMock()
    var interactor: DisplayContact!
    var viewModel: ContactDetailViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        interactor = DisplayContact(with: repository)
        viewModel = ContactDetailViewModel(with: interactor)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testDidLoadOnTappingContactFromList() {
        let didLoadExpectation: XCTestExpectation = expectation(description: "Expected to load screen on tapping any contact from Contact List on previous screen and right navigation button title should be Edit")
        let expectedRightBtnTitle = "Save"
        let contact = Contact(id: "id", firstName: "FirstName", lastName: "LastName", email: "Email", phone: "Phone", image: "Image")
        viewModel.contact = contact
        viewModel.updateRightBarItemStats = { title in
            XCTAssertEqual(title, expectedRightBtnTitle)
            didLoadExpectation.fulfill()
        }
        viewModel.didLoad()
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to refresh/reload all contacts")
            }
        }
    }
    
    func testDidLoadOnTappingAddContact() {
        let didLoadExpectation: XCTestExpectation = expectation(description: "Expected to load screen on tapping add contact on previous screen and right navigation button title should be Add")
        let expectedRightBtnTitle = "Add"
        viewModel.updateRightBarItemStats = { title in
            XCTAssertEqual(title, expectedRightBtnTitle)
            didLoadExpectation.fulfill()
        }
        viewModel.didLoad()
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to refresh/reload all contacts")
            }
        }
    }
    
    func testUpdateContactSuccessful() {
        let expectationUpdateContactSuccessful:XCTestExpectation = expectation(description: "Expected to recieve success == true while updating a contact with valid data")
        let contact = Contact(id: "id", firstName: "FirstName", lastName: "LastName", email: "email@email.com", phone: "Phone", image: "Image")
        viewModel.contact = contact
        interactor.updateContact(contact) { (success, message) in
            XCTAssertTrue(repository.updateRecordCalledSuccessfully)
            XCTAssertTrue(success)
            XCTAssertEqual(message, ResponseMessage.updateSuccess.rawValue)
            expectationUpdateContactSuccessful.fulfill()
        }
        viewModel.didTapRightNavigation { _ in }
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to update contact")
            }
        }
    }
    
    func testUpdateContactFirstNameValidations() {
        let expectationEmptyStringFirstName:XCTestExpectation = expectation(description: "Expected to display Blank First Name Error, when trying to update any contact without FirstName")
        let firstNameEmptyStringContact = Contact()
        viewModel.contact = firstNameEmptyStringContact
        interactor.updateContact(firstNameEmptyStringContact) { (success, message) in
            XCTAssertFalse(success)
            XCTAssertEqual(message, ResponseMessage.failureMissingFirstName.rawValue)
            expectationEmptyStringFirstName.fulfill()
        }
        viewModel.didTapRightNavigation { _ in }
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to update contact")
            }
        }
    }
    
    func testUpdateContactLastNameValidations() {
        let expectationEmptyStringLastName:XCTestExpectation = expectation(description: "Expected to display Blank Last Name Error, when trying to update any contact without Last")
        let lastNameEmptyStringContact = Contact(id: "id", firstName: "FirstName", lastName: "", email: "Email", phone: "Phone", image: "Image")
        viewModel.contact = lastNameEmptyStringContact
        interactor.updateContact(lastNameEmptyStringContact) { (success, message) in
            XCTAssertFalse(success)
            XCTAssertEqual(message, ResponseMessage.falireMissingLastName.rawValue)
            expectationEmptyStringLastName.fulfill()
        }
        viewModel.didTapRightNavigation { _ in }
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to update contact")
            }
        }
    }
    
    func testAddContactSuccessful() {
        let expectationUpdateContactSuccessful:XCTestExpectation = expectation(description: "Expected to recieve success == true while adding a new contact with valid data")
        let contact = Contact(id: "", firstName: "FirstName", lastName: "LastName", email: "email@email.com", phone: "Phone", image: "Image")
        viewModel.contact = contact
        interactor.addContact(contact) { (success, message) in
            XCTAssertTrue(repository.addNewRecordCalledSuccessfully)
            XCTAssertTrue(success)
            XCTAssertEqual(message, ResponseMessage.addSuccess.rawValue)
            expectationUpdateContactSuccessful.fulfill()
        }
        viewModel.didTapRightNavigation { _ in }
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to update contact")
            }
        }
    }
    
    func testAddContactFirstNameValidations() {
        let expectationEmptyStringFirstName:XCTestExpectation = expectation(description: "Expected to display Blank First Name Error, when trying to add contact without First Name")
        let firstNameEmptyStringContact = Contact()
        viewModel.contact = firstNameEmptyStringContact
        interactor.addContact(firstNameEmptyStringContact) { (success, message) in
            XCTAssertFalse(success)
            XCTAssertEqual(message, ResponseMessage.failureMissingFirstName.rawValue)
            expectationEmptyStringFirstName.fulfill()
        }
        viewModel.didTapRightNavigation { _ in }
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to update contact")
            }
        }
    }
    
    func testAddContactLastNameValidations() {
        let expectationEmptyStringLastName:XCTestExpectation = expectation(description: "Expected to display Blank First Name Error, when trying to add contact without Last Name")
        let lastNameEmptyStringContact = Contact(id: "id", firstName: "FirstName", lastName: "", email: "Email", phone: "Phone", image: "Image")
        viewModel.contact = lastNameEmptyStringContact
        interactor.addContact(lastNameEmptyStringContact) { (success, message) in
            XCTAssertFalse(success)
            XCTAssertEqual(message, ResponseMessage.falireMissingLastName.rawValue)
            expectationEmptyStringLastName.fulfill()
        }
        viewModel.didTapRightNavigation { _ in }
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to update contact")
            }
        }
    }
    
    func testSectionTitle() {
        let expectedFirstSectionTitle = "Main Information"
        XCTAssertEqual(viewModel.title(forSectionAt: 0), expectedFirstSectionTitle)
        
        let expectedSecondSectionTitle = "Sub Information"
        XCTAssertEqual(viewModel.title(forSectionAt: 1), expectedSecondSectionTitle)
    }
}
