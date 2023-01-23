//
//  LibraryViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 8.10.22.
//

import UIKit
import FirebaseDatabase

protocol LibraryViewControllerInterface: AnyObject {
    func hideNavigationBar()
    func showNavigationBar()
    
    func reloadCollectionData()
}

final class LibraryViewController: UIViewController {

    var presenter: LibraryPresenterInterface?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var libraryTableView: UITableView!
    @IBOutlet private weak var recentlyAddedCollectionView: UICollectionView!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        libraryTableView.register(
            UINib(nibName: SmallTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: SmallTableViewCell.identifier
        )
        recentlyAddedCollectionView.register(
            UINib(nibName: LargeCollectionViewCell.identifier, bundle: nil),
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

// MARK: - UITableViewDataSource

extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SmallTableViewCell.identifier
            ) as? SmallTableViewCell else {
            return UITableViewCell()
        }
        let category = Category.allCases[indexPath.row]
        cell.configureCategory(category: category)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
}

// MARK: - UITableViewDelegate

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didTriggerTableViewCell(category: Category.allCases[indexPath.row])
    }
}

// MARK: - UICollectionViewDataSource

extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        LocalStorage.shared.localTracks.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: LargeCollectionViewCell.identifier,
                for: indexPath) as? LargeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let track = LocalStorage.shared.localTracks[indexPath.row]
        cell.configureTrack(track: track)
        return cell
    }
}
// MARK: - UICollectionViewDelegate
extension LibraryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = DetailTrackViewController.storyboardInstance() else {
            return
        }

        LocalStorage.shared.currentAudioQueue = LocalStorage.shared.localTracks
        vc.trackIndex = indexPath.row
        navigationController?.present(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension LibraryViewController: UICollectionViewDelegateFlowLayout {
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

// MARK: - LibraryViewControllerInterface

extension LibraryViewController: LibraryViewControllerInterface {
    func showNavigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }

    func hideNavigationBar() {
//        self.navigationController?.navigationBar.isHidden = true
    }
    
    func reloadCollectionData() {
        self.recentlyAddedCollectionView.reloadData()
    }
}
