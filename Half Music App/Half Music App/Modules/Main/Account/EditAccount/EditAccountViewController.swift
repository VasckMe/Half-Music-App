//
//  EditAccountViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 25.10.22.
//

import UIKit
import FirebaseAuth

protocol EditAccountViewControllerInterface: AnyObject {
    func setNickname(nickname: String?)
    func setEmail(email: String?)
    func setPassword(password: String?)
    
    func emailErrorIsHidden(isHidden: Bool)
    func passwordErrorIsHidden(isHidden: Bool)
    
    func saveButtonIsEnabled(isEnabled: Bool)
    
    func getUserData() -> EditAccountPrivateInput
}

final class EditAccountViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var nicknameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var saveButtonOutlet: UIButton! {
        didSet {
            saveButtonOutlet.layer.borderColor = UIColor.darkGray.cgColor
            saveButtonOutlet.layer.borderWidth = 4
            saveButtonOutlet.layer.cornerRadius = saveButtonOutlet.frame.height/2
        }
    }
    
    @IBOutlet private weak var emailErrorLabel: UILabel!
    @IBOutlet private weak var passwordErrorLabel: UILabel!
    
    var presenter: EditAccountPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.enablePasswordToggle()
        presenter?.didTriggerViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - IBActions
    
    @IBAction private func nicknameTFAction() {
        presenter?.didTriggerNickname()
    }
    
    @IBAction private func emailTFAction() {
        presenter?.didTriggerEmail(email: emailTextField.text)
    }
    
    @IBAction private func passwordTFAction() {
        presenter?.didTriggerPassword(password: passwordTextField.text)
    }
    
    @IBAction private func saveAction() {
        presenter?.didTriggerSave()
    }
}

// MARK: - EditAccountViewControllerInterface

extension EditAccountViewController: EditAccountViewControllerInterface {
    func setNickname(nickname: String?) {
        nicknameTextField.text = nickname
    }
    
    func setEmail(email: String?) {
        emailTextField.text = email
    }
    
    func setPassword(password: String?) {
        passwordTextField.text = password
    }
    
    func emailErrorIsHidden(isHidden: Bool) {
        emailErrorLabel.isHidden = isHidden
    }
    
    func passwordErrorIsHidden(isHidden: Bool) {
        passwordErrorLabel.isHidden = isHidden
    }
    
    func saveButtonIsEnabled(isEnabled: Bool) {
        saveButtonOutlet.isEnabled = isEnabled
    }
    
    func getUserData() -> EditAccountPrivateInput {
        let input = EditAccountPrivateInput(
            nickname: nicknameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text
        )
        
        return input
    }
}
