//
//  AlbumsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

protocol AlbumsRouterInterface {
    func showDetailAlbumController(input: DetailAlbumInput)
    
    func showAddNewAlbumController(output: AddAlbumOutput)
    func closeAddNewAlbumController()
}

final class AlbumsRouter {
    private weak var controller: AlbumsCollectionViewController?
    
    init(controller: AlbumsCollectionViewController) {
        self.controller = controller
    }
}

extension AlbumsRouter: AlbumsRouterInterface {
    func showDetailAlbumController(input: DetailAlbumInput) {
        guard let detailAlbumController = DetailAlbumAssembly.detailAlbumViewController(input: input) else {
            return
        }
        
        controller?.navigationController?.pushViewController(detailAlbumController, animated: true)
    }
    
    func showAddNewAlbumController(output: AddAlbumOutput) {
        guard let addAlbumController = AddAlbumAssembly.addAlbumViewController(output: output) else {
            return
        }
        
        controller?.navigationController?.pushViewController(addAlbumController, animated: true)
    }
    
    func closeAddNewAlbumController() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
