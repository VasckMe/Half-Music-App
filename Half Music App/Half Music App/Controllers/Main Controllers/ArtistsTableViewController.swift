//
//  ArtistsTableViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import UIKit

class ArtistsTableViewController: UITableViewController {
    
    var artists: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(
            UINib(nibName: ArtistTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: ArtistTableViewCell.identifier
        )
        findArtists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LocalStorage.shared.refreshLocalTracks()
    }
    
    private func findArtists() {
        let array = LocalStorage.shared.localTracks
        
        for track in array {
            if !artists.contains(track.artist) {
                artists.append(track.artist)
            } else {
                continue
            }
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ArtistTableViewCell.identifier, for: indexPath
            ) as? ArtistTableViewCell else {
            return UITableViewCell()
        }

        cell.refresh(model: artists[indexPath.row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        LocalStorage.shared.localTracks = LocalStorage.shared.localTracks.filter { track in
            track.artist == artists[indexPath.row]
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if
            let vc = storyboard.instantiateViewController(
                withIdentifier: "SongsTVC"
            ) as? SongsTableViewController
        {
            navigationController?.pushViewController(vc, animated: true)
        }
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
