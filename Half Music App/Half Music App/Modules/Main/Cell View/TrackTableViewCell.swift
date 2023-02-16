//
//  TrackTableViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import UIKit

final class TrackTableViewCell: UITableViewCell {

    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var trackArtistsLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "TrackTableViewCell"
    let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    
    func configure(model: TrackFB) {
        trackNameLabel.text = model.name
        trackArtistsLabel.text = model.artist
        
        let numberOfImages = model.album?.images?.count
        var photo = ""
        switch numberOfImages {
        case 1:
            photo = (model.album?.images?[0].url)!
        case 2:
            photo = (model.album?.images?[1].url)!
        case 3:
            photo = (model.album?.images?[2].url)!
        default:
            photo = ""
        }
        let photoURL = photo
        
        dataFetcherService.fetchImage(urlString: photoURL) { [weak self] image in
            guard let image = image else { return }
            self?.trackImageView.image = image
            self?.activityIndicator.stopAnimating()
        }
    }
}
