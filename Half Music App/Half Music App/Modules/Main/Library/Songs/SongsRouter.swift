//
//  SongsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

protocol SongsRouterInterface {
    func showDetailTrack(input: DetailTrackInput)
}

final class SongsRouter {
    private weak var controller: SongsTableViewController?
    
    init(controller: SongsTableViewController) {
        self.controller = controller
    }
}

extension SongsRouter: SongsRouterInterface {
    func showDetailTrack(input: DetailTrackInput) {
        guard let detailTrackController = DetailTrackAssembly.detailTrackViewController(input: input) else {
            return
        }
        
        controller?.navigationController?.present(detailTrackController, animated: true)
    }
}
