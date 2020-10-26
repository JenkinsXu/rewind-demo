//
//  LandingViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-10-02.
//

import UIKit

class LandingViewController: UIViewController {
    
    // MARK: - Variables
    
    let learningViewController = LearningViewController()
    var startButton = RWButton(buttonText: "Start Task", textColor: .white)
    var addWordsButton = RWButton(buttonText: "Add Words", textColor: .label)
    var lastOpenDate: Date!
    var isFirstTimeOpenToday: Bool {
        let lastDayOpen = Calendar.current.dateComponents([.day], from: lastOpenDate)
        let dayOfToday = Calendar.current.dateComponents([.day], from: Date())
        return lastDayOpen != dayOfToday
    }

    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        retriveLastOpenDate()
        configureAddWordsButton()
        configureStartButton()
        configureDemoLabel()
    }
    
    func configureDemoLabel() {
        let demoLabel = RWBodyLabel("This version is for demo only. A demo key is used for API calls. The server used for the demo will automatically sleep after half an hour of no requests.", alignTo: .natural)
        view.addSubview(demoLabel)
        NSLayoutConstraint.activate([
            demoLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            demoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            demoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
        ])
        
        let demoTitleLabel = RWTitleLabel("Demo", alignTo: .natural)
        view.addSubview(demoTitleLabel)
        NSLayoutConstraint.activate([
            demoTitleLabel.bottomAnchor.constraint(equalTo: demoLabel.topAnchor, constant: -9),
            demoTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
        ])
    }
    
    func retriveLastOpenDate() {
        lastOpenDate = PersistenceManager.shared.retriveDate() ?? Date()
        PersistenceManager.shared.saveDate()
    }
    
    private var justLaunched = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if justLaunched {
            showIndicator()
            
            DispatchQueue.main.async {
                self.learningViewController.fetchData()
            }
            
            hideIndicator()
        }
        justLaunched = false
        
        if isFirstTimeOpenToday {
            DispatchQueue.global(qos: .userInteractive).async {
                LearningWordsQueues.shared.wordsLearntToday = 0
                LearningWordsQueues.shared.updateWordsForANewDay()
            }
        }
        
        updateViews()
    }
    
    func updateViews() {
        
    }

    func configureStartButton() {
        view.addSubview(startButton)
        startButton.backgroundColor = .systemBlue
        
        NSLayoutConstraint.activate([
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            startButton.bottomAnchor.constraint(equalTo: addWordsButton.topAnchor, constant: -18)
        ])
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    func configureAddWordsButton() {
        view.addSubview(addWordsButton)
        
        NSLayoutConstraint.activate([
            addWordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            addWordsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            addWordsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
        
        addWordsButton.addTarget(self, action: #selector(addWordsButtonTapped), for: .touchUpInside)
    }
    
    @objc func startButtonTapped() {
        learningViewController.modalPresentationStyle = .fullScreen
        present(learningViewController, animated: true, completion: nil)
    }
    
    @objc func addWordsButtonTapped() {
        present(UINavigationController(rootViewController: AddWordsViewController()), animated: true, completion: nil)
    }
    
}
