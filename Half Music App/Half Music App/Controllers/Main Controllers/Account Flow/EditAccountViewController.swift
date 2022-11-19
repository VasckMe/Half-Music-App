//
//  EditAccountViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 25.10.22.
//

import UIKit
import FirebaseAuth

final class EditAccountViewController: UIViewController {
    
    // MARK: - Default properties
    
    let defaultNickname = "user"
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var saveButtonOutlet: UIButton!
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    
    // MARK: - Properties
    
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
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.enablePasswordToggle()
        setup()
    }
    
    // MARK: - IBActions
    
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
        
        nick = nick.isEmpty ? defaultNickname : nick
        
        let queue = DispatchQueue(label: "AuthQueue", attributes: .concurrent)
        let group = DispatchGroup()
        queue.async(group: group) {
            Auth.auth().currentUser?.updateEmail(to: emailText)
            Auth.auth().currentUser?.updatePassword(to: passwordText)
            FireBaseStorageService.userRef.updateChildValues(["email" : emailText])
            FireBaseStorageService.userRef.updateChildValues(["password" : passwordText])
            FireBaseStorageService.userRef.updateChildValues(["nickname" : nick])
        }
        group.notify(queue: .main) {
            delegate.updateAccountVCP()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Private
    
    private func checkButton() {
        let isValid = isValidEmail && isValidPassword
        let isPassNotEmpty = passwordTextField.text?.isEmpty == false
        let isEmailNotEmpty = emailTextField.text?.isEmpty == false
        let isNickNotNil = nicknameTextField.text != nil
        let isSomethingChanged = passwordTextField.text != password
        || emailTextField.text != email
        || nicknameTextField.text != nickname
        if
            isValid,
            isPassNotEmpty,
            isEmailNotEmpty,
            isNickNotNil,
            isSomethingChanged
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
