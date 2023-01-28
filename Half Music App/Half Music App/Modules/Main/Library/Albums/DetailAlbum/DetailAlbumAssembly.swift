//
//  DetailAlbumAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 26.01.23.
//

import UIKit

struct DetailAlbumAssembly {
    static func detailAlbumViewController(input: DetailAlbumInput) -> DetailAlbumViewController? {
        guard
            let controller = UIStoryboard(
            name: "DetailAlbumViewController",
            bundle: nil
        ).instantiateViewController(
            withIdentifier: "DetailAlbumVC"
        ) as? DetailAlbumViewController
        else {
            return nil
        }
        
        let router = DetailAlbumRouter(controller: controller)
        
        let presenter = DetailAlbumPresenter(input: input, router: router)
        presenter.controller = controller
        
        controller.presenter = presenter
        
        return controller
    }
}
