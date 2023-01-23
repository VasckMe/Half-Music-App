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

    // MARK: - IBOutlets
    
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var albumTitleLabel: UILabel!
    @IBOutlet private weak var albumTracksTableView: UITableView!
    
    // MARK: - Properties
    
    var album: AlbumFB?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeObserverToFetchTracks()
    }
    
    // MARK: - IBActions
    
    @IBAction private func editAction(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "LibraryViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddEditAlbumVC") as? AddAlbumViewController
        vc?.detailAlbum = album
        vc?.delegate = self
        navigationController?.pushViewController(vc!, animated: true)
    }
}

// MARK: - UpdateDetailAlbumViewController

extension DetailAlbumViewController: UpdateDetailAlbumViewController {
    func update(album: AlbumFB) {
        self.album = album
        setup()
    }
}
// MARK: - UITableViewDataSource

extension DetailAlbumViewController: UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let track = LocalStorage.shared.localTracks[indexPath.row]
            FireBaseStorageService.albumsRef.child(album!.name).child(track.name ?? "track-name").removeValue()
            LocalStorage.shared.localTracks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
// MARK: - UITableViewDelegate
extension DetailAlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = DetailTrackViewController.storyboardInstance() else {
            return
        }
        LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
        vc.trackIndex = indexPath.row
        navigationController?.present(vc, animated: true)
    }
}

// MARK: - Extension DetailAlbumViewController

extension DetailAlbumViewController {
    
    // MARK: - Private
    
    private func setup() {
        albumImageView.image = UIImage(systemName: "music.note.list")
        albumTitleLabel.text = album?.name
    }
    
    private func addObserverToFetchTracks() {
        guard let album = album else { return }
        FireBaseStorageService.addAudioInAlbumObserver(albumName: album.name) { [weak self] tracksFB in
            LocalStorage.shared.localTracks = tracksFB
            self?.albumTracksTableView.reloadData()
        }
    }
    
    private func removeObserverToFetchTracks() {
        guard let album = album else { return }
        let ref = FireBaseStorageService.albumsRef.child(album.name)
        ref.removeAllObservers()
    }
    
    private func signTableView() {
        albumTracksTableView.delegate = self
        albumTracksTableView.dataSource = self
        albumTracksTableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier
        )
    }
}
