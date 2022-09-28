//
//  SearchTableViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 28.09.22.
//

import UIKit

class SearchTableViewController: UITableViewController {

    // MARK: IBOutlets
    
    @IBOutlet private weak var searchTrackBar: UISearchBar! {
        didSet {
            searchTrackBar.searchTextField.textColor = .white
        }
    }
    
    // MARK: Properties
    
    let dataFetcher: DataFetcherServiceProtocol = DataFetcherService()
    var copiedArray: [ItemInfo] = []
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.title = "Search music"
        searchTrackBar.delegate = self
        tableView.register(
            UINib(nibName: SearchTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        dataFetcher.fetchFreeMusic { [weak self] audio in
            guard let tracks = audio?.items else { return }
            LocalStorage.shared.searchTracks = tracks
            self?.tableView.reloadData()
            self?.copiedArray = tracks
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LocalStorage.shared.searchTracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchTableViewCell.identifier,
            for: indexPath) as? SearchTableViewCell
        else {
            return UITableViewCell()
        }
        
        let track = LocalStorage.shared.searchTracks[indexPath.row].track
        
        cell.configure(model: track)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75.0
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

extension SearchTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            LocalStorage.shared.searchTracks = copiedArray
        } else {
            LocalStorage.shared.searchTracks = copiedArray.filter({ iteminfo in
                iteminfo.track.name.contains(searchText)
            })
            tableView.reloadData()
        }
    }
}
