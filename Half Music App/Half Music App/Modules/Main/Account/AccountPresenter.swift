//
//  AccountPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.01.23.
//

import FirebaseAuth

protocol AccountPresenterInterface {
    func didTriggerViewLoad()
    
    func editAcction(input: EditAccountInput)
    func logoutAction()
    func removeAction()
}

final class AccountPresenter {
    weak var controller: AccountViewControllerInterface?
    
    private var router: AccountRouterInterface?
    
    init(router: AccountRouterInterface) {
        self.router = router
    }
}

extension AccountPresenter: EditAccountOutput {
    func updateUserData() {
        controller?.activityIndicatorIsAnimating(isAnimating: true)
        controller?.blurViewIsHidden(isHidden: false)
        fetchUserData()
    }
    func closeEditAccount() {
        router?.closeEditAccount()
    }
}

extension AccountPresenter: AccountPresenterInterface {
    func didTriggerViewLoad() {
        fetchUserData()
    }
    
    func editAcction(input: EditAccountInput) {
        edit(input: input)
    }
    
    func logoutAction() {
        logout()
    }
    
    func removeAction() {
        remove()
    }
}

private extension AccountPresenter {
    func fetchUserData() {
        FireBaseStorageService.userRef.getData { [weak self] error, snapshot in
            guard let self = self else {
                return
            }
            
            guard let snapshot = snapshot else {
                let message = error?.localizedDescription ?? "Generic error"
                self.controller?.callAlertWithClosure(title: "Error", message: message,titleForAction: "Refresh") {
                    self.fetchUserData()
                }
                return
            }
            
            guard
                let snapshotValue = snapshot.value as? [String: Any],
                let nickname = snapshotValue["nickname"] as? String,
                let email = snapshotValue["email"] as? String,
                let password = snapshotValue["password"] as? String
            else {
                self.controller?.callAlert(title: "Error", message: "Bad snapshot")
                return
            }
            
            DispatchQueue.main.async {
                self.controller?.setNickname(nickname: nickname)
                self.controller?.setEmail(email: email)
                self.controller?.setPassword(password: password)
                self.controller?.activityIndicatorIsAnimating(isAnimating: false)
                self.controller?.blurViewIsHidden(isHidden: true)
            }
        }
    }
    
    func edit(input: EditAccountInput) {
        router?.showEditAccount(input: input, output: self)
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            router?.showSignIn()
        } catch {
            controller?.callAlert(title: "Autho error", message: "Sign out error")
        }
    }
    
    func remove() {
        FireBaseStorageService.userRef.removeValue()
        Auth.auth().currentUser?.delete()
        router?.showSignIn()
    }
}
