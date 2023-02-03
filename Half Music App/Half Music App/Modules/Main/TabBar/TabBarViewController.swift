//
//  TabBarViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

import UIKit
import FirebaseAuth

protocol TabBarViewControllerInterface: AnyObject {
    func addSubviewOnTabBar(view: UIView?)
}

final class TabBarViewController: UITabBarController {
    var presenter: TabBarPresenterInterface?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        setup()
    }
}

// MARK: - TabBarViewControlerInterface

extension TabBarViewController: TabBarViewControllerInterface {
    func addSubviewOnTabBar(view: UIView?) {
        guard let view = view else {
            return
        }
        
        self.view.addSubview(view)
    }
}

// MARK: - Private

private extension TabBarViewController {
    func setup() {
        let height: CGFloat = 60
        let navigationBarHeight: CGFloat = navigationController?.navigationBar.bounds.height ?? 44
        let frame =  CGRect(
            x: 0,
            y: view.bounds.height - tabBar.bounds.height - height - navigationBarHeight,
            width: view.bounds.width,
            height: height
        )
        
        presenter?.setupXib(with: frame)
    }
}
