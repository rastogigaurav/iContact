import XCTest
@testable import iContact

class DisplayContactTest: XCTestCase {
    
    let repository = ContactRepositoryMock()
    var displayContact: DisplayContact!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        displayContact = DisplayContact(with: repository)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        displayContact = nil
    }
    
    func testAddContact() {
        let expectationAddContact: XCTestExpectation = expectation(description: "Expected to add contact into data.json and relevant methods in ContactRepository should gets called")
        let contact = Contact(id: "id", firstName: "FirstName", lastName: "LastName", email: "email@email.com", phone: "Phone", image: "Image")
        self.displayContact.addContact(contact) { (success, message) in
            XCTAssertTrue(success)
            XCTAssertEqual(message, ResponseMessage.addSuccess.rawValue)
            XCTAssertTrue(self.repository.addNewRecordCalledSuccessfully)
            expectationAddContact.fulfill()
        }
        
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to Add Contact into json")
            }
        }
    }
    
    func testUpdateContact() {
        let expectationUpdateContact: XCTestExpectation = expectation(description: "Expected to update existing contact into data.json and relevant methods in ContactRepository should gets called")
        let contact = Contact(id: "id", firstName: "FirstName", lastName: "LastName", email: "email@email.com", phone: "Phone", image: "Image")
        self.displayContact.updateContact(contact) { (success, message) in
            XCTAssertTrue(success)
            XCTAssertEqual(message, ResponseMessage.updateSuccess.rawValue)
            XCTAssertTrue(self.repository.updateRecordCalledSuccessfully)
            expectationUpdateContact.fulfill()
        }
        
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to Update Contact into json")
            }
        }
    }
}
