//
//  GitHubAPI.swift
//  DemoMoya
//
//  Created by AsianTech on 6/21/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation
import Moya

enum GitHub {
    case login
}

extension GitHub: TargetType {
    var baseURL: URL {
        guard let url = URL(string: API.baseUrl) else { fatalError("url string is invalid") }
        return url
    }

    var path: String {
        switch self {
        case .login: return "/user"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var parameters: [String: Any]? {
        switch self {
        default: return nil
        }
    }

    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var task: Task {
        return .request
    }

    var validate: Bool {
        return false
    }

    var sampleData: Data {
        switch self {
        case .login:
            return "".data(using: .utf8)!
            //return "{\"login\":\"at-ios-mvvm\",\"id\":26869290,\"avatar_url\":\"https://avatars3.githubusercontent.com/u/26869290?v=3\",\"gravatar_id\":\"\",\"url\":\"https://api.github.com/users/at-ios-mvvm\",\"html_url\":\"https://github.com/at-ios-mvvm\",\"followers_url\":\"https://api.github.com/users/at-ios-mvvm/followers\",\"following_url\":\"https://api.github.com/users/at-ios-mvvm/following{/other_user}\",\"gists_url\":\"https://api.github.com/users/at-ios-mvvm/gists{/gist_id}\",\"starred_url\":\"https://api.github.com/users/at-ios-mvvm/starred{/owner}{/repo}\",\"subscriptions_url\":\"https://api.github.com/users/at-ios-mvvm/subscriptions\",\"organizations_url\":\"https://api.github.com/users/at-ios-mvvm/orgs\",\"repos_url\":\"https://api.github.com/users/at-ios-mvvm/repos\",\"events_url\":\"https://api.github.com/users/at-ios-mvvm/events{/privacy}\",\"received_events_url\":\"https://api.github.com/users/at-ios-mvvm/received_events\",\"type\":\"User\",\"site_admin\":false,\"name\":null,\"company\":null,\"blog\":\"\",\"location\":null,\"email\":null,\"hireable\":null,\"bio\":null,\"public_repos\":2,\"public_gists\":0,\"followers\":0,\"following\":0,\"created_at\":\"2017-04-03T09:57:08Z\",\"updated_at\":\"2017-05-24T08:09:39Z\",\"private_gists\":0,\"total_private_repos\":0,\"owned_private_repos\":0,\"disk_usage\":2,\"collaborators\":0,\"two_factor_authentication\":false,\"plan\":{\"name\":\"free\",\"space\":976562499,\"collaborators\":0,\"private_repos\":0}}".data(using: .utf8)!
        }
    }
}
