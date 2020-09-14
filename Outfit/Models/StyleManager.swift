//
//  StyleManager.swift
//  Outfit
//
//  Created by Lionel Maquet on 14/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import Foundation

struct StyleManager {
    static func getName(styleID: String) -> String {
        switch styleID {
        case "0":
            return ""
        case "1":
            return "Casual for Men"
        default:
            return ""
        }
    }
}
