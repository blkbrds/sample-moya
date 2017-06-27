//
//  Network.swift
//  DemoMoya
//
//  Created by AsianTech on 6/22/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation
import Moya

let GitHubProvider = MoyaProvider<GitHub>(
    plugins: [
        NetworkLoggerPlugin(verbose: true), /// Logs network activity (outgoing requests and incoming responses).
        GitHubCredentialPlugin()
    ]
)

let credential = Credential()

final class Credential {
    var username = ""
    var token = ""
}

struct GitHubCredentialPlugin: PluginType {

    var auth: String {
        return "Basic " + "\(credential.username):\(credential.token)".base64(.encode)
    }

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let authorizable = target as? AccessTokenAuthorizable, authorizable.shouldAuthorize == false {
            return request
        }

        var request = request
        request.addValue(auth, forHTTPHeaderField: "Authorization")

        return request
    }
}
