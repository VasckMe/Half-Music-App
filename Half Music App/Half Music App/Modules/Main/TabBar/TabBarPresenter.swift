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
    weak var controller: TabBarViewControlerInterface?
    
    private var router: TabBarRouterInterface?
    
    init(router: TabBarRouterInterface) {
        self.router = router
    }
}

extension TabBarPresenter: TabBarPresenterInterface {
    func didViewTapped(with index: Int) {
        router?.showDetailTrack(with: index)
    }
}
