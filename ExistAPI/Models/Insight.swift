//
//  Insight.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation

public struct InsightResponse: Codable {
    let count: Int
    var next: String?
    var previous: String?
    let results: [Insight]
}

public struct Insight: Codable {
    let created: Date
    let targetDate: Date?
    let type: InsightType
    let html: String
    let text: String
    
    enum CodingKeys: CodingKey {
        case created, targetDate, type, html, text
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.created = try container.decode(Date.self, forKey: .created)
        if let targetDateString = try? container.decode(String.self, forKey: .targetDate) {
            print("targetdatestring: \(targetDateString)")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            self.targetDate = formatter.date(from: targetDateString)
            print("target date: \(self.targetDate)")
        } else {
            self.targetDate = nil
        }
        self.type = try container.decode(InsightType.self, forKey: .type)
        self.html = try container.decode(String.self, forKey: .html)
        self.text = try container.decode(String.self, forKey: .text)
    }
}

public struct InsightType: Codable {
    let name: String
    let period: Int
    let priority: Int
    let attribute: InsightAttribute
}

public struct InsightAttribute: Codable {
    let name: String
    let label: String
    let group: AttributeGroup
    let priority: Int
}
