//
//  SignUpSuccessPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.12.22.
//

import Foundation

protocol SignUpSuccessPresenterInterface {
    func didTriggerViewLoad()
    func didTriggerContinueButton()
}

protocol SignUpSuccessModuleOutput: AnyObject {
    func closeSignUpSuccessController()
}

struct SignUpSuccessModuleInput {
    let nickname: String
}

final class SignUpSuccessPresenter {
    weak var controller: SignUpSuccessViewControllerInterface?
        
    private let input: SignUpSuccessModuleInput
    private weak var output: SignUpSuccessModuleOutput?

    init(input: SignUpSuccessModuleInput, output: SignUpSuccessModuleOutput) {
        self.input = input
        self.output = output
    }
}

// MARK: - SignUpSuccessPresenterInterface

extension SignUpSuccessPresenter: SignUpSuccessPresenterInterface {
    func didTriggerViewLoad() {
        controller?.writeNickname(nick: input.nickname)
    }
    func didTriggerContinueButton() {
        output?.closeSignUpSuccessController()
    }
}
