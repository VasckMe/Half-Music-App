//
//  LibraryViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 8.10.22.
//

import UIKit
import FirebaseDatabase

final class LibraryViewController: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet weak var libraryTableView: UITableView!
    @IBOutlet weak var recentlyAddedCollectionView: UICollectionView!
    
    // MARK: Properties
    
    let ref = FireBaseStorageManager.audioRef
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.register(
            UINib(nibName: SmallTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: SmallTableViewCell.identifier
        )
        recentlyAddedCollectionView.register(
            UINib(nibName: "LargeCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: LargeCollectionViewCell.identifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref.observe(.value) { [weak self] snapshot in
            var tracks = [TrackFB]()
            
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let track = TrackFB(snapshot: snapshot) else { continue }
                tracks.append(track)
            }
            LocalStorage.shared.localTracks = tracks
            LocalStorage.shared.copyLocalTracks = tracks

            self?.recentlyAddedCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }
}

// MARK: - Extension UITableView

extension LibraryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LocalStorage.shared.library.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SmallTableViewCell.identifier
            ) as? SmallTableViewCell else {
            return UITableViewCell()
        }
        let category = LocalStorage.shared.library[indexPath.row]
        cell.configureCategory(category: category)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if LocalStorage.shared.library[indexPath.row] == "Songs" {
            performSegue(withIdentifier: "GoToSongsTVC", sender: nil)
        } else if LocalStorage.shared.library[indexPath.row] == "Artists"{
            performSegue(withIdentifier: "GoToArtistsTVC", sender: nil)
        } else if LocalStorage.shared.library[indexPath.row] == "Albums" {
            performSegue(withIdentifier: "GoToAlbumsCVC", sender: nil)
        }
    }
}

// MARK: - Extension UICollectionView

extension LibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        LocalStorage.shared.localTracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LargeCollectionViewCell.identifier,
                for: indexPath) as? LargeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let track = LocalStorage.shared.localTracks[indexPath.row]
        cell.configureTrack(track: track)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        return CGSize(width: 170, height: 190)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailTrack", bundle: nil)
        if
            let vc = storyboard.instantiateViewController(
                withIdentifier: "DetailTrackVC"
            ) as? DetailTrackViewController
        {
            vc.trackIndex = indexPath.row
            navigationController?.present(vc, animated: true)
        }
    }
}
