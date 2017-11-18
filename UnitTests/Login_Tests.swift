//
//  Login_Tests.swift
//  GitHub UnitTests
//
//  Created by Eduardo Irias on 10/31/17.
//  Copyright © 2017 Estamp. All rights reserved.
//

import XCTest

class Login_Tests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        DataManager.shared.clientId = "12345"
        DataManager.shared.clientSecretId = "1234567890"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequestEncoding() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let json = try? encoder.encode(LoginRequest())
        
        
        XCTAssertNotNil(json)
    }
    
    func testLogin() {
        
        let userOpExpectation: XCTestExpectation = expectation(description: "Login Request")
        
        DataManager.shared.postLogin(username: "octocat", password: "password") { (user, error) in
            
            XCTAssertNotNil(user)
            
            XCTAssertEqual(user?.username, "octocat")
            XCTAssertEqual(user?.name, "monalisa octocat")
            XCTAssertEqual(user?.type, .user )
            XCTAssertEqual((user as? User.Individual)?.company, "GitHub")
            
            userOpExpectation.fulfill()
            
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
}
