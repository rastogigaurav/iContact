//
//  ContactRepositoryTest.swift
//  iContactTests
//
//  Created by venbq8 on 6/10/19.
//  Copyright © 2019 Gaurav Rastogi. All rights reserved.
//

import XCTest
@testable import iContact

class ContactRepositoryTest: XCTestCase {

    var repository: ContactRepository!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        repository = ContactRepository()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        repository = nil
    }
    
    func testGetAllRecords() {
        let expectationGetAllRecords: XCTestExpectation = expectation(description: "Expected to fetch all records from data.json with success response message")
        self.repository.getAllRecords { (contacts, message) in
            XCTAssertNotNil(contacts)
            XCTAssertEqual(message, ResponseMessage.getSuccess.rawValue)
            expectationGetAllRecords.fulfill()
        }
        waitForExpectations(timeout: 4.0) { (error) in
            if let _ = error{
                XCTFail("Failed to get all records from json")
            }
        }
    }
}
