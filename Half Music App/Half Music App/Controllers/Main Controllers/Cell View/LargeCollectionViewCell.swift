//
//  LargeCollectionViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 12.10.22.
//

import UIKit

final class LargeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemLabel: UILabel!
    
    static let identifier = "LargeCollectionViewCell"
    let dataFetcherService: DataFetcherServiceProtocol = DataFetcherService()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemImageView.layer.cornerRadius = 15
    }
    
    func configureTrack(track: TrackFB) {
        itemLabel.text = track.name
        
        guard let photoURL = track.album?.images?[1].url else {
            return
        }
        
        dataFetcherService.fetchImage(urlString: photoURL) {[weak self] image in
            guard let image = image else {
                return
            }
            
            self?.itemImageView.image = image
        }
    }
    
    func configureAlbum(album: AlbumFB) {
        itemLabel.text = album.name
        itemImageView.image = UIImage(systemName: "music.note.list")
    }
}
