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
    enum Result {
        case success
        case failure(message: String)
    }

    var username = ""
    var password = ""
    var validate: Bool {
        return !username.isEmpty && !password.isEmpty
    }

    func login(completion: @escaping (LoginViewModel.Result) -> Void) {
        guard validate else {
            completion(.failure(message: "username and token can't empty"))
            return
        }
        githubCredential.username = username
        githubCredential.token = password
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
                    completion(.failure(message: errorMessage))
                }
            case .failure(let error):
                completion(.failure(message: error.localizedDescription))
            }
        }
    }
}
