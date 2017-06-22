//
//  String.swift
//  DemoMoya
//
//  Created by AsianTech on 6/22/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation

enum Process {
    case encode
    case decode
}

extension String {
    var len: Int { return characters.count }
    var host: String? { return (try? asURL())?.host }

    func base64(_ method: Process) -> String {
        switch method {
        case .encode:
            guard let data = data(using: .utf8) else { return "" }
            return data.base64EncodedString()
        case .decode:
            guard let data = Data(base64Encoded: self),
                let string = String(data: data, encoding: .utf8) else { return "" }
            return string
        }
    }

    var trimmed: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
