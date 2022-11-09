//
//  ItemInfo.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 27.09.22.
//

import Foundation

struct ItemInfo: Decodable {
    let track: Track
    
    func convertInDictionary() -> [String : Any] {
        ["Name" : track.name,
         "Album" : ["Album name" : track.album.name,
                    "Images" : ["Big image" : track.album.images[0].url,
                                "Medium image" : track.album.images[1].url,
                                "Small image" : track.album.images[2].url]],
         "Artist" : track.artists[0].name,
         "Preview_url" : track.preview_url]
    }
}
