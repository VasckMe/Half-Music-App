//
//  DetailAlbumRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 26.01.23.
//

protocol DetailAlbumRouterInterface {
    func showEditAlbumViewController(input: EditAlbumInput, output: EditAlbumOutput)
    func closeEditAlbumViewController()
    
    func showDetailTrackViewController(input: DetailTrackInput)
}

final class DetailAlbumRouter {
    private weak var controller: DetailAlbumViewController?
    
    init(controller: DetailAlbumViewController) {
        self.controller = controller
    }
}

//MARK: - DetailAlbumRouterInterface

extension DetailAlbumRouter: DetailAlbumRouterInterface {
    func showEditAlbumViewController(input: EditAlbumInput, output: EditAlbumOutput) {
        guard
            let addAlbumController = AddAlbumAssembly.editAlbumViewController(input: input, output: output)
        else {
            return
        }
        
        controller?.navigationController?.pushViewController(addAlbumController, animated: true)
    }
    
    func closeEditAlbumViewController() {
        controller?.navigationController?.popViewController(animated: true)
    }
    
    func showDetailTrackViewController(input: DetailTrackInput) {
        guard let detailTrackController = DetailTrackAssembly.detailTrackViewController(input: input) else {
            return
        }
        controller?.navigationController?.present(detailTrackController, animated: true)
    }
}
