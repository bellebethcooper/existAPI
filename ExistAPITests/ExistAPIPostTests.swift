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
        let todayComps = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day], from: Date())
        let date = Calendar.autoupdatingCurrent.date(from: todayComps)!
        let money = IntAttributeUpdate(name: "money_spent", date: date, value: 45)
        let caffeine = FloatAttributeUpdate(name: "caffeine", date: date, value: 14.5)
        self.api.update(attributes: [money, caffeine])
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
