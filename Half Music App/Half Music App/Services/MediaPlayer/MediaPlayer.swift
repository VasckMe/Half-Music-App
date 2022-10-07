//
//  MediaPlayer.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.10.22.
//

import Foundation
import MediaPlayer

protocol MediaPlayerProtocol {
    var player: AVPlayer { get }
    func preparePlayer(urlString: String)
    func getDuration() -> Int?
    func seekTo(time: CMTime)
}


final class MediaPlayer: MediaPlayerProtocol {

    var player = AVPlayer()
    
//    static var shared = MediaPlayer()
//
//    private init(){}
    
    func preparePlayer(urlString: String) {
        let item = createPlayerItem(urlString: urlString)
        player = AVPlayer(playerItem: item)
    }
    
    func createPlayerItem(urlString: String) -> AVPlayerItem? {
        guard let url = URL(string: urlString) else {
            return nil
        }
        return AVPlayerItem(url: url)
    }
    
    func getDuration() -> Int? {
        guard let currentItem = player.currentItem else {
            return nil
        }
        let duration = Int(currentItem.duration.value / 44100)
        return duration
    }
    
    func seekTo(time: CMTime) {
        player.seek(to: time)
    }
    
}
