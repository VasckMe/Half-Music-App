//
//  CurrentMusicViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import UIKit
import MediaPlayer

final class CurrentMusicViewController: UIViewController {

    
    @IBOutlet var ourView: UIView!
    @IBOutlet private weak var audioTitleLabel: UILabel!
    @IBOutlet private weak var animationImageView: UIImageView!
    @IBOutlet private weak var playPauseButtonOutlet: UIButton!
    
    // MARK: - Properties
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let audioPlayerService = AudioPlayerManager.shared
    private let animationService = AnimationManager.shared
    
    var presenter: CurrentMusicPresenterInterface?
    static let id = "CurrentMusicViewController"
    
    private var timeObserver: Any!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ourView.frame, ourView.bounds)
//        viewInit()
        setupUI()
        setupAudio()
        addObserver()
    }
    // MARK: - IBActions
    
    @IBAction private func playPauseAction() {
        playPause()
    }
    
    @IBAction private func forwardAction() {
        presenter?.nextTrack()
    }
    
    deinit {
        removeObserver()
    }
    
    func setupAudio() {
        guard let audioIndex = audioPlayerService.trackIndex else {
            print("XIB INDEX ERROR")
            return
        }
        playPauseButtonOutlet.isSelected = audioPlayerService.isPlaying
        playPauseButtonOutlet.isSelected
        ? animationImageView.startAnimating()
        : animationImageView.stopAnimating()
        
        let track = LocalStorage.shared.currentAudioQueue[audioIndex]
        guard let artist = track.artist else {
            return
        }
        audioTitleLabel.text = artist +  " - " + track.name
    }
    
    func addObserver() {
        timeObserver = audioPlayerService.addObserver { [weak self] time in
            self?.audioObserve(time: time)
        }
    }
    
    func removeObserver() {
        audioPlayerService.removeObserver(observer: timeObserver!)
    }
    
    func playPause() {
        playPauseButtonOutlet.isSelected.toggle()
        audioPlayerService.isPlaying = playPauseButtonOutlet.isSelected
        playPauseButtonOutlet.isSelected
        ? audioPlayerService.play()
        : audioPlayerService.pause()
    }
    
    func setupUI() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ourViewTapped))
        ourView.addGestureRecognizer(recognizer)
        animationImageView.animationImages = animationService.getAnimationImages()
        animationImageView.animationDuration = 0.4
        playPauseButtonOutlet.setImage(UIImage(systemName: "pause.circle.fill"), for: .selected)
        playPauseButtonOutlet.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
    }
    
//    func viewInit() {
//        let xibView = Bundle.main.loadNibNamed("NowIsPlayingView", owner: self)![0] as! UIView
//        xibView.frame = self.bounds
//        addSubview(xibView)
//    }
    
    func audioObserve(time: CMTime) {
        setupAudio()
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
    
    @objc func ourViewTapped() {
        presenter?.didTriggerTapView()
    }
}
