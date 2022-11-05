//
//  AlbumsCollectionViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import UIKit
import FirebaseDatabase

final class AlbumsCollectionViewController: UICollectionViewController {

    var albums: [AlbumFB] = []
    let ref = FireBaseStorageManager.albumsRef
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.clearsSelectionOnViewWillAppear = false
//         self.navigationItem.rightBarButtonItem = self.editButtonItem

        collectionView.register(
            UINib(nibName: LargeCollectionViewCell.identifier,bundle: nil),
            forCellWithReuseIdentifier: LargeCollectionViewCell.identifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref.observe(.value) { [weak self] snapshot in
            var albms: [AlbumFB] = []
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let album = AlbumFB(snapshot: snapshot) else { continue }
                albms.append(album)
            }
            self?.albums = albms
            self?.collectionView.reloadData()
        }
        FireBaseStorageManager.audioRef.observe(.value) { [weak self] snapshot in
            var tracks = [TrackFB]()
            
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let track = TrackFB(snapshot: snapshot) else { continue }
                tracks.append(track)
            }
            LocalStorage.shared.localTracks = tracks
            LocalStorage.shared.copyLocalTracks = tracks
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
        FireBaseStorageManager.audioRef.removeAllObservers()
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = albums[indexPath.row]
        LocalStorage.shared.localTracks = album.tracks
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if
            let vc = storyboard.instantiateViewController(
                withIdentifier: "DetailAlbumVC"
            ) as? DetailAlbumViewController
        {
            vc.album = album
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension AlbumsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        return CGSize(width: 170, height: 190)
    }
}
