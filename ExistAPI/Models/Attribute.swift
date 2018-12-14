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
}

public enum AttributeError: Error {
    case wrongAttributeValueType
}

public class Attribute: Codable, AttributeValues {
    let attribute: String
    let label: String
    let group: AttributeGroup
    let priority: Int
    let service: String
    let valueType: Int
    let valueTypeDescription: String
    private let values: [AttributeData]
    
    public func getIntValues() throws -> [IntValue] {
        guard self.valueType == 0 else {
            // not an Int
            throw AttributeError.wrongAttributeValueType
        }
        return self.values.compactMap { (attributeData) -> IntValue? in
            guard let string = attributeData.value else {
                return IntValue(value: nil, date: attributeData.date)
            }
            guard let v: Int = Int(string) else { return nil }
            return IntValue(value: v, date: attributeData.date)
        }
    }
    
    public func getStringValues() throws -> [StringValue] {
        guard self.valueType == 2 else {
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

public class AttributeGroup: Codable {
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
