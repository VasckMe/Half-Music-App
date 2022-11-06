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

    // MARK: - IBOutlets
    
    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    
    @IBOutlet private weak var playPauseButtonOutlet: UIButton!
    @IBOutlet private weak var shuffleOutlet: UIButton! {
        didSet {
            shuffleOutlet.setImage(UIImage(systemName: "shuffle.circle"), for: .normal)
            shuffleOutlet.setImage(UIImage(systemName: "shuffle.circle.fill"), for: .selected)
        }
    }
    @IBOutlet private weak var repeatOutlet: UIButton! {
        didSet {
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
    private let mediaPlayer: MediaPlayerProtocol = MediaPlayer()
    private var isPlaying = false {
        didSet {
            if isPlaying {
                playPauseButtonOutlet.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
                mediaPlayer.player.play()
            } else {
                playPauseButtonOutlet.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                mediaPlayer.player.pause()
            }
        }
    }
    private var timeObserver: Any!
    var trackIndex: Int?
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationController?.navigationBar.backgroundColor = .clear
        setupTrackUI()
    }
    
    deinit {
        print("DEINITED")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        timeObserver = mediaPlayer.addObserver { [weak self] time in
            self?.makeTime(time: time)
        }
        print("ADDED OBSERVER")
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mediaPlayer.removeObserver(observer: timeObserver!)
//        FireBaseStorageManager.audioRef.removeAllObservers()
        print("REMOVED OBSERVER")
    }
    
    // MARK: IBActions
    
    @IBAction private func trackSliderAction() {
        let value: Double = Double(trackSlider.value)
        let time = CMTime(seconds: value, preferredTimescale: .max)
        mediaPlayer.seekTo(time: time)
    }
    
    @IBAction private func backwardTrackAction() {
        if trackIndex != nil {
//            trackIndex! -= 1
            trackIndex! = trackIndex!-1 >= 0 ? trackIndex!-1 : LocalStorage.shared.localTracks.count-1
            setupTrackUI()
        }
    }
    
    @IBAction private func playPauseTrackAction(_ sender: UIButton) {
        trackSlider.maximumValue = Float(mediaPlayer.getDuration()!)
        isPlaying.toggle()
    }
    
    @IBAction private func forwardTrackAction() {
        if trackIndex != nil {
//            trackIndex! += 1
            if shuffleOutlet.isSelected {
                trackIndex! = Int.random(in: 0..<LocalStorage.shared.localTracks.count)
            } else {
                trackIndex! = trackIndex!+1 >= LocalStorage.shared.localTracks.count ? 0 : trackIndex!+1
            }
            setupTrackUI()
        }
    }
    
    @IBAction func shuffleAction() {
        shuffleOutlet.isSelected.toggle()
    }
    
    @IBAction private func volumeSliderAction(_ sender: UISlider) {
        mediaPlayer.changeVolume(volume: sender.value)
    }
    
    @IBAction func repeatAction() {
        repeatOutlet.isSelected.toggle()
    }
    
    @IBAction func addToLibrary(_ sender: Any) {
        guard
            let trackIndex = trackIndex,
            LocalStorage.shared.localTracks.indices.contains(trackIndex)
        else {
            print("Bad track index")
                return
        }
        
        let track = LocalStorage.shared.localTracks[trackIndex]
        
        if likeButtonOutlet.imageView?.image == UIImage(systemName: "heart.fill") {
            print("REMOVING \(track.name)")
            FireBaseStorageManager.audioRef.child(track.name).removeValue()
            likeButtonOutlet.isSelected.toggle()
        } else {
            print("ADDING \(track.name)")
            likeButtonOutlet.isSelected.toggle()
            FireBaseStorageManager.saveTrackInDB(track: track)
        }
    }
    
    @IBAction func addToAlbum() {
        let storyboard = UIStoryboard(name: "AddTrackToAlbum", bundle: nil)
        let vc = (storyboard.instantiateViewController(withIdentifier: "AddTrackToAlbumVC") as? AddTrackToAlbumViewController)!
        let track = LocalStorage.shared.localTracks[trackIndex!]
        vc.track = track
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    
    // MARK: Private
    
    private func setupTrackUI() {
        guard
            let trackIndex = trackIndex,
            LocalStorage.shared.localTracks.indices.contains(trackIndex)
        else {
            print("There is no tracks with that index")
            return
        }
        
        let track = LocalStorage.shared.localTracks[trackIndex]
        
        FireBaseStorageManager.isAddedInLibrary(track: track) { [weak self] bool in
            self?.likeButtonOutlet.isSelected = bool
        }
        
        mediaPlayer.preparePlayer(urlString: track.preview_url)
        
        trackNameLabel.text = track.name
        authorNameLabel.text = track.artist
        let trackUrl = track.album.images[0].url
                
        dataFetcherService.fetchImage(urlString: trackUrl) { [weak self] image in
            guard let image = image else {
                return
            }
            self?.trackImageView.image = image
        }
    }
    
    private func makeTime(time: CMTime) {
        let duration = mediaPlayer.getDuration()!
        
        let seconds = Int(time.value/1000000000)
        trackSlider.value = Float(seconds)
        startTimeLabel.text = seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)"
        endTimeLabel.text = duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)"

        
        if duration - seconds <= 0 {
            isPlaying = repeatOutlet.isSelected
            //            forwardTrackAction()
            mediaPlayer.seekTo(time: CMTime(seconds: 0.0, preferredTimescale: .max))
            trackSlider.value = Float(duration - seconds)
        }
    }
}

extension DetailTrackViewController: UpdateDetailTrackViewControllerProtocol {
    func updateDetailTrack() {
        let track = LocalStorage.shared.localTracks[trackIndex!]
        
        FireBaseStorageManager.isAddedInLibrary(track: track) { [weak self] bool in
            self?.likeButtonOutlet.isSelected = bool
        }
    }
}
