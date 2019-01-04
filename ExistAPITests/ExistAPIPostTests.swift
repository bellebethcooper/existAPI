//
//  ExistAPIPostTests.swift
//  ExistAPITests
//
//  Created by Belle Beth Cooper on 31/12/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import XCTest
@testable import ExistAPI

class ExistAPIPostTests: XCTestCase {
    var api: ExistAPI = ExistAPI(token: TEST_TOKEN)
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testAcquire_Succeeds() {
        let expectation = XCTestExpectation()
        self.api.acquire(names: ["money_spent"])
            .done { (attributeResponse, urlResponse) in
                print("testAcquire_Succeeds - attributeResp: \(attributeResponse) urlResp: \(urlResponse)")
                expectation.fulfill()
            }.catch { (error) in
                print("testAcquire_Succeeds - error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(30))
    }
    
    // NOTE: Make sure you run testAcquire_Succeeds test first
    // or else this test will fail, because the attribute
    // must be acquired before it can be updated
    func testUpdate_Succeeds() {
        let expectation = XCTestExpectation()
        self.api.update(attributes: [["value": 25, "name": "money_spent", "date": "2019-01-03"]])
            .done { (attributeResponse, urlResponse) in
                print("testUpdate_Succeeds - attributeResp: \(attributeResponse) urlResp: \(urlResponse)")
                expectation.fulfill()
            }.catch { (error) in
                print("testUpdate_Succeeds - error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(30))
    }
    
    // NOTE: After running this test, the update test won't work
    // Make sure update has already run before running this one
    func testRelease_Succeeds() {
        let expectation = XCTestExpectation()
        self.api.release(names: ["money_spent"])
            .done { (attributeResponse, urlResponse) in
                print("testRelease_Succeeds - attributeResp: \(attributeResponse) urlResp: \(urlResponse)")
                expectation.fulfill()
            }.catch { (error) in
                print("testRelease_Succeeds - error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(30))
    }
}
