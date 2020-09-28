//
//  Post.swift
//  Outfit
//
//  Created by Lionel Maquet on 12/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    var userID: String
    var user: User?
    var description: String
    var commentCount: Int
    var likeCount: Int
    var imageURL: String?
    var style: String
    var sexe: String
    var season: String
    var profileImage: UIImage?
    var postImage: UIImage?
    var postDocumentID: String?
    
    
    var styleName: String {
        return Style(sexe: self.sexe, season: self.season, style: self.style).name
    }
    
}
