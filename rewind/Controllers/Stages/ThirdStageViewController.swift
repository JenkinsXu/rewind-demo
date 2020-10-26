//
//  ThirdStageViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-26.
//

import UIKit

class ThirdStageViewController: SecondStageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    // Prevent showing the image
    override func updateViewsBasedOnWord() {
        wordLabel.text = learningWord.literal
        pronunciationLabel.text = learningWord.pronounciation
        
        playTrackOrPlaylist()
        
        updateColorsBasedOnBrightness()
    }
    
    func configure() {
        stageLabel.text = "Stage 3"
    }

}
