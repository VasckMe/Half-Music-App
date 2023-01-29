//
//  EditAccountPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.01.23.
//

import Foundation
import FirebaseAuth


protocol EditAccountOutput: AnyObject {
    func updateUserData()
    func closeEditAccount()
}

struct EditAccountInput {
    var nickname: String?
    var email: String?
    var password: String?
}

struct EditAccountPrivateInput {
    var nickname: String?
    var email: String?
    var password: String?
}

protocol EditAccountPresenterInterface {
    func didTriggerViewLoad()
    
    func didTriggerNickname()
    func didTriggerEmail(email: String?)
    func didTriggerPassword(password: String?)
    func didTriggerSave()
}

final class EditAccountPresenter {
    weak var controller: EditAccountViewControllerInterface?
    
    private var input: EditAccountInput
    private weak var output: EditAccountOutput?
    
    var isValidEmail = true {
        didSet {
            checkSaveButton()
        }
    }
    
    var isValidPassword = true {
        didSet {
            checkSaveButton()
        }
    }
    
    init(input: EditAccountInput, output: EditAccountOutput) {
        self.input = input
        self.output = output
    }
}

extension EditAccountPresenter: EditAccountPresenterInterface {
    func didTriggerViewLoad() {
        setupUI()
    }
    
    func didTriggerNickname() {
        checkSaveButton()
    }
    
    func didTriggerEmail(email: String?) {
        checkEmail(email: email)
    }
    
    func didTriggerPassword(password: String?) {
        checkPassword(password: password)
    }
    
    func didTriggerSave() {
        saveAction()
    }
}

private extension EditAccountPresenter {
    func setupUI() {
        controller?.setNickname(nickname: input.nickname)
        controller?.setEmail(email: input.email)
        controller?.setPassword(password: input.password)
    }
    
    func checkEmail(email: String?) {
        let result = VerificationService.isValidEmailAddress(emailAddressString: email)
        isValidEmail = result
        controller?.emailErrorIsHidden(isHidden: isValidEmail)
    }
    
    func checkPassword(password: String?) {
        let result = VerificationService.isValidPassword(password: password)
        isValidPassword = result != .bad
        controller?.passwordErrorIsHidden(isHidden: isValidPassword)
    }
    
    func checkSaveButton() {
        let input = controller?.getUserData()
        
        let isValid = isValidEmail && isValidPassword
        let isPassNotEmpty = input?.password?.isEmpty == false
        let isEmailNotEmpty = input?.email?.isEmpty == false
        let isNickNotNil = input?.nickname != nil
        let isSomethingChanged = input?.password != input?.password
        || input?.email != input?.email
        || input?.nickname != input?.nickname
        
        if
            isValid,
            isPassNotEmpty,
            isEmailNotEmpty,
            isNickNotNil,
            isSomethingChanged
        {
            controller?.saveButtonIsEnabled(isEnabled: true)
        } else {
            controller?.saveButtonIsEnabled(isEnabled: false)
        }
    }
    
    func saveAction() {
        let input = controller?.getUserData()

        guard
            let email = input?.email,
            let password = input?.password
        else {
            return
        }
        
        let queue = DispatchQueue(label: "AuthQueue", attributes: .concurrent)
        let group = DispatchGroup()
        queue.async(group: group) {
            Auth.auth().currentUser?.updateEmail(to: email)
            Auth.auth().currentUser?.updatePassword(to: password)
            FireBaseStorageService.userRef.updateChildValues(["email" : email])
            FireBaseStorageService.userRef.updateChildValues(["password" : password])
            FireBaseStorageService.userRef.updateChildValues(["nickname" : input?.nickname ?? "User"])
        }
        group.notify(queue: .main) {
            self.output?.updateUserData()
            self.output?.closeEditAccount()
        }
    }
}
