//
//  NowIsPlayingView.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.11.22.
//

import UIKit
import MediaPlayer

final class NowIsPlayingView: UIView {

    @IBOutlet private weak var audioImageView: UIImageView!
    @IBOutlet private weak var audioTitleLabel: UILabel!
    @IBOutlet private weak var playPauseButtonOutlet: UIButton! {
        didSet {
            playPauseButtonOutlet.setImage(UIImage(systemName: "pause.circle.fill"), for: .selected)
            playPauseButtonOutlet.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let audioPlayerService = AudioPlayerService.shared
    
    private var timeObserver: Any!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
        setup()
        addObserver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    private func viewInit() {
        let xibView = Bundle.main.loadNibNamed("NowIsPlayingView", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
    private func addObserver() {
        timeObserver = audioPlayerService.addObserver { [weak self] time in
            self?.audioObserve(time: time)
        }
    }
    
    deinit {
        print("DEINIT XIB")
        audioPlayerService.removeObserver(observer: timeObserver)
    }
    
    private func setup() {
        guard let audioIndex = audioPlayerService.trackIndex else {
            print("XIB INDEX ERROR")
            return
        }
        playPauseButtonOutlet.isSelected = audioPlayerService.isPlaying

        let track = LocalStorage.shared.currentAudioQueue[audioIndex]
        audioTitleLabel.text = track.artist +  " - " + track.name
        let trackUrl = track.album.images[0].url

//        dataFetcherService.fetchImage(urlString: trackUrl) { [weak self] image in
//            guard let image = image else {
//                return
//            }
//            self?.audioImageView.image = image
//        }
    }
    
    private func audioObserve(time: CMTime) {
        setup()
        let duration = audioPlayerService.getDuration()!

        let seconds = Int(time.value/1000000000)

        if duration - seconds <= 0, duration != 0 {
            audioPlayerService.seekTo(time: CMTime(seconds: 0.0, preferredTimescale: .max))
            if audioPlayerService.isRepeat {
                audioPlayerService.addAudioTrackInPlayer(audioIndex: audioPlayerService.trackIndex)
            } else {
                let _ = audioPlayerService.nextAudioTrack(audioIndex: audioPlayerService.trackIndex, isShuffleOn: audioPlayerService.isShuffle)
            }
        }
    }
    
    @IBAction private func playPauseAction() {
        playPauseButtonOutlet.isSelected.toggle()
        audioPlayerService.isPlaying = playPauseButtonOutlet.isSelected
        if playPauseButtonOutlet.isSelected {
            audioPlayerService.play()
        } else {
            audioPlayerService.pause()
        }
    }
    
    @IBAction private func forwardAction() {
        let _ = audioPlayerService.nextAudioTrack(audioIndex: audioPlayerService.trackIndex, isShuffleOn: audioPlayerService.isShuffle)
    }
}
