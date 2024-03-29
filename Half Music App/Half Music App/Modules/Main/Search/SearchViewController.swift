//
//  SearchViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.11.22.
//

import UIKit

protocol SearchViewControllerInterface: AnyObject {
    func reloadTableView()
}

final class SearchViewController: UIViewController {
    
    var presenter: SearchPresenterInterface?

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchTrackBar: UISearchBar!
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.didTriggerViewAppear()
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
        presenter?.didTriggerTableViewCellAt(index: indexPath.row)
    }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didTriggerSearchBar(text: searchText)
    }
}

// MARK: - SearchViewControllerInterface

extension SearchViewController: SearchViewControllerInterface {    
    func reloadTableView() {
        tableView.reloadData()
    }
}

// MARK: - Private

private extension SearchViewController {
    func setup() {
        title = "Music"
        searchTrackBar.searchTextField.textColor = .white
        searchTrackBar.delegate = self
        tableView.register(
            UINib(nibName: TrackTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: TrackTableViewCell.identifier)
    }
}
