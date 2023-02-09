//
//  DetailTrackPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.01.23.
//

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
        
    func didTriggerTrackSliderTouchUp(value: Double)
    func didTriggerTrackSliderTouchDown()
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
    private let player = AudioManager.shared
    
    private var timeObserver: Any!
    
    init(input: DetailTrackInput, router: DetailTrackRouterInterface) {
        self.input = input
        self.router = router
    }
}

// MARK: - DetailTrackPresenterInterface {

extension DetailTrackPresenter: DetailTrackPresenterInterface {
    func didTriggerLoadView() {
        
//        if player.trackIndex != input.trackIndex {
//            player.trackIndex = input.trackIndex
//            player.addAudioTrackInPlayer()
//        }
        player.trackIndex = input.trackIndex
        !input.isOpenInBackground ? player.addAudioTrackInPlayer() : nil
        setupTrack()
    }
    
    func didTriggerViewAppear() {
        timeObserver = player.addObserver { [weak self] time in
            self?.makeTime(time: time)
        }
    }
    
    func didTriggerViewDisappear() {
        player.removeObserver(observer: timeObserver!)
    }
    
    func didTriggerForward(isShuffle: Bool) {
        player.nextAudioTrack()
        setupTrack()
    }
    
    func didTriggerBackward() {
        player.previousAudioTrack()
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
    
    func didTriggerTrackSliderTouchUp(value: Double) {
        let time = CMTime(seconds: value, preferredTimescale: .max)
        player.seekTo(time: time)
        AudioManager.shared.play()
    }
    
    func didTriggerTrackSliderTouchDown() {
        AudioManager.shared.pause()
    }
    
    func didTriggerTrackSlider(value: Double) {
        let duration = player.getDuration()
        let seconds = Int(value)
        controller?.setTrackSliderValue(value: Float(value))
        controller?.setStartTimeLabel(time: seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)")
        controller?.setEndTimeLabel(time: duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)")
    }
    
    func didTriggerVolumeSlider(value: Float) {
        player.setVolume(volume: value/100)
    }
    
    func didTriggerPlayPause() {
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

 //MARK: - AddTrackToAlbumOutput

extension DetailTrackPresenter: AddTrackToAlbumOutput {
    func addToLibrary() {
        controller?.likeButtonIsSelected(isSelected: true)
    }
    
    func closeAddTrackToAlbum() {
        router?.closeAddTrackToAlbum()
    }
}

//MARK: - Private

private extension DetailTrackPresenter {
    func setupTrack() {
        guard LocalStorage.shared.currentAudioQueue.indices.contains(player.trackIndex) else {
            print("There is no tracks with that index")
            return
        }
        
        let track = LocalStorage.shared.currentAudioQueue[player.trackIndex]
        
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
        guard let controller = controller else {
            return
        }
        
        let duration = player.getDuration()
        let seconds = Int(time.seconds)
        controller.setTrackSliderValue(value: Float(time.seconds))
        controller.setStartTimeLabel(time: seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)")
        controller.setEndTimeLabel(time: duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)")
        controller.setMaxTrackSliderValue(value: Float(duration))
        
        if input.trackIndex != player.trackIndex {
            input.trackIndex = player.trackIndex
            setupTrack()
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
            FireBaseStorageService.saveTrackInDB(track: track)
            controller?.likeButtonToggle()
        }
    }
}
