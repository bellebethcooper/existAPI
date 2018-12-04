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
    
    public func insights(limit: Int?, pageIndex: Int?, minDate: Date?, maxDate: Date?) -> Promise<(insights: [Insight], response: URLResponse)> {
        var params = [String: Any]()
        if let limit = limit {
            params["limit"] = limit
        }
        if let index = pageIndex {
            params["page"] = index
        }
        if let min = minDate {
            params["date_min"] = ISOstring(from: min)
        }
        if let max = maxDate {
            params["date_min"] = ISOstring(from: max)
        }
        return get(url: baseURL+"insights/", params: [String:Any]())
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(insights: [Insight], response: URLResponse)> in
                let (data, response) = arg
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let insights = try decoder.decode([Insight].self, from: data)
                return Promise { seal in
                    seal.fulfill((insights, response))
                }
            })
    }
    
    public func averages(attribute: String?, limit: Int?) {
        
    }
    
    public func user() {
        
    }
    
    public func correlations(for attribute: String?, limit: Int?, pageIndex: Int?, minDate: Date?, maxDate: Date?, latest: Bool?) -> Promise<(correlations: [Correlation], response: URLResponse)> {
        var params = [String: Any]()
        if let limit = limit {
            params["limit"] = limit
        }
        if let index = pageIndex {
            params["page"] = index
        }
        if let min = minDate {
            params["date_min"] = ISOstring(from: min)
        }
        if let max = maxDate {
            params["date_min"] = ISOstring(from: max)
        }
        var urlString = baseURL+"correlations/"
        if let attribute = attribute {
            urlString += "attribute/\(attribute)/"
        } else {
            urlString += "strongest/"
        }
        return get(url: urlString, params: [String:Any]())
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(correlations: [Correlation], response: URLResponse)> in
                let (data, response) = arg
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let correlations = try decoder.decode([Correlation].self, from: data)
                return Promise { seal in
                    seal.fulfill((correlations, response))
                }
            })
    }
    
    public func today() {
        
    }
}
