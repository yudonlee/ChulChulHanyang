
//
//  RestaurantType.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/09.
//

import Foundation

enum RestaurantType: Int {
    case HumanEcology = 0
    case MaterialScience = 1
    case ResidenceOne = 2
    case ResidenceTwo = 3
    case HanyangPlaza = 4
    case HangwonPark = 5
    
    var name: String {
        switch self {
        case .HanyangPlaza:
            return "한플식당"
        case .HumanEcology:
            return "생과대"
        case .MaterialScience:
            return "신소재"
        case .ResidenceOne:
            return "제1생"
        case .ResidenceTwo:
            return "제2생"
        case .HangwonPark:
            return "행원파크"
        }
    }
    
    var link: Int {
        switch self {
        case .HanyangPlaza:
            return 1
        case .HumanEcology:
            return 2
        case .MaterialScience:
            return 4
        case .ResidenceOne:
            return 6
        case .ResidenceTwo:
            return 7
        case .HangwonPark:
            return 8
        }
    }
    
    var restaurantTime: [String: String] {
        switch self {
        case .HanyangPlaza:
            return ["분식": "14:00 ~ 15:00", "중식/석식": "10:30 ~ 15:00 / 16:00 ~ 18:00", "중식": "10:00 ~ 14:00"]
        case .HumanEcology:
            return ["중식": "11:30~14:00", "석식": "17:00 ~ 18:00"]
        case .MaterialScience:
            return ["중식": "11:30~13:30", "석식": "17:00 ~ 18:30"]
        case .ResidenceOne:
            return ["조식": "07:30~09:00", "중식": "12:00 ~ 13:30", "석식": "17:30 ~ 18:30"]
        case .ResidenceTwo:
            return ["조식": "07:30 ~ 09:00", "중식": "12:00 ~ 13:30", "석식": "17:30 ~ 18:30"]
        case .HangwonPark:
            return ["중식": "11:30 ~ 14:00"]
        }
    }
}

struct URLConstants {
    static let baseURL = "https://www.hanyang.ac.kr/web/www/re"
    static let dateURL = "?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay="
    static let yearURL = "&_foodView_WAR_foodportlet_sFoodDateYear="
    static let monthURL = "&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth="
    
}

