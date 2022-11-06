//
//  DetailAlbumViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.10.22.
//

import UIKit
import FirebaseDatabase

protocol UpdateDetailAlbumViewController {
    func update(album: AlbumFB)
}

final class DetailAlbumViewController: UIViewController {

    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var albumTitleLabel: UILabel!
    @IBOutlet private weak var albumTracksTableView: UITableView!
    
    var album: AlbumFB?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTracksTableView.delegate = self
        albumTracksTableView.dataSource = self
        albumTracksTableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let album = album else { return }
        let ref = FireBaseStorageManager.albumsRef.child(album.name)
        ref.removeAllObservers()
    }
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEditAlbumVC") as? AddAlbumViewController
        vc?.detailAlbum = album
        vc?.delegate = self
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    private func setup() {
        albumImageView.image = UIImage(systemName: "music.note.list")
        albumTitleLabel.text = album?.name
        
        guard let album = album else { return }
        let ref = FireBaseStorageManager.albumsRef.child(album.name)
        
        FireBaseStorageManager.addAudioInAlbumObserver(albumName: album.name) { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            LocalStorage.shared.copyLocalTracks = tracksFB
            self?.albumTracksTableView.reloadData()
        }
    }
}

extension DetailAlbumViewController: UpdateDetailAlbumViewController {
    func update(album: AlbumFB) {
        self.album = album
        setup()
    }
}

extension DetailAlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LocalStorage.shared.localTracks.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackTableViewCell.identifier,
                for: indexPath
            ) as? TrackTableViewCell
        else {
            return UITableViewCell()
        }
        let track = LocalStorage.shared.localTracks[indexPath.row]
        cell.configure(model: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.deleteRows(at: [indexPath], with: .fade)
            let track = LocalStorage.shared.localTracks[indexPath.row]
            FireBaseStorageManager.albumsRef.child(album!.name).child(track.name).removeValue()
        } else if editingStyle == .insert {
        }
    }
}
