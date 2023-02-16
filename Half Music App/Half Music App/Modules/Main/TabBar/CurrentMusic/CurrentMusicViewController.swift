//
//  CurrentMusicViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 17.01.23.
//

import UIKit
import MediaPlayer

protocol CurrentMusicViewControllerInterface: AnyObject {
    func setTitleLabel(title: String?)
    
    func animate()
    
    func setPlayPause()
    func playPause()
    func playPauseToggle()
}

final class CurrentMusicViewController: UIViewController {

    var presenter: CurrentMusicPresenterInterface?
    
    @IBOutlet private weak var audioTitleLabel: UILabel!
    @IBOutlet private weak var animationImageView: UIImageView!
    @IBOutlet private weak var playPauseButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.didTriggerLoadView()
        setupUI()
    }
    // MARK: - IBActions
    
    @IBAction private func playPauseAction() {
        presenter?.didTriggerPlayPause()
    }
    
    @IBAction private func forwardAction() {
        presenter?.didTriggerForward()
    }
    
    deinit {
        presenter?.didTriggerDeinit()
    }
    
    func setupUI() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ourViewTapped))
        view.addGestureRecognizer(recognizer)
        animationImageView.animationImages = AnimationManager.shared.getAnimationImages()
        animationImageView.animationDuration = 0.4
        playPauseButtonOutlet.setImage(UIImage(systemName: "pause.circle.fill"), for: .selected)
        playPauseButtonOutlet.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
    }
    
    @objc func ourViewTapped() {
        presenter?.didTriggerTapView()
    }
}

extension CurrentMusicViewController: CurrentMusicViewControllerInterface {
    func playPause() {
        playPauseButtonOutlet.isSelected ? AudioManager.shared.play() : AudioManager.shared.pause()
    }
    
    func playPauseToggle() {
        playPauseButtonOutlet.isSelected.toggle()
    }
    
    func setPlayPause() {
        playPauseButtonOutlet.isSelected = AudioManager.shared.isPlaying
    }
    
    func setTitleLabel(title: String?) {
        audioTitleLabel.text = title
    }
    
    func animate() {
        playPauseButtonOutlet.isSelected
            ? animationImageView.startAnimating()
            : animationImageView.stopAnimating()
    }
}
