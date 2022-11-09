//
//  Track.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.09.22.
//

import Foundation

struct Track: Decodable {
    let album: Album
    let artists: [Artists]
    let name: String
    let preview_url: String
}
