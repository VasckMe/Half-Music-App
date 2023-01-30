//
//  SignInViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.09.22.
//

import UIKit

protocol SignInViewControllerInterface: AnyObject {
    func addNotificationKBObserver()
    func removeNotificationKBObserver()
    
    func clearTextFields()
    func callAlert(title: String, message: String)

}

final class SignInViewController: BaseViewController {
    var presenter: SignInPresenterInterface?
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.enablePasswordToggle()
        }
    }
    @IBAction func goToSignUp() {
        presenter?.didTriggerSignUp()
    }
    
    @IBAction private func loginAction() {
        presenter?.didTriggerSignIn(email: emailTextField.text, password: passwordTextField.text)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SignInAssembly.assemblySignInViewController(with: self)
        presenter?.didTriggerViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.didTriggerViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.didTriggerViewDisappear()
    }
}

// MARK: - UITextFieldDelegate

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK: - SignInViewControllerInterface

extension SignInViewController: SignInViewControllerInterface {
    func addNotificationKBObserver() {
        addNotificationKBObservers()
    }
    
    func removeNotificationKBObserver() {
        removeNotificationKBObservers()
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func callAlert(title: String, message: String) {
        callDefaultAlert(title: title, message: message)
    }
}
