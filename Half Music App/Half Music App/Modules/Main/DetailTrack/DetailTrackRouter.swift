//
//  DetailTrackRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.01.23.
//

protocol DetailTrackRouterInterface {
    func showAddTrackToAlbum(input: AddTrackToAlbumInput, output: AddTrackToAlbumOutput)
    func closeAddTrackToAlbum()
}

final class DetailTrackRouter {
    private weak var controller: DetailTrackViewController?
    
    init(controller: DetailTrackViewController) {
        self.controller = controller
    }
}

extension DetailTrackRouter: DetailTrackRouterInterface {
    func showAddTrackToAlbum(input: AddTrackToAlbumInput, output: AddTrackToAlbumOutput) {
        guard
            let addTrackToAlbumController = AddTrackToAlbumAssembly.addTrackToAlbumViewController(
                input: input,
                output: output
            )
        else {
            return
        }
        
        controller?.present(addTrackToAlbumController, animated: true)
    }
    
    func closeAddTrackToAlbum() {
        controller?.dismiss(animated: true)
    }
}
