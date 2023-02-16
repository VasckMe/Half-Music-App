//
//  AudioManager.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 8.02.23.
//

import Foundation
import MediaPlayer

final class AudioManager {
    static let shared = AudioManager()
    
    private let player = AVPlayer()
    private var observer: Any!
    
    // Properties
    var isPlaying = false
    var isShuffle = false
    var isRepeat = false
    
    var trackIndex = 0
    var volume: Float = 0.5
    
    // Private
    private init() {
        setObserver()
    }
    
    // Play / pause
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    // Shuffle
    func shuffleOn() {
        isShuffle = true
    }
    
    func shuffleOff() {
        isShuffle = false
    }
    
    // Repeat
    func repeatOn() {
        isRepeat = true
    }
    
    func repeatOff() {
        isRepeat = false
    }
    
    // Volume
    func setVolume(volume: Float) {
        player.volume = volume
        self.volume = volume
    }
    
    // Seek to
    func seekTo(time: CMTime) {
        player.seek(to: time)
    }
    
    //  Observer
    func setObserver() {
        observer = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: .max), queue: nil) { time in
            self.observe(time: time)
        }
    }
    
    func addObserver(completion: @escaping (CMTime) -> Void) -> Any {
        player.addPeriodicTimeObserver(
            forInterval: CMTime(seconds: 1.0, preferredTimescale: .max),
            queue: nil) { time in
                completion(time)
            }
    }
    
    func removeObserver(observer: Any) {
        player.removeTimeObserver(observer)
    }
    
    // Duration
    func getDuration() -> Int {
        guard let currentItem = player.currentItem else {
            return 0
        }
        let duration = Int(currentItem.duration.value / 44100)
        return duration
    }
    
    // Forward / backward
    func nextAudioTrack() {
        if isShuffle {
            trackIndex = Int.random(in: 0..<LocalStorage.shared.currentAudioQueue.count)
        } else {
            if trackIndex + 1 >= LocalStorage.shared.currentAudioQueue.count {
                trackIndex = 0
            } else {
                trackIndex += 1
            }
        }
            
        addAudioTrackInPlayer()
    }
    
    func previousAudioTrack() {
        trackIndex = trackIndex - 1 >= 0
            ? trackIndex - 1
            : LocalStorage.shared.currentAudioQueue.count - 1

        addAudioTrackInPlayer()
    }
    
    // Add track in player
    func addAudioTrackInPlayer() {
        guard
            LocalStorage.shared.currentAudioQueue.indices.contains(trackIndex),
            let audioItem = createPlayerItem(
                urlString: LocalStorage.shared.currentAudioQueue[trackIndex].preview_url
            )
        else {
            return
        }
        player.replaceCurrentItem(with: audioItem)
    }
}


// MARK: - Private
private extension AudioManager {
    func createPlayerItem(urlString: String?) -> AVPlayerItem? {
        guard
            let urlString = urlString,
            let url = URL(string: urlString)
        else {
            return nil
        }
        return AVPlayerItem(url: url)
    }
    
    func observe(time: CMTime) {
        let duration = getDuration()
        let seconds = Int(time.seconds)
        
        if duration - seconds <= 0, duration != 0 {
            seekTo(time: CMTime(seconds: 0.0, preferredTimescale: .max))
            isRepeat
                ? addAudioTrackInPlayer()
                : nextAudioTrack()
        }
    }
}
