//
//  SignInViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.09.22.
//

import UIKit
import SwiftUI
import FirebaseAuth

protocol SignInViewControllerInterface: AnyObject {
    func addNotificationKBObserver()
    func removeNotificationKBObserver()
    
    func clearTextFields()
    func callAlert(title: String, message: String)

}

final class SignInViewController: BaseViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.enablePasswordToggle()
        }
    }
    
    var presenter: SignInPresenterInterface?
    
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
    
    // MARK: - IBActions
    
    @IBAction func goToSignUp() {
        presenter?.didTriggerSignUp()
    }
    
    @IBAction private func loginAction() {
        presenter?.didTriggerSignIn(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func unwindToSignIn(_ unwindSegue: UIStoryboardSegue) {
        let _ = unwindSegue.source
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
