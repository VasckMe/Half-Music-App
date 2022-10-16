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
}
