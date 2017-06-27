//
//  RepoListViewModel.swift
//  DemoMoya
//
//  Created by AsianTech on 6/27/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation
import MVVM
import ObjectMapper

final class RepoListViewModel: ViewModel {
    weak var delegate: ViewModelDelegate?
    private var repos: [Repo] = []

    func numberOfSections() -> Int {
        return 1
    }

    func numberOfItems(inSection section: Int) -> Int {
        return repos.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> RepoCellViewModel {
        guard !repos.isEmpty else {
            fatalError("Please call `fetch()` first.")
        }
        let repo = repos[indexPath.row]
        return RepoCellViewModel(repo: repo)
    }

    enum GetReposResult {
        case success
        case failure(Error)
    }

    typealias GetReposCompletion = (GetReposResult) -> Void

    func getRepos(completion: @escaping GetReposCompletion) {
        let target = GitHub.repoList(type: .all, sort: .fullName, direction: .desc)
        GitHubProvider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    _ = try response.filterSuccessfulStatusCodes()
                    let jsonObject = try response.mapJSON()
                    if let repos = Mapper<Repo>().mapArray(JSONObject: jsonObject) {
                        self.repos = repos
                    }
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
