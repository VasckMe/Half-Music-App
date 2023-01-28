//
//  EditAlbumPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 26.01.23.
//

import Foundation

protocol EditAlbumOutput: AddAlbumOutput {
    func update(with album: AlbumFB)
    func didTriggerCloseAddAlbumViewController()
}

struct EditAlbumInput {
    var detailAlbum: AlbumFB?
}

final class EditAlbumPresenter {
    weak var controller: AddAlbumViewControllerInterface?
    
    private var router: AddAlbumRouterInterface?
    private var input: EditAlbumInput
    private var output: EditAlbumOutput
    
    var choosedTracks: [TrackFB] = []
    
    init(input: EditAlbumInput, output: EditAlbumOutput, router: AddAlbumRouterInterface) {
        self.input = input
        self.output = output
        self.router = router
    }
}

//MARK: - AddAlbumPresenterInterface

extension EditAlbumPresenter: AddAlbumPresenterInterface {
    func didTriggerViewLoad() {
        guard let album = input.detailAlbum else {
            return
        }
        
        FireBaseStorageService.addAudioObserver { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            self?.controller?.reloadData()
        }
        
        controller?.setNameLabel(with: album.name)
        choosedTracks = album.tracks
    }
    
    func didTriggerViewDisappear() {
        FireBaseStorageService.audioRef.removeAllObservers()

    }
    
    func didTriggerSaveButton(albumName: String?) {
            saveButtonAction(name: albumName)
            router?.closeAddAlbumController(output: output)
    }
    
    func addAudioToChoosed(audio: TrackFB) {
        choosedTracks.append(audio)
    }
    
    func removeAudioFromCHoosedAt(index: Int?) {
        guard let index = index else {
            return
        }
        
        choosedTracks.remove(at: index)
    }
    
    func getChoosedAudio() -> [TrackFB] {
        choosedTracks
    }
}

private extension EditAlbumPresenter {
    func saveButtonAction(name: String?) {
        guard
            let text = name,
            !text.isEmpty
        else {
            controller?.callAlert()
            return
        }
        
        let album = AlbumFB(name: text, tracks: choosedTracks)

        let albumRef = FireBaseStorageService.albumsRef.child("\(album.name)")
        
        if let detailAlbum = input.detailAlbum {
            FireBaseStorageService.albumsRef.child(detailAlbum.name).removeValue()
            output.update(with: album)
        }
    
        choosedTracks.forEach { track in
            albumRef.child("\(track.name)").setValue(track.convertInDictionary())
        }
    }
}
