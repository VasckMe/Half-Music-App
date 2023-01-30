//
//  SongsPresenter.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 23.01.23.
//

import FirebaseDatabase

protocol SongsPresenterInterface {
    func didTriggerViewLoad()
    func didTriggerViewAppear()
    func didTriggerViewDisappear()
    
    func didTriggerSearchBar(text: String)
    
    func didTriggerTableViewCellAt(index: Int)
    func didTriggerRemoveCellAt(index: Int)
}

struct SongsModuleInput {
    var artist: String
}

final class SongsPresenter {
    weak var controller: SongsTableViewControllerInterface?
    
    private var input: SongsModuleInput?
    private var router: SongsRouterInterface?
    
    init(input: SongsModuleInput?, router: SongsRouterInterface) {
        self.input = input
        self.router = router
    }
}

extension SongsPresenter: SongsPresenterInterface {
    func didTriggerViewLoad() {
        controller?.setTitle(with: input?.artist)
    }
    
    func didTriggerViewAppear() {
        addObserverToFetchSongs()
        controller?.showNavigationBar()
    }
    
    func didTriggerViewDisappear() {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    func didTriggerSearchBar(text: String) {
        fetchTracks(with: text)
    }
    
    func didTriggerTableViewCellAt(index: Int) {
        LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
        let input = DetailTrackInput(trackIndex: index, isOpenInBackground: false)
        router?.showDetailTrack(input: input)
    }
    
    func didTriggerRemoveCellAt(index: Int) {
        let track = LocalStorage.shared.localTracks[index]
        FireBaseStorageService.audioRef.child(track.name).removeValue()
    }
}

private extension SongsPresenter {
    func addObserverToFetchSongs() {
        FireBaseStorageService.addAudioObserver(of: input?.artist) { [weak self] tracks in
            guard let self = self else {
                return
            }
            
            LocalStorage.shared.localTracks = tracks
            self.controller?.reloadData()
        }
    }
    
    func fetchTracks(with text: String) {
        if text.isEmpty {
            FireBaseStorageService.getTracks(of: self.input?.artist) { [weak self] tracks in
                guard let self = self else {
                    return
                }
                
                LocalStorage.shared.localTracks = tracks
                self.controller?.reloadData()
            }
        } else {
            FireBaseStorageService.getTracks(of: self.input?.artist) { [weak self] tracks in
                guard let self = self else {
                    return
                }
                
                LocalStorage.shared.localTracks = tracks.filter{ track in
                    track.name.lowercased().contains(text.lowercased())
                }
                
                self.controller?.reloadData()
            }
        }
    }
}
