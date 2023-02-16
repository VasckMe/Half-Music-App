//
//  AddTrackToAlbumViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.11.22.
//

import UIKit
import FirebaseDatabase

protocol AddTrackToAlbumViewControllerInterface: AnyObject {
    func reloadData()
    func callAlert(title: String, message: String)
}

final class AddTrackToAlbumViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar! {
        didSet {
            searchBar.searchTextField.textColor = .white
        }
    }
    @IBOutlet private weak var albumCollectionView: UICollectionView!
        
    var presenter: AddTrackToAlbumPresenterInterface?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adding track to ..."
        searchBar.delegate = self
        albumCollectionView.delegate = self
        albumCollectionView.dataSource = self
        albumCollectionView.register(
            UINib(nibName: LargeCollectionViewCell.identifier,bundle: nil),
            forCellWithReuseIdentifier: LargeCollectionViewCell.identifier
        )
        presenter?.didTriggerLoadView()
    }
}

// MARK: - UICollectionViewDataSource

extension AddTrackToAlbumViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let albums = presenter?.getAlbums() else {
            return 0
        }
        
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LargeCollectionViewCell.identifier,
                for: indexPath
            ) as? LargeCollectionViewCell,
            let albums = presenter?.getAlbums()
        else {
            return UICollectionViewCell()
        }
        
        let album = albums[indexPath.row]
        cell.configureAlbum(album: album)
    
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension AddTrackToAlbumViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTriggerCellAt(index: indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AddTrackToAlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        return CGSize(width: 170, height: 210)
    }
}

// MARK: - UISearchBarDelegate

extension AddTrackToAlbumViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.didTriggerSearchBar(text: searchText)
    }
}

// MARK: - AddTrackToAlbumViewControllerInterface

extension AddTrackToAlbumViewController: AddTrackToAlbumViewControllerInterface {
    func reloadData() {
        albumCollectionView.reloadData()
    }
    
    func callAlert(title: String, message: String) {
        callDefaultAlert(title: title, message: message)
    }
}
