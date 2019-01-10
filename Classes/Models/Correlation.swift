//
//  Correlation.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation


public class Correlation: Codable {
    public let date: Date
    public let period: Int
    public let attribute: String
    public let attribute2: String
    public let value: Float
    public let p: Float
    public let percentage: Float
    public let stars: Int
    public let secondPerson: String
    public let secondPersonElements: [String]
    public let strengthDescription: String
    public let starsDescription: String
    public let description: String?
    public let occurrence: String?
    public let rating: CorrelationRating?
}

public class CorrelationRating: Codable {
    public let positive: Bool
    public let rating: String
}
