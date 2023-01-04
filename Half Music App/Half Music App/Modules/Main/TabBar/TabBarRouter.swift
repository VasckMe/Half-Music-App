//
//  TabBarRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

import Foundation

protocol TabBarRouterInterface {
    func showDetailTrack(with index: Int)
}

final class TabBarRouter {
    private weak var controller: TabBarViewController?
    
    init(controller: TabBarViewController) {
        self.controller = controller
    }
}

extension TabBarRouter: TabBarRouterInterface {
    func showDetailTrack(with index: Int) {
        guard let vc = DetailTrackViewController.storyboardInstance() else {
            return
        }
        vc.trackIndex = index
        vc.isOpenInBackground = true
        controller?.viewControllers![0].present(vc, animated: true)
    }
}
