//
//  AccountRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.01.23.
//

import Foundation

protocol AccountRouterInterface {
    func showEditAccount(input: EditAccountInput, output: EditAccountOutput)
    func closeEditAccount()
    
    func showSignIn()
}

final class AccountRouter {
    private var controller: AccountViewController?
    
    init(controller: AccountViewController) {
        self.controller = controller
    }
}

extension AccountRouter: AccountRouterInterface {
    func showEditAccount(input: EditAccountInput, output: EditAccountOutput) {
        guard let controller = EditAccountAssembly.editAccount(input: input, output: output) else {
            return
        }
        
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func closeEditAccount() {
        controller?.navigationController?.popViewController(animated: true)
    }
    
    func showSignIn() {
        controller?.navigationController?.popToRootViewController(animated: true)
    }
}
