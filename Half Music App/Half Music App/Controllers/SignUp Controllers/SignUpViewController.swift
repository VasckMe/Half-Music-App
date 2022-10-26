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

    // MARK: IBOutlets
    
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
    
    // MARK: Properties
    
    var ref: DatabaseReference!
    
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
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        ref = Database.database().reference(withPath: "users")
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: IBActions
    
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
    
    @IBAction func signUpAction() {
    guard
        let email = emailTextField.text,
        var nickname = nickTextField.text,
        let password = passwordTextField.text
    else {
        print("Wrong data")
        return
        }
    
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                self?.callDefaultAlert(title: "Error", message: "\(error.localizedDescription)")
            } else {
                guard let user = user else {
                    return
                }
                
                nickname = nickname.isEmpty ? "user" : nickname
                
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email, "nickname" : nickname, "password" : password])
                self?.performSegue(withIdentifier: "GoToSignUpMessage", sender: nickname)
            }
        }
    }
    
    // MARK: Private functions
    
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
    
    @objc func kbDidShow(notification: Notification) {
        self.view.frame.origin.y = 0
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= (keyboardSize.height / 2)
        }
    }
    
    @objc func kbDidHide() {
        self.view.frame.origin.y = 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let signUpMessageVC = segue.destination as? SignUpMessageViewController,
            let nickname = sender as? String
        {
            signUpMessageVC.nickname = nickname
        }
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
