//
//  LibraryViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 8.10.22.
//

import UIKit
import FirebaseDatabase

class LibraryViewController: UIViewController {

    @IBOutlet weak var libraryTableView: UITableView!
    @IBOutlet weak var recentlyAddedCollectionView: UICollectionView!
    
    let ref = FireBaseStorageManager.audioRef
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.register(
            UINib(nibName: LibraryTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: LibraryTableViewCell.identifier
        )
        recentlyAddedCollectionView.register(UINib(nibName: "RecenltyAddedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RecenltyAddedCollectionViewCell.identifier)
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
            self?.recentlyAddedCollectionView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LibraryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LocalStorage.shared.library.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LibraryTableViewCell.identifier
            ) as? LibraryTableViewCell else {
            return UITableViewCell()
        }
        let category = LocalStorage.shared.library[indexPath.row]
        cell.refresh(category: category)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}

extension LibraryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        LocalStorage.shared.localTracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecenltyAddedCollectionViewCell.identifier,
                for: indexPath) as? RecenltyAddedCollectionViewCell else {
            return UICollectionViewCell()
        }
        let track = LocalStorage.shared.localTracks[indexPath.row]
        cell.refresh(track: track)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        return CGSize(width: 170, height: 190)
    }
}
