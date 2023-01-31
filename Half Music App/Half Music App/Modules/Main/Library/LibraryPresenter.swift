//
//  LibraryPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

protocol LibraryPresenterInterface {
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerCollectionViewCellAt(index: Int)
    func didTriggerTableViewCell(category: Category)
}

final class LibraryPresenter {
    weak var controller: LibraryViewControllerInterface?
    
    private var router: LibraryRouterInterface?
    
    init(router: LibraryRouterInterface) {
        self.router = router
    }
}

// MARK: - LibraryPresenterInterface

extension LibraryPresenter: LibraryPresenterInterface {
    func didTriggerViewAppear() {
        addAudioObserver()
        controller?.hideNavigationBar()
    }

    func didTriggerViewDisappear() {
        removeAudioObserver()
//        controller?.showNavigationBar()
    }

    func didTriggerTableViewCell(category: Category) {
        showCategory(category: category)
    }
    
    func didTriggerCollectionViewCellAt(index: Int) {
        LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
        
        let input = DetailTrackInput(trackIndex: index, isOpenInBackground: false)
        router?.showDetailTrackViewController(input: input)
    }
}

// MARK: - Privat

private extension LibraryPresenter {
    func addAudioObserver() {
        FireBaseStorageService.addAudioObserver { [weak self] tracksFB in
            guard let self = self else {
                return
            }
            
            LocalStorage.shared.localTracks = tracksFB
            self.controller?.reloadCollectionData()
        }
    }
    
    func removeAudioObserver() {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    func showCategory(category: Category) {
        switch category {
        case .artists:
            router?.showArtistsViewController()
        case .albums:
            router?.showAlbumsViewController()
        case .songs:
            router?.showSongsViewController()
        }
    }
}
