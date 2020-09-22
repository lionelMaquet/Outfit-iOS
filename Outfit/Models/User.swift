//
//  User.swift
//  Outfit
//
//  Created by Lionel Maquet on 13/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import Foundation

var currentUser: User?

struct User {
    var userID: String
    var imageURL: String
    var username: String
    var likedPosts: [String]?
}
