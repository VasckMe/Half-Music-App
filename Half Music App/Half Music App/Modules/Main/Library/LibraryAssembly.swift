//
//  LibraryAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import UIKit

struct LibraryAssembly {
    static func libraryViewController() -> LibraryViewController? {
        guard
            let controller = UIStoryboard(
                name: "LibraryViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "LibraryViewController"
            ) as? LibraryViewController
        else {
            return nil
        }
        
        let router = LibraryRouter(controller: controller)
        let presenter = LibraryPresenter(router: router)
        
        presenter.controller = controller
        controller.presenter = presenter
        
        return controller
    }
}
