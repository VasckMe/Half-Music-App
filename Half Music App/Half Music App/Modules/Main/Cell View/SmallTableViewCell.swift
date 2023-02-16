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
    
    func configureCategory(category: Category) {
        itemImageView.tintColor = UIConstants.globalTintColor
        itemImageView.image = category.image
        itemLabel.text = category.name
    }
    
    func configureArtist(artist: String) {
        itemImageView.tintColor = .darkGray
        itemLabel.text = artist
        itemImageView.image = UIImage(systemName: "person.circle")
    }
}
