//
//  SignUpAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.12.22.
//

import UIKit

struct SignUpAssembly {
    static func signUpController(output: SignUpOutput) -> SignUpViewController? {
        guard
            let viewController = UIStoryboard(
                name: "SignUpViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "SignUpVC"
            ) as? SignUpViewController
        else {
            return nil
        }
//        let router = SignUpRouter(controller: viewController)
        let presenter = SignUpPresenter(output: output)
        
        presenter.controller = viewController
        viewController.presenter = presenter
        
        return viewController
    }
    
    
    
//    static func signUpController() -> SignUpViewController? {
//        guard
//            let viewController = UIStoryboard(
//                name: "SignUpViewController",
//                bundle: nil
//            ).instantiateViewController(
//                withIdentifier: "SignUpVC") as? SignUpViewController
//        else {
//            return SignUpViewController()
//        }
//
//        let router = SignUpRouter(controller: viewController)
//        let presenter = SignUpPresenter(router: router)
//
//        presenter.controller = viewController
////        viewController.presenter = presenter
//
//        return viewController
//    }
}
