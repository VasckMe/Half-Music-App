//
//  AudioPlayerService.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.10.22.
//

import Foundation
import MediaPlayer

//protocol AudioPlayerServiceProtocol {
////    var player: AVPlayer { get }
//    var isPlaying: Bool { get set }
//    func addAudioTrackInPlayer(audioIndex: Int?)
//
//    func addObserver(completion: @escaping (CMTime) -> Void) -> Any
//    func removeObserver(observer: Any)
//
//    func play()
//    func pause()
//    func nextAudioTrack(audioIndex: Int?, isShuffleOn: Bool) -> Int?
//    func previousAudioTrack(audioIndex: Int?) -> Int?
//    func getDuration() -> Int?
//    func seekTo(time: CMTime)
//    func setVolume(volume: Float)
//}

final class AudioPlayerService {

    // MARK: Private
    
    private init() {}
    
    private let player = AVPlayer()
    
    private func createPlayerItem(urlString: String?) -> AVPlayerItem? {
        guard
            let urlString = urlString,
            let url = URL(string: urlString)
        else {
            return nil
        }
        return AVPlayerItem(url: url)
    }
    // MARK: Internal
        
    static let shared = AudioPlayerService()
    
    var trackIndex: Int!
    var isPlaying = false
    var isShuffle = false
    var isRepeat = false
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
    
    func nextAudioTrack(audioIndex: Int?, isShuffleOn: Bool) -> Int? {
        guard var audioIndex = audioIndex else { return nil }
        audioIndex = isShuffleOn
        ? Int.random(in: 0..<LocalStorage.shared.currentAudioQueue.count)
        : audioIndex+1 >= LocalStorage.shared.currentAudioQueue.count
            ? 0
            : audioIndex+1
        addAudioTrackInPlayer(audioIndex: audioIndex)
        return audioIndex
    }
    
    func previousAudioTrack(audioIndex: Int?) -> Int? {
        guard var audioIndex = audioIndex else { return nil }
        audioIndex = audioIndex - 1 >= 0
        ? audioIndex - 1
        : LocalStorage.shared.currentAudioQueue.count - 1
        addAudioTrackInPlayer(audioIndex: audioIndex)
        return audioIndex
    }
    
    func addAudioTrackInPlayer(audioIndex: Int?) {
        guard
            let audioIndex = audioIndex,
            let audioItem = createPlayerItem(urlString: LocalStorage.shared.currentAudioQueue[audioIndex].preview_url)
        else {
            return
        }
        trackIndex = audioIndex
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
}
