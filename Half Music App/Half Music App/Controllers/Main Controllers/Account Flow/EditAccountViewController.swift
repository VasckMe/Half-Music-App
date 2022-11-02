//
//  EditAccountViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 25.10.22.
//

import UIKit
import FirebaseAuth

class EditAccountViewController: UIViewController {
    
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var saveButtonOutlet: UIButton!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    
    var delegate: UpdateAccountViewControllerProtocol?
    
    var nickname: String?
    var email: String?
    var password: String?
    
    var isValidEmail = true {
        didSet {
            checkButton()
        }
    }
    
    var isValidPassword = true {
        didSet {
            checkButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.enablePasswordToggle()
        setup()
    }
    
    
    @IBAction private func nicknameTFAction() {
        checkButton()
    }
    
    @IBAction private func emailTFAction() {
        let result = VerificationService.isValidEmailAddress(emailAddressString: emailTextField.text)
        isValidEmail = result
        emailErrorLabel.isHidden = isValidEmail
    }
    
    @IBAction private func passwordTFAction() {
        let result = VerificationService.isValidPassword(password: passwordTextField.text)
        isValidPassword = result != . bad
        passwordErrorLabel.isHidden = isValidPassword
    }
    
    
    @IBAction private func saveAction() {
        guard
            var nick = nicknameTextField.text,
            let emailText = emailTextField.text,
            let passwordText = passwordTextField.text,
            let delegate = delegate
        else {
            return
        }
        
        if nick.isEmpty {
            nick = "user"
        }
        
        let queue = DispatchQueue(label: "AuthQueue", attributes: .concurrent)
        let group = DispatchGroup()
        queue.async(group: group) {
            Auth.auth().currentUser?.updateEmail(to: emailText)
            Auth.auth().currentUser?.updatePassword(to: passwordText)
            FireBaseStorageManager.userRef.updateChildValues(["email" : emailText])
            FireBaseStorageManager.userRef.updateChildValues(["password" : passwordText])
            FireBaseStorageManager.userRef.updateChildValues(["nickname" : nick])
        }
        group.notify(queue: .main) {
            delegate.updateAccountVCP()
            self.navigationController?.popViewController(animated: true)
        }
    }
    private func checkButton() {
        if
            isValidEmail && isValidPassword,
            let passwordText = passwordTextField.text,
            !passwordText.isEmpty,
            let emailText = emailTextField.text,
            !emailText.isEmpty,
            let nicknameText = nicknameTextField.text,
            passwordText != password || emailText != email || nicknameText != nickname
        {
            saveButtonOutlet.isEnabled = true
        } else {
            saveButtonOutlet.isEnabled = false
        }
        
    }
    
    private func setup() {
        guard
            let nickname = nickname,
            let email = email,
            let password = password else {
            return
        }
        nicknameTextField.text = nickname
        emailTextField.text = email
        passwordTextField.text = password
        
        saveButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
        saveButtonOutlet.layer.borderWidth = 4
        saveButtonOutlet.layer.cornerRadius = saveButtonOutlet.frame.height/2
    }
}
