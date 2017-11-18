//
//  User_Tests.swift
//  GitHub UnitTests
//
//  Created by Eduardo Irias on 11/18/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import XCTest

class User_Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let userOpExpectation: XCTestExpectation = expectation(description: "Events Request")
        
        DataManager.shared.getUser(username: "octocat") { (user, error) in
            
            guard let user = user else {
                XCTFail()
                return
            }
            
            DataManager.shared.getOrganizations(user: user) { (organizations, error) in
                XCTAssertNotNil(organizations)
                
                let organization = organizations?.first
                
                XCTAssertEqual(organization?.id, 1505520)
                XCTAssertEqual(organization?.username, "estampworld")
                
                userOpExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
