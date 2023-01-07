//
//  TabBarAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

import UIKit

struct TabBarAssembly {
    static func tabBarViewController() -> TabBarViewController? {
        guard
            let controller = UIStoryboard(
                name: "TabBarViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "TabBarVC"
            ) as? TabBarViewController
        else {
            return TabBarViewController()
        }
        let router = TabBarRouter(controller: controller)
        let presenter = TabBarPresenter(router: router)
        
        presenter.controller = controller
        controller.presenter = presenter
        
        
        let searchViewController = SearchAssembly.searchViewController()
        searchViewController.tabBarItem = UITabBarItem(
            title: "Music",
            image: UIImage(systemName: "magnifyingglass.circle.fill"),
            tag: 0
        )
        
        controller.setViewControllers([searchViewController], animated: true)
        
        return controller
    }
}
