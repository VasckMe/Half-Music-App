//
//  CustomTabBarController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.11.22.
//

import UIKit

protocol CustomTabBarProtocol {
    func showDetail(with index: Int)
}

final class CustomTabBarController: UITabBarController, CustomTabBarProtocol {
    func showDetail(with index: Int) {
        let storyboard = UIStoryboard(name: "DetailTrack", bundle: nil)
        guard
            let vc = storyboard.instantiateViewController(
                withIdentifier: "DetailTrackVC"
            ) as? DetailTrackViewController
        else {
            return
        }
        vc.trackIndex = index
        vc.isOpenInBackground = true
        self.viewControllers![0].present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let height: CGFloat = 60
        let y = view.bounds.height - tabBar.bounds.height - height - 34
        let nowIsPlayingView = NowIsPlayingView(
            frame: CGRect(x: 0, y: y, width: view.bounds.width, height: height)
        )
        nowIsPlayingView.delegate = self
        view.addSubview(nowIsPlayingView)
    }
}
