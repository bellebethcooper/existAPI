//
//  APIService+POST.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation
import PromiseKit


// Post requests
extension ExistAPI {
    
    /// Acquire one or more attributes (Attributes MUST be acquired before they can be updated. See the docs for more detail: http://developer.exist.io/#attribute-ownership)
    ///
    /// - Parameter names: [String] including the names of the attributes to be acquired. Names must be spelled exactly as they are listed in the API docs, including underscores: http://developer.exist.io/#list-of-attributes)
    /// - Returns: Promise<(attributeResponse: AttributeResponse, response: URLResponse)>. `AttributeResponse` includes optional `success` and `failed` arrays. If one or more attributes fails to be acquired, the API will return a 202, and the `failed` array will include details of what was sent and why it failed.
    public func acquire(names: [String]) -> Promise<(attributeResponse: AttributeResponse, response: URLResponse)> {
        let attributes = names.map { (name) -> [String: Any] in
            return ["name": name, "active": true]
        }
        return post(url: basePOSTURL+"attributes/acquire/", body: data(from: attributes), queries: nil)
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
    
    /// Release one or more attributes so they're no longer owned by your client
    ///
    /// - Parameter names: [String] including the names of the attributes to be acquired. Names must be spelled exactly as they are listed in the API docs, including underscores: http://developer.exist.io/#list-of-attributes)
    /// - Returns: Promise<(attributeResponse: AttributeResponse, response: URLResponse)>. `AttributeResponse` includes optional `success` and `failed` arrays. If one or more attributes fails to be released, the API will return a 202, and the `failed` array will include details of what was sent and why it failed.
    public func release(names: [String]) -> Promise<(attributeResponse: AttributeResponse, response: URLResponse)> {
        let attributes = names.map { (name) -> [String: Any] in
            return ["name": name, "active": true]
        }
        return post(url: basePOSTURL+"attributes/release/", body: data(from: attributes), queries: nil)
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
    
    internal func data(from array: [[String: Any]]) -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject:array , options: [])
            return data
        } catch {
            print("APIService+POST update - couldn't serialize updates into Data. Here's the error: \(error) and here are the updates: \(attributes)")
            return nil
        }
    }
    
    /// Update the value of one or more attributes
    ///
    /// - Parameter attributes: [AttributeUpdate]
    /// - Returns: Promise<(attributeResponse: AttributeUpdateResponse, response: URLResponse)>. `AttributeUpdateResponse` includes optional `success` and `failed` arrays. If one or more attributes fails to be released, the API will return a 202, and the `failed` array will include details of what was sent and why it failed.
    public func update(attributes: [AttributeUpdate]) -> Promise<(attributeResponse: AttributeUpdateResponse, response: URLResponse)> {
        
        func JSON(from updates: [AttributeUpdate]) throws -> Data {
            let array = try updates.compactMap({ (update) -> [String: Any]? in
                try update.dictionaryRepresentation()
            })
            return try JSONSerialization.data(withJSONObject: array, options: [])
        }
        
        var jsonData: Data? = nil
        do {
            jsonData = try JSON(from: attributes)
        } catch {
            print("APIService+POST update - couldn't serialize updates into Data. Here's the error: \(error) and here are the updates: \(attributes)")
            return Promise { seal in
                seal.reject(error)
            }
        }
        guard let d = jsonData else {
            return Promise { seal in
                seal.reject(APIServiceError.failedToCreateJSONData)
            }
        }
        return post(url: basePOSTURL+"attributes/update/", body:d , queries: nil)
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(attributeResponse: AttributeUpdateResponse, response: URLResponse)> in
                let (data, response) = arg
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601DateOnly)
                let attributeResponse = try decoder.decode(AttributeUpdateResponse.self, from: data)
                return Promise { seal in
                    seal.fulfill((attributeResponse, response))
                }
            })
    }
}
