//
//  AlbumsAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

import UIKit

struct AlbumsAssembly {
    static func albumsCollectionViewController() -> AlbumsCollectionViewController? {
        guard
            let controller = UIStoryboard(
                name: "AlbumsCollectionViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "AlbumsCVC"
            ) as? AlbumsCollectionViewController
        else {
            return nil
        }
        
        let router = AlbumsRouter(controller: controller)
        
        let presenter = AlbumsPresenter(router: router)
        presenter.controller = controller
        
        controller.presenter = presenter
        
        return controller
    }
}
