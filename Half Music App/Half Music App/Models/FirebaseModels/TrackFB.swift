//
//  TrackFB.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 3.10.22.
//

import Foundation
import FirebaseDatabase

struct TrackFB {
    var ref: DatabaseReference?

    let album: Album
    let artist: String
    let name: String
    let preview_url: String

    init(itemInfo: ItemInfo) {
        self.album = itemInfo.track.album
        self.artist = itemInfo.track.artists[0].name
        self.name = itemInfo.track.name
        self.preview_url = itemInfo.track.preview_url
        self.ref = nil
    }

    init?(snapshot: DataSnapshot) {
        guard
            let snapshotValue = snapshot.value as? [String: Any],
            let album = snapshotValue["Album"] as? [String: Any],
            let albumModel = Album.convertFromDictionary(dictionary: album),
            let artist = snapshotValue["Artist"] as? String,
            let name = snapshotValue["Name"] as? String,
            let preview_url = snapshotValue["Preview_url"] as? String
        else {
            return nil
        }
        self.artist = artist
        self.name = name
        self.preview_url = preview_url
        self.album = albumModel
        ref = snapshot.ref
    }
    
    func convertInDictionary() -> [String : Any] {
        ["Name" : self.name,
         "Album" : ["Album name" : self.album.name,
                    "Images" : ["Big image" : self.album.images[0].url,
                                "Medium image" : self.album.images[1].url,
                                "Small image" : self.album.images[2].url]],
         "Artist" : self.artist,
         "Preview_url" : self.preview_url]
    }
}
