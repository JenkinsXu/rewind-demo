//
//  AddWordsViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-10-12.
//

import UIKit

class AddWordsViewController: UIViewController {

    private let textView = UITextView()
    private let addToTodayLabel = RWTitleLabel("Add to today's task", alignTo: .natural)
    private let addToTodayToggle = UISwitch()
    private let padding: CGFloat = 12
    private let placeHolder = "Paste / input words in here, with each word on a line."
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureNavigationStyle()
        configureAddToToday()
        configureTextField()
        configureKeyboardHidding()
        configureKeyboardShowing()
    }
    
    func configureKeyboardShowing() {
        
    }
    
    func configureKeyboardHidding() {
        let tapHestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapHestureRecognizer)
        
//        let toolBar = UIToolbar()
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        toolBar.items = [flexibleSpace, flexibleSpace, doneButton]
//        toolBar.sizeToFit()
//        textView.inputAccessoryView = toolBar
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureNavigationStyle() {
        title = "Add New Words"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = .init(barButtonSystemItem: .cancel, target: self, action: #selector(dismissViewController))
        navigationItem.rightBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
    }
    
    @objc func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    func configureAddToToday() {
        view.addSubview(addToTodayLabel)
        NSLayoutConstraint.activate([
            addToTodayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            addToTodayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            addToTodayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
        ])
        
        view.addSubview(addToTodayToggle)
        addToTodayToggle.setOn(true, animated: true)
        addToTodayToggle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addToTodayToggle.centerYAnchor.constraint(equalTo: addToTodayLabel.centerYAnchor),
            addToTodayToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
        ])
    }
    
    @objc func doneButtonTapped() {
        guard textView.text != placeHolder else {
            dismiss(animated: true, completion: nil)
            return
        }
        let learningWordLiterals = textView.text.components(separatedBy: "\n")
        let isToggleOn = addToTodayToggle.isOn
        showIndicator()
        dismissKeyboard()
        for literal in learningWordLiterals {
            dispatchGroup.enter()
            guard literal != "" else { continue }
            let trimmedLiteral = literal.trimmingCharacters(in: .whitespacesAndNewlines)
            if isToggleOn {
                LearningWordsQueues.shared.enqueueWordFromReadyQueue(LearningWord(trimmedLiteral), to: 0)
            } else {
                LearningWordsQueues.shared.appendToReadyQueue(LearningWord(trimmedLiteral))
            }
            fetchPhoto(query: trimmedLiteral)
        }
        print("Added, queue staged: \(LearningWordsQueues.shared.stagedWordsCount)")
        print("Added, queue ready:  \(LearningWordsQueues.shared.readyQueue.count)")
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func fetchPhoto(query: String) {
        guard let url = URL(string: "https://source.unsplash.com/375x458/?\(query)") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            NetworkManager.shared.imageCache.setObject(image, forKey: NSString(string: query))
            
            self.dispatchGroup.leave()
        }
        
        task.resume()
    }
    
    func configureTextField() {
        textView.autocorrectionType = .yes
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = placeHolder
        textView.delegate = self
        textView.textColor = .systemGray2
        textView.font = .preferredFont(forTextStyle: .body)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            textView.topAnchor.constraint(equalTo: addToTodayLabel.bottomAnchor, constant: padding),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
        ])
    }

}

extension AddWordsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray2 {
            textView.text = nil
            textView.textColor = .label
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = .systemGray2
        }
    }
}
