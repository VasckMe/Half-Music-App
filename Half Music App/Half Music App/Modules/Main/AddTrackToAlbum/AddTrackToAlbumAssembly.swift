//
//  AddTrackToAlbumAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.01.23.
//

import UIKit

struct AddTrackToAlbumAssembly {
    static func addTrackToAlbumViewController(
        input: AddTrackToAlbumInput,
        output: AddTrackToAlbumOutput
    ) -> AddTrackToAlbumViewController? {
        guard
            let controller = UIStoryboard(
                name: "AddTrackToAlbumViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "AddTrackToAlbumVC"
            ) as? AddTrackToAlbumViewController
        else {
            return nil
        }
        
        let presenter = AddTrackToAlbumPresenter(input: input, output: output)
        presenter.controller = controller
        
        controller.presenter = presenter
        
        return controller
    }
}
