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
    
    var searchTracks: [ItemInfo] = []
    
    let libraryTableArray = ["Artists", "Songs", "Playlists"]
}
