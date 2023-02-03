//
//  SignInRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 2.01.23.
//

import UIKit
import SwiftUI

protocol SignInRouterInterface {
    func showMainTabBarController()
    func showOnBoardingController()
    
    func showSignUpViewController(output: SignUpOutput)
    func closeSignUpViewController()
}

final class SignInRouter {
    private weak var controller: SignInViewController?
    
    init(controller: SignInViewController) {
        self.controller = controller
    }
}

extension SignInRouter: SignInRouterInterface {
    func showMainTabBarController() {
        guard let tabBarController = TabBarAssembly.tabBarViewController() else {
            return
        }
        
        controller?.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func showOnBoardingController() {
        let onboardingController = UIHostingController(rootView: OnboardingView())
        onboardingController.modalTransitionStyle = .coverVertical
        onboardingController.modalPresentationStyle = .fullScreen
        
        controller?.navigationController?.present(onboardingController, animated: true)
    }
    
    func showSignUpViewController(output: SignUpOutput) {
        guard let signUpController = SignUpAssembly.signUpController(output: output) else {
            return
        }

        controller?.navigationController?.pushViewController(signUpController, animated: true)
    }
    
    func closeSignUpViewController() {
        controller?.navigationController?.popToRootViewController(animated: true)
    }
}
