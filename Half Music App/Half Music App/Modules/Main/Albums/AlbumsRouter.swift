//
//  AlbumsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

import Foundation

protocol AlbumsRouterInterface {
    func showDetailAlbumController(input: DetailAlbumInput)
    
    func showAddNewAlbumController(output: AddAlbumOutput)
    func closeAddNewAlbumController()
}

final class AlbumsRouter {
    private var controller: AlbumsCollectionViewController?
    
    init(controller: AlbumsCollectionViewController) {
        self.controller = controller
    }
}

extension AlbumsRouter: AlbumsRouterInterface {
    func showDetailAlbumController(input: DetailAlbumInput) {
        guard let controller = DetailAlbumAssembly.detailAlbumViewController(input: input) else {
            return
        }
        
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showAddNewAlbumController(output: AddAlbumOutput) {
        guard let controller = AddAlbumAssembly.addAlbumViewController(output: output) else {
            return
        }
        
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func closeAddNewAlbumController() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
