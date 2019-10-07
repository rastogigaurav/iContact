import XCTest
@testable import iContact

class ContactsListViewModelTest: XCTestCase {

    let interactor = DisplayContactsListMock()
    var viewModel: ContactsListViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ContactsListViewModel(with: interactor)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testDidLoad() {
        let didLoadExpectation: XCTestExpectation = expectation(description: "Expected to fetch all the contacts from data.json and view should be reloaded, also relevant method from Interactor")
        viewModel.reload = { [unowned self] in
            XCTAssertEqual(self.viewModel.numberOfRows(), 0)
            XCTAssertTrue(self.interactor.fetchAllContactsCalled)
            didLoadExpectation.fulfill()
        }
        viewModel.didLoad()
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to load all contacts")
            }
        }
    }
    
    func testWillRefereshScreenData() {
        let willRefreshExpectation: XCTestExpectation = expectation(description: "Expected to fetch all the contacts from data.json and view should be refreshed/reloaded, also relevant method from Interactor")
        viewModel.reload = { [unowned self] in
            XCTAssertEqual(self.viewModel.numberOfRows(), 0)
            XCTAssertTrue(self.interactor.fetchAllContactsCalled)
            willRefreshExpectation.fulfill()
        }
        viewModel.willRefreshScreenData()
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to refresh/reload all contacts")
            }
        }
    }
}
