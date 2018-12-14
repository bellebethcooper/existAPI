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
    
    public init(token: String,
                timeout: TimeInterval = TimeInterval(30.0)) {
        self.token = token
        self.timeout = timeout
    }
}

// Private methods
internal extension ExistAPI {
    
    internal func get(url: String, params: [String: Any]?, queries: [URLQueryItem]?) -> Promise<(data: Data, response: URLResponse)> {
        guard let rq = request(with: url, queries: queries) else {
            return Promise { seal in
                seal.reject(APIServiceError.failedToCreateURL)
            }
        }
        let session = defaultSession()
        return session.dataTask(.promise, with: rq).validate()
    }
    
    internal func post(url: String, body: [String: Any]?, queries: [URLQueryItem]?) -> Promise<(data: Data, response: URLResponse)> {
        guard let rq = request(with: url, queries: queries) else {
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
    
    internal func request(with url: String, queries: [URLQueryItem]?) -> URLRequest? {
        var urlComps = URLComponents(string: url)
        urlComps?.queryItems = queries
        guard let comps = urlComps,
            let finalURL = comps.url else {
            print("APIService get - failed to create URL from \(url)")
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer "+self.token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    internal func defaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = self.timeout
        config.timeoutIntervalForResource = self.timeout
        return URLSession(configuration: config)
    }
}

internal extension DateFormatter {
    static let iso8601DateOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
