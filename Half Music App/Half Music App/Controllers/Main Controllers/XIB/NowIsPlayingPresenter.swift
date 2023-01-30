//
//  NowIsPlayingPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 9.01.23.
//

import MediaPlayer

protocol NowIsPlayingOutput: AnyObject {
    func showDetail(with index: Int)
}

protocol NowIsPlayingPresenterInterface {
//    func addPlayerObserver()
//    func removePlayerObserver()
    
    func nextTrack()
    func didTriggerTapView()
}

struct NowIsPlayingModuleInput {
    let frame: CGRect?
}

final class NowIsPlayingPresenter {
    weak var view: NowIsPlayingViewInterface?
    
    private weak var output: NowIsPlayingOutput?
    private let router: NowIsPlayingRouterInteface?
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let audioPlayerService = AudioPlayerManager.shared
    private let animationService = AnimationManager.shared
    
    init(output: NowIsPlayingOutput, router: NowIsPlayingRouterInteface) {
        self.output = output
        self.router = router
    }
}

extension NowIsPlayingPresenter: NowIsPlayingPresenterInterface {
//    func addPlayerObserver() {
//        timeObserver = audioPlayerService.addObserver { [weak self] time in
//            self?.audioObserve(time: time)
//        }
//    }
//    
//    func removePlayerObserver() {
//        audioPlayerService.removeObserver(observer: timeObserver!)
//    }
    
    func nextTrack() {
        let _ = audioPlayerService.nextAudioTrack(
            audioIndex: audioPlayerService.trackIndex,
            isShuffleOn: audioPlayerService.isShuffle
        )
    }
    
    func didTriggerTapView() {
        router?.showTrack(output: output)
    }
}

private extension NowIsPlayingPresenter {
//    func audioObserve(time: CMTime) {
//        view?.setupAudio()
//        let duration = audioPlayerService.getDuration()!
//
//        let seconds = Int(time.value/1000000000)
//
//        if duration - seconds <= 0, duration != 0 {
//            audioPlayerService.seekTo(time: CMTime(seconds: 0.0, preferredTimescale: .max))
//            if audioPlayerService.isRepeat {
//                audioPlayerService.addAudioTrackInPlayer(audioIndex: audioPlayerService.trackIndex)
//            } else {
//                let _ = audioPlayerService.nextAudioTrack(
//                    audioIndex: audioPlayerService.trackIndex,
//                    isShuffleOn: audioPlayerService.isShuffle
//                )
//            }
//        }
//    }
}
