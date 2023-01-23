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
    
    func getArtistsArray() -> [String]
}

final class ArtistsPresenter {
    weak var controller: ArtistsTableViewControllerInterface?
    
    private var router: ArtistsRouterInterface?
    
    var artists: [String] = []
    
    init(router: ArtistsRouterInterface) {
        self.router = router
    }
}

extension ArtistsPresenter: ArtistsPresenterInterface {
    func didTriggerViewAppear() {
        fetchArtists()
        controller?.showNavigationBar()
    }
    
    func didTriggerViewDisappear() {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    func didTriggerCell(atIndex: Int) {
        filterArtists(index: atIndex)
        showController(artistIndex: atIndex)
    }
    
    func getArtistsArray() -> [String] {
        artists
    }
}

private extension ArtistsPresenter {
    func fetchArtists() {
        FireBaseStorageService.addAudioObserver { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            self?.findArtists()
        }
    }
    
    func filterArtists(index: Int) {
        LocalStorage.shared.localTracks = LocalStorage.shared.localTracks.filter { track in
            track.artist == artists[index]
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
        self.artists = artists
        controller?.reloadData()
    }
    
    func showController(artistIndex: Int) {
        let input = SongsInput(artist: artists[artistIndex])
        router?.showSongsViewController(input: input)
    }
}
