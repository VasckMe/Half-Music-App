//
//  SmallTableViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.10.22.
//

import UIKit

final class SmallTableViewCell: UITableViewCell {

    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var itemLabel: UILabel!
    
    static let identifier = "SmallTableViewCell"
    
    func configureCategory(category: String) {
        itemImageView.tintColor = ColorConstants.globalTintColor
        if category == LocalStorage.shared.library[0] { //artists
            itemImageView.image = UIImage(systemName: "music.mic")
        } else if category == LocalStorage.shared.library[1] { //albums
            itemImageView.image = UIImage(systemName: "square.stack")
        } else { //songs
            itemImageView.image = UIImage(systemName: "music.note.list")
        }
        itemLabel.text = category
    }
    
    func configureArtist(artist: String) {
        itemImageView.tintColor = .darkGray
        itemLabel.text = artist
        itemImageView.image = UIImage(systemName: "person.circle")
    }
    
}
