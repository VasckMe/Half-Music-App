//
//  AddAlbumPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

protocol AddAlbumOutput: AnyObject {
    func didTriggerCloseAddAlbumViewController()
}

protocol AddAlbumPresenterInterface {
    func didTriggerViewLoad()
    func didTriggerViewDisappear()
    
    func didTriggerSaveButton(albumName: String?)
    
    func addAudioToChoosed(audio: TrackFB)
    func removeAudioFromCHoosedAt(index: Int?)
    func getChoosedAudio() -> [TrackFB]
}

final class AddAlbumPresenter {
    weak var controller: AddAlbumViewControllerInterface?
    
    private var router: AddAlbumRouterInterface?
    private weak var output: AddAlbumOutput?
    
    var choosedTracks: [TrackFB] = []
    
    init(output: AddAlbumOutput, router: AddAlbumRouterInterface) {
        self.output = output
        self.router = router
    }
}

//MARK: - AddAlbumPresenterInterface

extension AddAlbumPresenter: AddAlbumPresenterInterface {
    func didTriggerViewLoad() {
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

// MARK: - Private

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
    
        choosedTracks.forEach { track in
            albumRef.child("\(track.name)").setValue(track.convertInDictionary())
        }
    }
}
