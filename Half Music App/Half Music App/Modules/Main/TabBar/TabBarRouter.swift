//
//  TabBarRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

import Foundation

protocol TabBarRouterInterface {
    func showDetailTrack(input: DetailTrackInput)
}

final class TabBarRouter {
    private weak var controller: TabBarViewController?
    
    init(controller: TabBarViewController) {
        self.controller = controller
    }
}

extension TabBarRouter: TabBarRouterInterface {
    func showDetailTrack(input: DetailTrackInput) {
        guard let controller = DetailTrackAssembly.detailTrackViewController(input: input) else {
            return
        }
        self.controller?.viewControllers![0].present(controller, animated: true)
    }
}
