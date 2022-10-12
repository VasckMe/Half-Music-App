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
    
    func refresh(track: TrackFB) {
        trackLabel.text = track.name
    }
}
