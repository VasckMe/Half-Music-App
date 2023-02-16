//
//  CurrentMusicRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import Foundation

protocol CurrentMusicRouterInterface {
    func showTrack(output: CurrentMusicModuleOutput?)
}

final class CurrentMusicRouter {
    private weak var view: CurrentMusicViewController?

    init(view: CurrentMusicViewController) {
        self.view = view
    }
}

extension CurrentMusicRouter: CurrentMusicRouterInterface {
    func showTrack(output: CurrentMusicModuleOutput?) {
        output?.showDetail(with: AudioManager.shared.trackIndex)
    }
}
