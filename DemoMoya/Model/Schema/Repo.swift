//
//  Repo.swift
//  DemoMoya
//
//  Created by AsianTech on 6/27/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation
import ObjectMapper

final class Repo: Mappable {
    var id = 0
    var name = ""
    var fullName = ""
    var desc: String?
    var owner: User?
    var isPrivate = false

    init?(map: Map) { }

    func mapping(map: Map) {
        name <- map["name"]
        fullName <- map["full_name"]
        desc <- map["description"]
        owner <- map["owner"]
        isPrivate <- map["private"]
    }
}
