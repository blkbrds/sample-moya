//
//  RepoCellViewModel.swift
//  DemoMoya
//
//  Created by AsianTech on 6/27/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import Foundation
import MVVM

final class RepoCellViewModel: ViewModel {
    var name = ""
    var desc: String?

    init(repo: Repo?) {
        guard let repo = repo else { return }
        name = repo.name
        desc = repo.desc
    }
}
