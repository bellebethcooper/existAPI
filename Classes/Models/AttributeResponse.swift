//
//  AttributeResponse.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 8/1/19.
//  Copyright © 2019 Hello Code. All rights reserved.
//

import Foundation

public struct AttributeResponse: Codable {
    public var success: [SuccessfulAttribute]?
    public var failed: [FailedAttribute]?
}

public struct SuccessfulAttribute: Codable {
    public var name: String
    public var active: Bool?
}

public struct FailedAttribute: Codable {
    public var name: String
    public var errorCode: String
    public var error: String
}
