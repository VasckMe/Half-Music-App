//
//  DetailTrackViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.10.22.
//

import UIKit
import MediaPlayer
import FirebaseDatabase

protocol UpdateDetailTrackViewControllerProtocol {
    func updateDetailTrack()
}

final class DetailTrackViewController: UIViewController {

    static func storyboardInstance() -> DetailTrackViewController? {
        let storyboard = UIStoryboard(name: "DetailTrack", bundle: nil)
        return storyboard.instantiateViewController(
            withIdentifier: "DetailTrackVC"
        ) as? DetailTrackViewController
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var trackBackgroundImageView: UIImageView!
    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var volumeSliderOutlet: UISlider! {
        didSet {
            volumeSliderOutlet.value = audioPlayerService.volume * 100
        }
    }
    
    @IBOutlet private weak var playPauseButtonOutlet: UIButton! {
        didSet {
            playPauseButtonOutlet.isSelected = audioPlayerService.isPlaying
            playPauseButtonOutlet.setImage(UIImage(systemName: "pause.circle.fill"), for: .selected)
            playPauseButtonOutlet.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        }
    }
    @IBOutlet private weak var shuffleOutlet: UIButton! {
        didSet {
            shuffleOutlet.isSelected = audioPlayerService.isShuffle
            shuffleOutlet.setImage(UIImage(systemName: "shuffle.circle"), for: .normal)
            shuffleOutlet.setImage(UIImage(systemName: "shuffle.circle.fill"), for: .selected)
        }
    }
    @IBOutlet private weak var repeatOutlet: UIButton! {
        didSet {
            repeatOutlet.isSelected = audioPlayerService.isRepeat
            repeatOutlet.setImage(UIImage(systemName: "arrow.2.circlepath.circle"), for: .normal)
            repeatOutlet.setImage(UIImage(systemName: "arrow.2.circlepath.circle.fill"), for: .selected)
        }
    }
    
    @IBOutlet private weak var likeButtonOutlet: UIButton! {
        didSet {
            likeButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
            likeButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        }
    }
    
    // MARK: - Properties
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let audioPlayerService = AudioPlayerManager.shared
    private var timeObserver: Any!
    var trackIndex: Int?
    var isOpenInBackground = false
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTrackUI()
        if !isOpenInBackground {
            audioPlayerService.addAudioTrackInPlayer(audioIndex: trackIndex)

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeObserver = audioPlayerService.addObserver { [weak self] time in
            self?.makeTime(time: time)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayerService.removeObserver(observer: timeObserver!)
    }
    
    // MARK: - IBActions
    
    @IBAction private func trackSliderAction() {
        let value: Double = Double(trackSlider.value)
        let time = CMTime(seconds: value, preferredTimescale: .max)
        audioPlayerService.seekTo(time: time)
    }
    
    @IBAction private func backwardTrackAction() {
        trackIndex = audioPlayerService.previousAudioTrack(audioIndex: trackIndex)
        setupTrackUI()
    }
    
    @IBAction private func playPauseTrackAction() {
        trackSlider.maximumValue = Float(audioPlayerService.getDuration()!)
        playPauseButtonOutlet.isSelected.toggle()
        audioPlayerService.isPlaying = playPauseButtonOutlet.isSelected
        if playPauseButtonOutlet.isSelected {
            audioPlayerService.play()
        } else {
            audioPlayerService.pause()
        }
    }
    
    @IBAction private func forwardTrackAction() {
        trackIndex = audioPlayerService.nextAudioTrack(
            audioIndex: trackIndex,
            isShuffleOn: shuffleOutlet.isSelected
        )
        setupTrackUI()
    }
    
    @IBAction private func shuffleAction() {
        shuffleOutlet.isSelected.toggle()
        audioPlayerService.isShuffle = shuffleOutlet.isSelected
    }
    
    @IBAction private func volumeSliderAction(_ sender: UISlider) {
        audioPlayerService.volume = sender.value/100
        audioPlayerService.setVolume(volume: sender.value/100)
    }
    
    @IBAction private func repeatAction() {
        repeatOutlet.isSelected.toggle()
        audioPlayerService.isRepeat = repeatOutlet.isSelected
    }
    
    @IBAction private func addToLibrary(_ sender: Any) {
        addAudioToLibrary()
    }
    
    @IBAction private func addToAlbum() {
        let storyboard = UIStoryboard(name: "AddTrackToAlbum", bundle: nil)
        let vc = (storyboard.instantiateViewController(withIdentifier: "AddTrackToAlbumVC") as? AddTrackToAlbumViewController)!
        let track = LocalStorage.shared.currentAudioQueue[trackIndex!]
        vc.track = track
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
}

// MARK: - UpdateDetailTrackViewControllerProtocol

extension DetailTrackViewController: UpdateDetailTrackViewControllerProtocol {
    func updateDetailTrack() {
        let track = LocalStorage.shared.currentAudioQueue[trackIndex!]
        FireBaseStorageService.isAddedInLibrary(track: track) { [weak self] bool in
            self?.likeButtonOutlet.isSelected = bool
        }
    }
}

// MARK: - Extension Logic

extension DetailTrackViewController {
    
    // MARK: - Private
    
    private func addAudioToLibrary() {
        guard
            let audioIndex = trackIndex,
            LocalStorage.shared.currentAudioQueue.indices.contains(audioIndex)
        else {
            print("Bad track index")
                return
        }
        
        let track = LocalStorage.shared.currentAudioQueue[audioIndex]
        
        if likeButtonOutlet.imageView?.image == UIImage(systemName: "heart.fill") {
            print("REMOVING \(track.name)")
            FireBaseStorageService.audioRef.child(track.name ?? "track name").removeValue()
            likeButtonOutlet.isSelected.toggle()
        } else {
            print("ADDING \(track.name)")
            likeButtonOutlet.isSelected.toggle()
            FireBaseStorageService.saveTrackInDB(track: track)
        }
    }
    
    private func setupTrackUI() {
        guard
            let audioIndex = trackIndex,
            LocalStorage.shared.currentAudioQueue.indices.contains(audioIndex)
        else {
            print("There is no tracks with that index")
            return
        }
        
        let track = LocalStorage.shared.currentAudioQueue[audioIndex]
        
        FireBaseStorageService.isAddedInLibrary(track: track) { [weak self] bool in
            self?.likeButtonOutlet.isSelected = bool
        }
                
        trackNameLabel.text = track.name
        authorNameLabel.text = track.artist
        guard let trackImageUrl = track.album?.images?[0].url else {
            return
        }
                
        dataFetcherService.fetchImage(urlString: trackImageUrl) { [weak self] image in
            guard let image = image else {
                return
            }
            self?.trackBackgroundImageView.image = image
            self?.trackImageView.image = image
        }
    }
    
    private func makeTime(time: CMTime) {
        let duration = audioPlayerService.getDuration()!
        
        let seconds = Int(time.value/1000000000)
        trackSlider.value = Float(seconds)
        startTimeLabel.text = seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)"
        endTimeLabel.text = duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)"

        if duration - seconds <= 0, duration != 0 {
            audioPlayerService.seekTo(time: CMTime(seconds: 0.0, preferredTimescale: .max))
            if repeatOutlet.isSelected {
                audioPlayerService.addAudioTrackInPlayer(audioIndex: trackIndex!)
            } else {
                forwardTrackAction()
            }
        }
    }
}
