//
//  User.swift
//  DemoMoya
//
//  Created by AsianTech on 6/23/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation
import ObjectMapper

final class User: Mappable {

    var id = 0
    var username: String!
    var name: String?
    var email: String?
    var avatar: String?

    init?(map: Map) { }

    func mapping(map: Map) {
        username <- map["login"]
        name <- map["name"]
        email <- map["email"]
        avatar <- map["avatar_url"]
    }
}
