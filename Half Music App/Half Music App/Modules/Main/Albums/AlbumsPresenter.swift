//
//  AlbumsPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 24.01.23.
//

import Foundation

protocol AlbumsPresenterInterface {
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerAddButton()
    
    func didTriggerCellAt(index: Int)
    
    func getAlbums() -> [AlbumFB]
}

final class AlbumsPresenter {
    weak var controller: AlbumsCollectionViewControllerInterface?
    
    private var router: AlbumsRouterInterface?
    
    var albums: [AlbumFB] = []
    let ref = FireBaseStorageService.albumsRef
    
    init(router: AlbumsRouterInterface) {
        self.router = router
    }
}

// MARK: - AlbumsPresenterInterface

extension AlbumsPresenter: AlbumsPresenterInterface {
    func didTriggerViewAppear() {
        addObserverToFetchAlbums()
        addObserverToFetchTracks()
        controller?.showNavigationBar()
    }
    
    func didTriggerViewDisappear() {
        removeObserverToFetchAlbums()
        removeObserverToFetchTracks()
    }
    
    func didTriggerCellAt(index: Int) {
        goToDetailAlbumController(with: index)
    }
    
    func didTriggerAddButton() {
        router?.showAddNewAlbumController(output: self)
    }
    
    func getAlbums() -> [AlbumFB] {
        albums
    }
}

// MARK: - AddAlbumOutput

extension AlbumsPresenter: AddAlbumOutput {
    func didTriggerCloseAddAlbumViewController() {
        router?.closeAddNewAlbumController()
    }
}

// MARK: - Private

private extension AlbumsPresenter {
    func addObserverToFetchAlbums() {
        FireBaseStorageService.addAlbumsObserver { [weak self] albumsFB in
            self?.albums = albumsFB
            self?.controller?.reloadData()
        }
    }
    
    func addObserverToFetchTracks() {
        FireBaseStorageService.addAudioObserver { tracksFB in
            LocalStorage.shared.localTracks = tracksFB
        }
    }
    
    func removeObserverToFetchAlbums() {
        FireBaseStorageService.albumsRef.removeAllObservers()
    }
    
    func removeObserverToFetchTracks() {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    func goToDetailAlbumController(with index: Int) {
        let input = DetailAlbumInput(album: albums[index])
        LocalStorage.shared.localTracks = albums[index].tracks
        router?.showDetailAlbumController(input: input)
    }
}
