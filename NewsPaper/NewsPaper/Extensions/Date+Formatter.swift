//
//  Date+Formatter.swift
//  NewsPaper
//
//  Created by Ahmed Mahdy on 26/09/2021.
//

import Foundation

extension Date {
    static func getFormattedDate(string: String?) -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d yyyy, h:mm a"

        if let date = dateFormatterGet.date(from: string ?? "") {
            return dateFormatterPrint.string(from: date)
        }
        return nil
    }
}
