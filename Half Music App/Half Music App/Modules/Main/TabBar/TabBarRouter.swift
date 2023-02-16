//
//  TabBarRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

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
        guard let detailTrackController = DetailTrackAssembly.detailTrackViewController(
            input: input
        ) else {
            return
        }
        
        controller?.viewControllers![0].present(detailTrackController, animated: true)
    }
}
