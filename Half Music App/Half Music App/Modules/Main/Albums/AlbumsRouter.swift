//
//  AlbumsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

import Foundation

protocol AlbumsRouterInterface {
    func showDetailAlbumController()
    func showAddNewAlbumController()
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
    
    func showAddNewAlbumController() {
        //
    }
}
