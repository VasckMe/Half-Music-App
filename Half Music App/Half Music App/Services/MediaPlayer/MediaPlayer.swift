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
    func addObserver(completion: @escaping (CMTime) -> Void) -> Any
    func removeObserver(observer: Any)
    func preparePlayer(urlString: String?)
    func getDuration() -> Int?
    func seekTo(time: CMTime)
    func changeVolume(volume: Float)
}

final class MediaPlayer: MediaPlayerProtocol {

    // MARK: Internal
    
    let player = AVPlayer()
    
    func preparePlayer(urlString: String?) {
        guard let item = createPlayerItem(urlString: urlString) else {
            return
        }
        player.replaceCurrentItem(with: item)
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
    
    func addObserver(completion: @escaping (CMTime) -> Void) -> Any {
        let observer = player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1.0, preferredTimescale: .max),
            queue: nil) { time in
            completion(time)
        }
        return observer
    }
    
    func removeObserver(observer: Any) {
        player.removeTimeObserver(observer)
    }
    
    func changeVolume(volume: Float) {
        player.volume = volume
    }
    
    // MARK: Private
    
    private func createPlayerItem(urlString: String?) -> AVPlayerItem? {
        guard
            let urlString = urlString,
            let url = URL(string: urlString)
        else {
            return nil
        }
        return AVPlayerItem(url: url)
    }
}
