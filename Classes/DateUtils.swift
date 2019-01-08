//
//  DateUtils.swift
//  ExistAPI
//
//  Created by Belle Beth Cooper on 30/11/18.
//  Copyright © 2018 Hello Code. All rights reserved.
//

import Foundation

enum DateError: Error {
    case tooFarInFuture
}

/// Creates string based on date in format "YYYY-mm-dd"
///
/// - Parameter date: Date to be used for creating date string
public func ISOstring(from date: Date) throws -> String {
    guard let tomorrow = tomorrow(),
        date <= tomorrow else {
            throw DateError.tooFarInFuture
    }
    let formatter = DateFormatter()
    formatter.timeZone = .autoupdatingCurrent
    formatter.dateFormat = "YYYY-MM-dd"
    let string = formatter.string(from: date)
    return string
}

private func tomorrow() -> Date? {
    var comps = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day], from: Date())
    comps.day! += 1
    return Calendar.autoupdatingCurrent.date(from: comps)
}
