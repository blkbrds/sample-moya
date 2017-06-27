//
//  RepoListViewController.swift
//  DemoMoya
//
//  Created by AsianTech on 6/27/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import UIKit
import MVVM

final class RepoListViewController: UIViewController, View {
    @IBOutlet private weak var tableView: UITableView!

    var viewModel = RepoListViewModel() {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Repo List"
        tableView.register(RepoCell.self, forCellReuseIdentifier: "RepoCell")
        viewModel.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getRepos { [weak self] (result) in
            guard let this = self else { return }
            switch result {
            case .success:
                this.updateView()
            case .failure(let error):
                this.showAlert(title: "Error", message: error.localizedDescription)
            }
            this.viewDidUpdated()
        }
    }

    func updateView() {
        guard isViewLoaded else { return }
        tableView.reloadData()
        viewDidUpdated()
    }
}

extension RepoListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell") as? RepoCell
            else { fatalError() }
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        return cell
    }
}

extension RepoListViewController: ViewModelDelegate {
    func viewModel(_ viewModel: ViewModel, didChangeItemsAt indexPaths: [IndexPath], changeType: ChangeType) {
        updateView()
    }
}
