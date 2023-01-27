//
//  EditAccountAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.01.23.
//

import UIKit

struct EditAccountAssembly {
    static func editAccount(input: EditAccountInput, output: EditAccountOutput) -> EditAccountViewController? {
        guard
            let controller = UIStoryboard(
                name: "EditAccountViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "EditVC"
            ) as? EditAccountViewController
        else {
            return nil
        }
        
        let presenter = EditAccountPresenter(input: input, output: output)
        presenter.controller = controller
        
        controller.presenter = presenter
        
        return controller
    }
}
