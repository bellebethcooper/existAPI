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
    case failedToCreateJSONData
}

// MARK: ExistAPI

public class ExistAPI {
    
    let baseGETURL = "https://exist.io/api/1/users/$self/"
    let basePOSTURL = "https://exist.io/api/1/"
    var token: String
    var timeout: TimeInterval
    
    /// Create an instance of the ExistAPI class
    ///
    /// - Parameters:
    ///   - token: An OAuth API token obtained from the Exist API (see details on authorisation in the API docs here: http://developer.exist.io/#authentication-overview)
    ///   - timeout: Optional TimeInterval for all network requests. Default is 30.0
    public init(token: String,
                timeout: TimeInterval = TimeInterval(30.0)) {
        self.token = token
        self.timeout = timeout
    }
}

// Private methods
internal extension ExistAPI {
    
    internal func get(url: String, params: [String: Any]?, queries: [URLQueryItem]?) -> Promise<(data: Data, response: URLResponse)> {
        guard var rq = request(with: url, queries: queries) else {
            return Promise { seal in
                seal.reject(APIServiceError.failedToCreateURL)
            }
        }
        rq.httpMethod = "GET"
        let session = defaultSession()
        return session.dataTask(.promise, with: rq).validate()
    }
    
    internal func post(url: String, body: Data?, queries: [URLQueryItem]?) -> Promise<(data: Data, response: URLResponse)> {
        guard var rq = request(with: url, queries: queries, body: body) else {
            return Promise { seal in
                seal.reject(APIServiceError.failedToCreateURL)
            }
        }
        rq.httpMethod = "POST"
        let session = defaultSession()
        return session.uploadTask(.promise, with: rq, from: body ?? Data()).validate()
    }
    
    internal func request(with url: String, queries: [URLQueryItem]?, body: Data? = nil) -> URLRequest? {
        var urlComps = URLComponents(string: url)
        urlComps?.queryItems = queries
        guard let comps = urlComps,
            let finalURL = comps.url else {
            print("APIService get - failed to create URL from \(url)")
            return nil
        }
        
        var request = URLRequest(url: finalURL)
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer "+self.token, forHTTPHeaderField: "Authorization")
        return request
    }
    
    internal func defaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = self.timeout
        config.timeoutIntervalForResource = self.timeout
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
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
