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
    case utcTime = "yyyy-MM-dd'T'HH:mm"
    case local = "dd.MM.yyyy"
    case localTime = "HH:mm"
    case ddMMMMyyyy = "dd MMMM yyyy"
    case GMT = "EEE MMM dd HH:mm:ss zzz yyyy"
    
    case leagueDate = "yyyy-MM-dd"
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
    
    func getDateOfType(type: DateFormats) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        guard let date = dateFormatter.date(from: self) else {
            Print.d(message: "DEBUG: date format exception String -> Date")
            return Date()
        }
        return date
    }
}

extension Date {
    func getStringOfType(type: DateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        
        guard let date: String = dateFormatter.string(from: self) else {
            Print.d(message: "DEBUG: date format exception Date -> String")
            return ""
        }
        return date
    }
}

