//
//  ArtistsTableViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import UIKit
import FirebaseDatabase

final class ArtistsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var artists: [String] = []
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(
            UINib(nibName: SmallTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: SmallTableViewCell.identifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FireBaseStorageService.addAudioObserver { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            self?.findArtists()

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FireBaseStorageService.audioRef.removeAllObservers()
    }
    
    // MARK: - Private
    
    private func findArtists() {
        let array = LocalStorage.shared.localTracks
        
        var artists = [String]()
        
        for track in array {
            if !artists.contains(track.artist) {
                artists.append(track.artist)
            } else {
                continue
            }
        }
        self.artists = artists
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SmallTableViewCell.identifier, for: indexPath
            ) as? SmallTableViewCell else {
            return UITableViewCell()
        }

        cell.configureArtist(artist: artists[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LocalStorage.shared.localTracks = LocalStorage.shared.localTracks.filter { track in
            track.artist == artists[indexPath.row]
        }
        
        let storyboard = UIStoryboard(name: "Library", bundle: nil)
        if
            let vc = storyboard.instantiateViewController(
                withIdentifier: "SongsTVC"
            ) as? SongsTableViewController
        {
            vc.artist = artists[indexPath.row]
            vc.title = artists[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
