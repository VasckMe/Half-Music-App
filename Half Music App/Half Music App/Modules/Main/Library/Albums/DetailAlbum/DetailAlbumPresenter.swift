//
//  DetailAlbumPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 26.01.23.
//

import Foundation

struct DetailAlbumInput {
    var album: AlbumFB?
}

protocol DetailAlbumPresenterInterface {
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerEditAction()
    
    func didTriggerRemoveCellAt(index: Int)
    func didTriggerCellAt(index: Int)
}

final class DetailAlbumPresenter {
    weak var controller: DetailAlbumViewControllerInterface?
    
    private var input: DetailAlbumInput?
    private var router: DetailAlbumRouterInterface?
        
    init(input: DetailAlbumInput, router: DetailAlbumRouterInterface) {
        self.input = input
        self.router = router
    }
}

//MARK: - DetailAlbumPresenterInterface

extension DetailAlbumPresenter: DetailAlbumPresenterInterface {
    func didTriggerViewAppear() {
        controller?.setAlbumTitle(text: input?.album?.name)
        addObserverToFetchTracks()
    }
    
    func didTriggerViewDisappear() {
        removeObserverToFetchTracks()
    }
    
    func didTriggerEditAction() {
        let input = EditAlbumInput(detailAlbum: input?.album)
        router?.showEditAlbumViewController(input: input, output: self)
    }
    
    func didTriggerCellAt(index: Int) {
        router?.showDetailTrackViewController(index: index)
    }
    
    func didTriggerRemoveCellAt(index: Int) {
        guard
            let albumName = input?.album?.name
        else {
            return
        }
        FireBaseStorageService.albumsRef.child(albumName).child(LocalStorage.shared.localTracks[index].name).removeValue()
        LocalStorage.shared.localTracks.remove(at: index)
        controller?.deleteRowAt(index: index)
    }
}

//MARK: - EditAlbumOutput

extension DetailAlbumPresenter: EditAlbumOutput {
    func update(with album: AlbumFB) {
        controller?.setAlbumTitle(text: album.name)
    }
    
    func didTriggerCloseAddAlbumViewController() {
        router?.closeEditAlbumViewController()
    }
}

private extension DetailAlbumPresenter {
    func removeObserverToFetchTracks() {
        guard let album = input?.album else { return }
        let ref = FireBaseStorageService.albumsRef.child(album.name)
        ref.removeAllObservers()
    }
    
    private func addObserverToFetchTracks() {
        guard let album = input?.album else { return }
        FireBaseStorageService.addAudioInAlbumObserver(albumName: album.name) { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            self?.controller?.reloadData()
        }
    }
}
