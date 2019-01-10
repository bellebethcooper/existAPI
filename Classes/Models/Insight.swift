//
//  Insight.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation

public struct InsightResponse: Codable {
    public let count: Int
    public var next: String?
    public var previous: String?
    public let results: [Insight]
}

public struct Insight: Codable {
    public let created: Date
    public let targetDate: Date?
    public let type: InsightType
    public let html: String
    public let text: String
    
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
    public let name: String
    public let period: Int
    public let priority: Int
    public let attribute: InsightAttribute
}

public struct InsightAttribute: Codable {
    public let name: String
    public let label: String
    public let group: AttributeGroup
    public let priority: Int
}
