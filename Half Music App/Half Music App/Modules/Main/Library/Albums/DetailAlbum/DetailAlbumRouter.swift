//
//  DetailAlbumRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 26.01.23.
//

import Foundation

protocol DetailAlbumRouterInterface {
    func showEditAlbumViewController(input: EditAlbumInput, output: EditAlbumOutput)
    func closeEditAlbumViewController()
    
    func showDetailTrackViewController(input: DetailTrackInput)
}

final class DetailAlbumRouter {
    private var controller: DetailAlbumViewController?
    
    init(controller: DetailAlbumViewController) {
        self.controller = controller
    }
}

//MARK: - DetailAlbumRouterInterface

extension DetailAlbumRouter: DetailAlbumRouterInterface {
    func showEditAlbumViewController(input: EditAlbumInput, output: EditAlbumOutput) {
        guard
            let controller = AddAlbumAssembly.editAlbumViewController(input: input, output: output)
        else {
            return
        }
        
        self.controller?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func closeEditAlbumViewController() {
        controller?.navigationController?.popViewController(animated: true)
    }
    
    func showDetailTrackViewController(input: DetailTrackInput) {
        guard let controller = DetailTrackAssembly.detailTrackViewController(input: input) else {
            return
        }
        self.controller?.navigationController?.present(controller, animated: true)
    }
}
