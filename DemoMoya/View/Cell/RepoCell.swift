//
//  RepoCell.swift
//  DemoMoya
//
//  Created by AsianTech on 6/27/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import UIKit
import MVVM

final class RepoCell: UITableViewCell, View {
    var viewModel = RepoCellViewModel(repo: nil) {
        didSet {
            updateView()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }

    func updateView() {
        textLabel?.text = viewModel.name
        detailTextLabel?.text = viewModel.desc
    }
}
