//
//  SongsAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import UIKit

struct SongsAssembly {
    static func songsTableViewController(input: SongsInput? = nil) -> SongsTableViewController? {
        guard
            let songsController = UIStoryboard(
                name: "SongsTableViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "SongsTVC"
            ) as? SongsTableViewController
        else {
            return nil
        }
        
        let router = SongsRouter(controller: songsController)
        let presenter = SongsPresenter(input: input, router: router)
        
        presenter.controller = songsController
        songsController.presenter = presenter
        
        return songsController
    }
}
