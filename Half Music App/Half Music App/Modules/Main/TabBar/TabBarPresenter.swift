//
//  TabBarPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

import Foundation

protocol TabBarPresenterInterface {
    func setupXib(with frame: CGRect)
}

final class TabBarPresenter {
    weak var controller: TabBarViewControllerInterface?
    var xibController: CurrentMusicViewController?
    
    private var router: TabBarRouterInterface?
    
    init(router: TabBarRouterInterface) {
        self.router = router
    }
}

// MARK: - TabBarPresenterInterface

extension TabBarPresenter: TabBarPresenterInterface {
    func setupXib(with frame: CGRect) {
        guard let controller = CurrentMusicAssembly.currentMusicViewController(output: self) else {
            return
        }
        
        xibController = controller
        controller.view.frame = frame
        self.controller?.addViewOnTabBar(view: controller.view)
    }
}

// MARK: - NowIsPlayingOutput

extension TabBarPresenter: CurrentMusicModuleOutput {
    func showDetail(with index: Int) {
        let input = DetailTrackInput(trackIndex: index, isOpenInBackground: true)
        router?.showDetailTrack(input: input)
    }
}
