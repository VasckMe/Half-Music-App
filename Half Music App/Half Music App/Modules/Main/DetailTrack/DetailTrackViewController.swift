//
//  DetailTrackViewController.swift
//  Half Music App
//
//  Created by Apple Macbook Pro 13 on 5.10.22.
//

import UIKit
import MediaPlayer
import FirebaseDatabase

protocol UpdateDetailTrackViewControllerProtocol {
    func updateDetailTrack()
}

protocol DetailTrackViewControllerInterface: AnyObject {
    func setTrackName(name: String?)
    func setAuthorName(name: String?)
    func setBackgroundImageView(image: UIImage?)
    func setTrackImageView(image: UIImage?)
    
    func setMaxTrackSliderValue(value: Float)
    func setTrackSliderValue(value: Float)
    
    func setStartTimeLabel(time: String)
    func setEndTimeLabel(time: String)
    
    func setRepeat()
    func repeatButtonToggle()
    
    func setShuffle()
    func shuffleButtonToggle()
        
    func playPause()
    func playPauseButtonToggle()
    
    func likeButtonToggle()
    func likeButtonIsSelected(isSelected: Bool)
}

final class DetailTrackViewController: UIViewController {

    var presenter: DetailTrackPresenterInterface?
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var trackBackgroundImageView: UIImageView!
    @IBOutlet private weak var trackImageView: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var trackSlider: UISlider!
    @IBOutlet private weak var startTimeLabel: UILabel!
    @IBOutlet private weak var endTimeLabel: UILabel!
    @IBOutlet private weak var volumeSliderOutlet: UISlider!
    @IBOutlet private weak var playPauseButtonOutlet: UIButton!
    @IBOutlet private weak var shuffleOutlet: UIButton!
    @IBOutlet private weak var repeatOutlet: UIButton!
    @IBOutlet private weak var likeButtonOutlet: UIButton!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.didTriggerLoadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.didTriggerViewAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        presenter?.didTriggerViewDisappear()
    }
    
    // MARK: - IBActions
    
    @IBAction private func touchUpInside(_ sender: UISlider) {
        presenter?.didTriggerTrackSliderTouchUp(value: Double(sender.value))
    }
    
    @IBAction private func touchUpDown(_ sender: UISlider) {
        presenter?.didTriggerTrackSliderTouchDown()
    }
    
    @IBAction private func trackSliderAction() {
        presenter?.didTriggerTrackSlider(value: Double(trackSlider.value))
    }
    
    @IBAction private func backwardTrackAction() {
        presenter?.didTriggerBackward()
    }
    
    @IBAction private func playPauseTrackAction() {
        presenter?.didTriggerPlayPause()
    }
    
    @IBAction private func forwardTrackAction() {
        presenter?.didTriggerForward(isShuffle: shuffleOutlet.isSelected)
    }
    
    @IBAction private func shuffleAction() {
        presenter?.didTriggerShuffle()
    }
    
    @IBAction private func volumeSliderAction(_ sender: UISlider) {
        presenter?.didTriggerVolumeSlider(value: sender.value)
    }
    
    @IBAction private func repeatAction() {
        presenter?.didTriggerRepeat()
    }
    
    @IBAction private func addToLibrary(_ sender: Any) {
        presenter?.didTriggerAddToLibrary(isSelected: likeButtonOutlet.isSelected)
    }
    
    @IBAction private func addToAlbum() {
        presenter?.didTriggerAddToAlbum()
    }
}

// MARK: - DetailTrackViewControllerInterface

extension DetailTrackViewController: DetailTrackViewControllerInterface {
    func setTrackName(name: String?) {
        trackNameLabel.text = name
    }
    
    func setAuthorName(name: String?) {
        authorNameLabel.text = name
    }
    
    func setBackgroundImageView(image: UIImage?) {
        trackBackgroundImageView.image = image
    }
    
    func setTrackImageView(image: UIImage?) {
        trackImageView.image = image
    }
    
    func setMaxTrackSliderValue(value: Float) {
        trackSlider.maximumValue != value ? trackSlider.maximumValue = value : nil
    }
    
    func setTrackSliderValue(value: Float) {
        trackSlider.value = value
    }
    
    func setStartTimeLabel(time: String) {
        startTimeLabel.text = time
    }
    
    func setEndTimeLabel(time: String) {
        endTimeLabel.text = time
    }
    
    func setRepeat() {
        AudioPlayerManager.shared.isRepeat = repeatOutlet.isSelected
    }
    
    func repeatButtonToggle() {
        repeatOutlet.isSelected.toggle()
    }

    func setShuffle() {
        AudioPlayerManager.shared.isShuffle = shuffleOutlet.isSelected
    }
    
    func shuffleButtonToggle() {
        shuffleOutlet.isSelected.toggle()
    }
    
    func playPause() {
        playPauseButtonOutlet.isSelected ? AudioManager.shared.play() : AudioManager.shared.pause()
    }
    
    func playPauseButtonToggle() {
        playPauseButtonOutlet.isSelected.toggle()
    }
    
    func likeButtonIsSelected(isSelected: Bool) {
        likeButtonOutlet.isSelected = isSelected
    }
    
    func likeButtonToggle() {
        likeButtonOutlet.isSelected.toggle()
    }
}

// MARK: - Private

private extension DetailTrackViewController {
    func setupUI() {
        volumeSliderOutlet.value = AudioManager.shared.volume * 100
        
        playPauseButtonOutlet.isSelected = AudioManager.shared.isPlaying
        playPauseButtonOutlet.setImage(UIImage(systemName: "pause.circle.fill"), for: .selected)
        playPauseButtonOutlet.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        
        likeButtonOutlet.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButtonOutlet.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
        repeatOutlet.isSelected = AudioManager.shared.isRepeat
        repeatOutlet.setImage(UIImage(systemName: "arrow.2.circlepath.circle"), for: .normal)
        repeatOutlet.setImage(UIImage(systemName: "arrow.2.circlepath.circle.fill"), for: .selected)
        
        shuffleOutlet.isSelected = AudioManager.shared.isShuffle
        shuffleOutlet.setImage(UIImage(systemName: "shuffle.circle"), for: .normal)
        shuffleOutlet.setImage(UIImage(systemName: "shuffle.circle.fill"), for: .selected)
    }
}
