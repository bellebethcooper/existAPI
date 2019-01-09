//
//  AttributeUpdate.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 8/1/19.
//  Copyright © 2019 Hello Code. All rights reserved.
//

import Foundation

public protocol AttributeUpdate: Codable {
    func dictionaryRepresentation() throws -> [String: Any]?
}

public struct StringAttributeUpdate: AttributeUpdate {
    public var name: String
    public var date: Date
    public var value: String
    
    public func dictionaryRepresentation() throws -> [String : Any]? {
        do {
            let date = try ISOstring(from: self.date)
            return ["name": self.name,
                    "date": date,
                    "value": self.value]
        } catch {
            print("ExistAPI StringAttributeUpdate - Failed to create AttributeUpdate due to error formatting date: \(error)")
            throw DateError.tooFarInFuture
        }
    }
    
}

public struct FloatAttributeUpdate: AttributeUpdate {
    public var name: String
    public var date: Date
    public var value: Float
    
    public func dictionaryRepresentation() throws -> [String : Any]? {
        do {
            let date = try ISOstring(from: self.date)
            return ["name": self.name,
                    "date": date,
                    "value": self.value]
        } catch {
            print("ExistAPI FloatAttributeUpdate - Failed to create AttributeUpdate due to error formatting date: \(error)")
            throw DateError.tooFarInFuture
        }
    }
}

public struct IntAttributeUpdate: AttributeUpdate {
    public var name: String
    public var date: Date
    public var value: Int
    
    public func dictionaryRepresentation() throws -> [String : Any]? {
        do {
            let date = try ISOstring(from: self.date)
            return ["name": self.name,
                    "date": date,
                    "value": self.value]
        } catch {
            print("ExistAPI IntAttributeUpdate - Failed to create AttributeUpdate due to error formatting date: \(error)")
            throw DateError.tooFarInFuture
        }
    }
}
