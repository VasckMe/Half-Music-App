//
//  AudioPlayerService.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.10.22.
//

import Foundation
import MediaPlayer

protocol AudioPlayerServiceProtocol {
//    var player: AVPlayer { get }
    
    func addTrackInPlayer(audioIndex: Int?)
    
    func addObserver(completion: @escaping (CMTime) -> Void) -> Any
    func removeObserver(observer: Any)
    
    func play()
    func pause()
    func nextAudioTrack(audioIndex: Int?, isShuffleOn: Bool) -> Int?
    func previousAudioTrack(audioIndex: Int?) -> Int?
    func getDuration() -> Int?
    func seekTo(time: CMTime)
    func setVolume(volume: Float)
}

final class AudioPlayerService: AudioPlayerServiceProtocol {

    // MARK: Internal
    
    private let player = AVPlayer()
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func nextAudioTrack(audioIndex: Int?, isShuffleOn: Bool) -> Int? {
        guard var index = audioIndex else { return nil }
        index = isShuffleOn
        ? Int.random(in: 0..<LocalStorage.shared.localTracks.count)
        : index+1 >= LocalStorage.shared.localTracks.count
            ? 0
            : index+1
        addTrackInPlayer(audioIndex: index)
        return index
    }
    
    func previousAudioTrack(audioIndex: Int?) -> Int? {
        guard var index = audioIndex else { return nil }
        index = index - 1 >= 0
        ? index - 1
        : LocalStorage.shared.localTracks.count - 1
        addTrackInPlayer(audioIndex: index)
        return index
    }
    
    func addTrackInPlayer(audioIndex: Int?) {
        guard
            let index = audioIndex,
            let audioItem = createPlayerItem(urlString: LocalStorage.shared.localTracks[index].preview_url)
        else {
            return
        }
        
        player.replaceCurrentItem(with: audioItem)
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
    
    func setVolume(volume: Float) {
        player.volume = volume
    }
    
    /// observing
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
