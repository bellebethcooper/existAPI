//
//  ExistAPITests.swift
//  ExistAPITests
//
//  Created by Belle Beth Cooper on 9/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import XCTest
@testable import ExistAPI

class ExistAPIGetTests: XCTestCase {
    var api: ExistAPI = ExistAPI(token: TEST_TOKEN)
    
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
                print("testAttributes_returnsAResponse - attributes: \(attributes) resp: \(response)")
                expectation.fulfill()
            }.catch { (error) in
                print("testAttributes_steps_returnsAResponse - error: \(error)")
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
                    print("testAttributes_steps_returnsAResponse - att: \(attribute.name) values: \(values)")
                })
                expectation.fulfill()
            }.catch { (error) in
                print("testAttributes_steps_returnsAResponse - error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(10))
    }

    func testInsights_returnsAResponse() {
        let expectation = XCTestExpectation()
        self.api.insights()
            .done { (insights, response) in
                print("testInsights_returnsAResponse - insights: \(insights) response: \(response)")
                expectation.fulfill()
            }.catch { (error) in
                print("testInsights_returnsAResponse - error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(10))
    }
    
    func testCorrelations_returnsAResponse() {
        let expectation = XCTestExpectation()
        self.api.correlations()
            .done { (correlations, response) in
                print("testCorrelations_returnsAResponse - correlations: \(correlations) response: \(response)")
                expectation.fulfill()
            }.catch { (error) in
                print("testCorrelations_returnsAResponse - error: \(error)")
            }
        self.wait(for: [expectation], timeout: TimeInterval(10))
    }
    
    func testAverages_returnsAResponse() {
        let expectation = XCTestExpectation()
        self.api.averages()
            .done { (averages, response) in
                print("testAverages_returnsAResponse - averages: \(averages) response: \(response)")
                expectation.fulfill()
            }.catch { (error) in
                print("testAverages_returnsAResponse - error: \(error)")
            }
        self.wait(for: [expectation], timeout: TimeInterval(10))
    }

    func testUser_returnsAResponse() {
        let expectation = XCTestExpectation()
        self.api.user()
            .done { (user, response) in
                print("testUser_returnsAResponse - user: \(user) response: \(response)")
                expectation.fulfill()
            }.catch { (error) in
                print("testUser_returnsAResponse - error: \(error)")
        }
        self.wait(for: [expectation], timeout: TimeInterval(10))
    }
}
