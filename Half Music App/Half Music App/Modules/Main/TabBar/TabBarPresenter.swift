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
    
    private var router: TabBarRouterInterface?
    
    init(router: TabBarRouterInterface) {
        self.router = router
    }
}

// MARK: - TabBarPresenterInterface

extension TabBarPresenter: TabBarPresenterInterface {
    func setupXib(with frame: CGRect) {
        let input = NowIsPlayingModuleInput(frame: frame)
        let xibView = NowIsPlayingAssembly.nowIsPlayingView(input: input, output: self)
        controller?.addSubviewOnTabBar(view: xibView)
    }
}

// MARK: - NowIsPlayingOutput

extension TabBarPresenter: NowIsPlayingOutput {
    func showDetail(with index: Int) {
        let input = DetailTrackInput(trackIndex: index, isOpenInBackground: true)
        router?.showDetailTrack(input: input)
    }
}
