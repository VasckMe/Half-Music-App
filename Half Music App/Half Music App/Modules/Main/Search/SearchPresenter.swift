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
    
    func didTriggerSearchBar(text: String)
    
    func didTriggerTableViewCellAt(index: Int)
}

final class SearchPresenter {
    weak var controller: SearchViewControllerInterface?
    
    private var router: SearchRouterInterface?
    
    let dataFetcher: DataFetcherServiceProtocol = DataFetcherService()
    
    init(router: SearchRouterInterface) {
        self.router = router
    }
}

// MARK: - SearchPresenterInterface

extension SearchPresenter: SearchPresenterInterface {
    func didTriggerViewAppear() {
        controller?.hideNavigationBar()
        fetchMusic()
    }
    
    func didTriggerViewDisappear() {
//        controller?.showNavigationBar()
    }
    
    func didTriggerSearchBar(text: String) {
        fetchMusic(with: text)
    }
    
    func didTriggerTableViewCellAt(index: Int) {
        LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
        let input = DetailTrackInput(trackIndex: index, isOpenInBackground: false)
        router?.showDetailTrack(input: input)
    }
}

// MARK: - Private

private extension SearchPresenter {
    func fetchMusic(with filter: String = "") {
        filter.isEmpty
            ? fetchMusicWithouFilter()
            : fetchMusicWithFilter(filter: filter)
    }
    
    func fetchMusicWithouFilter() {
        DispatchQueue.global(qos: .utility).async {
            self.dataFetcher.fetchFreeMusic { [weak self] audio in
                guard
                    let self = self,
                    let tracks = audio?.items
                else {
                    return
                }
                DispatchQueue.main.async {
                    LocalStorage.shared.convertToNewModelArray(itemArray: tracks)
                    self.controller?.reloadTableView()
                }
            }
        }
    }
    
    func fetchMusicWithFilter(filter: String?) {
        DispatchQueue.global(qos: .utility).async {
            self.dataFetcher.fetchFreeMusic { [weak self] audio in
                guard
                    let self = self,
                    let tracks = audio?.items
                else {
                    return
                }
                
                DispatchQueue.main.async {
                    LocalStorage.shared.convertToNewModelArray(itemArray: tracks)
                    LocalStorage.shared.localTracks = LocalStorage.shared.localTracks.filter { trackFB in
                        trackFB.name.lowercased().contains(filter?.lowercased() ?? "")
                    }
                    self.controller?.reloadTableView()
                }
            }
        }
    }
}
