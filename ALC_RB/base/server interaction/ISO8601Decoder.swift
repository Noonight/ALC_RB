//
//  ISO8601Decoder.swift
//  ALC_RB
//
//  Created by Ayur Arkhipov on 07/10/2019.
//  Copyright © 2019 test. All rights reserved.
//

import Foundation

class ISO8601Decoder {
    
    static func getDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
//        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current

        decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

//            if let date = dateStr.toDate() {
//                return date.date
//            }
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
//            formatter.dateFormat = DateFormats.iso8601.ck
            if let date = formatter.date(from: dateStr) {
                return date + TimeInterval(TimeZone.current.secondsFromGMT())
            }
            
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
//            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+|-hh:mm"
            if let date = formatter.date(from: dateStr) {
                return date + TimeInterval(TimeZone.current.secondsFromGMT())
            }
            throw DateError.invalidDate
        })
//        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }
    
}
