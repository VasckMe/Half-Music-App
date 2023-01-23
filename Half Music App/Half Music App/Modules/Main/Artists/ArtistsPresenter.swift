//
//  ArtistsPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import Foundation

protocol ArtistsPresenterInterface {
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerCell(atIndex: Int)
}

final class ArtistsPresenter {
    weak var controller: ArtistsTableViewControllerInterface?
    
    private var router: ArtistsRouterInterface?
    
    init(router: ArtistsRouterInterface) {
        self.router = router
    }
}

extension ArtistsPresenter: ArtistsPresenterInterface {
    func didTriggerViewAppear() {
        fetchArtists()
    }
    
    func didTriggerViewDisappear() {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    func didTriggerCell(atIndex: Int) {
        controller?.filterArtists(index: atIndex)
        router?.showSongsViewController(artist: atIndex)
    }
}

private extension ArtistsPresenter {
    func fetchArtists() {
        FireBaseStorageService.addAudioObserver { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            self?.findArtists()
        }
    }
    
    func findArtists() {
        let array = LocalStorage.shared.localTracks
        
        var artists = [String]()
        
        for track in array {
            if !artists.contains(track.artist ?? "artist") {
                artists.append(track.artist ?? "artist")
            } else {
                continue
            }
        }
        controller?.updateArtists(with: artists)
    }
}
