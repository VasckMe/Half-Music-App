//
//  CurrentMusicAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

struct CurrentMusicAssembly {
    static func currentMusicViewController(
        output: CurrentMusicModuleOutput
    ) -> CurrentMusicViewController? {
        
        let controller = CurrentMusicViewController()
        
        let router = CurrentMusicRouter(view: controller)
        
        let presenter = CurrentMusicPresenter(output: output, router: router)
        presenter.controller = controller
        
        controller.presenter = presenter
        
        return controller
    }
}
