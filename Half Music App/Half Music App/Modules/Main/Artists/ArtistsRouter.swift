//
//  ArtistsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation

protocol ArtistsRouterInterface {
    func showSongsViewController(artist: Int)
}

final class ArtistsRouter {
    private var controller: ArtistsTableViewController?
    
    init(controller: ArtistsTableViewController) {
        self.controller = controller
    }
}

extension ArtistsRouter: ArtistsRouterInterface {
    func showSongsViewController(artist: Int) {
        
        /// go to songsViewController
//        let storyboard = UIStoryboard(name: "LibraryViewController", bundle: nil)
//        if
//            let vc = storyboard.instantiateViewController(
//                withIdentifier: "SongsTVC"
//            ) as? SongsTableViewController
//        {
//            vc.artist = artists[indexPath.row]
//            vc.title = artists[indexPath.row]
//            navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
}
