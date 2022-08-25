//
//  ParsingManager.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/17.
//

import Foundation

struct ParsingManager {
    
    static private let ResidenceMealTime: [String] = ["조식", "조식", "조식", "조식", "조식", "조식", "조식", "조식", "조식", "중식", "중식", "중식", "중식", "중식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식"]
    
    static private let AverageMealTime: [String] = ["중식", "중식", "중식", "중식", "중식", "중식", "중식", "중식", "중식", "중식", "중식", "중식", "중식", "중식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식", "석식"]
    
    static private func getMealTime(type: RestaurantType) -> String {
        let date = Date()
        
        switch type {
        case .ResidenceOne, .ResidenceTwo:
            if date.hour < ResidenceMealTime.count {
                return ResidenceMealTime[date.hour]
            }
        default:
            if date.hour < AverageMealTime.count {
                return AverageMealTime[date.hour]
            }
        }
        
        
        return "중식"
    }
    
    static func parsing(type: RestaurantType) -> [String] {
        guard let data = CrawlManager.shared.crawlRestaurantMenu(date: Date(), restaurantType: type) else {
            return [String]()
        }
        
        var result = [String]()
        
        let getTimeStamp = getMealTime(type: type)
        
        switch type {
        case .HanyangPlaza:
            result = data.filter { str in
                str.contains("중식/석식")
            }.flatMap({ $0 })
        
        case .HumanEcology:
            result = data.filter { str in
                str.contains(getTimeStamp)
            }.flatMap({ $0 })
            
            if let damAIndex = result.firstIndex(of: "[Dam-A]"),
               let pangeosIndex = result.firstIndex(of: "[Pangeos]") {
                
                let range = pangeosIndex..<result.endIndex
                result.removeSubrange(range)
            }
            
            
        case .MaterialScience:
            result = data.filter { str in
                str.contains(getTimeStamp)
            }.flatMap({ $0 })
            
            if let jeongsikIndex = result.firstIndex(of: "[정식]"),
               let ilpoomIndex = result.firstIndex(of: "[일품]") {
                
                let range = ilpoomIndex..<result.endIndex
                result.removeSubrange(range)
            }
            
        case .ResidenceOne, .ResidenceTwo:
            result = data.filter { str in
                str.contains(getTimeStamp)
            }.flatMap({ $0 })
        case .HangwonPark:
            var result = data.filter { str in
                str.contains(getTimeStamp)
            }.flatMap({ $0 })
            
            if let cornerAIndex = result.firstIndex(of: "[코너 A]"),
               let cornerBIndex = result.firstIndex(of: "[코너 B]") {
                
                let range = cornerBIndex..<result.endIndex
                result.removeSubrange(range)
            }
            
        }
        
        result = result.filter { str in
            return str != "-"
        }
        return result
    }
}
