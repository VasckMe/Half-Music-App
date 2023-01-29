//
//  DetailTrackAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.01.23.
//

import UIKit

struct DetailTrackAssembly {
    static func detailTrackViewController(input: DetailTrackInput) -> DetailTrackViewController? {
        guard
            let controller = UIStoryboard(
                name: "DetailTrackViewController",
                bundle: nil
            ).instantiateViewController(
                withIdentifier: "DetailTrackVC"
            ) as? DetailTrackViewController
        else {
            return nil
        }
        
        let router = DetailTrackRouter(controller: controller)
        
        let presenter = DetailTrackPresenter(input: input, router: router)
        presenter.controller = controller
        
        controller.presenter = presenter
        
        return controller
    }
}
