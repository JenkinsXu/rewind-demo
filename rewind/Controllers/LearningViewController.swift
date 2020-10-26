//
//  LearningViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-26.
//

import UIKit

class LearningViewController: UIViewController {
    
    // MARK: -Variables
    
    let firstStageVC = FirstStageViewController()
    let secondStageVC = SecondStageViewController()
    let thirdStageVC = ThirdStageViewController()
    let fourthStageVC = FourthStageViewController()
    let mediateStageVC = MediateStageViewController()
    
    var learningWordsQueue: LearningWordsQueues = LearningWordsQueues.shared
    let dispatchGroup = DispatchGroup()
    
    // MARK: -Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showIndicator()
    }
    
    var isFirstLoad = true
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.isFirstLoad {
                self.preloadViewControllers()
            }
            self.presentStageVC()
        }
        hideIndicator()
    }
    
    // This method is called in LandingViewController instead to speed up loading.
    func fetchData() {
        
        learningWordsQueue.literals.forEach { (query) in
            dispatchGroup.enter()
            fetchPhoto(query: query)
        }
        
        dispatchGroup.notify(queue: .main) {
            print("All images needed are fetched.")
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
    
    func preloadViewControllers() {
        _ = firstStageVC.view
        _ = secondStageVC.view
        _ = thirdStageVC.view
        _ = fourthStageVC.view
        _ = mediateStageVC.view
    }
    
    func presentStageVC() {
        let (learningWord, stage) = learningWordsQueue.dequeueLastWord()
        switch stage {
        case .done:
            presentAlert(title: "🥳 Congratulations!",
                         description: "You've finished your task of the day. Take a break and enjoy your day!",
                         buttonText: "DONE") { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true)
            }
            
            
        case .first:
            // First stage VC is not being dismiss to speed up loading
            firstStageVC.learningWord = learningWord
            print("Dequeued \(self.firstStageVC.learningWord!.literal) to Stage 1.")
            firstStageVC.closeButtonAction = {
                self.learningWordsQueue.prependWord(learningWord!, to: 0)
                print("Adding \(self.firstStageVC.learningWord!.literal) to Stage 1 due to closing.")
                self.dismiss(animated: true, completion: nil)
            }
            firstStageVC.buttonAction = { [weak self] in
                guard let self = self else { return }
                self.learningWordsQueue.moveWordToNextStage(learningWord!)
                self.presentStageVC()
            }
            presentStage(vc: firstStageVC)
            
        case .second:
            secondStageVC.learningWord = learningWord
            print("Dequeued \(self.secondStageVC.learningWord!.literal) to Stage 2.")
            secondStageVC.closeButtonAction = {
                self.learningWordsQueue.prependWord(learningWord!, to: 1)
                print("Adding \(self.secondStageVC.learningWord!.literal) to Stage 2 due to closing.")
                self.dismiss(animated: true, completion: nil)
            }
            secondStageVC.positiveButtonAction = { [weak self] in
                guard let self = self else { return }
                self.learningWordsQueue.moveWordToNextStage(learningWord!)
                self.presentStageVC()
            }
            secondStageVC.negativeButtonAction = { [weak self] in
                guard let self = self else { return }
                
                self.learningWordsQueue.enqueueWord(learningWord!, to: 1)
                print("Adding \(self.secondStageVC.learningWord!.literal) to Stage 2 due to negative button event.")
                self.mediateStageVC.learningWord = learningWord
                self.mediateStageVC.completion = { self.presentStageVC() }
                self.present(self.mediateStageVC, animated: true, completion: nil)
            }
            presentStage(vc: secondStageVC)
            
        case .third:
            // Third stage VC is not being dismiss to speed up loading
            thirdStageVC.learningWord = learningWord
            print("Dequeued \(self.thirdStageVC.learningWord!.literal) to Stage 3.")
            thirdStageVC.closeButtonAction = {
                self.learningWordsQueue.prependWord(learningWord!, to: 2)
                print("Adding \(self.thirdStageVC.learningWord!.literal) to Stage 3 due to closing.")
                self.dismiss(animated: true, completion: nil)
            }
            thirdStageVC.positiveButtonAction = { [weak self] in
                guard let self = self else { return }
                self.learningWordsQueue.moveWordToNextStage(learningWord!)
                self.presentStageVC()
            }
            thirdStageVC.negativeButtonAction = { [weak self] in
                guard let self = self else { return }
                self.learningWordsQueue.enqueueWord(learningWord!, to: 2)
                print("Adding \(self.thirdStageVC.learningWord!.literal) to Stage 3 due to negative button event.")
                self.mediateStageVC.learningWord = learningWord
                self.mediateStageVC.completion = { self.presentStageVC() }
                self.present(self.mediateStageVC, animated: true, completion: nil)
            }
            presentStage(vc: thirdStageVC)
            
        case .fourth:
            fourthStageVC.learningWord = learningWord
            print("Dequeued \(self.fourthStageVC.learningWord!.literal) to Stage 4.")
            fourthStageVC.closeButtonAction = {
                self.learningWordsQueue.prependWord(learningWord!, to: 3)
                print("Adding \(self.fourthStageVC.learningWord!.literal) to Stage 4 due to closing.")
                self.dismiss(animated: true, completion: nil)
            }
            fourthStageVC.positiveButtonAction = { [weak self] in
                guard let self = self else { return }
                self.learningWordsQueue.enqueueToReadyQueue(learningWord!)
                print("Done \(self.fourthStageVC.learningWord!.literal)'s learning for today.")
                self.presentStageVC()
            }
            fourthStageVC.negativeButtonAction = { [weak self] in
                guard let self = self else { return }
                
                self.learningWordsQueue.enqueueWord(learningWord!, to: 3)
                print("Adding \(self.fourthStageVC.learningWord!.literal) to Stage 4 due to negative button event.")
                self.mediateStageVC.learningWord = learningWord
                self.mediateStageVC.completion = { self.presentStageVC() }
                self.present(self.mediateStageVC, animated: true, completion: nil)
            }
            presentStage(vc: fourthStageVC)
            
        case .none:
            fatalError()
        }
    }
    
    private func presentStage(vc: UIViewController) {
        addChild(vc)
        view.addSubview(vc.view)
        vc.view.pin(to: view)
        vc.didMove(toParent: self)
    }
    
    private func dismissStage(vc: UIViewController) {
        vc.willMove(toParent: nil)
        vc.view.unpin(from: view)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
}
