//
//  NowIsPlayingView.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.11.22.
//

import UIKit
import MediaPlayer

class NowIsPlayingView: UIView {

    @IBOutlet weak var audioImageView: UIImageView!
    @IBOutlet weak var audioTitleLabel: UILabel!
    @IBOutlet weak var playPauseButtonOutlet: UIButton!
    
    private let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    private let audioPlayerService = AudioPlayerService.shared
    
    private var timeObserver: Any!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewInit()
        print("Frame hello")
//        setup()
//        addObserver()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewInit()
        print("Coder hello")
    }
    
    func viewInit() {
        let xibView = Bundle.main.loadNibNamed("NowIsPlayingView", owner: self)![0] as! UIView
        xibView.frame = self.bounds
        addSubview(xibView)
    }
    
//    func addObserver() {
//        timeObserver = audioPlayerService.addObserver { [weak self] time in
//            self?.audioObserve(time: time)
//        }
//    }
    
//    func setup() {
//        guard LocalStorage.shared.localTracks.count > 0 else { return }
//        let track = LocalStorage.shared.localTracks[audioPlayerService.audioIndex]
//        audioTitleLabel.text = track.artist +  " - " + track.name
//        let trackUrl = track.album.images[0].url
//
//        dataFetcherService.fetchImage(urlString: trackUrl) { [weak self] image in
//            guard let image = image else {
//                return
//            }
//            self?.audioImageView.image = image
//        }
//    }
    
//    private func audioObserve(time: CMTime) {
//        let duration = audioPlayerService.getDuration()!
//
//        let seconds = Int(time.value/1000000000)
//
//        if duration - seconds <= 0, duration != 0 {
//            audioPlayerService.seekTo(time: CMTime(seconds: 0.0, preferredTimescale: .max))
//            if audioPlayerService.isRepeat {
//                audioPlayerService.addTrackInPlayer()
//            } else {
//                audioPlayerService.nextAudioTrack(isShuffleOn: audioPlayerService.isShuffle)
//                setup()
//            }
//        }
//    }
    
    @IBAction func playPauseAction() {
    }
    
    @IBAction func forwardAction() {
    }
}
