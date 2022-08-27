//
//  Date+Extension.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/07.
//

import Foundation

extension Date {
        
    var keyText: String {
        return DateFormatterLiteral.yearDateFormatter.string(from: self)
    }
    
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
    
//  한양대 서버 데이터가 현재일로부터 1주일까진 최신 업데이트가 되어 있기 때문에 해당 기간을 넘어선다면 로컬에서 다시 reload받아야 한다.
    func lessThanSevenDays() -> Bool {
        let today = Date()
        let day = Calendar.current.dateComponents([.day], from: today, to: self)
        if let difference = day.day, difference > 7 {
            return false
        }
        return true
       
    }
}
