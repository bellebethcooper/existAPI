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

// MARK: ExistAPI

public class ExistAPI {
    
    let baseURL = "https://exist.io/api/1/users/$self/"
    var token: String
    var timeout: TimeInterval
    
    public init(token: String, timeout: TimeInterval = TimeInterval(30.0)) {
        self.token = token
        self.timeout = timeout
    }
}

// Private methods
internal extension ExistAPI {
    
    internal func get(url: String, params: [String: Any]?) -> Promise<(data: Data, response: URLResponse)> {
        guard let rq = request(with: url) else {
            return Promise { seal in
                seal.reject(APIServiceError.failedToCreateURL)
            }
        }
        let session = defaultSession()
        return session.dataTask(.promise, with: rq).validate()
    }
    
    internal func post(url: String, body: [String: Any]?) -> Promise<(data: Data, response: URLResponse)> {
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
    
    internal func data(from body: [String: Any]) -> Data? {
        do {
            let data = try JSONSerialization.data(withJSONObject: body, options: [])
            return data
        } catch {
            print("APIService data(from body:) - couldn't serialize body into Data. Here's the error: \(error) and here's the body object: \(body)")
            return nil
        }
    }
    
    internal func request(with url: String) -> URLRequest? {
        guard let URL = URL(string: url) else {
            print("APIService get - failed to create URL from \(url)")
            return nil
        }
        return URLRequest(url: URL)
    }
    
    internal func defaultSession() -> URLSession {
        let config = URLSessionConfiguration()
        config.timeoutIntervalForRequest = self.timeout
        config.timeoutIntervalForResource = self.timeout
        return URLSession(configuration: config)
    }
}
