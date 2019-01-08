//
//  AttributeUpdate.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 8/1/19.
//  Copyright © 2019 Hello Code. All rights reserved.
//

import Foundation

public protocol AttributeUpdate: Codable {
    associatedtype Value: Codable
    var name: String { get }
    var date: Date { get }
    var value: Value { get }
    func dictionaryRepresentation() -> [String: Any]?
}

extension AttributeUpdate {
    public func dictionaryRepresentation() -> [String : Any]? {
        return ["name": self.name,
                "date": ISOstring(from: self.date),
                "value": self.value]
    }
}

public struct StringAttributeUpdate: AttributeUpdate {
    public typealias Value = String
    public var name: String
    public var date: Date
    public var value: String
    
}

public struct FloatAttributeUpdate: AttributeUpdate {
    public typealias Value = Float
    public var name: String
    public var date: Date
    public var value: Float
}

public struct IntAttributeUpdate: AttributeUpdate {
    public typealias Value = Int
    public var name: String
    public var date: Date
    public var value: Int
}
