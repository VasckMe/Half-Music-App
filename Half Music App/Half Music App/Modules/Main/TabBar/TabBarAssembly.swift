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
            ) as? TabBarViewController,
            let searchViewController = SearchAssembly.searchViewController(),
            let libraryViewController = LibraryAssembly.libraryViewController()
        else {
            return nil
        }
        let router = TabBarRouter(controller: controller)
        let presenter = TabBarPresenter(router: router)
        
        presenter.controller = controller
        controller.presenter = presenter
        
        
        searchViewController.tabBarItem = UITabBarItem(
            title: "Music",
            image: UIImage(systemName: "magnifyingglass.circle"),
            tag: 0
        )
        searchViewController.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        
        libraryViewController.tabBarItem = UITabBarItem(
            title: "Library",
            image: UIImage(systemName: "rectangle.stack"),
            tag: 1
        )
        libraryViewController.tabBarItem.selectedImage = UIImage(systemName: "rectangle.stack.fill")
        
        controller.setViewControllers([searchViewController, libraryViewController], animated: true)
        
        return controller
    }
}
