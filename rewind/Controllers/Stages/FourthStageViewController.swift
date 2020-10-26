//
//  FourthStageViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-26.
//

import UIKit

class FourthStageViewController: SecondStageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    // Prevent sound from playing
    override func updateViewsBasedOnWord() {
        topImageView.updateImage(for: learningWord.literal)
        pronunciationLabel.text = learningWord.pronounciation
    }
    
    func configure() {
        stageLabel.text = "Stage 4"
        wordLabel.text = "..."
        QAController.questionLabel.text = "What do you call this?"
        QAController.positiveButton.setTitle("I know the answer", for: .normal)
        QAController.negativeButton.setTitle("I don't fully know the answer", for: .normal)
    }

}
