//
//  Correlation.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation


public class Correlation: Codable {
    let date: Date
    let period: Int
    let attribute: String
    let attribute2: String
    let value: Float
    let p: Float
    let percentage: Float
    let stars: Int
    let secondPerson: String
    let secondPersonElements: [String]
    let strengthDescription: String
    let starsDescription: String
    let description: String?
    let occurrence: String?
    let rating: CorrelationRating?
}

public class CorrelationRating: Codable {
    let positive: Bool
    let rating: String
}
