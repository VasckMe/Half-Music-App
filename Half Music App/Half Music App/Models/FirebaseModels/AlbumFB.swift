//
//  AlbumFB.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import Foundation
import FirebaseDatabase

struct AlbumFB {
    var ref: DatabaseReference?

    var name: String
    var tracks: [TrackFB]
    
    init(name: String, tracks: [TrackFB]) {
        self.name = name
        self.tracks = tracks
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let albums = snapshot.value as? [String : Any]
        else {
            return nil
        }
        let name = snapshot.key // Album title
        let albumArray = albums.values
        var music: [TrackFB] = []
        for album in albumArray {
            guard
                let trackDictionary = album as? [String : Any],
                let track = TrackFB(dict: trackDictionary) else {
                self.name = "?"
                self.tracks = []
                return
            }
            music.append(track)
        }

        self.name = name
        self.tracks = music
        ref = snapshot.ref
    }
}
