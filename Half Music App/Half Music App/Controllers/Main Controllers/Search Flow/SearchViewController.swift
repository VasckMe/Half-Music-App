//
//  SearchViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.11.22.
//

import UIKit

final class SearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    
    @IBOutlet private weak var searchTrackBar: UISearchBar! {
        didSet {
            searchTrackBar.searchTextField.textColor = .white
        }
    }
    
    // MARK: Properties
    
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
        dataFetcher.fetchFreeMusic { [weak self] audio in
            guard let tracks = audio?.items else { return }
            LocalStorage.shared.convertToNewModelArray(itemArray: tracks)
            self?.tableView.reloadData()
        }
    }
    
    
    @IBAction func sortAction(_ sender: UIBarButtonItem) {
//        let xib = SortView()
//        xib.frame = CGRect(x: 250, y: 80, width: 100, height: 100)
//        view.addSubview(xib)
//        view.bringSubviewToFront(xib)
    }
    
    
    
    // MARK: - Table view data source

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
    
    // MARK: - Table view delegate
    
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
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            LocalStorage.shared.refreshLocalTracks()
            tableView.reloadData()
        } else {
            LocalStorage.shared.localTracks = LocalStorage.shared.copyLocalTracks.filter({ trackFB in
                trackFB.name.lowercased().contains(searchText.lowercased())
            })
            tableView.reloadData()
        }
    }
}
