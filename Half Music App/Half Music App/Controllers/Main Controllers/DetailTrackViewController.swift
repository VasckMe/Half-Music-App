//
//  DetailTrackViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.10.22.
//

import UIKit
import MediaPlayer

final class DetailTrackViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var playPauseButtonOutlet: UIButton!
    
    // MARK: Properties
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let mediaPlayer: MediaPlayerProtocol = MediaPlayer()
    
    private var isPlaying = false {
        didSet {
            if isPlaying {
                playPauseButtonOutlet.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                mediaPlayer.player.play()
            } else {
                playPauseButtonOutlet.setImage(UIImage(systemName: "play.fill"), for: .normal)
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
        
        timeObserver = mediaPlayer.addObserver { [weak self] time in
            self?.makeTime(time: time)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mediaPlayer.removeObserver(observer: timeObserver!)
    }
    
    // MARK: IBActions
    
    @IBAction private func trackSliderAction() {
        let value: Double = Double(trackSlider.value)
        let time = CMTime(seconds: value, preferredTimescale: .max)
        mediaPlayer.seekTo(time: time)
//        makeTime(time: time)
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
            trackIndex! = trackIndex!+1 >= LocalStorage.shared.localTracks.count ? 0 : trackIndex!+1
            setupTrackUI()
        }
    }
    
    @IBAction private func volumeSliderAction(_ sender: UISlider) {
        mediaPlayer.changeVolume(volume: sender.value)
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
        
        mediaPlayer.preparePlayer(urlString: track.preview_url)
        
        trackNameLabel.text = track.name
        authorNameLabel.text = track.artist
        let trackUrl = track.album.images[0].url
                
        if let image = ImageCacheManager.shared.imageCache.image(withIdentifier: trackUrl) {
            trackImageView.image = image
        } else {
            dataFetcherService.fetchImage(urlString: trackUrl) {[weak self] image in
                guard let image = image else {
                    return
                }
                ImageCacheManager.shared.imageCache.add(image, withIdentifier: trackUrl)
                self?.trackImageView.image = image
            }
        }
    }
    
    private func makeTime(time: CMTime) {
        let duration = mediaPlayer.getDuration()!
        let seconds = Int(time.value/1000000000)
        trackSlider.value = Float(seconds)
        startTimeLabel.text = seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)"
        endTimeLabel.text = duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)"
        
        if duration - seconds <= 0 {
//            isPlaying = false
//            forwardTrackAction()
            mediaPlayer.seekTo(time: CMTime(seconds: 0.0, preferredTimescale: .max))
            trackSlider.value = Float(duration - seconds)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
