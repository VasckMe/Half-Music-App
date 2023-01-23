//
//  SearchPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 7.01.23.
//

import Foundation


protocol SearchPresenterInterface {
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    func fetchMusic()
    func fetchMusicWithFilter(filter: String?)
}

final class SearchPresenter {
    weak var controller: SearchViewControllerInterface?
    let dataFetcher: DataFetcherServiceProtocol = DataFetcherService()
    
    private var router: SearchRouterInterface?
    
    init(router: SearchRouterInterface) {
        self.router = router
    }
}

extension SearchPresenter: SearchPresenterInterface {
    func didTriggerViewAppear() {
        controller?.hideNavigationBar()
        fetchMusic()
    }
    
    func didTriggerViewDisappear() {
//        controller?.showNavigationBar()

    }
    
    func fetchMusic() {
        dataFetcher.fetchFreeMusic { [weak self] audio in
            guard let tracks = audio?.items else { return }
            LocalStorage.shared.convertToNewModelArray(itemArray: tracks)
            self?.controller?.reloadTableView()
        }
    }
    
    func fetchMusicWithFilter(filter: String?) {
        dataFetcher.fetchFreeMusic { [weak self] audio in
            guard let tracks = audio?.items else { return }
            LocalStorage.shared.convertToNewModelArray(itemArray: tracks)
            LocalStorage.shared.localTracks = LocalStorage.shared.localTracks.filter { trackFB in
                trackFB.name.lowercased().contains(filter?.lowercased() ?? "")
            }
            self?.controller?.reloadTableView()
        }
    }
}
