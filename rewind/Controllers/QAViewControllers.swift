//
//  QAViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-23.
//

import UIKit

protocol QAViewControllerDelegate {
    func positiveButtonTapped()
    func negativeButtonTapped()
}

class QAViewController: UIViewController {
    
    var delegate: QAViewControllerDelegate!
    
    let questionLabel = QuestionLabel("Not implemented yet?")
    let negativeButton = RWButton(buttonText: "TEST", textColor: .systemRed)
    let positiveButton = RWButton(buttonText: "TEST", textColor: .systemBlue)
    private let padding: CGFloat = 18
    
    init(question: String, positiveButtonText: String, negativeButtonText: String) {
        super.init(nibName: nil, bundle: nil)
        questionLabel.text = question
        positiveButton.setTitle(positiveButtonText, for: .normal)
        negativeButton.setTitle(negativeButtonText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureQuestionLabel()
        configureNegativeButton()
        configurePositiveButton()
    }
    
    func configureQuestionLabel() {
        view.addSubview(questionLabel)
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    func configureNegativeButton() {
        view.addSubview(negativeButton)
        negativeButton.addTarget(self, action: #selector(negativeButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            negativeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            negativeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            negativeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }
    
    func configurePositiveButton() {
        view.addSubview(positiveButton)
        positiveButton.addTarget(self, action: #selector(positiveButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            positiveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            positiveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            positiveButton.bottomAnchor.constraint(equalTo: negativeButton.topAnchor, constant: -padding),
        ])
    }
    
    @objc func negativeButtonTapped() {
        delegate.negativeButtonTapped()
    }
    
    @objc func positiveButtonTapped() {
        delegate.positiveButtonTapped()
    }
    
}

