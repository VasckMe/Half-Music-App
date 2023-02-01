//
//  AccountViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 22.10.22.
//

import UIKit
import FirebaseAuth

protocol AccountViewControllerInterface: AnyObject {
    func setNickname(nickname: String?)
    func setEmail(email: String?)
    func setPassword(password: String?)
    
    func activityIndicatorIsAnimating(isAnimating: Bool)
    func blurViewIsHidden(isHidden: Bool)
    
    func callAlertWithClosure(title: String, message: String, titleForAction: String, closure: @escaping () -> ())
    func callAlert(title: String, message: String)
    func callSettingsAlert(
        password: String,
        edit: @escaping () -> (),
        logout: @escaping () -> (),
        delete: @escaping () -> ()
    )
}

final class AccountViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var passTextField: UITextField!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: AccountPresenterInterface?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didTriggerViewLoad()
        passTextField.enablePasswordToggle()
        passTextField.delegate = self
    }
    
    // MARK: - IBActions
    
    @IBAction private func editAction(_ sender: UIBarButtonItem) {
//        guard let passw = passTextField.text else {
//            return
//        }
//        callAccountSettingsAlertSheet(password: passw) {
//            self.edit()
//        } logoutCompletion: {
//            self.logout()
//        } deleteCompletion: {
//            self.deleteAccount()
//        }
    }
    
    @IBAction func settingsAction() {
        guard let passw = passTextField.text else {
            return
        }
        callAccountSettingsAlertSheet(password: passw) {
            self.edit()
        } logoutCompletion: {
            self.logout()
        } deleteCompletion: {
            self.deleteAccount()
        }
    }
}

// MARK: - UITextFieldDelegate

extension AccountViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - AccountViewControllerInterface

extension AccountViewController: AccountViewControllerInterface {
    func setNickname(nickname: String?) {
        nicknameLabel.text = nickname
    }
    
    func setEmail(email: String?) {
        emailLabel.text = email
    }
    
    func setPassword(password: String?) {
        passTextField.text = password
    }
    
    func activityIndicatorIsAnimating(isAnimating: Bool) {
        isAnimating
        ? activityIndicator.startAnimating()
        : activityIndicator.stopAnimating()
    }
    
    func blurViewIsHidden(isHidden: Bool) {
        blurView.isHidden = isHidden
    }
    
    func callAlertWithClosure(title: String, message: String, titleForAction: String, closure: @escaping () -> ()) {
        callClosureAlert(title: title, message: message, titleForAction: titleForAction, closure: closure)
    }
    func callAlert(title: String, message: String) {
        callDefaultAlert(title: title, message: message)
    }
    
    func callSettingsAlert(password: String, edit: @escaping () -> (), logout: @escaping () -> (), delete: @escaping () -> ()) {
        callAccountSettingsAlertSheet(
            password: password,
            editCompletion: edit,
            logoutCompletion: logout,
            deleteCompletion: delete
        )
    }
}

// MARK: - Private

private extension AccountViewController {
    private func edit() {
        let input = EditAccountInput(nickname: nicknameLabel.text, email: emailLabel.text, password: passTextField.text)
        presenter?.editAcction(input: input)
    }
    
    private func logout() {
        presenter?.logoutAction()
    }
    
    private func deleteAccount() {
        presenter?.removeAction()
    }
}

