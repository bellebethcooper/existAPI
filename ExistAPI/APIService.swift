//
//  APIService.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 10/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation
import PromiseKit

enum APIServiceError: Error {
    case failedToCreateURL
}

// MARK: - models

class AttributeGroup: Codable {
    let name: String
    let label: String
    let priority: Int
}

class ValueObject: Codable {
    let value: ValueType
    let date: Date
}

enum ValueType: Codable {
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

class Attribute: Codable {
    let name: String
    let label: String
    let group: AttributeGroup
    let priority: Int
    let serviceName: String
    let value_type: Int
    let value_type_description: String
    let isPrivate: Bool
    let values: [ValueObject]
}


// MARK: ExistAPI

class ExistAPI {
    
    var token: String
    var timeout: TimeInterval
    
    init(token: String, timeout: TimeInterval = TimeInterval(30.0)) {
        self.token = token
        self.timeout = timeout
    }
}

// Get requests
extension ExistAPI {
    
    public func attributes(names: [String]?, limit: Int?, queries: [[String: Any]]?) -> Promise<(attributes: [Attribute], response: URLResponse)> {
        return get(url: "", params: [String:Any]())
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(attributes: [Attribute], response: URLResponse)> in
                let (data, response) = arg
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
            })
    }
    
    public func insights(days: Int) {
        
    }
    
    public func averages(attribute: String?, limit: Int?) {
        
    }
    
    public func user() {
        
    }
    
    public func correlations() {
        
    }
    
    public func today() {
        
    }
}

// Post requests
extension ExistAPI {
    
    public func acquire(names: [String]) -> Promise<(data: Data, response: URLResponse)> {
        return post(url: "", body: nil)
    }
}

// Private methods
extension ExistAPI {
    
    private func get(url: String, params: [String: Any]) -> Promise<(data: Data, response: URLResponse)> {
        guard let rq = request(with: url) else {
            return Promise { seal in
                seal.reject(APIServiceError.failedToCreateURL)
            }
        }
        let session = defaultSession()
        return session.dataTask(.promise, with: rq).validate()
    }
    
    private func post(url: String, body: [String: Any]?) -> Promise<(data: Data, response: URLResponse)> {
        guard let rq = request(with: url) else {
            return Promise { seal in
                seal.reject(APIServiceError.failedToCreateURL)
            }
        }
        var serializedData: Data? = nil
        if let body = body {
            serializedData = data(from: body)
        }
        let session = defaultSession()
        return session.uploadTask(.promise, with: rq, from: serializedData ?? Data()).validate()
    }
    
    private func data(from body: [String: Any]) -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            return data
        } catch {
            print("APIService data(from body:) - couldn't serialize body into Data. Here's the error: \(error) and here's the body object: \(body)")
            return nil
        }
    }
    
    private func request(with url: String) -> URLRequest? {
        guard let URL = URL(string: url) else {
            print("APIService get - failed to create URL from \(url)")
            return nil
        }
        return URLRequest(url: URL)
    }
    
    private func defaultSession() -> URLSession {
        let config = URLSessionConfiguration()
        config.timeoutIntervalForRequest = self.timeout
        config.timeoutIntervalForResource = self.timeout
        return URLSession(configuration: config)
    }
}
