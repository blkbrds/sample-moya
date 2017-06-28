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
import Moya

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
        case failure(NSError)
    }

    typealias GetReposCompletion = (RepoListViewModel.GetReposResult) -> Void

    func getRepos(completion: @escaping GetReposCompletion) {
        let target = MultiTarget(GitHub.repoList(type: .all, sort: .fullName, direction: .desc))
        GitHubProvider.requestDecoded(target) { result in
            switch result {
            case .success(let jsonObject):
                if let repos = Mapper<Repo>().mapArray(JSONObject: jsonObject) {
                    self.repos = repos
                }
                completion(.success)
            case .failure(let error):
                completion(.failure(error as NSError))
            }
        }
    }
}
