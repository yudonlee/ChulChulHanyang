
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
}

struct URLConstants {
    static let baseURL = "https://www.hanyang.ac.kr/web/www/re"
    static let dateURL = "?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay="
    static let yearURL = "&_foodView_WAR_foodportlet_sFoodDateYear="
    static let monthURL = "&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth="
    
}

