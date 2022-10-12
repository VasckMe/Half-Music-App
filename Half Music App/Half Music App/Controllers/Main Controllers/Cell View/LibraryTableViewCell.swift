//
//  LibraryTableViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 12.10.22.
//

import UIKit

final class LibraryTableViewCell: UITableViewCell {

    static let identifier = "LibraryTableViewCell"
    
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var categoryImageView: UIImageView!
    
    let categories = LocalStorage.shared.library
    
    func refresh(category: String) {
        if category == categories[0] { //artists
            categoryImageView.image = UIImage(systemName: "music.mic")
        } else if category == categories[1] { //albums
            categoryImageView.image = UIImage(systemName: "square.stack")
        } else { //songs
            categoryImageView.image = UIImage(systemName: "music.note.list")
        }
        categoryLabel.text = category
    }
}
