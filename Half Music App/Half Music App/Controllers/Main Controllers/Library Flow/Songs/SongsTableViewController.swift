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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        FireBaseStorageService.audioRef.observe(.value) { [weak self] snapshot in
            var tracks = [TrackFB]()

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

            LocalStorage.shared.localTracks = tracks

            self?.tableView.reloadData()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalStorage.shared.localTracks.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
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
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let audioTrack = LocalStorage.shared.localTracks[indexPath.row]
            FireBaseStorageService.audioRef.child(audioTrack.name).removeValue()
            LocalStorage.shared.localTracks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}
