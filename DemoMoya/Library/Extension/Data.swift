//
//  Data.swift
//  DemoMoya
//
//  Created by AsianTech on 6/22/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation

extension Data {
    func toJSON() -> Any? {
        do {
            return try JSONSerialization.jsonObject(
                with: self,
                options: .allowFragments
            )
        } catch {
            return nil
        }
    }

    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
}
