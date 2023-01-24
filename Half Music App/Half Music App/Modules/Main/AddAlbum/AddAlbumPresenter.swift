//
//  AddAlbumPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

import Foundation

protocol AddAlbumOutput {
    func didTriggerCloseAddAlbumViewController()
}

struct AddAlbumInput {
    var delegate: UpdateDetailAlbumViewController?
}

protocol AddAlbumPresenterInterface {
    func didTriggerViewLoad()
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerSaveButton(albumName: String?)
    
    func addAudioToChoosed(audio: TrackFB)
    func removeAudioFromCHoosedAt(index: Int?)
    func getChoosedAudio() -> [TrackFB]
}

final class AddAlbumPresenter {
    weak var controller: AddAlbumViewControllerInterface?
    
    private var router: AddAlbumRouterInterface?
    private var input: AddAlbumInput?
    private var output: AddAlbumOutput
    
    var detailAlbum: AlbumFB?
    var choosedTracks: [TrackFB] = []
    
    init(input: AddAlbumInput?, output: AddAlbumOutput, router: AddAlbumRouterInterface) {
        self.input = input
        self.output = output
        self.router = router
    }
}

extension AddAlbumPresenter: AddAlbumPresenterInterface {
    func didTriggerViewLoad() {
        guard let album = detailAlbum else {
            return
        }
        controller?.setNameLabel(with: album.name)
        choosedTracks = album.tracks
    }
    
    func didTriggerViewAppear() {
        FireBaseStorageService.addAudioObserver { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            self?.controller?.reloadData()
        }
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

private extension AddAlbumPresenter {
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
        
        if let detailAlbum = detailAlbum {
            FireBaseStorageService.albumsRef.child(detailAlbum.name).removeValue()
            input?.delegate?.update(album: album)
        }
    
        choosedTracks.forEach { track in
            albumRef.child("\(track.name)").setValue(track.convertInDictionary())
        }
    }
}
