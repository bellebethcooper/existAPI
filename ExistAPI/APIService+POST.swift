//
//  APIService+POST.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation
import PromiseKit


class AttributeUpdate: Codable {
    let name: String
    let date: String
    let value: AttributeData
}

// Post requests
extension ExistAPI {
    
    public func acquire(names: [String]) -> Promise<(data: Data, response: URLResponse)> {
        return post(url: "", body: nil)
    }
    
    public func release(names: [String]) {
        
    }
    
    public func update(attributes: [AttributeData]) {
        
    }
}
