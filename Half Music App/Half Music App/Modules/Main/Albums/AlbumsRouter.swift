//
//  AlbumsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

import Foundation

protocol AlbumsRouterInterface {
    func showDetailAlbumController()
    
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
    func showDetailAlbumController() {
//        let storyboard = UIStoryboard(name: "LibraryViewController", bundle: nil)
//        if
//            let vc = storyboard.instantiateViewController(
//                withIdentifier: "DetailAlbumVC"
//            ) as? DetailAlbumViewController
//        {
//            vc.album = album
//            navigationController?.pushViewController(vc, animated: true)
//        }
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
