//
//  DetailedViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-24.
//

import UIKit

class DetailedViewController: SplitedViewController {
    
    // MARK: -Variables
    
    let collocationTitleLabel = LargeWordLabel("Collocations")
    var collocationContainerView = UIStackView()
    let naLabel = SentenceLabel("No collocation in the database for this word.")
    
    let translationTitleLabel = LargeWordLabel("Translations")
    var translationContainerView = UIStackView()
    
    let paddingView = UIView()
    
    let bottomButton = RWButton(buttonText: "NEXT", textColor: .systemBlue)
    
    private let padding: CGFloat = 18
    var hasAddedCollocations = false

    // MARK: -Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureBottomButton()
        configuretranslationContainerView()
        configureCollocationContainerView()
        configureBottomPadding()
    }
    
    private func removeArrangedSubviews() {
        for arrangedSubview in collocationContainerView.arrangedSubviews {
            collocationContainerView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        for arrangedSubview in translationContainerView.arrangedSubviews {
            translationContainerView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
    }
    
    private func updateCollocations() {
        let collocations = learningWord.collocations
        collocationContainerView.addArrangedSubview(collocationTitleLabel)
        collocationContainerView.setCustomSpacing(9, after: collocationTitleLabel)
        if collocations.count == 0 {
            collocationContainerView.addArrangedSubview(naLabel)
        } else {
            for collocation in collocations {
                let collocationView = CollocationView(collocation)
                collocationContainerView.addArrangedSubview(collocationView)
            }
        }
    }
    
    private func updateTranslations() {
        let translations = learningWord.translations
        translationContainerView.addArrangedSubview(translationTitleLabel)
        translationContainerView.setCustomSpacing(9, after: translationTitleLabel)
        guard translations.count != 0 else {
            let naLabel = SentenceLabel("No translation in the database for this word.")
            translationContainerView.addArrangedSubview(naLabel)
            return
        }
        for translation in translations {
            let translationLabel = SentenceLabel(translation)
            translationContainerView.addArrangedSubview(translationLabel)
        }
    }
    
    override func updateViewsBasedOnWord() {
        super.updateViewsBasedOnWord()
        
        removeArrangedSubviews()
        updateTranslations()
        updateCollocations()
    }
    
    func configureCollocationContainerView() {
        containerView.addArrangedSubview(collocationContainerView)
        containerView.setCustomSpacing(9, after: topImageView)
        collocationContainerView.axis = .vertical
        collocationContainerView.alignment = .leading
        collocationContainerView.spacing = 18
        
        NSLayoutConstraint.activate([
            collocationContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collocationContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        collocationContainerView.layoutMargins = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        collocationContainerView.isLayoutMarginsRelativeArrangement = true
        
        collocationContainerView.addArrangedSubview(collocationTitleLabel)
        collocationContainerView.setCustomSpacing(9, after: collocationTitleLabel)
    }
    
    func configuretranslationContainerView() {
        containerView.addArrangedSubview(translationContainerView)
        containerView.setCustomSpacing(28, after: collocationContainerView)
        translationContainerView.axis = .vertical
        translationContainerView.alignment = .leading
        translationContainerView.spacing = 18
        
        NSLayoutConstraint.activate([
            translationContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            translationContainerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
        ])
        
        translationContainerView.layoutMargins = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        translationContainerView.isLayoutMarginsRelativeArrangement = true
    }

    func configureBottomButton() {
        view.addSubview(bottomButton)
        bottomButton.addTarget(self, action: #selector(bottomButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
        ])
    }
    
    @objc func bottomButtonTapped() {}
    
    func configureBottomPadding() {
        paddingView.heightAnchor.constraint(equalToConstant: 170).isActive = true
        containerView.addArrangedSubview(paddingView)
    }
    
}
