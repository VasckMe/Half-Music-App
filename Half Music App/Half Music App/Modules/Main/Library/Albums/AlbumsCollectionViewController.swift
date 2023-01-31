//
//  AlbumsCollectionViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 16.10.22.
//

import UIKit
import FirebaseDatabase

protocol AlbumsCollectionViewControllerInterface: AnyObject {
    func showNavigationBar()
    
    func reloadData()
}

final class AlbumsCollectionViewController: UICollectionViewController {
    
    var presenter: AlbumsPresenterInterface?
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        presenter?.didTriggerAddButton()
    }

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(
            UINib(nibName: LargeCollectionViewCell.identifier,bundle: nil),
            forCellWithReuseIdentifier: LargeCollectionViewCell.identifier
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.didTriggerViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.didTriggerViewDisappear()
    }
}
// MARK: - UICollectionViewDelegateFlowLayout

extension AlbumsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        return CGSize(width: 170, height: 210)
    }
}

// MARK: - CollectionView Data Source, Delegate
extension AlbumsCollectionViewController {
    // Data Source

    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let array = presenter?.getAlbums() else {
            return 0
        }
        return array.count
    }

    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LargeCollectionViewCell.identifier,
                for: indexPath
            ) as? LargeCollectionViewCell,
            let array = presenter?.getAlbums()
        else {
            return UICollectionViewCell()
        }
        let album = array[indexPath.row]
        cell.configureAlbum(album: album)
    
        return cell
    }
    
    // Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didTriggerCellAt(index: indexPath.row)
    }
}

extension AlbumsCollectionViewController: AlbumsCollectionViewControllerInterface {
    func showNavigationBar() {
        navigationController?.navigationBar.isHidden = false
    }
    
    func reloadData() {
        self.collectionView.reloadData()
    }
}
