//
//  NowIsPlayingView.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.11.22.
//

import UIKit
import MediaPlayer

final class NowIsPlayingView: UIView {

    // MARK: - IBOutlets
    
    @IBOutlet var ourView: UIView!
    
    @IBOutlet private weak var audioTitleLabel: UILabel!
    
    @IBOutlet private weak var animationImageView: UIImageView! {
        didSet {
            animationImageView.animationImages = animationService.getAnimationImages()
            animationImageView.animationDuration = 0.7
        }
    }

    @IBOutlet private weak var playPauseButtonOutlet: UIButton! {
        didSet {
            playPauseButtonOutlet.setImage(UIImage(systemName: "pause.circle.fill"), for: .selected)
            playPauseButtonOutlet.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    
    // MARK: - Properties
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let audioPlayerService = AudioPlayerManager.shared
    private let animationService = AnimationManager.shared
    
    private var timeObserver: Any!
    
    var delegate: CustomTabBarProtocol?
    
    // MARK: Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
        setup()
        addObserver()
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ourViewTapped))
        ourView.addGestureRecognizer(recognizer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
    }
    
    deinit {
        print("DEINIT XIB")
        audioPlayerService.removeObserver(observer: timeObserver!)
    }
    
    // MARK: - IBActions
    
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
        let _ = audioPlayerService.nextAudioTrack(
            audioIndex: audioPlayerService.trackIndex,
            isShuffleOn: audioPlayerService.isShuffle
        )
    }
}


// MARK: - Extension NowIsPlayingView

extension NowIsPlayingView {
    
    // MARK: - Private
    
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
    
    private func setup() {
        guard let audioIndex = audioPlayerService.trackIndex else {
            print("XIB INDEX ERROR")
            return
        }
        playPauseButtonOutlet.isSelected = audioPlayerService.isPlaying
        
        if playPauseButtonOutlet.isSelected {
            animationImageView.startAnimating()
        } else {
            animationImageView.stopAnimating()
        }
        
        let track = LocalStorage.shared.currentAudioQueue[audioIndex]
        audioTitleLabel.text = track.artist +  " - " + track.name
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
                let _ = audioPlayerService.nextAudioTrack(
                    audioIndex: audioPlayerService.trackIndex,
                    isShuffleOn: audioPlayerService.isShuffle
                )
            }
        }
    }
    
    @objc private func ourViewTapped() {
        guard let delegate = delegate else { return }
        guard let index = audioPlayerService.trackIndex else {
            return
        }
        delegate.showDetail(with: index)
    }
}
