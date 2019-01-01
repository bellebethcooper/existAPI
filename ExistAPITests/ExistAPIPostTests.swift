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
    
    func testRelease_Succeeds() {
        let expectation = XCTestExpectation()
        self.api.release(names: ["money_spent"])
            .done { (attributeResponse, urlResponse) in
                print("testAcquire_Succeeds - attributeResp: \(attributeResponse) urlResp: \(urlResponse)")
                expectation.fulfill()
            }.catch { (error) in
                print("testAcquire_Succeeds - error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(30))
    }
}
