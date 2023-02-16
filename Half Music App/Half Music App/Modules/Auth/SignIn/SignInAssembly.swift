//
//  SignInAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 2.01.23.
//

import UIKit

struct SignInAssembly {
    static func assemblySignInViewController(with viewController: SignInViewController) {
        let router = SignInRouter(controller: viewController)
        
        let presenter = SignInPresenter(router: router)
        presenter.controller = viewController

        viewController.presenter = presenter
    }
}
