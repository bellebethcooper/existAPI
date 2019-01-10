//
//  Average.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 4/12/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation

public class Average: Codable {
    public let attribute: String
    public let date: Date
    public let overall: Float
    public let monday: Float
    public let tuesday: Float
    public let wednesday: Float
    public let thursday: Float
    public let friday: Float
    public let saturday: Float
    public let sunday: Float
}
