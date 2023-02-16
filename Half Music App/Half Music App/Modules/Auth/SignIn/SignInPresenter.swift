//
//  SignInPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 2.01.23.
//

import FirebaseAuth

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
        
    init(router: SignInRouter) {
        self.router = router
    }
}

// MARK: - SignInPresenterInterface
extension SignInPresenter: SignInPresenterInterface {
    func didTriggerViewLoad() {
        isLoggedUser()
        addNotificationKBObserver()
    }
    
    func didTriggerViewAppear() {
        controller?.clearTextFields()
    }
    
    func didTriggerViewDisappear() {
        removeNotificationKBObserver()
    }
    
    func didTriggerSignUp() {
        router?.showSignUpViewController(output: self)
    }

    func didTriggerSignIn(email: String?, password: String?) {
        signIn(email: email, password: password)
    }
    
}

extension SignInPresenter: SignUpOutput {
    func showTabBarController() {
        router?.showMainTabBarController()
    }
    func showOnboarding() {
        router?.showOnBoardingController()
    }
    
    func closeSignUp() {
        router?.closeSignUpViewController()
    }
}

// MARK: Private
private extension SignInPresenter {
    func isLoggedUser() {
        if let _ = Auth.auth().currentUser {
            print("user is logged in")
            self.router?.showMainTabBarController()
        } else {
            print("no logged user")
        }
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
                self.router?.showMainTabBarController()
            } else {
                self.controller?.callAlert(title: "Error", message: "Unknown problem O_o")
            }
        }
    }
}
