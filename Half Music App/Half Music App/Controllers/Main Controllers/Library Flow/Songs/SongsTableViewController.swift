//
//  SongsTableViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 12.10.22.
//

import UIKit
import FirebaseDatabase

final class SongsTableViewController: UITableViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.searchTextField.textColor = .white
        }
    }
    
    // MARK: - Properties
    
    var artist: String?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier
        )
    }

    override func viewWillAppear(_ animated: Bool) {
        addObserverToFetchTracks()
    }

    override func viewWillDisappear(_ animated: Bool) {
        removeObserverToFetchTracks()
    }
}

// MARK: - UISearchBarDelegate

extension SongsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            FireBaseStorageService.getTracksWithOptionalArtist(
                artist: self.artist
            ) { [weak self] audioTracks in
                LocalStorage.shared.localTracks = audioTracks
                self?.tableView.reloadData()
            }
        } else {
            FireBaseStorageService.getTracksWithOptionalArtist(
                artist: self.artist
            ) { [weak self] audioTracks in
                LocalStorage.shared.localTracks = audioTracks.filter({ track in
                    track.name.lowercased().contains(searchText.lowercased())
                })
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - Extension Logic

extension SongsTableViewController {
    
    // MARK: - Private
    
    private func addObserverToFetchTracks() {
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
    
    private func removeObserverToFetchTracks() {
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
        guard let vc = DetailTrackViewController.storyboardInstance() else {
            return
        }
        LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
        vc.trackIndex = indexPath.row
        navigationController?.present(vc, animated: true)
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
