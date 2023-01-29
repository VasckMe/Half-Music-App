//
//  DetailTrackRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.01.23.
//

import Foundation

protocol DetailTrackRouterInterface {
    
}

final class DetailTrackRouter {
    private var controller: DetailTrackViewController?
    
    init(controller: DetailTrackViewController) {
        self.controller = controller
    }
}

extension DetailTrackRouter: DetailTrackRouterInterface {
    
}
