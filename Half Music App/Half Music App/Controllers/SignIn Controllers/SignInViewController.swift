//
//  SignInViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.09.22.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import FirebaseAuth

final class SignInViewController: BaseViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.enablePasswordToggle()
        addAuthStateListener()
        addNotificationKBObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
        removeNotificationKBObservers()
    }
    
    // MARK: - IBActions
    
    @IBAction func goToSignUp() {
        guard
            let controller = SignUpAssembly.signUpController()
                
        else {
            return
        }

        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    @IBAction private func loginAction() {
        signUp()
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

// MARK: - Extension Logic
extension SignInViewController {
    
    // MARK: - Private
    
    private func addAuthStateListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let _ = user else {
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC")
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .coverVertical
            self?.present(vc, animated: true)
        }
    }
    
    private func signUp() {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                self?.callDefaultAlert(title: "Error", message: "\(error.localizedDescription)")
            } else if let _ = user {
                
                let vc = UIHostingController(rootView: OnboardingView())
                vc.modalTransitionStyle = .coverVertical
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
                return
            } else {
                self?.callDefaultAlert(title: "Error", message: "Uknown problem O_o")
            }
        }
    }
}
