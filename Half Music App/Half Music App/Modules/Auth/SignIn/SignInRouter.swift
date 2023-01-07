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
    func showSignUpViewController()
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
//        tabBarController.modalPresentationStyle = .fullScreen
//        tabBarController.modalTransitionStyle = .coverVertical
//        controller?.present(tabBarController, animated: true)
        controller?.navigationController?.pushViewController(tabBarController, animated: true)
    }
    
    func showOnBoardingController() {
        let vc = UIHostingController(rootView: OnboardingView())
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .fullScreen
        controller?.present(vc, animated: true)
    }
    
    func showSignUpViewController() {
        guard let signUpController = SignUpAssembly.signUpController() else {
            return
        }
        
        controller?.navigationController?.pushViewController(signUpController, animated: true)
    }
}
