//
//  NowIsPlayingRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 9.01.23.
//

import Foundation

protocol NowIsPlayingRouterInteface {
    func showTrack()
}

final class NowIsPlayingRouter {
    private let view: NowIsPlayingView?
    private let delegate: TabBarViewControllerInterface?

    private let audioPlayerService = AudioPlayerManager.shared

    init(view: NowIsPlayingView, delegate: TabBarViewControllerInterface) {
        self.view = view
        self.delegate = delegate
    }
}

extension NowIsPlayingRouter: NowIsPlayingRouterInteface {
    func showTrack() {
        guard let delegate = delegate else { return }
        guard let index = audioPlayerService.trackIndex else {
            return
        }
        delegate.showDetail(with: index)
    }
}
