//
//  ArtistsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

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
        guard let songsController = SongsAssembly.songsTableViewController(input: input) else {
            return
        }
        controller?.navigationController?.pushViewController(songsController, animated: true)
    }
}
