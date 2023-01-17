//
//  NowIsPlayingAssembly.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 9.01.23.
//

import UIKit

struct NowIsPlayingAssembly {
    static func nowIsPlayingView(input: NowIsPlayingModuleInput) -> NowIsPlayingView? {
        guard
            let frame = input.frame,
            let delegate = input.delegate
        else {
            return nil
        }
        
        let view = NowIsPlayingView(frame: frame)
        let router = NowIsPlayingRouter(view: view, delegate: delegate)
        let presenter = NowIsPlayingPresenter(router: router)
        
        presenter.view = view
        view.presenter = presenter
        
        return view
    }
}
