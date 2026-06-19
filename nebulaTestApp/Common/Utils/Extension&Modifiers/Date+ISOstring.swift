//
//  Date+ISOstring.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import Foundation

extension Date {
    /// Date string with local time
    func isoString() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXX"

        return formatter.string(from: self)
    }
    
    /// Date string UTC
    func isoStringUTC() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        return formatter.string(from: self)
    }
    
    /// Date string for display
    func toDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}
