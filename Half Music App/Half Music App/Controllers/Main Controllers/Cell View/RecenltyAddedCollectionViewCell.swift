//
//  RecenltyAddedCollectionViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 12.10.22.
//

import UIKit

final class RecenltyAddedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackLabel: UILabel!
    
    static let identifier = "RecenltyAddedCollectionViewCell"
    let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    
    func refresh(track: TrackFB) {
        trackLabel.text = track.name
        
        let photoURL = track.album.images[1].url
        if let image = ImageCacheManager.shared.imageCache.image(withIdentifier: photoURL) {
            trackImageView.image = image
//            activityIndicator.stopAnimating()
        } else {
            dataFetcherService.fetchImage(urlString: photoURL) {[weak self] image in
                guard let image = image else {
                    return
                }
                ImageCacheManager.shared.imageCache.add(image, withIdentifier: photoURL)
                self?.trackImageView.image = image
//                self?.activityIndicator.stopAnimating()
            }
        }
        
    }
}
