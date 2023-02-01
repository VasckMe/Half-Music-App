//
//  SignUpViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.09.22.
//

import UIKit

protocol SignUpViewControllerInterface: AnyObject {
    func addKeyBoardObserver()
    func removeKeyBoardObserver()
    
    func changeEmailState(with valid: Bool)
    func changePasswordState(with valid: PasswordDifficult)
    func changeConfirmedPasswordState(with valid: Bool)
    
    func showErrorAlert(title: String?, message: String?)
    func showLoading()
    func hideLoading()
}

final class SignUpViewController: UIViewController {
    
    var presenter: SignUpPresenterInterface?
    
    @IBOutlet private weak var nickTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var wrongEmailLabel: UILabel!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var wrongPasswordLabel: UILabel!
    @IBOutlet var indicatorViews: [UIView]!
    @IBOutlet private weak var confirmedPasswordTextField: UITextField!
    @IBOutlet private weak var wrongConfirmedPasswordLabel: UILabel!
    @IBOutlet private weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Internal
    
    var ref = FireBaseStorageService.usersRef
    
    var isValidEmail = false {
        didSet {
            checkSignUpButton()
            emailTextField.layer.borderColor = isValidEmail ? UIColor.clear.cgColor : UIColor.red.cgColor
            wrongEmailLabel.isHidden = isValidEmail
        }
    }
    var isValidPassword = PasswordDifficult.bad {
        didSet {
            checkSignUpButton()
            setupPasswordIndicator(passStrength: isValidPassword)
            passwordTextField.layer.borderColor = isValidPassword != .bad
            ? UIColor.clear.cgColor
            : UIColor.red.cgColor
            wrongPasswordLabel.isHidden = isValidPassword != .bad
        }
    }
    var isValidConfPass = false {
        didSet {
            checkSignUpButton()
            confirmedPasswordTextField.layer.borderColor = isValidConfPass ? UIColor.clear.cgColor : UIColor.red.cgColor
            wrongConfirmedPasswordLabel.isHidden = isValidConfPass
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        presenter?.didTriggerViewLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.didTriggerViewDissappear()
    }
    
    // MARK: - Private
    
    @IBAction private func emailTFAction() {
        presenter?.didTriggerEmailTextFieldAction(email: emailTextField.text)
    }
    
    @IBAction private func passwordTFAction() {
        presenter?.didTriggerPasswordTextFieldAction(password: passwordTextField.text)
        presenter?.didTriggerConfirmedPasswordTextFieldAction(
            password: passwordTextField.text,
            confirmed: confirmedPasswordTextField.text
        )
    }
    
    @IBAction private func confPassTFAction() {
        presenter?.didTriggerConfirmedPasswordTextFieldAction(
            password: passwordTextField.text,
            confirmed: confirmedPasswordTextField.text
        )
    }
    
    @IBAction private func signUpAction() {
        presenter?.didTriggerSignUpButton(
            nickname: nickTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text
        )
    }
}

// MARK: - UITextFieldDelegate

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

// MARK: SignUpViewControllerInterface

extension SignUpViewController: SignUpViewControllerInterface {
    func addKeyBoardObserver() {
        addNotificationKBObservers()
    }
    
    func removeKeyBoardObserver() {
        removeNotificationKBObservers()
    }
    
    func changeEmailState(with valid: Bool) {
        isValidEmail = valid
    }
    
    func changePasswordState(with valid: PasswordDifficult) {
        isValidPassword = valid
    }
    
    func changeConfirmedPasswordState(with valid: Bool) {
        isValidConfPass = valid
    }
    
    func showErrorAlert(title: String? = "Error", message: String? = "Wrong data") {
        callDefaultAlert(title: title!, message: message!)
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
        blurView.isHidden = false
    }
    
    func hideLoading() {
        activityIndicator.stopAnimating()
        blurView.isHidden = true
    }
}

// MARK: Private extension

private extension SignUpViewController {
    func setup() {
        title = "Sign Up"
        blurView.isHidden = true
        emailTextField.layer.borderWidth = 2
        passwordTextField.enablePasswordToggle()
        passwordTextField.layer.borderWidth = 2
        confirmedPasswordTextField.enablePasswordToggle()
        confirmedPasswordTextField.layer.borderWidth = 2
    }
    
    func setupPasswordIndicator(passStrength: PasswordDifficult) {
        for (index, view) in indicatorViews.enumerated() {
            if index <= passStrength.rawValue {
                view.alpha = 1.0
            } else {
                view.alpha = 0.3
            }
        }
    }
    
    func checkSignUpButton() {
        signUpButtonOutlet.isEnabled = isValidEmail && isValidPassword != .bad && isValidConfPass
    }
}
