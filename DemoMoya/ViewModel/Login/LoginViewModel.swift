//
//  LoginViewModel.swift
//  DemoMoya
//
//  Created by AsianTech on 6/21/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation
import Moya

final class LoginViewModel {
    enum Field: String {
        case username
        case accessToken
    }

    enum Result {
        case success
        case failure(NSError)
    }

    enum Validation: CustomStringConvertible {
        case success
        case failure(field: Field, msg: String)

        var isSuccess: Bool {
            switch self {
            case .success: return true
            default: return false
            }
        }

        var description: String {
            switch self {
            case .success: return "Success"
            case .failure(_, let msg):
                return "Failure: " + msg
            }
        }
    }

    var username = ""
    var accessToken = ""

//    init(user: User?) {
//        guard let user = user else { return }
//        username = user.username
//    }

    func validate() -> Validation {
        guard username.len >= 4 else {
            return .failure(field: .username, msg: "'\(Field.username)' too short")
        }
        guard accessToken.len >= 6 else { return .failure(field: .accessToken, msg: "'\(Field.accessToken)' too short") }
        return .success
    }

    func login(_ completion: @escaping (LoginViewModel.Result) -> Void) {
        let validation = validate()
        guard validation.isSuccess else {
            let info: [String: Any] = [
                NSLocalizedDescriptionKey: validation.description
            ]
            let error = NSError(domain: "", code: -1, userInfo: info)
            completion(.failure(error))
            return
        }
        credential.username = username
        credential.token = accessToken
        GitHubProvider.request(GitHub.login) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    completion(.success)
                } catch {
                    var errorMessage = (error as CustomStringConvertible).description
                    if let json = result.value?.data.toJSON() as? [String: Any], let message = json["message"] as? String {
                        errorMessage = message
                    }
                    let info: [String: Any] = [
                        NSLocalizedDescriptionKey: errorMessage
                    ]
                    let error = NSError(domain: "", code: -1, userInfo: info)
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }
}
