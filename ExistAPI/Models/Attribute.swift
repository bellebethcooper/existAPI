//
//  Models.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation


public class Attribute: Codable {
    let name: String
    let label: String
    let group: AttributeGroup
    let priority: Int
    let serviceName: String
    let valueType: Int
    let valueTypeDescription: String
    let isPrivate: Bool
    let values: [AttributeData]
}

public class AttributeGroup: Codable {
    let name: String
    let label: String
    let priority: Int
}

public class AttributeData: Codable {
    let value: ValueType
    let date: Date
}

public enum ValueType: Codable {
    case string(String)
    case int(Int)
    case float(Float)
    case periodMin(Int)
    case minFromMidnight(Int)
    case minFromMidday(Int)
    
    enum CodingKeys: CodingKey {
        case string, int, float, periodMin, minFromMidnight, minFromMidday
    }
    
    enum CodingError: Error { case decoding(String) }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .string(let value):
            try container.encode(value, forKey: .string)
        case .int(let value):
            try container.encode(value, forKey: .int)
        case .float(let value):
            try container.encode(value, forKey: .float)
        case .periodMin(let value):
            try container.encode(value, forKey: .periodMin)
        case .minFromMidnight(let value):
            try container.encode(value, forKey: .minFromMidnight)
        case .minFromMidday(let value):
            try container.encode(value, forKey: .minFromMidday)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let stringValue = try? container.decode(String.self, forKey: .string) {
            self = .string(stringValue)
            return
        }
        
        if let intValue = try? container.decode(Int.self, forKey: .int) {
            self = .int(intValue)
            return
        }
        
        if let floatValue = try? container.decode(Float.self, forKey: .float) {
            self = .float(floatValue)
            return
        }
        
        if let periodValue = try? container.decode(Int.self, forKey: .periodMin) {
            self = .periodMin(periodValue)
            return
        }
        
        throw CodingError.decoding("Decoding Failed. \(container)")
    }
}
