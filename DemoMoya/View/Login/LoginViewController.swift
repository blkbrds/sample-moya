//
//  LoginViewController.swift
//  DemoMoya
//
//  Created by AsianTech on 6/21/17.
//  Copyright © 2017 hoanv. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    @IBOutlet private weak var userNameTextfield: UITextField!
    @IBOutlet private weak var tokenTextfield: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signInButtonBottomConstraint: NSLayoutConstraint!
    let viewModel = LoginViewModel()
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerNotification()
    }

    // MARK: - Function
    private func registerNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardDidChangeFrame),
            name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil
        )
    }

    private func setupView() {
        title = "Github"
        userNameTextfield.becomeFirstResponder()
    }

    @objc private func handleKeyboardDidChangeFrame(notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }
        if keyboardFrame.size.height == 0 {
            signInButtonBottomConstraint.constant = -signInButton.bounds.height
        } else {
            signInButtonBottomConstraint.constant = keyboardFrame.size.height
        }
    }

    @IBAction private func didSelectSignInButton(_ sender: UIButton) {
        viewModel.username = userNameTextfield.text.content
        viewModel.accessToken = tokenTextfield.text.content
        signInButton.isEnabled = false
        indicatorView.startAnimating()
        viewModel.login { [weak self] result in
            guard let this = self else { return }
            this.signInButton.isEnabled = true
            this.indicatorView.stopAnimating()
            switch result {
            case .success:
                let repoListController = RepoListViewController()
                this.navigationController?.pushViewController(repoListController, animated: true)
            case .failure(let error):
                this.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
}
