//
//  SongsPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation

protocol SongsPresenterInterface {
    
}

final class SongsPresenter {
    weak var controller: SongsTableViewController?
    
    private var router: SongsRouterInterface?
    
    init(router: SongsRouterInterface) {
        self.router = router
    }
}

extension SongsPresenter: SongsPresenterInterface {
    
}
