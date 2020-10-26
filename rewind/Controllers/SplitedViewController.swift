//
//  SplitedViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-23.
//

import UIKit
import AVFoundation

class SplitedViewController: UIViewController {
    
    // MARK: -Variables
    
    // Audio related variables
    var autoPlayOn = true
    lazy var playerQueue : AVQueuePlayer = {
        return AVQueuePlayer()
    }()
    
    // UI elements
    let scrollView = UIScrollView()
    let containerView = UIStackView()
    let topImageView = RWImageView(image: UIImage(named: "placeholder"))
    let bottomContainerView = UIView()
    let playButton = PlayButton()
    let closeButton = CloseButton()
    let pronunciationLabel = RWSecondaryLabel("/Not implemented yet/")
    var closeButtonAction: (()->Void)!
    private let padding: CGFloat = 18
    
    // Models
    var learningWord: LearningWord! {
        didSet {
            updateViewsBasedOnWord()
        }
    }
    
    // MARK: -Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
        
        configureScrollView()
        configureTopImageView()
        configureBottomContainerView()
        configurePlayButton()
        configureCloseButton()
        configurePronunciationLabel()
        
    }
    
    func updateViewsBasedOnWord() {
        topImageView.updateImage(for: learningWord.literal)
        
        pronunciationLabel.text = learningWord.pronounciation
        playTrackOrPlaylist()
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -50),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        scrollView.addSubview(containerView)
        containerView.axis = .vertical
        containerView.alignment = .leading
        containerView.spacing = padding
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
    }
    
    func configureTopImageView() {
        topImageView.contentMode = .scaleAspectFill
        topImageView.translatesAutoresizingMaskIntoConstraints = false
        topImageView.layer.masksToBounds = true
        containerView.addArrangedSubview(topImageView)
        NSLayoutConstraint.activate([
            topImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.67),
        ])
    }
    
    func configureBottomContainerView() {
        bottomContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addArrangedSubview(bottomContainerView)
        
        // bottomContainerView's height depends on the content.
        NSLayoutConstraint.activate([
            bottomContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
    }
    
    func configurePlayButton() {
        containerView.addSubview(playButton)
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            playButton.bottomAnchor.constraint(equalTo: topImageView.bottomAnchor, constant: -padding),
        ])
        
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    func configureCloseButton() {
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
        ])
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    func configurePronunciationLabel() {
        containerView.addSubview(pronunciationLabel)
        NSLayoutConstraint.activate([
            pronunciationLabel.centerYAnchor.constraint(equalTo: playButton.centerYAnchor),
            pronunciationLabel.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: padding / 4),
        ])
    }
    
    @objc func playButtonTapped() {
        playTrackOrPlaylist()
    }
    
    @objc func closeButtonTapped() {
        closeButtonAction()
    }
    
    func playTrackOrPlaylist() {
        guard let url = URL(string: learningWord.dictionaryResult.content?.ph_am_mp3 ??
                                    "http://media.shanbay.com/audio/us/\(learningWord.literal).mp3") else { return }
        let playerItem = AVPlayerItem.init(url: url)
        self.playerQueue.insert(playerItem, after: nil)
        self.playerQueue.play()
    }

}
