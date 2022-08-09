//
//  CrawlManager.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/08.
//

import Alamofire
import SwiftSoup
import Foundation

final class CrawlManager {
    
    static let shared = CrawlManager()
    
    private init() { }
    
    private func getRestaurantURL(type: Int, month: Int, day: Int, year: Int) -> String {
        let str = "\(URLConstants.baseURL)\(type)\(URLConstants.dateURL)\(day)\(URLConstants.yearURL) \(year)\(URLConstants.monthURL)\(month - 1)"
        return str
    }
    
    func crawlRestaurantMenu(date: Date, restaurantType: RestaurantType) -> [[String]]? {
        
        let linkString = getRestaurantURL(type: restaurantType.link, month: date.month, day: date.day, year: date.year)
        
        guard let encodedStr = linkString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedStr) else {
            return nil
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
    
//    func crawlDomesticScience() -> [[String]]? {
//
//        //        let urlStr = "https://www.hanyang.ac.kr/web/www/re2"
//        //
//        //        AF.request(urlStr).responseString { (response) in
//        //            guard let html = response.value else {
//        //                return
//        //            }
//        //            print(html)
//        //
//        //            do {
//        //                let doc: Document = try SwiftSoup.parse(html)
//        //                // #newsContents > div > div.postRankSubjectList.f_clear
//        //                let elements: Elements = try doc.select("#mArticle > div")
//        //                for element in elements {
//        //                    print(try element.select("a.link_post > strong").text())
//        //                }
//        //
//        //            } catch {
//        //                print("crawl error")
//        //            }
//        //        }
//        //        var components = URLComponents(string: "https://www.skku.edu/skku/index.do")!
//        //        components.path = "/web/www/at-a-glance"
//        //        var urlComponents = URLComponents(string: "https://www.hanyang.ac.kr/")
//
//        let url = URL(string: "https://www.hanyang.ac.kr/web/www/re2?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay=8&_foodView_WAR_foodportlet_sFoodDateYear=2022&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth=7")
//        guard let myURL =  url else {
//            return nil
//        }
//
//        var result = [[String]]()
//        do {
//            let html = try String(contentsOf: myURL)
//            let doc: Document = try SwiftSoup.parse(html)
//
//            let firstLinkTitles:Elements = try doc.select(".span3") //.은 클래스
//            try firstLinkTitles.forEach { element in
//                var str = try element.text()
//                str.removeAll(where: { [","].contains($0) })
//                let convertedStrArray = str.components(separatedBy: " ").map { String($0) }
//                result.append(convertedStrArray)
//
//            }
//
//            let titles:Elements = try doc.select(".d-title2") //.은 클래스
//            try titles.forEach { element in
//                var str = try element.text()
//                print(str)
//            }
//
//            let bbs:Elements = try doc.select(".bbs") //.은 클래스
//            try bbs.forEach { element in
//                var str = try element.text()
//                print(str)
//            }
//
//            let inbox:Elements = try doc.select(".in-box") //.은 클래스
//            try inbox.forEach { element in
//                var str = try element.text()
//                print(str)
//            }
//
//        } catch Exception.Error(let type, let message) {
//            print("Message: \(message)")
//        } catch {
//            print("error")
//        }
//
//        return result
//
//    }
}

