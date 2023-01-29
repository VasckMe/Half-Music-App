//
//  TabBarPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 4.01.23.
//

import Foundation

protocol TabBarPresenterInterface {
    func didViewTapped(with index: Int)
}

final class TabBarPresenter {
    weak var controller: TabBarViewControllerInterface?
    
    private var router: TabBarRouterInterface?
    
    init(router: TabBarRouterInterface) {
        self.router = router
    }
}

extension TabBarPresenter: TabBarPresenterInterface {
    func didViewTapped(with index: Int) {
        let input = DetailTrackInput(trackIndex: index, isOpenInBackground: true)
        router?.showDetailTrack(input: input)
    }
}
