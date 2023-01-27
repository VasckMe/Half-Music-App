//
//  AccountAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.01.23.
//

import UIKit

struct AccountAssembly {
    static func accountViewController() -> AccountViewController? {
        guard
            let controller = UIStoryboard(
                name: "AccountViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "AccountVC"
            ) as? AccountViewController
        else {
            return nil
        }
        
        let router = AccountRouter(controller: controller)
        
        let presenter = AccountPresenter(router: router)
        presenter.controller = controller
        
        controller.presenter = presenter
        
        return controller
    }
}
