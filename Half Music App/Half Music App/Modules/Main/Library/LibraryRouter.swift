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
    
    func showDetailTrackViewController(input: DetailTrackInput)
}

final class LibraryRouter {
    private weak var controller: LibraryViewController?
    
    init(controller: LibraryViewController) {
        self.controller = controller
    }
}

extension LibraryRouter: LibraryRouterInterface {
    func showArtistsViewController() {
        guard let artistsController = ArtistsAssembly.artistsTableViewController() else {
            return
        }
        
        controller?.navigationController?.pushViewController(artistsController, animated: true)
    }
    
    func showSongsViewController() {
        guard let songsController = SongsAssembly.songsTableViewController() else {
            return
        }
        
        controller?.navigationController?.pushViewController(songsController, animated: true)
    }
    
    func showAlbumsViewController() {
        guard let albumsController = AlbumsAssembly.albumsCollectionViewController() else {
            return
        }
        
        controller?.navigationController?.pushViewController(albumsController, animated: true)
    }
    
    func showDetailTrackViewController(input: DetailTrackInput) {
        guard let controller = DetailTrackAssembly.detailTrackViewController(input: input) else {
            return
        }
        
        self.controller?.navigationController?.present(controller, animated: true)
    }
}
