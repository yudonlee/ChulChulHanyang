//
//  CrawlManager.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/08.
//

import SwiftSoup
import Foundation

final class CrawlManager {
    
    static let shared = CrawlManager()
    
    private init() { }
    
    let ramenInformation: [String] = ["분식", "라면", "2000원", "떡 or 만두 or 치즈 라면", "2300원", "떡 or 만두 or 치즈 라면 + 공깃밥", "2800원"]
    
    private func getRestaurantURL(type: Int, month: Int, day: Int, year: Int) -> String {
        let str = "\(URLConstants.baseURL)\(type)\(URLConstants.dateURL)\(day)\(URLConstants.yearURL) \(year)\(URLConstants.monthURL)\(month - 1)"
        return str
    }
    
    func crawlRestaurantMenu(date: Date, restaurantType: RestaurantType) -> [[String]]? {
        
        let linkString = getRestaurantURL(type: restaurantType.link, month: date.month, day: date.day, year: date.year)
        
        guard let encodedStr = linkString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedStr) else {
            return nil
        }
        
        if restaurantType == .HanyangPlaza {
            return crawlHanyangPlaza(url: url)
        }
        
        var result = [[String]]()
        do {
            let html = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(html)
            
            let inbox:Elements = try doc.select(".in-box") //.은 클래스
            try inbox.forEach { element in
                var str = try element.text()
                str.removeAll(where: { [","].contains($0) })
                let convertedStrArray = str.components(separatedBy: " ").map { String($0) }
                result.append(convertedStrArray)
            }
            
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        
        return result
        
    }
    
    func crawlHanyangPlaza(url: URL) -> [[String]]? {
        
        var result = [[String]]()
        
        do {
            let html = try String(contentsOf: url)
            let doc: Document = try SwiftSoup.parse(html)
            
            let inbox:Elements = try doc.select(".in-box") //.은 클래스
            try inbox.forEach { element in
                
                
                var str = try element.text()
                if str.contains("라면") {
                    result.append(ramenInformation)
                    return
                }
                
//                학생식당 영어 번역 메뉴 삭제
                str = str.replacingOccurrences(of: "[a-zA-Z]", with: "", options: .regularExpression)
                str.removeAll(where: { [","].contains($0) })
                var convertedStrArray = str.components(separatedBy: " ").map { String($0) }.filter { element in
                    return !element.isEmpty && !(element.contains(":"))
                }
                
                if convertedStrArray.contains("공통찬") {
                    let firstIdx = convertedStrArray.lastIndex(of: "공통찬")
                    let lastIdx = convertedStrArray.firstIndex(of: "*")
                    guard let firstIdx = firstIdx, let lastIdx = lastIdx else {
                        return
                    }
                    convertedStrArray = convertedStrArray[firstIdx...lastIdx - 1].map({ String($0) })
                }
                
//                if convertedStrArray.contains("라면") {
//                    convertedStrArray.lastIndex(of: "+")
//                    
//                    
//                    let firstRiceCake = convertedStrArray.firstIndex(of: "떡")
//                    let lastRiceCake = convertedStrArray.firstIndex(of: "치즈")
//                    
//                    let firstCheese = convertedStrArray.firstIndex(of: "치즈")
//                    let lastCheese = convertedStrArray.lastIndex(of: "치즈")
//                    
//                    convertedStrArray[]
//                }
                
                result.append(convertedStrArray)
            }
        } catch Exception.Error(let type, let message) {
            print("Message: \(message)")
        } catch {
            print("error")
        }
        return result
    }
}

