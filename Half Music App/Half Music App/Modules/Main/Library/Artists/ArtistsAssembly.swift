//
//  ArtistsAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import UIKit

struct ArtistsAssembly {
    static func artistsTableViewController() -> ArtistsTableViewController? {
        guard
            let tableController = UIStoryboard(
                name: "ArtistsTableViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "ArtistsTVC"
            ) as? ArtistsTableViewController
        else {
            return nil
        }
        
        let router = ArtistsRouter(controller: tableController)
        let presenter = ArtistsPresenter(router: router)
        
        tableController.presenter = presenter
        presenter.controller = tableController
        
        return tableController
    }
}
