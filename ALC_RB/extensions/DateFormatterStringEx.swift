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
    case ddMMMMyyyy = "dd MMMM yyyy"
    case GMT = "EEE MMM dd HH:mm:ss zzz yyyy"
    
    case leagueDate = "yyyy-MM-dd"
    
    case local = "dd.MM.yyyy"
    case localTime = "HH:mm"
    case iso8601 = "yyyy-MM-dd'T'HH:mm:ss:SSS+|-hh:mm"
}
//internal static let builtInAutoFormat: [String] =  [
//    DateFormats.iso8601,
//    "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'",
//    "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSS'Z'",
//    "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
//    "yyyy-MM-dd'T'HH:mm", // modificated utc
//    "yyyy-MM-dd HH:mm:ss",
//    "yyyy-MM-dd HH:mm",
//    "yyyy-MM-dd",
//    "h:mm:ss A",
//    "h:mm A",
//    "MM/dd/yyyy",
//    "MMMM d, yyyy",
//    "MMMM d, yyyy LT",
//    "dddd, MMMM D, yyyy LT",
//    "yyyyyy-MM-dd",
//    "yyyy-MM-dd",
//    "GGGG-[W]WW-E",
//    "GGGG-[W]WW",
//    "yyyy-ddd",
//    "HH:mm:ss.SSSS",
//    "HH:mm:ss",
//    "HH:mm",
//    "HH",
//    "EEE MMM dd HH:mm:ss zzz yyyy", // modificated GMT
//    "dd MMMM yyyy" // modificated
//]

extension String {
    
    func convertDate(from: DateFormats, to: DateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = from.rawValue
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        var dt = dateFormatter.date(from: self)
        
//        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = to.rawValue
        
        
        if dt == nil {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = from.rawValue
            dateFormatter.locale = Locale(identifier: "en_US")
            
            dt = dateFormatter.date(from: self)
            
//            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = to.rawValue
        }
//        if dt == nil
//        {
//            Print.m("dt is nil")
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = DateFormats.utc.rawValue
//            dateFormatter.locale = Locale(identifier: "en_US")
//
//            dt = dateFormatter.date(from: self)
//
//            //            dateFormatter.timeZone = TimeZone.current
//            dateFormatter.dateFormat = to.rawValue
//        }
        
        return dateFormatter.string(from: dt ?? Date())
    }

//    func localToUTC(from: String, to: String) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = from
//        dateFormatter.calendar = NSCalendar.current
//        dateFormatter.timeZone = TimeZone.current
//
//        let dt = dateFormatter.date(from: self)
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        dateFormatter.dateFormat = to
//
//        return dateFormatter.string(from: dt ?? Date())
//    }
    
    func getDateOfType(type: DateFormats) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.locale = Locale(identifier: "en_US")
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        guard let date = dateFormatter.date(from: self) else {
            Print.d(message: "DEBUG: date format exception String -> Date")
            return Date()
        }
        return date
    }
    
    func toDateCustom(type: DateFormats) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: self)

        return dt
    }
}

extension Date {
    func getStringOfType(type: DateFormats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.locale = Locale(identifier: "en_US")
        
        guard let date: String = dateFormatter.string(from: self) else {
            Print.d(message: "DEBUG: date format exception Date -> String")
            return ""
        }
        return date
    }
    
    func isBetween(_ date1: Date, and date2: Date) -> Bool {
        return (min(date1, date2) ... max(date1, date2)).contains(self)
    }
}

