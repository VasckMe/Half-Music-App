//
//  SongsPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation
import FirebaseDatabase

protocol SongsPresenterInterface {
    func didTriggerViewLoad()
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerSearchBar(text: String)
    func didTriggerTableViewCellAt(index: Int)
}

struct SongsInput {
    var artist: String?
}

final class SongsPresenter {
    weak var controller: SongsTableViewControllerInterface?
    
    private var router: SongsRouterInterface?
    private var input: SongsInput?
    
    init(input: SongsInput?, router: SongsRouterInterface) {
        self.input = input
        self.router = router
    }
}

extension SongsPresenter: SongsPresenterInterface {
    func didTriggerViewLoad() {
        controller?.setTitle(with: input?.artist)
    }
    
    func didTriggerViewAppear() {
        fetchSongs()
        controller?.showNavigationBar()
    }
    
    func didTriggerViewDisappear() {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    func didTriggerSearchBar(text: String) {
        findSongs(with: text)
    }
    
    func didTriggerTableViewCellAt(index: Int) {
        LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
        let input = DetailTrackInput(trackIndex: index, isOpenInBackground: false)
        router?.showDetailTrack(input: input)
    }
}

private extension SongsPresenter {
    func fetchSongs() {
        FireBaseStorageService.audioRef.observe(.value) { [weak self] snapshot in
            var tracks = [TrackFB]()

            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let track = TrackFB(snapshot: snapshot) else { continue }
                if let artist = self?.input?.artist {
                    if artist == track.artist {
                        tracks.append(track)
                    } else {
                        continue
                    }
                } else {
                    tracks.append(track)
                }
            }

            LocalStorage.shared.localTracks = tracks
            self?.controller?.reloadData()
        }
    }
    
    func findSongs(with text: String) {
        if text.isEmpty {
            FireBaseStorageService.getTracksWithOptionalArtist(
                artist: self.input?.artist
            ) { [weak self] audioTracks in
                LocalStorage.shared.localTracks = audioTracks
                self?.controller?.reloadData()
            }
        } else {
            FireBaseStorageService.getTracksWithOptionalArtist(
                artist: self.input?.artist
            ) { [weak self] audioTracks in
                LocalStorage.shared.localTracks = audioTracks.filter({ track in
                    track.name.lowercased().contains(text.lowercased())
                })
                self?.controller?.reloadData()
            }
        }
    }
}
