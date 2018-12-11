//
//  Insight.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation

public class Insight: Codable {
    let created: Date
    let targetDate: Date
    let type: InsightType
    let html: String
    let text: String
}

public class InsightType: Codable {
    let name: String
    let period: Int
    let priority: Int
    let attribute: InsightAttribute
}

public class InsightAttribute: Codable {
    let name: String
    let label: String
    let group: AttributeGroup
    let priority: Int
}

public class InsightGroup: Codable {
    let name: String
    let label: String
    let priority: Int
}
