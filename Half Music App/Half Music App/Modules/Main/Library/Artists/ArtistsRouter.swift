//
//  ArtistsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation

protocol ArtistsRouterInterface {
    func showSongsViewController(input: SongsInput)
}

final class ArtistsRouter {
    private weak var controller: ArtistsTableViewController?
    
    init(controller: ArtistsTableViewController) {
        self.controller = controller
    }
}

extension ArtistsRouter: ArtistsRouterInterface {
    func showSongsViewController(input: SongsInput) {
        guard let controller = SongsAssembly.songsTableViewController(input: input) else {
            return
        }
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
}
