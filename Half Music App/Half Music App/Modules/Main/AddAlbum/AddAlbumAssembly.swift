//
//  AddAlbumAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

import UIKit

struct AddAlbumAssembly {
    static func addAlbumViewController(input: AddAlbumInput? = nil, output: AddAlbumOutput) -> AddAlbumViewController? {
        guard
            let controller = UIStoryboard(
                name: "AddAlbumViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "AddEditAlbumVC"
            ) as? AddAlbumViewController
        else {
            return nil
        }
        
        let router = AddAlbumRouter(controller: controller)
        let presenter = AddAlbumPresenter(input: input, output: output, router: router)
        
        presenter.controller = controller
        controller.presenter = presenter
        
        return controller
    }
}
