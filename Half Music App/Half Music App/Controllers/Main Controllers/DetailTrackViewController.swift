//
//  DetailTrackViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.10.22.
//

import UIKit

class DetailTrackViewController: UIViewController {

    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    
    var track: Track?
    let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        setUpTrackUI()
    }
    
    @IBAction func trackSliderAction() {
    }
    
    @IBAction private func backwardTrackAction() {
    }
    @IBAction private func playPauseTrackAction(_ sender: UIButton) {
    }
    
    @IBAction private func forwardTrackAction() {
    }
    
    @IBAction private func volumeSliderAction() {
    }
    
    // MARK: Private
    
    private func setUpTrackUI() {
        guard let track = track else {
            return
        }
        trackNameLabel.text = track.name
        authorNameLabel.text = track.artists[0].name
        let trackUrl = track.album.images[0].url
        
        if let image = CacheManager.shared.imageCache.image(withIdentifier: trackUrl) {
            trackImageView.image = image
        } else {
            dataFetcherService.fetchImage(urlString: trackUrl) {[weak self] image in
                guard let image = image else {
                    return
                }
                CacheManager.shared.imageCache.add(image, withIdentifier: trackUrl)
                self?.trackImageView.image = image
            }
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
