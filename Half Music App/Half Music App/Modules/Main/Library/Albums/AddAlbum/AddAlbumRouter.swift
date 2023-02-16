//
//  AddAlbumRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

protocol AddAlbumRouterInterface {
    func closeAddAlbumController(output: AddAlbumOutput?)
}

final class AddAlbumRouter {
    private weak var controller: AddAlbumViewController?
    
    init(controller: AddAlbumViewController) {
        self.controller = controller
    }
}

extension AddAlbumRouter: AddAlbumRouterInterface {
    func closeAddAlbumController(output: AddAlbumOutput?) {
        output?.didTriggerCloseAddAlbumViewController()
    }
}
