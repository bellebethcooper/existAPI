//
//  User.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 4/12/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation

public class User: Codable {
    let id: Int
    let username: String
    let firstName: String
    let lastName: String
    let bio: String
    let url: String
    let avatarURL: String
    let timezone: String
    let localTime: Date
    let isPrivate: Bool
    let imperialUnits: Bool
    let imperialDistance: Bool
    let imperialWeight: Bool
    let imperialEnergy: Bool
    let imperialLiquid: Bool
    let imperialTemperature: Bool
    let onTrial: Bool
    let delinquent: Bool
    let iosNoCard: Bool
    let iOSTrialEnd: Date
    let isiOSCustomer: Bool
}
