//
//  SignUpSuccessAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.12.22.
//

import UIKit

struct SignUpSuccessAssembly {
    static func signUpSuccessViewController(
        input: SignUpSuccessModuleInput,
        output: SignUpSuccessModuleOutput
    ) -> SignUpSuccessViewController? {
        guard
            let viewController = UIStoryboard(
                name: "SignUpSuccessViewController", bundle: nil
            ).instantiateViewController(
            withIdentifier: "SignUpSuccessVC"
            ) as? SignUpSuccessViewController
        else {
            return nil
        }
        
        let presenter = SignUpSuccessPresenter(
            input: input,
            output: output
        )
        
        viewController.presenter = presenter
        presenter.controller = viewController
        
        return viewController
    }
}
