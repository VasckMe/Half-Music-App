//
//  SignUpViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.09.22.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

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
        ref = Database.database().reference(withPath: "users")
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
        let nickname = nickTextField.text,
        let password = passwordTextField.text
    else {
        print("Bad email, nickname, password")
        return
        }
    
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let error = error {
                print("Registration was incorrect\n\(error.localizedDescription)")
            } else {
                guard let user = user else {
                    return
                }
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
