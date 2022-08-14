//
//  Date+Extension.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import Foundation

extension Date {
    
    var dateText: String {
        return DateFormatterLiteral.dateDateFormatter.string(from: self)
    }
    
    var dayText: String {
        return DateFormatterLiteral.dayDateFormatter.string(from: self)
    }
    
}
