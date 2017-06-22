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
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var signInButton: UIButton!
    @IBOutlet private weak var signInButtonBottomConstraint: NSLayoutConstraint!
    let viewModel = LoginViewModel()

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
        signInButtonBottomConstraint.constant = keyboardFrame.size.height
    }

    fileprivate func showAlert(title: String, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(ok)
        present(alertController, animated: true, completion: nil)
    }

    @IBAction private func didSelectSignInButton(_ sender: UIButton) {
        viewModel.username = userNameTextfield.text.content
        viewModel.password = passwordTextfield.text.content
        viewModel.login { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success: break
            case .failure(let message):
                this.showAlert(title: "Error", message: message)
            }
        }
    }
}
