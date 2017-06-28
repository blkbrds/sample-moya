//
//  Network.swift
//  DemoMoya
//
//  Created by AsianTech on 6/22/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation
import Moya
import Result

let GitHubProvider = MoyaProvider<GitHub>(
    plugins: [
        NetworkLoggerPlugin(verbose: true), /// Logs network activity (outgoing requests and incoming responses).
        GitHubCredentialPlugin(),
        CustomPlugin()
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

struct CustomPlugin: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            do {
                _ = try response.filterSuccessfulStatusCodes()
                return Result.success(response)
            } catch {
                var errorMessage = (error as CustomStringConvertible).description
                var statusCode = -1
                if let response = result.value,
                    let json = response.data.toJSON() as? [String: Any],
                    let message = json["message"] as? String {
                    errorMessage = message
                    statusCode = response.statusCode
                }
                let info: [String: Any] = [
                    NSLocalizedDescriptionKey: errorMessage
                ]
                let error = NSError(domain: "", code: statusCode, userInfo: info)
                return Result.failure(MoyaError.underlying(error))
            }
        case .failure(let error):
            return Result.failure(error)
        }
    }
}
