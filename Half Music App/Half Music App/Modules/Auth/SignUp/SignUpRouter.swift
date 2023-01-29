//
//  SignUpRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.12.22.
//

import Foundation
import UIKit
import SwiftUI

//protocol SignUpRouterInterface {
////    func showSignUpSuccessViewController(
////        input: SignUpSuccessModuleInput,
////        output: SignUpSuccessModuleOutput
////    )
////    func closeSignUpSuccessViewController()
////    func showOnboarding()
//}
//
//final class SignUpRouter {
//    private weak var controller: SignUpViewController?
//    
//    init(controller: SignUpViewController) {
//        self.controller = controller
//    }
//}
//
//extension SignUpRouter: SignUpRouterInterface {
//    func showSignUpSuccessViewController(
//        input: SignUpSuccessModuleInput,
//        output: SignUpSuccessModuleOutput
//    ) {
//        guard
//            let signUpSuccessController = SignUpSuccessAssembly.signUpSuccessViewController(
//                input: input,
//                output: output
//            )
//        else {
//            return
//        }
//        
//        controller?.navigationController?.present(signUpSuccessController, animated: true)
//    }
//    
//    func closeSignUpSuccessViewController() {
//        controller?.dismiss(animated: true) {
//            self.controller?.navigationController?.popToRootViewController(animated: true)
//        }
//    }
//    
//    func showOnboarding() {
//        let controller = UIHostingController(rootView: OnboardingView())
//        controller.modalTransitionStyle = .coverVertical
//        controller.modalPresentationStyle = .fullScreen
//        self.controller?.navigationController?.present(controller, animated: true)
//    }
//}
