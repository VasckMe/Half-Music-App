//
//  SearchTableViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var trackArtistsLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "SearchTableViewCell"
    let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    var photoURL: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: Track) {
        trackNameLabel.text = model.name
        trackArtistsLabel.text = model.artists.first?.name
        guard let photoURL = photoURL else { return }
        if let image = ImageCacheManager.shared.imageCache.image(withIdentifier: photoURL) {
            trackImageView.image = image
            activityIndicator.stopAnimating()
        } else {
            dataFetcherService.fetchImage(urlString: model.album.images[2].url) {[weak self] image in
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
