//
//  Utality.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/16/22.
//

import Foundation

class Utility  {
    class func formateDate(date: Date) ->  String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale =  NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        debugPrint(dateFormatter.string(from: date))
        return dateFormatter.string(from: date)
    }
}
