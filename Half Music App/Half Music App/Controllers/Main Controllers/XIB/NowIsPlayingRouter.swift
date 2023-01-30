//
//  NowIsPlayingRouter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 9.01.23.
//

protocol NowIsPlayingRouterInteface {
    func showTrack(output: NowIsPlayingOutput?)
}

final class NowIsPlayingRouter {
    private weak var view: NowIsPlayingView?

    private let audioPlayerService = AudioPlayerManager.shared

    init(view: NowIsPlayingView) {
        self.view = view
    }
}

extension NowIsPlayingRouter: NowIsPlayingRouterInteface {
    func showTrack(output: NowIsPlayingOutput?) {
        guard let index = audioPlayerService.trackIndex else {
            return
        }
        output?.showDetail(with: index)
    }
}
