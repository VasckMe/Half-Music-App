//
//  CurrentMusicRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import Foundation

protocol CurrentMusicRouterInterface {
    func showTrack()
}

final class CurrentMusicRouter {
    private weak var view: CurrentMusicViewController?
    private let delegate: TabBarViewControllerInterface?

    private let audioPlayerService = AudioPlayerManager.shared

    init(view: CurrentMusicViewController, delegate: TabBarViewControllerInterface) {
        self.view = view
        self.delegate = delegate
    }
}

extension CurrentMusicRouter: CurrentMusicRouterInterface {
    func showTrack() {
        guard let delegate = delegate else { return }
        guard let index = audioPlayerService.trackIndex else {
            return
        }
//        delegate.showDetail(with: index)
    }
}
