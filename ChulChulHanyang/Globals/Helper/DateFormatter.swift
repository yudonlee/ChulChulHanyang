//
//  DateFormatter.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import Foundation

final class DateFormatterLiteral {
    
    static let dateDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM.dd"
        return formatter
    }()
    
    static let dayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
}
