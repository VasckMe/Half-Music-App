//
//  SongsTableViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 12.10.22.
//

import UIKit
import FirebaseDatabase

final class SongsTableViewController: UITableViewController {

    var artist: String?
    var album: AlbumFB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier
        )
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        FireBaseStorageManager.audioRef.observe(.value) { [weak self] snapshot in
            var tracks = [TrackFB]()
            
            if let album = self?.album {
                tracks = album.tracks
            } else {
                for item in snapshot.children {
                    guard let snapshot = item as? DataSnapshot,
                          let track = TrackFB(snapshot: snapshot) else { continue }
                    if let artist = self?.artist {
                        if artist == track.artist {
                            tracks.append(track)
                        } else {
                            continue
                        }
                    } else {
                        tracks.append(track)
                    }
                }
            }
            
            LocalStorage.shared.localTracks = tracks

            self?.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FireBaseStorageManager.audioRef.removeAllObservers()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalStorage.shared.localTracks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackTableViewCell.identifier,
                for: indexPath) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        let track = LocalStorage.shared.localTracks[indexPath.row]
        cell.configure(model: track)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailTrack", bundle: nil)
        if
            let vc = storyboard.instantiateViewController(
                withIdentifier: "DetailTrackVC"
            ) as? DetailTrackViewController
        {
            LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
            vc.trackIndex = indexPath.row
            navigationController?.present(vc, animated: true)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}
