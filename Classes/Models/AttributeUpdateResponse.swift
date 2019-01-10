//
//  AttributeUpdateResponse.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 8/1/19.
//  Copyright © 2019 Hello Code. All rights reserved.
//

import Foundation

public struct AttributeUpdateResponse: Codable {
    public var success: [SuccessfullyUpdatedAttribute]?
    public var failed: [FailedToUpdateAttribute]?
}

public struct SuccessfullyUpdatedAttribute: Codable {
    public var name: String
    public var date: Date
    public var value: String?
    
    enum CodingKeys: CodingKey {
        case name
        case date
        case value
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.date = try container.decode(Date.self, forKey: .date)
        var stringValue: String? = nil
        if let string = try? container.decode(String.self, forKey: .value) {
            stringValue = string
        }
        if let number = try? container.decode(Float.self, forKey: .value) {
            stringValue = String(number)
        }
        self.value = stringValue
    }
}

public struct FailedToUpdateAttribute: Codable {
    public var name: String?
    public var date: Date?
    public var value: String?
    public var errorCode: String
    public var error: String
    
    enum CodingKeys: CodingKey {
        case name
        case date
        case value
        case errorCode
        case error
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.date = try container.decode(Date.self, forKey: .date)
        var stringValue: String? = nil
        if let string = try? container.decode(String.self, forKey: .value) {
            stringValue = string
        }
        if let number = try? container.decode(Float.self, forKey: .value) {
            stringValue = String(number)
        }
        self.value = stringValue
        self.error = try container.decode(String.self, forKey: .error)
        self.errorCode = try container.decode(String.self, forKey: .errorCode)
    }
}
