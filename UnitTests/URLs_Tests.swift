//
//  GitHub_User_ProfileTests.swift
//  GitHub User ProfileTests
//
//  Created by Eduardo Irías on 8/16/15.
//  Copyright (c) 2015 Estamp. All rights reserved.
//

import XCTest
//@testable import GitHub_iOS

class GitHub_User_ProfileTests: XCTestCase {
    
    let clientId = "12345"
    let username = "octocat"
    let projectName = "hello-worId"
    let branch = "developer"
    
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
        
        let userRequest =  HTTPManager.createRequest(endpoint: .users, path: username, method: .get)
        XCTAssertEqual(userRequest.url?.absoluteString ?? "", "https://api.github.com/users/octocat")
        
        let reposPath = username + "/" + Endpoint.repos.rawValue
        let usersReposRequest = HTTPManager.createRequest(endpoint: .users, path: reposPath)
        XCTAssertEqual(usersReposRequest.url?.absoluteString ?? "", "https://api.github.com/users/octocat/repos")
        
        let branchesPath = username + "/" + projectName + "/" + Endpoint.branches.rawValue
        let branchesRequest = HTTPManager.createRequest(endpoint: .repos, path: branchesPath)
        XCTAssertEqual(branchesRequest.url?.absoluteString ?? "", "https://api.github.com/repos/octocat/hello-worId/branches")
        
        let commitsPath = username + "/" + projectName + "/" + Endpoint.commits.rawValue
        let commitsRequest = HTTPManager.createRequest(endpoint: .repos, path: commitsPath, parameters: ["sha" : "commits"])
        XCTAssertEqual(commitsRequest.url?.absoluteString ?? "", "https://api.github.com/repos/octocat/hello-worId/commits?sha=commits")
        
    }
    
    func testReadMeRequest() {
        
        let path = username + "/" + projectName + "/" + Endpoint.readme.rawValue

        let request =  HTTPManager.createRequest(endpoint: .repos, path: path, method: .get)
        
        XCTAssertEqual(request.url?.absoluteString ?? "", "https://api.github.com/repos/octocat/hello-worId/readme")
        
    }
    
    
    func testLoginRequest() {
        
        let path = Endpoint.client.rawValue + "/" + clientId
        
        let request =  HTTPManager.createRequest(endpoint: .authorization, path: path, method: .put)
        
        XCTAssertEqual(request.url?.absoluteString ?? "", "https://api.github.com/authorizations/clients/12345")
        
    }
    
    
    func testUserOrganizationsRequest() {
        
        let path = username + "/" + Endpoint.organizations.rawValue
        
        let request =  HTTPManager.createRequest(endpoint: .users, path: path)
        
        XCTAssertEqual(request.url?.absoluteString, "https://api.github.com/users/octocat/orgs")
        
    }
    
    func testEventsRequest() {
        
        let path = username + "/" + Endpoint.events.rawValue
        
        let request =  HTTPManager.createRequest(endpoint: .users, path: path)
        
        XCTAssertEqual(request.url?.absoluteString ?? "", "https://api.github.com/users/octocat/received_events")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
