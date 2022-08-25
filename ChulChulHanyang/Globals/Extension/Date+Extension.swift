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
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }
}
