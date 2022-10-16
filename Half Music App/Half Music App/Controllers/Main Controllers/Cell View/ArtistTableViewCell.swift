//
//  ArtistTableViewCell.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var artistImageView: UIImageView!
    @IBOutlet private weak var artistLabel: UILabel!
    
    static let identifier = "ArtistTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refresh(model: String) {
        artistLabel.text = model
    }
    
}
