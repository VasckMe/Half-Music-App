//
//  ArtistsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation

protocol ArtistsRouterInterface {
    
}

final class ArtistsRouter {
    private var controller: ArtistsTableViewController?
    
    init(controller: ArtistsTableViewController) {
        self.controller = controller
    }
}

extension ArtistsRouter: ArtistsRouterInterface {
    
}
