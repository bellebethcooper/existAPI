//
//  DateUtils.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation


/// Creates string based on date in format "YYYY-mm-dd"
///
/// - Parameter date: Date to be used for creating date string
public func ISOstring(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-mm-dd"
    return formatter.string(from: date)
}
