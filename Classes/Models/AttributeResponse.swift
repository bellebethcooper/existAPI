//
//  AttributeResponse.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 8/1/19.
//  Copyright © 2019 Hello Code. All rights reserved.
//

import Foundation

public struct AttributeResponse: Codable {
    var success: [SuccessfulAttribute]?
    var failed: [FailedAttribute]?
}

public struct SuccessfulAttribute: Codable {
    var name: String
    var active: Bool?
}

public struct FailedAttribute: Codable {
    var name: String
    var errorCode: String
    var error: String
}
