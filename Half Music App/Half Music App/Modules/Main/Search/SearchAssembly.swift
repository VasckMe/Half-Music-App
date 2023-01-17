//
//  SearchAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.01.23.
//

import UIKit

struct SearchAssembly {
    static func searchViewController() -> SearchViewController {
        guard
            let controller = UIStoryboard(
                name: "SearchViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "SearchVC"
            ) as? SearchViewController
        else {
            return SearchViewController()
        }
        
        let router = SearchRouter(controller: controller)
        let presenter = SearchPresenter(router: router)
        
        presenter.controller = controller
        controller.presenter = presenter
        
        
        return controller
    }
}
