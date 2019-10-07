import XCTest
@testable import iContact

class DisplayContactsListTest: XCTestCase {
    var repository = ContactRepositoryMock()
    var displayContactList: DisplayContactsList!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        displayContactList = DisplayContactsList(with: repository)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        displayContactList = nil
    }
    
    func testFetchAllContacts() {
        let expectationFetchContacts: XCTestExpectation = expectation(description: "Expected to fetch all contacts from data.json and relevant methods in ContactRepository should gets called")
        self.displayContactList.fetchAllContacts { (contacts, message) in
            XCTAssertTrue(self.repository.getAllRecordsCalledSuccessfully)
            expectationFetchContacts.fulfill()
        }
        
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to call fetch Movies from Repository")
            }
        }
    }
}
