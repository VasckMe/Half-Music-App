//
//  SignInPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 2.01.23.
//

import Foundation
import FirebaseAuth
import SwiftUI

protocol SignInPresenterInterface {
    func didTriggerViewLoad()
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerSignUp()
    func didTriggerSignIn(email: String?, password: String?)
}

final class SignInPresenter {
    weak var controller: SignInViewControllerInterface?
    
    private var router: SignInRouter?
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    
    init(router: SignInRouter) {
        self.router = router
    }
}

// MARK: - SignInPresenterInterface
extension SignInPresenter: SignInPresenterInterface {
    func didTriggerViewLoad() {
        addAuthStateDidChangeListener()
        addNotificationKBObserver()
    }
    
    func didTriggerViewAppear() {
        controller?.clearTextFields()
    }
    
    func didTriggerViewDisappear() {
        removeNotificationKBObserver()
        removeAuthStateDidChangeListener()
    }
    
    func didTriggerSignUp() {
        router?.showSignUpViewController()
    }

    func didTriggerSignIn(email: String?, password: String?) {
        signIn(email: email, password: password)
    }
    
}

// MARK: Private
private extension SignInPresenter {
    func addAuthStateDidChangeListener() {
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard
                let self = self,
                let _ = user
            else {
                return
            }
            self.router?.showMainTabBarController()
        }
    }
    
    func removeAuthStateDidChangeListener() {
        guard let listener = authStateDidChangeListenerHandle else {
            return
        }
        Auth.auth().removeStateDidChangeListener(listener)
    }
    
    func addNotificationKBObserver() {
        controller?.addNotificationKBObserver()
    }
    
    func removeNotificationKBObserver() {
        controller?.removeNotificationKBObserver()
    }
    
    func signIn(email: String?, password: String?) {
        guard
            let email = email,
            let password = password
        else {
            controller?.callAlert(title: "Error", message: "bad auth")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            guard let self = self else {
                return
            }
            
            if let error = error {
                self.controller?.callAlert(title: "Error", message: "\(error.localizedDescription)")
            } else if let _ = user {
                self.router?.showOnBoardingController()
                return
            } else {
                self.controller?.callAlert(title: "Error", message: "Uknown problem O_o")
            }
        }
    }
}
