//
//  SearchViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.11.22.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTrackBar: UISearchBar! {
        didSet {
            searchTrackBar.searchTextField.textColor = .white
        }
    }
    
    // MARK: - Properties
    
    let dataFetcher: DataFetcherServiceProtocol = DataFetcherService()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Music"
        searchTrackBar.delegate = self
        tableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchMusic()
    }
}

// MARK: - UITableViewDataSource

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalStorage.shared.localTracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
            withIdentifier: TrackTableViewCell.identifier,
            for: indexPath) as? TrackTableViewCell
        else {
            return UITableViewCell()
        }
        
        let track = LocalStorage.shared.localTracks[indexPath.row]
        
        cell.configure(model: track)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75.0
    }
}

// MARK: - UITableViewDelegate

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = DetailTrackViewController.storyboardInstance() else {
            return
        }

        LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
        vc.trackIndex = indexPath.row

        navigationController?.present(vc, animated: true)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            dataFetcher.fetchFreeMusic { [weak self] audio in
                guard let tracks = audio?.items else { return }
                LocalStorage.shared.convertToNewModelArray(itemArray: tracks)
                self?.tableView.reloadData()
            }
        } else {
            dataFetcher.fetchFreeMusic { [weak self] audio in
                guard let tracks = audio?.items else { return }
                LocalStorage.shared.convertToNewModelArray(itemArray: tracks)
                LocalStorage.shared.localTracks = LocalStorage.shared.localTracks.filter { trackFB in
                    trackFB.name.lowercased().contains(searchText.lowercased())
                }
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: Extension Logic
extension SearchViewController {
    // MARK: - Private
    private func fetchMusic() {
        dataFetcher.fetchFreeMusic { [weak self] audio in
            guard let tracks = audio?.items else { return }
            LocalStorage.shared.convertToNewModelArray(itemArray: tracks)
            self?.tableView.reloadData()
        }
    }
}
