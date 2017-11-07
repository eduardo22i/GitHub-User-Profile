//
//  Events_Tests.swift
//  GitHub UnitTests
//
//  Created by Eduardo Irias on 11/7/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import XCTest

class Events_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEventsRequest() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let userOpExpectation: XCTestExpectation = expectation(description: "Events Request")

        
        DataManager.shared.getEvents(username: "octocat") { (events, error) in
            XCTAssertNotNil(events)
            
            XCTAssertEqual(events?.count, 1)
            
            let event = events?.first
            
            XCTAssertEqual(event?.id, "12345")
            XCTAssertEqual(event?.actor?.username, "octocat")
            XCTAssertEqual(event?.type, .watchEvent )
            
            userOpExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)

    }
    
}
