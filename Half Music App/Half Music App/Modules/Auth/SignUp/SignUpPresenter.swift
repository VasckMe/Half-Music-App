//
//  SignUpPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.12.22.
//

import Foundation
import FirebaseAuth

protocol SignUpPresenterInterface {
    func didTriggerViewLoad()
    func didTriggerViewDissappear()
    
    func didTriggerEmailTextFieldAction(email: String?)
    func didTriggerPasswordTextFieldAction(password: String?)
    func didTriggerConfirmedPasswordTextFieldAction(password: String?, confirmed: String?)
    
    func didTriggerSignUpButton(nickname: String?, email: String?, password: String?)
}

final class SignUpPresenter {
    weak var controller: SignUpViewControllerInterface?
    
    private let router: SignUpRouterInterface?
    
    init(router: SignUpRouterInterface) {
        self.router = router
    }
}
//MARK: - SignUpPresenterInterface
extension SignUpPresenter: SignUpPresenterInterface {
    func didTriggerSignUpButton(nickname: String?, email: String?, password: String?) {
        guard
            let email = email,
            let password = password
        else {
            controller?.showErrorAlert(title: "Error", message: "Wrong data")
            return
        }
        let nick = nickname?.isEmpty ?? true ? "user" : nickname
        createUser(nickname: nick!, email: email, password: password)
    }
    
    func didTriggerViewLoad() {
        controller?.addKeyBoardObserver()
    }
    
    func didTriggerViewDissappear() {
        controller?.removeKeyBoardObserver()
    }
    
    func didTriggerEmailTextFieldAction(email: String?) {
        guard let email = email else {
            return
        }
        let isValidEmail = VerificationService.isValidEmailAddress(emailAddressString: email)
        
        controller?.changeEmailState(with: isValidEmail)
    }
    
    func didTriggerPasswordTextFieldAction(password: String?) {
        guard let password = password else {
            return
        }
        let isValidPassword = VerificationService.isValidPassword(password: password)
        controller?.changePasswordState(with: isValidPassword)
    }
    
    func didTriggerConfirmedPasswordTextFieldAction(password: String?, confirmed: String?) {
        guard
            let password = password,
            let confirmed = confirmed
        else {
            return
        }
        let isValidPassword = VerificationService.isPasswordConfirm(password: password, confPassword: confirmed)
        controller?.changeConfirmedPasswordState(with: isValidPassword)
    }
}

// MARK: - SignUpSuccessModuleOutput

extension SignUpPresenter: SignUpSuccessModuleOutput {
    func closeSignUpSuccessController() {
        router?.closeSignUpSuccessViewController()
    }
}

// MARK: - Private

private extension SignUpPresenter {
    func createUser(nickname: String, email: String, password: String) {
        self.controller?.showLoading()

        DispatchQueue.global(qos: .utility).async {
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                guard let self = self else {
                    return
                }
                    
                guard let user = user else {
                    let message = error?.localizedDescription ?? "Generic error"
                    self.controller?.showErrorAlert(title: "Error", message: message)
                    self.controller?.hideLoading()
                    return
                }
                    
                let userRef = FireBaseStorageService.usersRef.child(user.user.uid)
                userRef.setValue(
                    ["email": user.user.email,
                     "nickname": nickname,
                     "password": password]
                )
                DispatchQueue.main.async {
                    self.controller?.hideLoading()
                    self.router?.showSignUpSuccessViewController(
                        input: SignUpSuccessModuleInput(nickname: nickname),
                        output: self
                    )
                }
            }
        }
    }
}
