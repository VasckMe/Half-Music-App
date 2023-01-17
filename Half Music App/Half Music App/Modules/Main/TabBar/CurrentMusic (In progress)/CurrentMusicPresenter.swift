//
//  CurrentMusicPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import Foundation

protocol CurrentMusicPresenterInterface {
    func nextTrack()
    func didTriggerTapView()
}

struct CurrentMusicModuleInput {
    let delegate: TabBarViewControllerInterface?
}

final class CurrentMusicPresenter {
    weak var controller: CurrentMusicViewController?
    
    private var router: CurrentMusicRouterInterface?
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let audioPlayerService = AudioPlayerManager.shared
    private let animationService = AnimationManager.shared
    
    init(router: CurrentMusicRouterInterface) {
        self.router = router
    }
}

extension CurrentMusicPresenter: CurrentMusicPresenterInterface {
    func nextTrack() {
        let _ = audioPlayerService.nextAudioTrack(
            audioIndex: audioPlayerService.trackIndex,
            isShuffleOn: audioPlayerService.isShuffle
        )
    }
    
    func didTriggerTapView() {
        router?.showTrack()
    }
}
