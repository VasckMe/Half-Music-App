//
//  SongsTableViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 12.10.22.
//

import UIKit
import FirebaseDatabase

protocol SongsTableViewControllerInterface: AnyObject {
    func setTitle(with: String?)
    
    func showNavigationBar()
    
    func reloadData()
}

final class SongsTableViewController: UITableViewController {
    
    var presenter: SongsPresenterInterface?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.searchTextField.textColor = .white
        }
    }
    
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
        presenter?.didTriggerViewAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        presenter?.didTriggerViewDisappear()
    }
}

// MARK: - UISearchBarDelegate

extension SongsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didTriggerSearchBar(text: searchText)
    }
}

// MARK: - Table view data source, delegate

extension SongsTableViewController {
    // Data source

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
            FireBaseStorageService.audioRef.child(audioTrack.name ?? "track name").removeValue()
            LocalStorage.shared.localTracks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
    
    // Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTriggerTableViewCellAt(index: indexPath.row)
    }
}

extension SongsTableViewController: SongsTableViewControllerInterface {
    func setTitle(with text: String?) {
        self.title = text
    }
    
    func showNavigationBar() {
        navigationController?.navigationBar.isHidden = false
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}
