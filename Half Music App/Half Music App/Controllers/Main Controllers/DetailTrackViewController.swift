//
//  DetailTrackViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.10.22.
//

import UIKit
import MediaPlayer

class DetailTrackViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    
    // MARK: Properties
    
    var track: Track?
    var player: AVPlayer!
    let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    var timer = Timer()
    var seconds = 0
    
    var timeobs: Any!
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        setupPlayer()
        setupTrackUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.removeTimeObserver(timeobs)
    }
    
    // MARK: IBActions
    
    @IBAction func trackSliderAction() {
        seconds = Int(trackSlider.value)
//        player.currentTime().tim  = CMTimeValue(seconds * 1000000000)
        timeobs = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: .max), queue: nil) { time in
            print("time: \(time.value)")
        }
        
        print(player.status)
    }
    
    @IBAction private func backwardTrackAction() {
    }
    @IBAction private func playPauseTrackAction(_ sender: UIButton) {
        
//        sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        if sender.imageView?.image == UIImage(systemName: "play.fill") {
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            startTimer()
            player.play()
        } else {
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            stopTimer()
            player.pause()
        }
    }
    
    @IBAction private func forwardTrackAction() {
    }
    
    @IBAction func volumeSliderAction(_ sender: UISlider) {
        player.volume = sender.value
        print("CURRRRRRRR ",player.currentItem?.currentTime())
        print("CURRENT TIME: ",player.currentTime().value/1000000000)
        print("DURATION: ",(player.currentItem?.duration.value)!/44100)
    }
    
    
    
    
    // MARK: Private
    
    private func setupTrackUI() {
        guard let track = track else {
            return
        }
        trackNameLabel.text = track.name
        authorNameLabel.text = track.artists[0].name
        let trackUrl = track.album.images[0].url
        
//        trackSlider.maximumValue = Float((player.currentItem?.duration.value)! / 44100)
        
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
    
    private func setupPlayer() {
        guard
            let trackUrl = track?.preview_url,
            let url = URL(string: trackUrl)
        else {
            return
        }
        let music = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: music)
    }
    private func stopTimer() {
        timer.invalidate()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerSelector), userInfo: nil, repeats: true)
    }
    
    private func reset() {
        stopTimer()
        trackSlider.value = 0
        seconds = 0
//        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    @objc private func timerSelector() {
        trackSlider.maximumValue = Float((player.currentItem?.duration.value)! / 44100)
        let duration = Int((player.currentItem?.duration.value)! / 44100)
        if duration - seconds == 0 {
            reset()
        }
        print("Timer tolerance: ",timer.tolerance)
        print("Seconds: ",seconds)
        trackSlider.value = Float(seconds)
        startTimeLabel.text = seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)"
        endTimeLabel.text = duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)"
        seconds += 1
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
