//
//  DetailAlbumViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 30.10.22.
//

import UIKit
import FirebaseDatabase

protocol DetailAlbumViewControllerInterface: AnyObject {
    func setAlbumTitle(text: String?)
    
    func deleteRowAt(index: Int)
    func reloadData()
}

final class DetailAlbumViewController: UIViewController {
    var presenter: DetailAlbumPresenterInterface?

    @IBOutlet private weak var albumImageView: UIImageView! {
        didSet {
            albumImageView.image = UIImage(systemName: "music.note.list")
        }
    }
    
    @IBOutlet private weak var albumTitleLabel: UILabel!
    @IBOutlet private weak var albumTracksTableView: UITableView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.didTriggerViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.didTriggerViewDisappear()
    }
    
    // MARK: - IBActions
    
    @IBAction private func editAction(_ sender: UIBarButtonItem) {
        presenter?.didTriggerEditAction()
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
            presenter?.didTriggerRemoveCellAt(index: indexPath.row)
        }
    }
}
// MARK: - UITableViewDelegate

extension DetailAlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTriggerCellAt(index: indexPath.row)
    }
}

// MARK: - DetailAlbumViewControllerInterface

extension DetailAlbumViewController: DetailAlbumViewControllerInterface {
    func setAlbumTitle(text: String?) {
        albumTitleLabel.text = text
    }
    
    func reloadData() {
        albumTracksTableView.reloadData()
    }
    
    func deleteRowAt(index: Int) {
        albumTracksTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }
}

// MARK: - Private

private extension DetailAlbumViewController {
    private func signTableView() {
        albumTracksTableView.delegate = self
        albumTracksTableView.dataSource = self
        albumTracksTableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier
        )
    }
}
