//
//  SongsRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation

protocol SongsRouterInterface {
    
}

final class SongsRouter {
    private var controller: SongsTableViewController?
    
    init(controller: SongsTableViewController) {
        self.controller = controller
    }
}

extension SongsRouter: SongsRouterInterface {
    
}
