//
//  CurrentMusicPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import Foundation
import MediaPlayer

protocol CurrentMusicModuleOutput: AnyObject {
    func showDetail(with index: Int)
}

protocol CurrentMusicPresenterInterface {
    func didTriggerLoadView()
    func didTriggerDeinit()
    
    func didTriggerPlayPause()
    func didTriggerForward()
    func didTriggerTapView()
}

final class CurrentMusicPresenter {
    weak var controller: CurrentMusicViewControllerInterface?
    
    private weak var output: CurrentMusicModuleOutput?
    private var router: CurrentMusicRouterInterface?
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let player = AudioManager.shared
    private let animationService = AnimationManager.shared
    
    private var trackIndex = 0
    private var timeObserver: Any!
    
    init(output: CurrentMusicModuleOutput, router: CurrentMusicRouterInterface) {
        self.output = output
        self.router = router
    }
}

extension CurrentMusicPresenter: CurrentMusicPresenterInterface {
    func didTriggerLoadView() {
        setupNewAudio()
        addObserver()
    }
    
    func didTriggerDeinit() {
        AudioManager.shared.removeObserver(observer: timeObserver)
    }
    
    func didTriggerPlayPause() {
        controller?.playPauseToggle()
        controller?.playPause()
    }
    
    func didTriggerForward() {
        player.nextAudioTrack()
        setupNewAudio()
    }
    
    func didTriggerTapView() {
        router?.showTrack(output: output)
    }
}

private extension CurrentMusicPresenter {
    func observeTime(time: CMTime) {
        controller?.setPlayPause()
        controller?.animate()
        
        if trackIndex != player.trackIndex {
            trackIndex = player.trackIndex
            setupNewAudio()
        }
    }
    
    func setupNewAudio() {
        guard LocalStorage.shared.currentAudioQueue.indices.contains(player.trackIndex) else {
            return
        }
        
        let track = LocalStorage.shared.currentAudioQueue[player.trackIndex]
        
        guard let artist = track.artist else {
            return
        }
        
        controller?.setTitleLabel(title: artist +  " - " + track.name)
    }
    
    func addObserver() {
        timeObserver = player.addObserver { [weak self] time in
            self?.observeTime(time: time)
        }
    }
    
    func removeObserver() {
        player.removeObserver(observer: timeObserver!)
    }
}
