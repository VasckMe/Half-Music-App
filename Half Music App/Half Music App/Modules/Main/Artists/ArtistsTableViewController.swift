//
//  ArtistsTableViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import UIKit
import FirebaseDatabase

protocol ArtistsTableViewControllerInterface: AnyObject {
    func filterArtists(index: Int)
    func updateArtists(with artists: [String])
}

final class ArtistsTableViewController: UITableViewController {
    
    var presenter: ArtistsPresenterInterface?
        
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
        presenter?.didTriggerViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.didTriggerViewDisappear()
    }
}
// MARK: - Table view data source, delegate

extension ArtistsTableViewController {
    // Data source
    
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
    
    // Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTriggerCell(atIndex: indexPath.row)
    }
}

extension ArtistsTableViewController: ArtistsTableViewControllerInterface {
    func updateArtists(with artists: [String]) {
        self.artists = artists
        tableView.reloadData()
    }
    
    func filterArtists(index: Int) {
        LocalStorage.shared.localTracks = LocalStorage.shared.localTracks.filter { track in
            track.artist == artists[index]
        }
    }
}
