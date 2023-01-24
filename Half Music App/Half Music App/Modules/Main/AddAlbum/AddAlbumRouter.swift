//
//  AddAlbumRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

import Foundation

protocol AddAlbumRouterInterface {
    func closeAddAlbumController(output: AddAlbumOutput)
}

final class AddAlbumRouter {
    private var controller: AddAlbumViewController?
    
    init(controller: AddAlbumViewController) {
        self.controller = controller
    }
}

extension AddAlbumRouter: AddAlbumRouterInterface {
    func closeAddAlbumController(output: AddAlbumOutput) {
        output.didTriggerCloseAddAlbumViewController()
    }
}
