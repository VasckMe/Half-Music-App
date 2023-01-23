//
//  LibraryPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import Foundation

protocol LibraryPresenterInterface {
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerTableViewCell(category: Category)
}

final class LibraryPresenter {
    weak var controller: LibraryViewControllerInterface?
    
    private var router: LibraryRouterInterface?
    
    init(router: LibraryRouterInterface) {
        self.router = router
    }
}

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
}

private extension LibraryPresenter {
    func addAudioObserver() {
        FireBaseStorageService.addAudioObserver { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            self?.controller?.reloadCollectionData()
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
