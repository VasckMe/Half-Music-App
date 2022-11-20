//
//  SignUpViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.09.22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

final class SignUpViewController: BaseViewController {
    
    let defaultNickname = "user"
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var nickTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField! {
        didSet {
            emailTextField.layer.borderWidth = 2
        }
    }
    @IBOutlet private weak var wrongEmailLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.layer.borderWidth = 2
        }
    }
    @IBOutlet private weak var wrongPasswordLabel: UILabel!
    @IBOutlet var indicatorViews: [UIView]!
    @IBOutlet private weak var confirmedPasswordTextField: UITextField! {
        didSet {
            confirmedPasswordTextField.layer.borderWidth = 2
        }
    }
    @IBOutlet private weak var wrongConfirmedPasswordLabel: UILabel!
    @IBOutlet private weak var signUpButtonOutlet: UIButton!
    
    // MARK: - Internal
    
    var ref = FireBaseStorageService.usersRef
    
    var isValidEmail = false {
        didSet {
            checkSignUpButton()
        }
    }
    var isValidPassword = PasswordDifficult.bad {
        didSet {
            checkSignUpButton()
        }
    }
    var isValidConfPass = false {
        didSet {
            checkSignUpButton()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        addNotificationKBObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeNotificationKBObservers()
    }
    
    // MARK: - Private
    
    @IBAction private func emailTFAction() {
        isValidEmail = VerificationService.isValidEmailAddress(
            emailAddressString: emailTextField.text
        )
        emailTextField.layer.borderColor = isValidEmail ? UIColor.clear.cgColor : UIColor.red.cgColor
        wrongEmailLabel.isHidden = isValidEmail
    }
    
    @IBAction private func passwordTFAction() {
        isValidPassword = VerificationService.isValidPassword(password: passwordTextField.text)
        setupPasswordIndicator(passStrength: isValidPassword)
        passwordTextField.layer.borderColor = isValidPassword != .bad ? UIColor.clear.cgColor : UIColor.red.cgColor
        
        wrongPasswordLabel.isHidden = isValidPassword != .bad
    }
    
    @IBAction private func confPassTFAction() {
        isValidConfPass = VerificationService.isPasswordConfirm(
            password: passwordTextField.text,
            confPassword: confirmedPasswordTextField.text
        )
        confirmedPasswordTextField.layer.borderColor = isValidConfPass ? UIColor.clear.cgColor : UIColor.red.cgColor
        
        wrongConfirmedPasswordLabel.isHidden = isValidConfPass
    }
    
    @IBAction private func signUpAction() {
        signUp()
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: - Extension Logic

extension SignUpViewController {
    
    // MARK: - Private
    
    private func setupPasswordIndicator(passStrength: PasswordDifficult) {
        for (index, view) in indicatorViews.enumerated() {
            if index <= passStrength.rawValue {
                view.alpha = 1.0
            } else {
                view.alpha = 0.3
            }
        }
    }
    
    private func checkSignUpButton() {
        signUpButtonOutlet.isEnabled = isValidEmail && isValidPassword != .bad && isValidConfPass
    }
    
    private func signUp() {
        guard
            let email = emailTextField.text,
            let nickname = nickTextField?.text,
            let password = passwordTextField.text
        else {
            callDefaultAlert(title: "Error", message: "Wrong data")
            return
        }
    
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else {
                return
            }
            
            guard let user = user else {
                let message = error?.localizedDescription ?? "Generic error"
                self.callDefaultAlert(title: "Error", message: message)
                return
            }
                            
            let userRef = self.ref.child(user.user.uid)
            userRef.setValue(
                ["email": user.user.email,
                 "nickname": nickname.isEmpty ? self.defaultNickname : nickname,
                 "password": password]
            )
            self.goToMessageVC()
        }
    }
    
    private func goToMessageVC() {
        guard let vc = SignUpMessageViewController.storyboardInstance() else {
            return
        }
        if let nick = nickTextField.text, !nick.isEmpty {
            vc.nickname = nick
        } else {
            vc.nickname = defaultNickname
        }
        navigationController?.present(vc, animated: true)
    }
}
