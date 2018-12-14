//
//  ExistAPITests.swift
//  ExistAPITests
//
//  Created by Belle Beth Cooper on 9/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import XCTest
@testable import ExistAPI

class ExistAPITests: XCTestCase {
    var api: ExistAPI = ExistAPI(token: "da50757e605c7918738ee93e00fa10c83321ca85")
    
    override func setUp() {
    }

    override func tearDown() {
        
    }

    func testAttributesReturnsAResponse() {
        let expectation = XCTestExpectation()
        self.api.attributes(names: ["steps"],
                            limit: 2,
                            minDate: nil,
                            maxDate: nil)
            .done { (attributes, response) in
                attributes.forEach({ (attribute) in
                    let values = try! attribute.getIntValues()
                    print("att: \(attribute.attribute) values: \(values)")
                })
//                print("resp: \(response)")
                expectation.fulfill()
            }.catch { (error) in
                print("error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(10))
    }

}
