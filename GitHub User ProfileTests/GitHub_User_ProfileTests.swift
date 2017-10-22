//
//  GitHub_User_ProfileTests.swift
//  GitHub User ProfileTests
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp World. All rights reserved.
//

import UIKit
import XCTest

class GitHub_User_ProfileTests: XCTestCase {
    
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
        
        let request =  HTTPManager.createRequest(endpoint: .user, path: "eduardo22i", method: .get)
        XCTAssertEqual(request.url?.absoluteString ?? "", "https://api.github.com/users/eduardo22i")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
