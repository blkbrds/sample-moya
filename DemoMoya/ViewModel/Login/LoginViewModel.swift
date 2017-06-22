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
        case failure(MoyaError)
    }

    var username = ""
    var password = ""
    var validate: Bool {
        return username.isEmpty || password.isEmpty
    }

    func login(completion: @escaping (LoginViewModel.Result) -> Void) {
        githubCredential.username = username
        githubCredential.token = password
        GitHubProvider.request(GitHub.login) { result in
            do {
                let response = try result.dematerialize()
                let json = try response.mapJSON()
                print(json)
            } catch {
                let errorMessage = (error as CustomStringConvertible).description
                print(errorMessage)
//                self.showAlert("GitHub Fetch", message: errorMessage)
            }
        }
    }
}
