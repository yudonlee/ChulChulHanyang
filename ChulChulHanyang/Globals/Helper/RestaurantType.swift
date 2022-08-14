
//
//  RestaurantType.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/09.
//

import Foundation

enum RestaurantType: Int {
    case HanyangPlaza = 1
    case HumanEcology = 2
    case MaterialScience = 4
    case ResidenceOne = 6
    case ResidenceTwo = 7
    case HangwonPark = 8
}

struct URLConstants {
    static let baseURL = "https://www.hanyang.ac.kr/web/www/re"
    static let dateURL = "?p_p_id=foodView_WAR_foodportlet&p_p_lifecycle=0&p_p_state=normal&p_p_mode=view&p_p_col_id=column-1&p_p_col_pos=1&p_p_col_count=2&_foodView_WAR_foodportlet_sFoodDateDay="
    static let yearURL = "&_foodView_WAR_foodportlet_sFoodDateYear="
    static let monthURL = "&_foodView_WAR_foodportlet_action=view&_foodView_WAR_foodportlet_sFoodDateMonth="
    
}

