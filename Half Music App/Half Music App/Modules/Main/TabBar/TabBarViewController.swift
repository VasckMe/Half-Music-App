//
//  TabBarViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

import UIKit

protocol TabBarViewControlerInterface: AnyObject {
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
extension TabBarViewController: TabBarViewControlerInterface {
    func showDetail(with index: Int) {
        presenter?.didViewTapped(with: index)
    }
}

// MARK: - Private
private extension TabBarViewController {
    func setup() {
        let height: CGFloat = 60
        let navigationBarHeight: CGFloat = navigationController?.navigationBar.bounds.height ?? 44
        let nowIsPlayingView = NowIsPlayingView(
            frame: CGRect(x: 0, y: view.bounds.height - tabBar.bounds.height - height - navigationBarHeight, width: view.bounds.width, height: height)
        )
        nowIsPlayingView.delegate = self
        view.addSubview(nowIsPlayingView)
    }
}
