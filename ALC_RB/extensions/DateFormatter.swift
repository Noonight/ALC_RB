//
//  Extensions.swift
//  ALC_RB
//
//  Created by user on 30.11.18.
//  Copyright © 2018 test. All rights reserved.
//

import Foundation

enum DateFormats: String {
    case utc = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case current = "dd.MM.yyyy"
}

extension String {
    
    func UTCToLocal(from: DateFormats, to: DateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = to.rawValue

        return dateFormatter.string(from: dt ?? Date())
    }

    func localToUTC(from: String, to: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from
        dateFormatter.calendar = NSCalendar.current
        dateFormatter.timeZone = TimeZone.current

        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = to

        return dateFormatter.string(from: dt ?? Date())
    }
}

