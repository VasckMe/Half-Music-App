//
//  AccountViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 22.10.22.
//

import UIKit
import FirebaseAuth

protocol UpdateAccountViewControllerProtocol {
    func updateAccountVCP()
}

final class AccountViewController: BaseViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var passTextField: UITextField!
    @IBOutlet private weak var blurView: UIVisualEffectView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passTextField.delegate = self
        setupUI()
        passTextField.enablePasswordToggle()
    }
    
    // MARK: - IBActions
    
    @IBAction private func editAction(_ sender: UIBarButtonItem) {
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

// MARK: - UpdateAccountViewControllerProtocol

extension AccountViewController: UpdateAccountViewControllerProtocol {
    func updateAccountVCP() {
        self.activityIndicator.startAnimating()
        self.blurView.isHidden = false
        setupUI()
    }
}

// MARK: - Extension AccountViewController

extension AccountViewController {
    
    // MARK: - Private
    
    private func setupUI() {
        FireBaseStorageService.userRef.getData { [weak self] error, snapshot in
            guard let self = self else {
                return
            }

            guard let snapshot = snapshot else {
                let message = error?.localizedDescription ?? "Generic error"
                self.callClosureAlert(title: "Error", message: message,titleForAction: "Refresh") {
                    self.setupUI()
                }
                return
            }

            guard
                let snapshotValue = snapshot.value as? [String: Any],
                let nickname = snapshotValue["nickname"] as? String,
                let email = snapshotValue["email"] as? String,
                let password = snapshotValue["password"] as? String
            else {
                self.callDefaultAlert(title: "Error", message: "Bad snapshot")
                return
            }

            DispatchQueue.main.async {
                self.nicknameLabel.text = nickname
                self.emailLabel.text = email
                self.passTextField.text = password
            }
            self.activityIndicator.stopAnimating()
            self.blurView.isHidden = true
        }
    }
    
    private func edit() {
        guard let editVC = EditAccountViewController.storyboardInstance() else {
            callDefaultAlert(title: "Error", message: "Cant go to Edit Account Information")
            return
        }
        editVC.nickname = self.nicknameLabel.text
        editVC.email = self.emailLabel.text
        editVC.password = self.passTextField.text
        editVC.delegate = self
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "unwindToSignIn", sender: nil)
        } catch {
            print("Auth signOut error")
        }
    }
    
    private func deleteAccount() {
        FireBaseStorageService.userRef.removeValue()
        Auth.auth().currentUser?.delete()
        self.performSegue(withIdentifier: "unwindToSignIn", sender: nil)
    }
}
