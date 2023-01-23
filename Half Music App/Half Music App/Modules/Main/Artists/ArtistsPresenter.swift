//
//  ArtistsPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation

protocol ArtistsPresenterInterface {
    
}

final class ArtistsPresenter {
    weak var controller: ArtistsTableViewController?
    
    private var router: ArtistsRouterInterface?
    
    init(router: ArtistsRouterInterface) {
        self.router = router
    }
}

extension ArtistsPresenter: ArtistsPresenterInterface {
    
}
