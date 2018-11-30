//
//  Insight.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation

class Insight: Codable {
    let created: Date
    let targetDate: Date
    let type: InsightType
    let html: String
    let text: String
}

class InsightType: Codable {
    let name: String
    let period: Int
    let priority: Int
    let attribute: InsightAttribute
}

class InsightAttribute: Codable {
    let name: String
    let label: String
    let group: AttributeGroup
    let priority: Int
}

class InsightGroup: Codable {
    let name: String
    let label: String
    let priority: Int
}
