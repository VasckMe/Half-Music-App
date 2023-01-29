//
//  AddTrackToAlbumPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 29.01.23.
//

import Foundation

protocol AddTrackToAlbumOutput {
    func addToLibrary()
    func closeAddTrackToAlbum()
}

struct AddTrackToAlbumInput {
    var track: TrackFB
}

protocol AddTrackToAlbumPresenterInterface {
    func didTriggerLoadView()
    func didTriggerSearchBar(text: String)
    
    func didTriggerCellAt(index: Int)
    
    func getAlbums() -> [AlbumFB]
}

final class AddTrackToAlbumPresenter {
    weak var controller: AddTrackToAlbumViewControllerInterface?
    
    private var input: AddTrackToAlbumInput
    private var output: AddTrackToAlbumOutput
    
    var albums: [AlbumFB] = []
    
    init(input: AddTrackToAlbumInput, output: AddTrackToAlbumOutput) {
        self.input = input
        self.output = output
    }
}

extension AddTrackToAlbumPresenter: AddTrackToAlbumPresenterInterface {
    func didTriggerLoadView() {
        fetchAlbums()
    }
    func didTriggerSearchBar(text: String) {
        if text.isEmpty {
            FireBaseStorageService.getAlbums {[weak self] albums in
                self?.albums = albums
                self?.controller?.reloadData()
            }
        } else {
            FireBaseStorageService.getAlbumsWithPredicade(predicate: text) {[weak self] albums in
                self?.albums = albums
                self?.controller?.reloadData()
            }
        }
    }
    
    func didTriggerCellAt(index: Int) {
        let album = albums[index]
        
        if album.tracks.contains(input.track) {
            controller?.callAlert(title: "Cancelled", message: "Track is already exist in that album")
            return
        } else {
            let ref = FireBaseStorageService.albumsRef.child(album.name).child(input.track.name)
            ref.setValue(input.track.convertInDictionary())
            FireBaseStorageService.saveTrackInDB(track: input.track)
            output.addToLibrary()
            output.closeAddTrackToAlbum()
        }
    }
    
    func getAlbums() -> [AlbumFB] {
        albums
    }
}

private extension AddTrackToAlbumPresenter {
    func fetchAlbums() {
        FireBaseStorageService.getAlbums {[weak self] albums in
            self?.albums = albums
            self?.controller?.reloadData()
        }
    }
}
