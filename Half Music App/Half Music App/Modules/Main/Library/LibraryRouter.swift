//
//  LibraryRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import Foundation

protocol LibraryRouterInterface {
    func showArtistsViewController()
    func showSongsViewController()
    func showAlbumsViewController()
}

final class LibraryRouter {
    private var controller: LibraryViewController?
    
    init(controller: LibraryViewController) {
        self.controller = controller
    }
}

extension LibraryRouter: LibraryRouterInterface {
    func showArtistsViewController() {
//        controller?.navigationController.push
    }
    
    func showSongsViewController() {
        
    }
    
    func showAlbumsViewController() {
        
    }
    
    
}
