//
//  Style.swift
//  Outfit
//
//  Created by Lionel Maquet on 14/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import Foundation

/*

SEXES
1 = Men
2 = Women
3 = Boys
4 = Girls

SEASONS
1 = Summer/Spring -> 1 in db
2 = Autumn/Winter -> 2 in db

STYLES
1 = Classic
2 = Casual
3 = Streetswear
4 = Sportswear
5 = Classy


*/


struct Style {
    var sexe: String
    var season: String
    var style: String
    
    var name : String {
        var name = ""
        
        switch self.style {
        case "1":
            name = "Classic"
        case "2":
            name = "Casual"
        case "3":
            name = "Streetswear"
        case "4":
            name = "Sportswear"
        case "5":
            name = "Classy"
        default:
            name = ""
        }
        
        switch self.sexe {
        case "1":
            name = "\(name) for men"
        case "2":
            name = "\(name) for women"
        case "3":
            name = "\(name) for boys"
        case "4":
            name = "\(name) for girls"
        default:
            name = "\(name)"
        }
        
        return name
    }
}
