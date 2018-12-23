//
//  Models.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation


public protocol AttributeValues {
    func getIntValues() throws -> [IntValue]
    func getStringValues() throws -> [StringValue]
    func getFloatValues() throws -> [FloatValue]
}

public enum AttributeError: Error {
    case wrongAttributeValueType
}

public enum ValueType {
    case int, float, string, periodMin, minFromMidnight, minFromMidday
}

public struct Attribute: AttributeValues {
    let name: String
    let label: String
    let group: AttributeGroup
    let priority: Int
    let service: String
    let valueType: ValueType
    let valueTypeDescription: String
    private let values: [AttributeData]
    
    enum CodingKeys: String, CodingKey {
        case name = "attribute", label, group, priority, service, valueType, valueTypeDescription, values
    }
}

extension Attribute: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.label = try values.decode(String.self, forKey: .label)
        self.group = try values.decode(AttributeGroup.self, forKey: .group)
        self.priority = try values.decode(Int.self, forKey: .priority)
        self.service = try values.decode(String.self, forKey: .service)
        let type = try values.decode(Int.self, forKey: .valueType)
        switch type {
        case 0:
            self.valueType = .int
        case 1:
            self.valueType = .float
        case 2:
            self.valueType = .string
        case 3:
            self.valueType = .periodMin
        case 4:
            self.valueType = .minFromMidnight
        case 6:
            self.valueType = .minFromMidday
        default:
            self.valueType = .string
        }
        self.valueTypeDescription = try values.decode(String.self, forKey: .valueTypeDescription)
        self.values = try values.decode([AttributeData].self, forKey: .values)
    }
}

// MARK: get values
public extension Attribute {
    
    public func getIntValues() throws -> [IntValue] {
        switch self.valueType {
        case .int, .minFromMidday, .minFromMidnight, .periodMin:
            return self.values.compactMap { (attributeData) -> IntValue? in
                guard let string = attributeData.value else {
                    return IntValue(value: nil, date: attributeData.date)
                }
                guard let v: Int = Int(string) else { return nil }
                return IntValue(value: v, date: attributeData.date)
            }
        default:
            // not an Int
            throw AttributeError.wrongAttributeValueType
        }
    }
    
    public func getStringValues() throws -> [StringValue] {
        guard case ValueType.string = self.valueType else {
            // not a string
            throw AttributeError.wrongAttributeValueType
        }
        return self.values.compactMap { (attributeData) -> StringValue? in
            guard let string = attributeData.value else {
                return StringValue(value: nil, date: attributeData.date)
            }
            return StringValue(value: string, date: attributeData.date)
        }
    }
    
    public func getFloatValues() throws -> [FloatValue] {
        guard case ValueType.float = self.valueType else {
            // not a float
            throw AttributeError.wrongAttributeValueType
        }
        return self.values.compactMap { (attributeData) -> FloatValue? in
            guard let string = attributeData.value else {
                return FloatValue(value: nil, date: attributeData.date)
            }
            guard let v: Float = Float(string) else { return nil }
            return FloatValue(value: v, date: attributeData.date)
        }
    }
}

public protocol ValueObject {
    associatedtype ValueType
    var value: ValueType? { get }
    var date: Date { get }
}

public struct IntValue: ValueObject {
    public typealias ValueType = Int
    public var value: Int?
    public var date: Date
}

public struct StringValue: ValueObject {
    public typealias ValueType = String
    public var value: String?
    public var date: Date
}

public struct FloatValue: ValueObject {
    public typealias ValueType = Float
    public var value: Float?
    public var date: Date
}

public struct AttributeGroup: Codable {
    let name: String
    let label: String
    let priority: Int
}

public struct AttributeData: Codable {
    var value: String?
    let date: Date
    
    enum CodingKeys: CodingKey {
        case value
        case date
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.date, forKey: .date)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
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
