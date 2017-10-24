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
    
    let username = "eduardo22i"
    let projectName = "github-user-profile"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRequests() {
        // This is an example of a functional test case.
        
        let userRequest =  HTTPManager.createRequest(endpoint: .user, path: username, method: .get)
        XCTAssertEqual(userRequest.url?.absoluteString ?? "", "https://api.github.com/users/eduardo22i")
        
        let reposPath = username + "/" + Endpoint.repos.rawValue
        let usersReposRequest = HTTPManager.createRequest(endpoint: .user, path: reposPath)
        XCTAssertEqual(usersReposRequest.url?.absoluteString ?? "", "https://api.github.com/users/eduardo22i/repos")
        
        let branchesPath = username + "/" + projectName + "/" + Endpoint.branches.rawValue
        let branchesRequest = HTTPManager.createRequest(endpoint: .repos, path: branchesPath)
        XCTAssertEqual(branchesRequest.url?.absoluteString ?? "", "https://api.github.com/repos/eduardo22i/github-user-profile/branches")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
