//
//  Category.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 19.11.22.
//

import Foundation
import UIKit

enum Category: CaseIterable {
    case artists
    case albums
    case songs
    
    var image: UIImage? {
        switch self {
        case .artists:
            return UIImage(systemName: "music.mic")
        case .albums:
            return UIImage(systemName: "square.stack")
        case .songs:
            return UIImage(systemName: "music.note.list")
        }
    }
    
    var name: String {
        switch self {
        case .artists:
            return "Artists"
        case .albums:
            return "Albums"
        case .songs:
            return "Songs"
        }
    }
}
