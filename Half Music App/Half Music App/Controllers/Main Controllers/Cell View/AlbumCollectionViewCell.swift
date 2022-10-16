//
//  AlbumCollectionViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    static let identifier = "AlbumCollectionViewCell"
    
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var albumName: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func refresh(album: AlbumFB) {
        albumName.text = album.name
    }
    
}
