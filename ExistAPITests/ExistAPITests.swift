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
    
    func testAttributes_returnsAResponse() {
        let expectation = XCTestExpectation()
        self.api.attributes(names: nil,
                            limit: 2,
                            minDate: nil,
                            maxDate: nil)
            .done { (attributes, response) in
                attributes.forEach({ (attribute) in
                    switch attribute.valueType {
                    case .int:
                        print("testAttributes_returnsAResponse: \(attribute.name) values: \(try! attribute.getIntValues())")
                    case .string:
                        print("testAttributes_returnsAResponse: \(attribute.name) values: \(try! attribute.getStringValues())")
                    default:
                        print("testAttributes_returnsAResponse: \(attribute.name) isn't int or string")
                    }
                })
                //                print("resp: \(response)")
                expectation.fulfill()
            }.catch { (error) in
                print("error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(10))
    }

    func testAttributes_steps_returnsAResponse() {
        let expectation = XCTestExpectation()
        self.api.attributes(names: ["steps"],
                            limit: 2,
                            minDate: nil,
                            maxDate: nil)
            .done { (attributes, response) in
                attributes.forEach({ (attribute) in
                    let values = try! attribute.getIntValues()
                    print("att: \(attribute.name) values: \(values)")
                })
//                print("resp: \(response)")
                expectation.fulfill()
            }.catch { (error) in
                print("error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(10))
    }

}
