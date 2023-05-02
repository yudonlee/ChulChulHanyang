//
//  CrawlManager.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/08.
//

import Combine
import Foundation

import SwiftSoup

final class CrawlManager {
    
    static let shared = CrawlManager()
    
    private init() {}
    
    let ramenInformation: [String] = ["분식", "라면", "떡 or 만두 or 치즈 라면", "떡 or 만두 or 치즈 라면 + 공깃밥"]
    
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
                let str = try element.text()
                
                let convertedStrArray = self.processDataByType(str, type: restaurantType)
                if !convertedStrArray.isEmpty {
                    result.append(convertedStrArray)
                }
            }
            
        } catch {
            print("\(APIError.failedTogetData.localizedDescription)")
        }
        
        return result
        
    }
    
    func convertDataToMenu(html: String, data: Date, restaurantType: RestaurantType) throws -> [[String]] {
        var result: [[String]] = []
        let doc: Document = try SwiftSoup.parse(html)
        let inbox:Elements = try doc.select(".in-box") //.은 클래스
        
        do {
            try inbox.forEach { element in
                let menu = try element.text()
                let convertedMenuList = self.processDataByType(menu, type: restaurantType).filter { $0 != "-" }
                if !convertedMenuList.isEmpty {
                    result.append(convertedMenuList)
                }
            }
        } catch {
            throw NetworkError.failedToParseHtml
        }
        return result
    }
    
    func requestMenu(date: Date, restaurantType: RestaurantType) -> AnyPublisher<[[String]], Error> {
        
        let stringURL = getRestaurantURL(type: restaurantType.link, month: date.month, day: date.day, year: date.year)
        guard let encodedStringURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedStringURL) else {
            return Fail(error: NetworkError.failedToConvertURL)
                .eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                if let httpResponse = element.response as? HTTPURLResponse,
                   httpResponse.statusCode != 200 {
                    throw NetworkError.serverResponseError(statusCode: httpResponse.statusCode)
                }
                return element.data
            }
            .tryMap { [weak self] data in
                guard let html = String(data: data, encoding: .utf8) else {
                    throw NetworkError.failedToLoadHtml
                }
                
                guard let result = try self?.convertDataToMenu(html: html, data: date, restaurantType: restaurantType) else {
                    throw NetworkError.failedToParseHtml
                }
                return result
            }
            .eraseToAnyPublisher()
    }
    
}

// TODO: Need to Refactor
extension CrawlManager {
    
    func crawlRestaurantMenuAsyncAndURL(date: Date, restaurantType: RestaurantType, completion: @escaping (Result<[[String]], Error>) -> Void)  {
        
        let linkString = getRestaurantURL(type: restaurantType.link, month: date.month, day: date.day, year: date.year)
        
        guard let encodedStr = linkString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: encodedStr) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            var result = [[String]]()
            guard let data = data, let html = String(data: data, encoding: .utf8) else {
                return
            }
            do {
                let doc: Document = try SwiftSoup.parse(html)
                
                let inbox:Elements = try doc.select(".in-box") //.은 클래스
                
                try inbox.forEach { element in
                    let str = try element.text()
                    let convertedStrArray = self.processDataByType(str, type: restaurantType)
                    if !convertedStrArray.isEmpty {
                        result.append(convertedStrArray)
                    }
                }
                completion(.success(result))
            }  catch {
                completion(.failure(APIError.failedTogetData))
            }
        }
        task.resume()
        
    }
    
    private func processDataByType(_ str: String, type: RestaurantType) -> [String] {
        
        var removedData = str
        
        //        영어메뉴 삭제
        if type == .HanyangPlaza || type == .ResidenceTwo {
            removedData = removedData.replacingOccurrences(of: "[a-zA-Z]", with: "", options: .regularExpression)
        }
        
        if type != .HanyangPlaza {
            
            removedData.removeAll(where: { [","].contains($0) })
            let convertedStrArray = removedData.components(separatedBy: " ").map { String($0) }.filter { element in
                !element.contains("00원") && !element.isEmpty
            }
            return convertedStrArray
        } else {
            if str.contains("떡 or 만두 or 치즈 라면") {
                return ramenInformation
            }
            
            removedData.removeAll(where: { [","].contains($0) })
            let convertedStrArray = removedData.components(separatedBy: " ").map { String($0) }.filter { element in
                return !element.isEmpty && !(element.contains(":")) &&
                !(element.contains("00원"))
            }
            
            if convertedStrArray.contains("공통찬") {
                return []
            }
            return convertedStrArray
        }
    }
}
