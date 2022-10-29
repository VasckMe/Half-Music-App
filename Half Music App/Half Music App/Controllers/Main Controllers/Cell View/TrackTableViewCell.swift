//
//  TrackTableViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import UIKit

class TrackTableViewCell: UITableViewCell {

    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var trackArtistsLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "TrackTableViewCell"
    let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: TrackFB) {
        trackNameLabel.text = model.name
        trackArtistsLabel.text = model.artist
        let photoURL = model.album.images[2].url
        if let image = ImageCacheManager.shared.imageCache.image(withIdentifier: photoURL) {
            trackImageView.image = image
            activityIndicator.stopAnimating()
        } else {
            dataFetcherService.fetchImage(urlString: photoURL) {[weak self] image in
                guard let image = image else {
                    return
                }
                ImageCacheManager.shared.imageCache.add(image, withIdentifier: photoURL)
                self?.trackImageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}
