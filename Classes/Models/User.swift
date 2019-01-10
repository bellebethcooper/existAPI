//
//  User.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 4/12/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation

public class User: Codable {
    public let id: Int
    public let username: String
    public let firstName: String
    public let lastName: String
    public let bio: String
    public let url: String
    public let avatar: String
    public let timezone: String
    public let imperialUnits: Bool
    public let imperialDistance: Bool
    public let imperialWeight: Bool
    public let imperialEnergy: Bool
    public let imperialLiquid: Bool
    public let imperialTemperature: Bool
    public let trial: Bool
    public let delinquent: Bool
}
