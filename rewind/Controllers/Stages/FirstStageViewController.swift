//
//  FirstStageViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-25.
//

import UIKit

class FirstStageViewController: DetailedViewController {
    
    // MARK: -Variables
    let stageLabel = StageLabel("Stage 1")
    let wordLabel = LargeWordLabel("Word")
    let partOfSpeechLabel = PartOfSpeechLabel("UNKNOWN")
    let labelStackView = UIStackView()
    
    var buttonAction: (() -> Void)!
    
    private let padding: CGFloat = 18
    
    // MARK: -Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLabelStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func updateViewsBasedOnWord() {
        wordLabel.text = learningWord.literal
        partOfSpeechLabel.text = learningWord.partOfSpeech
        
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
    
    func configureLabelStackView() {
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
        DispatchQueue.main.async {
            self.buttonAction()
        }
    }
    
}
