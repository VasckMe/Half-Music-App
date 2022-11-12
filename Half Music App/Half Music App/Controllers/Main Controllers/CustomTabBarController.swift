//
//  CustomTabBarController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.11.22.
//

import UIKit

final class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height: CGFloat = 60
        let y = view.bounds.height - tabBar.bounds.height - height - 34
        let nowIsPlayingView = NowIsPlayingView(frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height))
        view.addSubview(nowIsPlayingView)
    }
}
