//
//  AlbumsCollectionViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import UIKit
import FirebaseDatabase

final class AlbumsCollectionViewController: UICollectionViewController {
    
    // MARK: Properties
    
    var albums: [AlbumFB] = []
    let ref = FireBaseStorageService.albumsRef
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            UINib(nibName: LargeCollectionViewCell.identifier,bundle: nil),
            forCellWithReuseIdentifier: LargeCollectionViewCell.identifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addObserverToFetchAlbums()
        addObserverToFetchTracks()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserverToFetchAlbums()
        removeObserverToFetchTracks()
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        return CGSize(width: 170, height: 210)
    }
}

// MARK: - Extension Logic

extension AlbumsCollectionViewController {
    
    // MARK: - Private
    
    private func addObserverToFetchAlbums() {
        FireBaseStorageService.addAlbumsObserver { [weak self] albumsFB in
            self?.albums = albumsFB
            self?.collectionView.reloadData()
        }
    }

    private func addObserverToFetchTracks() {
        FireBaseStorageService.addAudioObserver { tracksFB in
            LocalStorage.shared.localTracks = tracksFB
        }
    }
    
    private func removeObserverToFetchAlbums() {
        FireBaseStorageService.albumsRef.removeAllObservers()
    }
    
    private func removeObserverToFetchTracks() {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    // MARK: - CollectionView Data Source

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return albums.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LargeCollectionViewCell.identifier,
                for: indexPath
            ) as? LargeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let album = albums[indexPath.row]
        cell.configureAlbum(album: album)
    
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        LocalStorage.shared.localTracks = album.tracks
        let storyboard = UIStoryboard(name: "Library", bundle: nil)
        if
            let vc = storyboard.instantiateViewController(
                withIdentifier: "DetailAlbumVC"
            ) as? DetailAlbumViewController
        {
            vc.album = album
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
