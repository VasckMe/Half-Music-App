//
//  SignInViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.09.22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

final class SignInViewController: BaseViewController {

    // MARK: IBOutlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.enablePasswordToggle()
        
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let _ = user else {
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC")
//            nc.modalPresentationStyle = .fullScreen
//            nc.modalTransitionStyle = .coverVertical
//            self?.navigationController?.present(nc, animated: true)
//            self?.navigationController?.pushViewController(nc, animated: true)
            self?.present(nc, animated: true)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbDidShow),
            name: UIWindow.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(kbDidHide),
            name: UIWindow.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Actions
    
    @IBAction private func loginAction() {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                self?.callDefaultAlert(title: "Error", message: "\(error.localizedDescription)")
            } else if let _ = user {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC") as! UITabBarController
//                tabBarController.modalPresentationStyle = .fullScreen
//                tabBarController.modalTransitionStyle = .coverVertical
//                self?.present(tabBarController, animated: true)
                self?.navigationController?.pushViewController(tabBarController, animated: true)

//                self?.navigationController?.present(tabBarController, animated: true)
                
                return
            } else {
                self?.callDefaultAlert(title: "Error", message: "Uknown problem O_o")
            }
        }
    }
    
    @IBAction func unwindToSignIn(_ unwindSegue: UIStoryboardSegue) {
        let _ = unwindSegue.source
    }
    
    // MARK: Private
    
    @objc private func kbDidShow(notification: Notification) {
        self.view.frame.origin.y = 0
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= (keyboardSize.height / 2)
        }
    }
    
    @objc private func kbDidHide() {
        self.view.frame.origin.y = 0
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
