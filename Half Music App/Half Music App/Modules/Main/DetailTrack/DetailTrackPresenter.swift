//
//  DetailTrackPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.01.23.
//

import Foundation
import MediaPlayer

struct DetailTrackInput {
    var trackIndex: Int
    var isOpenInBackground: Bool
}

protocol DetailTrackPresenterInterface {
    func didTriggerLoadView()
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerForward(isShuffle: Bool)
    func didTriggerBackward()
    
    func didTriggerShuffle()
    func didTriggerRepeat()
    
    func didTriggerTrackSlider(value: Double)
    func didTriggerVolumeSlider(value: Float)
    
    func didTriggerPlayPause()
    
    func didTriggerAddToLibrary(isSelected: Bool)
    func didTriggerAddToAlbum()
}

final class DetailTrackPresenter {
    weak var controller: DetailTrackViewControllerInterface?
    
    private var input: DetailTrackInput
    private var router: DetailTrackRouterInterface?
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let audioPlayerService = AudioPlayerManager.shared
    private var timeObserver: Any!
    
    init(input: DetailTrackInput, router: DetailTrackRouterInterface) {
        self.input = input
        self.router = router
    }
}

// MARK: - DetailTrackPresenterInterface {

extension DetailTrackPresenter: DetailTrackPresenterInterface {
    func didTriggerLoadView() {
        !input.isOpenInBackground ? audioPlayerService.addAudioTrackInPlayer(audioIndex: input.trackIndex) : nil
        setupTrack()
    }
    
    func didTriggerViewAppear() {
        timeObserver = audioPlayerService.addObserver { [weak self] time in
            self?.makeTime(time: time)
        }
    }
    
    func didTriggerViewDisappear() {
        audioPlayerService.removeObserver(observer: timeObserver!)
    }
    
    func didTriggerForward(isShuffle: Bool) {
        guard
            let nextTrackIndex = audioPlayerService.nextAudioTrack(
            audioIndex: input.trackIndex,
            isShuffleOn: isShuffle
        )
        else {
            return
        }
        
        input.trackIndex = nextTrackIndex
        setupTrack()
    }
    
    func didTriggerBackward() {
        guard
            let previousIndex = audioPlayerService.previousAudioTrack(audioIndex: input.trackIndex)
        else {
            return
        }
        input.trackIndex = previousIndex
        setupTrack()
    }
    
    func didTriggerRepeat() {
        controller?.repeatButtonToggle()
        controller?.setRepeat()
    }
    
    func didTriggerShuffle() {
        controller?.shuffleButtonToggle()
        controller?.setShuffle()
    }
    
    func didTriggerTrackSlider(value: Double) {
        let time = CMTime(seconds: value, preferredTimescale: .max)
        audioPlayerService.seekTo(time: time)
    }
    
    func didTriggerVolumeSlider(value: Float) {
        audioPlayerService.volume = value/100
        audioPlayerService.setVolume(volume: value/100)
    }
    
    func didTriggerPlayPause() {
        let duration = audioPlayerService.getDuration()
        controller?.setMaxTrackSliderValue(value: Float(duration ?? 0))
        
        controller?.playPauseButtonToggle()
        
        controller?.playPause()
    }
    
    func didTriggerAddToLibrary(isSelected: Bool) {
        addToLibrary(isSelected: isSelected)
    }
    
    func didTriggerAddToAlbum() {
        let track = LocalStorage.shared.currentAudioQueue[input.trackIndex]
        let input = AddTrackToAlbumInput(track: track)
        
        router?.showAddTrackToAlbum(input: input, output: self)
    }
}

extension DetailTrackPresenter: AddTrackToAlbumOutput {
    func addToLibrary() {
        controller?.likeButtonIsSelected(isSelected: true)
    }
    
    func closeAddTrackToAlbum() {
        router?.closeAddTrackToAlbum()
    }
}

private extension DetailTrackPresenter {
    func setupTrack() {
        guard LocalStorage.shared.currentAudioQueue.indices.contains(input.trackIndex) else {
            print("There is no tracks with that index")
            return
        }
        
        let track = LocalStorage.shared.currentAudioQueue[input.trackIndex]
        
        FireBaseStorageService.isAddedInLibrary(track: track) { [weak self] isAdded in
            self?.controller?.likeButtonIsSelected(isSelected: isAdded)
        }
        controller?.setTrackName(name: track.name)
        controller?.setAuthorName(name: track.artist)

        fetchAndLoadImages(track: track)
    }
    
    func fetchAndLoadImages(track: TrackFB) {
        guard let trackImageUrl = track.album?.images?[0].url else {
            return
        }
                
        dataFetcherService.fetchImage(urlString: trackImageUrl) { [weak self] image in
            guard let image = image else {
                return
            }
            self?.controller?.setBackgroundImageView(image: image)
            self?.controller?.setTrackImageView(image: image)
        }
    }
    
    func makeTime(time: CMTime) {
        guard let duration = audioPlayerService.getDuration() else {
            return
        }
        
        let seconds = Int(time.value/1000000000)
        
        controller?.setTrackSliderValue(value: Float(seconds))
        controller?.setStartTimeLabel(time: seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)")
        controller?.setEndTimeLabel(time: duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)")

        if duration - seconds <= 0, duration != 0 {
            audioPlayerService.seekTo(time: CMTime(seconds: 0.0, preferredTimescale: .max))
            audioPlayerService.isRepeat
                ? audioPlayerService.addAudioTrackInPlayer(audioIndex: input.trackIndex)
                : didTriggerForward(isShuffle: audioPlayerService.isShuffle)
        }
    }
    
    func addToLibrary(isSelected: Bool) {
        guard
            LocalStorage.shared.currentAudioQueue.indices.contains(input.trackIndex)
        else {
            print("Bad track index")
            return
        }
        
        let track = LocalStorage.shared.currentAudioQueue[input.trackIndex]
        
        if isSelected {
            FireBaseStorageService.audioRef.child(track.name).removeValue()
            controller?.likeButtonToggle()
        } else {
            controller?.likeButtonToggle()
            FireBaseStorageService.saveTrackInDB(track: track)
        }
    }
}
