//
//  SearchResultViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-26.
//

import UIKit

class SearchResultViewController: DetailedViewController {
    
    var isUpdatingFromANewWord = true

    override func viewDidLoad() {
        super.viewDidLoad()

        bottomButton.setTitle("Add", for: .normal)
        closeButton.removeFromSuperview()
        scrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isUpdatingFromANewWord {
            showIndicator()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isUpdatingFromANewWord {
            
            isUpdatingFromANewWord = false
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                guard let self = self else { return }
                self.updateViewsWithoutResettingButton()
                self.naLabel.text = "Loading collocations..."
                self.hideIndicator()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else { return }
                if self.learningWord.collocations.count == 0 {
                    self.updateViewsWithoutResettingButton()
                    self.naLabel.text = "Giving it another trying...."
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                guard let self = self else { return }
                if self.learningWord.collocations.count == 0 {
                    self.updateViewsWithoutResettingButton()
                    self.naLabel.text = "No collocations for this word."
                }
            }
            
        }
        
    }
    
    override func updateViewsBasedOnWord() {
        super.updateViewsBasedOnWord()
        isUpdatingFromANewWord = true
        bottomButton.isEnabled = true
        bottomButton.setTitle("Add", for: .normal)
    }
    
    func updateViewsWithoutResettingButton() {
        super.updateViewsBasedOnWord()
    }
    
    override func bottomButtonTapped() {
        bottomButton.isEnabled = false
        bottomButton.setTitle("Added", for: .disabled)
        LearningWordsQueues.shared.enqueueWordFromReadyQueue(learningWord, to: 0)
        presentAlert(title: "Added", description: "This word has been added to today's task. 😀 Happy studying!", buttonText: "DONE") {}
    }

}
