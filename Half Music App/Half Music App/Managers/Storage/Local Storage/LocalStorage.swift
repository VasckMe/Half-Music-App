//
//  LocalStorage.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import Foundation

final class LocalStorage {
    
    static let shared = LocalStorage()
    
    private init() {}
    
    var library: [String] = ["Artists", "Albums", "Songs"]
    var localTracks: [TrackFB] = []
    var copyLocalTracks: [TrackFB] = []
    
    func convertToNewModelArray(itemArray: [ItemInfo]) {
        var newItemArray: [TrackFB] = []
        for item in itemArray {
            let trackFB = TrackFB(itemInfo: item)
            newItemArray.append(trackFB)
        }
        localTracks = newItemArray
        copyLocalTracks = newItemArray
    }
    
    func refreshLocalTracks() {
        localTracks = copyLocalTracks
    }
}
