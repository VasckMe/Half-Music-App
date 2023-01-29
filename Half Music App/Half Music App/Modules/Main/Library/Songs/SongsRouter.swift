//
//  SongsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation

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
        guard let controller = DetailTrackAssembly.detailTrackViewController(input: input) else {
            return
        }
        
        self.controller?.navigationController?.present(controller, animated: true)
    }
}
