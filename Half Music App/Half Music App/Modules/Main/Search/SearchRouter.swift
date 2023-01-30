//
//  SearchRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.01.23.
//

import Foundation

protocol SearchRouterInterface {
    func showDetailTrack(input: DetailTrackInput)
}

final class SearchRouter {
    private weak var controller: SearchViewController?
    
    init(controller: SearchViewController) {
        self.controller = controller
    }
}

extension SearchRouter: SearchRouterInterface {
    func showDetailTrack(input: DetailTrackInput) {
        guard let detailTrackController = DetailTrackAssembly.detailTrackViewController(input: input) else {
            return
        }
        
        controller?.navigationController?.present(detailTrackController, animated: true)
    }
}
