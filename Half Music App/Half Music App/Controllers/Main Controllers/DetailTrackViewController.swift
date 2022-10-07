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
    var timeobs: Any!
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        setupPlayer()
        setupTrackUI()
        
        timeobs = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: .max), queue: nil) {[weak self] time in
            print("time: \(time.value)")
            print("STATUs: ",self?.player.status)
            self?.makeTime(time: time)
//            let duration = Int((self?.player.currentItem?.duration.value)!/44100)
//            let seconds = Int(time.value/1000000000)
//            self?.trackSlider.value = Float(seconds)
//            self?.startTimeLabel.text = seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)"
//            self?.endTimeLabel.text = duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player.removeTimeObserver(timeobs!)
    }
    
    // MARK: IBActions
    
    @IBAction func trackSliderAction() {
        let value: Double = Double(trackSlider.value)
        let time = CMTime(seconds: value, preferredTimescale: .max)
        player.seek(to: time)
        makeTime(time: time)
    }
    
    @IBAction private func backwardTrackAction() {
    }
    @IBAction private func playPauseTrackAction(_ sender: UIButton) {
        
//        sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
        
        if sender.imageView?.image == UIImage(systemName: "play.fill") {
            sender.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            player.play()
        } else {
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.pause()
        }
    }
    
    func makeTime(time: CMTime) {
        let duration = Int((player.currentItem?.duration.value)!/44100)
        let seconds = Int(time.value/1000000000)
        trackSlider.value = Float(seconds)
        startTimeLabel.text = seconds < 10 ? "0:0\(seconds)" : "0:\(seconds)"
        endTimeLabel.text = duration - seconds < 10 ? "0:0\(duration - seconds)" : "0:\(duration - seconds)"
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
        
        trackSlider.maximumValue = Float((player.currentItem?.duration.value)! / 44100)
        
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
//        player = AVPlayer(url: url)
        player = AVPlayer(playerItem: music)
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
