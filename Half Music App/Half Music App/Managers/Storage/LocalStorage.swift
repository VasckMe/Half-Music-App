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
    
    var localTracks: [TrackFB] = []
    var currentAudioQueue: [TrackFB] = []
    
    func convertToNewModelArray(itemArray: [ItemInfo]) {
        var newItemArray: [TrackFB] = []
        for item in itemArray {
            let trackFB = TrackFB(itemInfo: item)
            newItemArray.append(trackFB)
        }
        localTracks = newItemArray
    }
}
