//
//  UINavigationController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 1.02.23.
//

import UIKit

extension UINavigationController {
    func setupNavigationController() {
        navigationBar.tintColor = UIConstants.globalTintColor
        navigationBar.barTintColor = UIConstants.navigationTintColor
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}
