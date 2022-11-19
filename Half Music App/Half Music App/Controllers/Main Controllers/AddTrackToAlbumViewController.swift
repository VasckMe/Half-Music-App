//
//  AddTrackToAlbumViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.11.22.
//

import UIKit
import FirebaseDatabase

final class AddTrackToAlbumViewController: BaseViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.searchTextField.textColor = .white
        }
    }
    @IBOutlet private weak var albumCollectionView: UICollectionView!
    
    // MARK: - Properties
    
    var track: TrackFB?
    var albums: [AlbumFB] = []
    let ref = FireBaseStorageService.albumsRef
    var delegate: UpdateDetailTrackViewControllerProtocol?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adding track to ..."
        searchBar.delegate = self
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(
            UINib(nibName: LargeCollectionViewCell.identifier,bundle: nil),
            forCellWithReuseIdentifier: LargeCollectionViewCell.identifier
        )
        FireBaseStorageService.getAlbums {[weak self] albums in
            self?.albums = albums
            self?.albumCollectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource

extension AddTrackToAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
}

// MARK: - UICollectionViewDelegate

extension AddTrackToAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let track = track else { return }
        let album = albums[indexPath.row]
        
        if album.tracks.contains(track) {
            callDefaultAlert(title: "Cancelled", message: "Track is already exist in that album")
            return
        } else {
            let ref = FireBaseStorageService.albumsRef.child(album.name).child(track.name)
            ref.setValue(track.convertInDictionary())
            FireBaseStorageService.saveTrackInDB(track: track)
            delegate?.updateDetailTrack()
            self.dismiss(animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddTrackToAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        return CGSize(width: 170, height: 210)
    }
}

// MARK: - UISearchBarDelegate

extension AddTrackToAlbumViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            FireBaseStorageService.getAlbums {[weak self] albums in
                self?.albums = albums
                self?.albumCollectionView.reloadData()
            }
        } else {
            FireBaseStorageService.getAlbumsWithPredicade(predicate: searchText) {[weak self] albums in
                self?.albums = albums
                self?.albumCollectionView.reloadData()
            }
        }
    }
}
