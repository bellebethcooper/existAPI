//
//  ExistAPIDateTests.swift
//  ExistAPITests
//
//  Created by Belle Beth Cooper on 8/1/19.
//  Copyright © 2019 Hello Code. All rights reserved.
//

import Foundation
import XCTest
@testable import ExistAPI

class ExistAPIDateTests: XCTestCase {
    var api: ExistAPI = ExistAPI(token: TEST_TOKEN)
    
    func testUpdating_withDateAfterTomorrow_Throws() {
        let expectation = XCTestExpectation()
        let cal = Calendar.autoupdatingCurrent
        var todayComps = cal.dateComponents([.year, .month, .day, .minute, .second], from: Date())
        todayComps.day! += 3
        let tomorrow = cal.date(from: todayComps)
        let tomorrowUpdate = IntAttributeUpdate(name: "money_spent", date: tomorrow!, value: 30)
        print("test tomo: \(String(describing: try? tomorrowUpdate.dictionaryRepresentation()?["date"]))")
        self.api.update(attributes: [tomorrowUpdate])
            .done { (attributeResponse, urlResponse) in
                print("testUpdating_withDateAfterTomorrow_Throws - attributeResp: \(attributeResponse) urlResp: \(urlResponse)")
            }.catch { (error) in
                print("testUpdating_withDateAfterTomorrow_Throws - error: \(error)")
                expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: TimeInterval(30))
    }
}
