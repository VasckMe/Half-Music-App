//
//  SignInViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.09.22.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // MARK: Properties
    
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction private func loginAction() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                print("Error ocured: \(error.localizedDescription)")
            } else if let _ = user {
                self?.performSegue(withIdentifier: "GoToMainTBVC", sender: nil)
                return
            } else {
                print("ERROR LOGIN AMOGUS ACTION")
            }
        }
    }
    
    @objc func kbDidShow(notification: Notification) {
        self.view.frame.origin.y = 0
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= (keyboardSize.height / 2)
        }
    }
    
    @objc func kbDidHide() {
        self.view.frame.origin.y = 0
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
