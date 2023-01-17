//
//  TabBarViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

import UIKit

protocol TabBarViewControllerInterface: AnyObject {
    func showDetail(with index: Int)
}

final class TabBarViewController: UITabBarController {
    
    var presenter: TabBarPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - TabBarViewControlerInterface
extension TabBarViewController: TabBarViewControllerInterface {
    func showDetail(with index: Int) {
        presenter?.didViewTapped(with: index)
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
        
        let input = NowIsPlayingModuleInput(frame: frame, delegate: self)
        guard let controller = NowIsPlayingAssembly.nowIsPlayingView(input: input) else {
            return
        }

        view.addSubview(controller)
    }
}
