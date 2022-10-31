//
//  UserDefaults+Extension.swift
//  ChulChulHanyang
//
//  Created by yudonlee on 2022/08/30.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let groupID = "group.ChulChulHanyang"
        return UserDefaults(suiteName: groupID)!
    }
}
