//
//  SearchRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.01.23.
//

import Foundation

protocol SearchRouterInterface {
    
}

final class SearchRouter {
    private var controller: SearchViewController?
    
    init(controller: SearchViewController) {
        self.controller = controller
    }
}

extension SearchRouter: SearchRouterInterface {
    
}
