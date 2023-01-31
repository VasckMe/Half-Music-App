//
//  AccountRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.01.23.
//

protocol AccountRouterInterface {
    func showEditAccount(input: EditAccountInput, output: EditAccountOutput)
    func closeEditAccount()
    
    func showSignIn()
}

final class AccountRouter {
    private weak var controller: AccountViewController?
    
    init(controller: AccountViewController) {
        self.controller = controller
    }
}

extension AccountRouter: AccountRouterInterface {
    func showEditAccount(input: EditAccountInput, output: EditAccountOutput) {
        guard let editAccountController = EditAccountAssembly.editAccount(input: input, output: output) else {
            return
        }
        
        controller?.navigationController?.pushViewController(editAccountController, animated: true)
    }
    
    func closeEditAccount() {
        controller?.navigationController?.popViewController(animated: true)
    }
    
    func showSignIn() {
        controller?.navigationController?.popToRootViewController(animated: true)
    }
}
