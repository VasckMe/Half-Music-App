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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: Track) {
        trackNameLabel.text = model.name
        trackArtistsLabel.text = model.artists.first?.name
        
        let imageUrl = model.album.images[2].url
        
        if let image = CacheManager.shared.imageCache.image(withIdentifier: imageUrl) {
            trackImageView.image = image
            activityIndicator.stopAnimating()
        } else {
            dataFetcherService.fetchImage(urlString: model.album.images[2].url) {[weak self] image in
                guard let image = image else {
                    return
                }
                CacheManager.shared.imageCache.add(image, withIdentifier: imageUrl)
                self?.trackImageView.image = image
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
}
