//
//  Album.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.09.22.
//

import Foundation

struct Album: Decodable {
    let images: [AlbumImage]
    let name: String
    
    static func convertFromDictionary(dictionary: [String: Any]) -> Album? {
        guard
            let imagesDictionary = dictionary["Images"] as? [String: String],
            let albumName = dictionary["Album name"] as? String,
            let images = AlbumImage.convertFromDictionary(dictionary: imagesDictionary)
        else {
            return nil
        }
        return Album(images: images, name: albumName)
    }
}
