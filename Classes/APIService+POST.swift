//
//  APIService+POST.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation
import PromiseKit


public struct AttributeUpdate: Codable {
    let name: String
    let date: String
    let value: AttributeData
}

public struct AttributeResponse: Codable {
    var success: [SuccessfulAttribute]?
    var failed: [FailedAttribute]?
}

public struct SuccessfulAttribute: Codable {
    var name: String
    var active: Bool
}

public struct FailedAttribute: Codable {
    var name: String
    var errorCode: String
    var error: String
}

// Post requests
extension ExistAPI {
    
    public func acquire(names: [String]) -> Promise<(attributeResponse: AttributeResponse, response: URLResponse)> {
        let attributes = names.map { (name) -> [String: Any] in
            return ["name": name, "active": true]
        }
        return post(url: basePOSTURL+"attributes/acquire/", body: attributes, queries: nil)
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(attributeResponse: AttributeResponse, response: URLResponse)> in
                let (data, response) = arg
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601DateOnly)
                let attributeResponse = try decoder.decode(AttributeResponse.self, from: data)
                return Promise { seal in
                    seal.fulfill((attributeResponse, response))
                }
            })
    }
    
    public func release(names: [String]) -> Promise<(attributeResponse: AttributeResponse, response: URLResponse)> {
        let attributes = names.map { (name) -> [String: Any] in
            return ["name": name, "active": true]
        }
        return post(url: basePOSTURL+"attributes/release/", body: attributes, queries: nil)
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(attributeResponse: AttributeResponse, response: URLResponse)> in
                let (data, response) = arg
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601DateOnly)
                let attributeResponse = try decoder.decode(AttributeResponse.self, from: data)
                return Promise { seal in
                    seal.fulfill((attributeResponse, response))
                }
            })
    }
    
    public func update(attributes: [AttributeData]) {
        
    }
}
