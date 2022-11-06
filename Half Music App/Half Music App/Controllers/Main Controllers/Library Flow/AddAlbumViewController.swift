//
//  AddAlbumViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 18.10.22.
//

import UIKit
import FirebaseDatabase

final class AddAlbumViewController: BaseViewController {

    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var albumNameLabel: UITextField!
    @IBOutlet private weak var albumTableView: UITableView!
    
    let ref = FireBaseStorageManager.albumsRef
    var detailAlbum: AlbumFB?
    var delegate: UpdateDetailAlbumViewController?
    
    var choosedTracks: [TrackFB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTableView.delegate = self
        albumTableView.dataSource = self
        
        albumTableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        FireBaseStorageManager.audioRef.observe(.value) { [weak self] snapshot in
            var tracks = [TrackFB]()
            
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let track = TrackFB(snapshot: snapshot) else { continue }
                tracks.append(track)
            }
            LocalStorage.shared.localTracks = tracks
            LocalStorage.shared.copyLocalTracks = tracks
            
            self?.albumTableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FireBaseStorageManager.audioRef.removeAllObservers()
    }
    
    @IBAction private func saveAlbumAction(_ sender: UIBarButtonItem) {
        guard
            let text = albumNameLabel.text,
            !text.isEmpty
        else {
            callDefaultAlert(title: "Bad title", message: "Change album title")
            return
        }
        
        let album = AlbumFB(name: text, tracks: choosedTracks)

        let albumRef = ref.child("\(album.name)")
        
        if let detailAlbum = detailAlbum {
            ref.child(detailAlbum.name).removeValue()
            delegate?.update(album: album)
        }
    
        choosedTracks.forEach { track in
            albumRef.child("\(track.name)").setValue(track.convertInDictionary())
        }
        
        navigationController?.popViewController(animated: true)
    }
    private func setup() {
        if let album = detailAlbum {
            albumNameLabel.text = album.name
            choosedTracks = album.tracks
        }
    }

}

extension AddAlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LocalStorage.shared.localTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackTableViewCell.identifier
            ) as? TrackTableViewCell else {
            return UITableViewCell()
        }
        let trackFB = LocalStorage.shared.localTracks[indexPath.row]
        cell.configure(model: trackFB)
        cell.accessoryType = choosedTracks.contains(trackFB) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        let trackFB = LocalStorage.shared.localTracks[indexPath.row]
        
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
            choosedTracks.append(trackFB)
        } else if cell?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            cell?.accessoryType = .none
            let index = choosedTracks.firstIndex { track in
                track == trackFB
            }
            choosedTracks.remove(at: index!)
        }
    }
}