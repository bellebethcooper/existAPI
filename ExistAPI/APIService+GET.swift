//
//  APIService+GET.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation
import PromiseKit


// Get requests
extension ExistAPI {
    
    public func attributes(names: [String]?, limit: Int?, minDate: Date?, maxDate: Date?) -> Promise<(attributes: [Attribute], response: URLResponse)> {
        var params = [String: Any]()
        if let limit = limit {
            params["limit"] = limit
        }
        if let min = minDate {
            params["date_min"] = ISOstring(from: min)
        }
        if let max = maxDate {
            params["date_min"] = ISOstring(from: max)
        }
        return get(url: baseURL+"attributes/", params: params)
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(attributes: [Attribute], response: URLResponse)> in
                let (data, response) = arg
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let attributes = try decoder.decode([Attribute].self, from: data)
                return Promise { seal in
                    seal.fulfill((attributes, response))
                }
            })
    }
    
    public func insights(days: Int) {
        return get(url: baseURL+"insights/", params: [String:Any]())
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Thenable in
                <#code#>
            })
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
