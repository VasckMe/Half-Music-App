//
//  TrackFB.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 3.10.22.
//

import Foundation
import FirebaseDatabase

struct TrackFB: Equatable {
    static func == (lhs: TrackFB, rhs: TrackFB) -> Bool {
        return lhs.name == rhs.name && lhs.preview_url == rhs.preview_url
    }
    
    var ref: DatabaseReference?

    let album: Album?
    let artist: String?
    let name: String?
    let preview_url: String?

    init(itemInfo: ItemInfo) {
        self.album = itemInfo.track?.album ?? Album(images: [AlbumImage(url: "123")], name: "123")
        self.artist = itemInfo.track?.artists?[0].name ?? "name"
        self.name = itemInfo.track?.name ?? "name"
        self.preview_url = itemInfo.track?.preview_url ?? "name"
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
    
    init?(dict: [String : Any]) {
        guard
            let album = dict["Album"] as? [String: Any],
            let albumModel = Album.convertFromDictionary(dictionary: album),
            let artist = dict["Artist"] as? String,
            let name = dict["Name"] as? String,
            let preview_url = dict["Preview_url"] as? String
        else {
            return nil
        }
        self.artist = artist
        self.name = name
        self.preview_url = preview_url
        self.album = albumModel
    }
    
    func convertInDictionary() -> [String : Any] {
        ["Name" : self.name,
         "Album" : ["Album name" : self.album?.name,
                    "Images" : ["Big image" : self.album?.images?[0].url,
                                "Medium image" : self.album?.images?[1].url,
                                "Small image" : self.album?.images?[2].url]],
         "Artist" : self.artist,
         "Preview_url" : self.preview_url]
    }
}
