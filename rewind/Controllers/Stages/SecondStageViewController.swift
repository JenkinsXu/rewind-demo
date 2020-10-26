//
//  SecondStageViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-23.
//

import UIKit

class SecondStageViewController: SplitedViewController, QAViewControllerDelegate {

    // MARK: -Variables
    let stageLabel =            StageLabel("Stage 2")
    let wordLabel =             LargeWordLabel("Word")
    let partOfSpeechLabel =     PartOfSpeechLabel("UNKNOWN")
    let labelStackView =        UIStackView()
    
    var QAController = QAViewController(question: "Do you know what this word means?",
                                        positiveButtonText: "I know the meaning",
                                        negativeButtonText: "I don't fully know the meaning")
    var positiveButtonAction: (() -> Void)!
    var negativeButtonAction: (() -> Void)!
    
    private let padding: CGFloat = 18
    
    // MARK: -Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureQAController()
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
    
    func configureQAController() {
        addChild(QAController)
        view.addSubview(QAController.view)
        QAController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            QAController.view.topAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            QAController.view.bottomAnchor.constraint(equalTo: bottomContainerView.bottomAnchor),
            QAController.view.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor),
            QAController.view.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor),
        ])
        QAController.didMove(toParent: self)
        QAController.delegate = self
    }
    
    func updateColorsBasedOnBrightness() {
        let adaptiveColor: UIColor = topImageView.isBright() ? .black : .white
        wordLabel.textColor = adaptiveColor
        partOfSpeechLabel.textColor = adaptiveColor
        pronunciationLabel.textColor = adaptiveColor
        playButton.tintColor = adaptiveColor
    }
    
    func configureLabelStackView() {
        view.addSubview(labelStackView)
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.axis = .vertical
        labelStackView.alignment = .leading
        
        labelStackView.addArrangedSubview(stageLabel)
        labelStackView.addArrangedSubview(wordLabel)
        labelStackView.addArrangedSubview(partOfSpeechLabel)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding),
            labelStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
        ])
    }

    func positiveButtonTapped() {
        DispatchQueue.main.async {
            self.positiveButtonAction()
        }
    }
    
    func negativeButtonTapped() {
        DispatchQueue.main.async {
            self.negativeButtonAction()
        }
    }
    
}


