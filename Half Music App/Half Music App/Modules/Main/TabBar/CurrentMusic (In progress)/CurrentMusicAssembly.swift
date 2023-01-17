//
//  CurrentMusicAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

struct CurrentMusicAssembly {
    static func currentMusicViewController(
        input: CurrentMusicModuleInput
    ) -> CurrentMusicViewController? {
        
        guard let delegate = input.delegate else {
            return nil
        }
        
        let controller = CurrentMusicViewController(
            nibName: CurrentMusicViewController.id,
            bundle: nil
        )
        
        let router = CurrentMusicRouter(view: controller, delegate: delegate)
        let presenter = CurrentMusicPresenter(router: router)
        
        controller.presenter = presenter
        presenter.controller = controller
        
        return controller
    }
}
