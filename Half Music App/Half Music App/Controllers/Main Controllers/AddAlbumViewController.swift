//
//  AddAlbumViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 18.10.22.
//

import UIKit

final class AddAlbumViewController: BaseViewController {

    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var albumNameLabel: UITextField!
    @IBOutlet private weak var albumTableView: UITableView!
    
    let ref = FireBaseStorageManager.albumsRef
    
    var choosedTracks: [TrackFB] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTableView.delegate = self
        albumTableView.dataSource = self
        
        albumTableView.register(
            UINib(nibName: SearchTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: SearchTableViewCell.identifier)
        
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
        choosedTracks.forEach { track in
            albumRef.child("\(track.name)").setValue(track.convertInDictionary())
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

extension AddAlbumViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LocalStorage.shared.localTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchTableViewCell.identifier
            ) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        let trackFB = LocalStorage.shared.localTracks[indexPath.row]
        cell.configure(model: trackFB)
        cell.accessoryType = .none
        
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
