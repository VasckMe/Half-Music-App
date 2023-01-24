//
//  AddAlbumViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 18.10.22.
//

import UIKit
import FirebaseDatabase

protocol AddAlbumViewControllerInterface: AnyObject {
    func reloadData()
    
    func callAlert()
    
    func setNameLabel(with: String)
}

final class AddAlbumViewController: BaseViewController {
    
    var presenter: AddAlbumPresenterInterface?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var albumImageView: UIImageView!
    @IBOutlet private weak var albumNameLabel: UITextField! {
        didSet {
            let redPlaceholderText = NSAttributedString(
                string: "Album Title",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
            )
                    
            albumNameLabel.attributedPlaceholder = redPlaceholderText
        }
    }
    @IBOutlet private weak var albumTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        albumTableView.delegate = self
        albumTableView.dataSource = self
        
        albumTableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier)
        presenter?.didTriggerViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.didTriggerViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.didTriggerViewDisappear()
    }
    // MARK: - IBActions
    @IBAction private func saveAlbumAction(_ sender: UIBarButtonItem) {
        presenter?.didTriggerSaveButton(albumName: albumNameLabel.text)
    }
}

// MARK: - UITableViewDataSource

extension AddAlbumViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        LocalStorage.shared.localTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TrackTableViewCell.identifier
            ) as? TrackTableViewCell,
            let choosedAudio = presenter?.getChoosedAudio()
        else {
            return UITableViewCell()
        }
        let trackFB = LocalStorage.shared.localTracks[indexPath.row]
        cell.configure(model: trackFB)
        cell.accessoryType = choosedAudio.contains(trackFB) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}

// MARK: - UITableViewDelegate

extension AddAlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let choosedAudio = presenter?.getChoosedAudio() else {
            return
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        let trackFB = LocalStorage.shared.localTracks[indexPath.row]
        
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
            presenter?.addAudioToChoosed(audio: trackFB)
        } else if cell?.accessoryType == UITableViewCell.AccessoryType.checkmark {
            cell?.accessoryType = .none
            let index = choosedAudio.firstIndex { track in
                track == trackFB
            }
            presenter?.removeAudioFromCHoosedAt(index: index)
        }
    }
}

// MARK: - AddAlbumViewControllerInterface

extension AddAlbumViewController: AddAlbumViewControllerInterface {
    func reloadData() {
        albumTableView.reloadData()
    }
    
    func callAlert() {
        callDefaultAlert(title: "Bad title", message: "Change album title")
    }
    
    func setNameLabel(with text: String) {
        albumNameLabel.text = text
    }
}
