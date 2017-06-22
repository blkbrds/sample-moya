//
//  Optional.swift
//  DemoMoya
//
//  Created by AsianTech on 6/22/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    var content: String {
        switch self {
        case .some(let value):
            return String(describing: value)
        case _:
            return ""
        }
    }
}
