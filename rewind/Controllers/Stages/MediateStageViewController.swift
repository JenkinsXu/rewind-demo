//
//  MediateStageViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-10-02.
//

import UIKit

class MediateStageViewController: DetailedViewController {
    
    // MARK: -Variables
    let stageLabel = StageLabel("Review")
    let wordLabel = LargeWordLabel("Word")
    let partOfSpeechLabel = PartOfSpeechLabel("UNKNOWN")
    let labelStackView = UIStackView()
    
    var completion: (() -> Void)!
    
    private let padding: CGFloat = 18
    
    // MARK: -Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureModalPresentation()
        configureButton()
        configureStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    func configureModalPresentation() {
        modalPresentationStyle = .automatic
    }
    
    func configureButton() {
        bottomButton.backgroundColor = .tertiarySystemBackground
        bottomButton.setTitle("Continue", for: .normal)
    }
    
    override func updateViewsBasedOnWord() {
        wordLabel.text = learningWord.literal
        super.updateViewsBasedOnWord()
        updateColorsBasedOnBrightness()
    }

    func updateColorsBasedOnBrightness() {
        let adaptiveColor: UIColor = topImageView.isBright() ? .black : .white
        wordLabel.textColor = adaptiveColor
        partOfSpeechLabel.textColor = adaptiveColor
        pronunciationLabel.textColor = adaptiveColor
        playButton.tintColor = adaptiveColor
    }
    
    func configureStackView() {
        topImageView.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        
        labelStackView.addArrangedSubview(stageLabel)
        labelStackView.addArrangedSubview(wordLabel)
        labelStackView.addArrangedSubview(partOfSpeechLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topImageView.safeAreaLayoutGuide.topAnchor, constant: padding + 50),
            labelStackView.leadingAnchor.constraint(equalTo: topImageView.leadingAnchor, constant: padding),
        ])
    }
    
    override func bottomButtonTapped() {
        dismiss(animated: true, completion: completion)
    }
    
    override func closeButtonTapped() {
        dismiss(animated: true, completion: completion)
    }
    
}
