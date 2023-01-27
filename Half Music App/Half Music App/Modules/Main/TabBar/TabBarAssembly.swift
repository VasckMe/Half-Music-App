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
            let libraryViewController = LibraryAssembly.libraryViewController(),
            let accountViewController = AccountAssembly.accountViewController()
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
            selectedImage:  UIImage(systemName: "magnifyingglass.circle.fill")
        )
//        searchViewController.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass.circle.fill")
        
        libraryViewController.tabBarItem = UITabBarItem(
            title: "Library",
            image: UIImage(systemName: "rectangle.stack"),
            selectedImage: UIImage(systemName: "rectangle.stack.fill")
        )
//        libraryViewController.tabBarItem.selectedImage = UIImage(systemName: "rectangle.stack.fill")
        
        accountViewController.tabBarItem = UITabBarItem(
            title: "Account",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        controller.setViewControllers([searchViewController, libraryViewController, accountViewController], animated: true)
        
        return controller
    }
}
