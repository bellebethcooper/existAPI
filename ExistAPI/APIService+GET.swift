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
public extension ExistAPI {
    
    /// Return all the user's attributes with the last week’s values by default.
    /// Exist API docs for attributes: http://developer.exist.io/#attributes6
    ///
    /// - Parameters:
    ///   - names: Optional array of attribute names. If not provided, all attributes will be returned.
    ///   - limit: Number of values to return, starting with today. Optional, max is 31.
    ///   - minDate: Optional date specifying the oldest value that can be returned, in format YYYY-mm-dd.
    ///   - maxDate: Optional date specifying the newest value that can be returned, in format YYYY-mm-dd.
    /// - Returns: A Promise with an array of Attribute models and a URLResponse, if no error is caught.
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
                decoder.dateDecodingStrategy = .iso8601
                let attributes = try decoder.decode([Attribute].self, from: data)
                return Promise { seal in
                    seal.fulfill((attributes, response))
                }
            })
    }
    
    /// Returns the user's correlations for a single attribute, or strongest correlations across all attributes.
    /// Exist docs for correlations: http://developer.exist.io/#insights7
    ///
    /// - Parameters:
    ///   - limit: Number of values to return per page, starting with today. Optional, max is 100.
    ///   - pageIndex: Optional, default is 1.
    ///   - minDate: Oldest date (inclusive) of results to be returned, in format YYYY-mm-dd.
    ///   - maxDate: Most recent date (inclusive) of results to be returned, in format YYYY-mm-dd.
    ///   - latest: Set this to true to return only the most recently generated batch of correlations. Use this on its own without date_min and date_max.
    /// - Returns: a Promise with an array of Insight models and a URLResponse if no error was caught.
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
                decoder.dateDecodingStrategy = .iso8601
                let insights = try decoder.decode([Insight].self, from: data)
                return Promise { seal in
                    seal.fulfill((insights, response))
                }
            })
    }
    
    /// Returns the most recent average values for each attribute, or for a single attribute if requested.
    /// Exist docs for correlations: http://developer.exist.io/#averages8
    ///
    /// - Parameters:
    ///   - attribute: Optional name of a single attribute. If not provided, this function will instead call for the user's averages across all attributes
    ///   - limit: Number of values to return per page, starting with today. Optional, max is 100.
    ///   - pageIndex: Optional, default is 1.
    ///   - minDate: Oldest date (inclusive) of results to be returned, in format YYYY-mm-dd.
    ///   - maxDate: Most recent date (inclusive) of results to be returned, in format YYYY-mm-dd.
    /// - Returns: a Promise with an array of Average models and a URLResponse if no error was caught.
    public func averages(for attribute: String?, limit: Int?, pageIndex: Int?, minDate: Date?, maxDate: Date?) -> Promise<(averages: [Average], response: URLResponse)> {
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
        var urlString = baseURL+"averages/"
        if let attribute = attribute {
            urlString += "attribute/\(attribute)/"
        }
        return get(url: urlString, params: params)
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(averages: [Average], response: URLResponse)> in
                let (data, response) = arg
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let averages = try decoder.decode([Average].self, from: data)
                return Promise { seal in
                    seal.fulfill((averages, response))
                }
            })
    }
    
    /// Exist docs for correlations: http://developer.exist.io/#get-all-correlations-for-attribute
    ///
    /// - Parameters:
    ///   - attribute: Optional name of a single attribute. If not provided, this function will instead call for the user's strongest correlations across all attributes
    ///   - limit: Number of values to return per page, starting with today. Optional, max is 100.
    ///   - pageIndex: Optional, default is 1.
    ///   - minDate: Oldest date (inclusive) of results to be returned, in format YYYY-mm-dd.
    ///   - maxDate: Most recent date (inclusive) of results to be returned, in format YYYY-mm-dd.
    ///   - latest: Set this to true to return only the most recently generated batch of correlations. Use this on its own without date_min and date_max.
    /// - Returns: a Promise with an array of Correlation models and a URLResponse if no error was caught.
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
                decoder.dateDecodingStrategy = .iso8601
                let correlations = try decoder.decode([Correlation].self, from: data)
                return Promise { seal in
                    seal.fulfill((correlations, response))
                }
            })
    }
    
    /// Returns an overview of the user's personal details.
    /// Exist API docs for user endpoint: http://developer.exist.io/#users5
    ///
    /// - Returns: A Promise with a User model and URLResponse, if no errors were caught
    public func user() -> Promise<(user: User, response: URLResponse)> {
        return get(url: baseURL+"profile/", params: nil)
            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(user: User, response: URLResponse)> in
                let (data, response) = arg
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let user = try decoder.decode(User.self, from: data)
                return Promise { seal in
                    seal.fulfill((user, response))
                }
            })
    }

    // TODO: Need to decide how to handle attribute models for this endpoint, since they're similar but different to /attributes/ models
//    public func today() -> Promise<(user: User, response: URLResponse)> {
//        return get(url: baseURL+"today/", params: nil)
//            .then(on: DispatchQueue.global(), flags: nil, { (arg) -> Promise<(user: User, response: URLResponse)> in
//                let (data, response) = arg
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                decoder.dateDecodingStrategy = .iso8601
//                let user = try decoder.decode(User.self, from: data)
//                return Promise { seal in
//                    seal.fulfill((user, response))
//                }
//            })
//    }
}
