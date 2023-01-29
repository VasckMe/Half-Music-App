//
//  NowIsPlayingAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 9.01.23.
//

import UIKit

struct NowIsPlayingAssembly {
    static func nowIsPlayingView(input: NowIsPlayingModuleInput, output: NowIsPlayingOutput) -> NowIsPlayingView? {
        guard
            let frame = input.frame
        else {
            return nil
        }
        
        let view = NowIsPlayingView(frame: frame)
        let router = NowIsPlayingRouter(view: view)
        
        let presenter = NowIsPlayingPresenter(output: output, router: router)
        presenter.view = view
        
        view.presenter = presenter
        
        return view
    }
}
