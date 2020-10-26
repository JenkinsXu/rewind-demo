//
//  LearningWordsQueues.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-26.
//

import Foundation

class LearningWordsQueues: Codable {
    
    // MARK: -Variables
    static var shared = LearningWordsQueues(newWords: [], reviewingWords: [])
    
    private var stagedWords: [[LearningWord]] = [[], [], [], []]
    private var remaining: Int
    private var topNonEmptyLevel: Int {
        for i in 0..<stagedWords.count {
            if !stagedWords[i].isEmpty {
                return i
            }
        }
        return stagedWords.count
    }
    private var currentLevelPopCount = 0
    private var returningStage: ReturningStage = .upper
    private var setSize: Int
    private var previousLevel = 0
    private var returningLevel = 0
    var isEmpty: Bool {
        return remaining == 0
    }
    var literals: [String] {
        var learningWords: [LearningWord] = []
        var literals: [String] = []
        for stagedWord in stagedWords {
            learningWords += stagedWord
        }
        for learningWord in learningWords {
            literals.append(learningWord.literal)
        }
        return literals
    }
    
    var limit = 50
    var newWordsLimit = 10
    
    // MARK: -Spaced Repetition Support
    
    var wordsLearntToday = 0
    var readyQueue: [LearningWord] = []
    var stagedWordsCount: Int {
        var count = 0
        for stagedWord in stagedWords {
            count += stagedWord.count
        }
        return count
    }
    
    func appendToReadyQueue(_ words: LearningWord...) {
        for word in words {
            readyQueue.append(word)
        }
    }
    
    // MARK: -Functions
    
    private init(newWords: [LearningWord], reviewingWords: [LearningWord]) {
        remaining = newWords.count + reviewingWords.count
        setSize = remaining / stagedWords.count + remaining % stagedWords.count
        stagedWords[0] = newWords
        stagedWords[2] = reviewingWords
    }
    
    func dequeueLastWord() -> (LearningWord?, Stage?) {
        guard topNonEmptyLevel != stagedWords.count else {
            currentLevelPopCount = 0
            returningStage = .upper
            previousLevel = 0
            returningLevel = 0
            print(topNonEmptyLevel)
            return (nil, .done)
        }
        
        returningLevel = topNonEmptyLevel
        if !(topNonEmptyLevel == stagedWords.count - 1) && returningStage == .lower {
            returningLevel = previousLevel + 1
        } else {
            previousLevel = returningLevel
        }
        
        if stagedWords[returningLevel].count == 0 { returningLevel -= 1 }
        let learningWord = stagedWords[returningLevel].removeFirst()
        currentLevelPopCount += 1
        if currentLevelPopCount == 2 * setSize && returningStage == .upper {
            currentLevelPopCount = 0
            returningStage = .lower
        } else if (currentLevelPopCount == setSize && returningStage == .lower) || (stagedWords[returningLevel].isEmpty && returningStage == .lower) {
            currentLevelPopCount = 0
            returningStage = .upper
        }
        
        return (learningWord, Stage.allCases[returningLevel])
    }
    
    func moveWordToNextStage(_ learningWord: LearningWord) {
        if !(returningLevel == stagedWords.count - 1) {
            stagedWords[returningLevel + 1].append(learningWord)
        }
    }
    
    func enqueueWord(_ words: LearningWord..., to stage: Int) {
        for word in words {
            guard stage < stagedWords.count else { return }
            stagedWords[stage].append(word)
            print("\(word.literal) is enqueued to stage \(stage + 1)")
        }
    }
    
    func prependWord(_ word: LearningWord, to stage: Int) {
        guard stage < stagedWords.count else { return }
        stagedWords[stage].insert(word, at: 0)
    }
    
    func enqueueWordFromReadyQueue(_ words: LearningWord..., to stage: Int) {
        for word in words {
            enqueueWord(word, to: stage)
        }
        remaining = stagedWordsCount
        setSize = remaining / stagedWords.count + remaining % stagedWords.count
        
    }
    
    func updateWordsForANewDay() {
        guard readyQueue.count != 0 && stagedWordsCount <= limit else { return }
        
        var newWords = 0
        for word in readyQueue {
            
            switch word.learntCount {
            case 0:
                if newWords < newWordsLimit {
                    newWords += 1
                    enqueueWordFromReadyQueue(word, to: 0)
                }
            case 1:
                if !(word.lastDate.addingTimeInterval(86400 * 0.7) <= Date()) { continue }
            case 2:
                if !(word.lastDate.addingTimeInterval(86400 * 1.7) <= Date()) { continue }
            case 3:
                if !(word.lastDate.addingTimeInterval(86400 * 2.7) <= Date()) { continue }
            case 4:
                if !(word.lastDate.addingTimeInterval(86400 * 4.7) <= Date()) { continue }
            case 5:
                if !(word.lastDate.addingTimeInterval(86400 * 7.7) <= Date()) { continue }
            default:
                continue
            }
            
            enqueueWordFromReadyQueue(word, to: 2)
            
        }
    }
    
    func enqueueToReadyQueue(_ word: LearningWord) {
        word.lastDate = Date()
        word.learntCount += 1
        if word.learntCount <= 5 { readyQueue.append(word) }
        wordsLearntToday += 1
    }
    
}

enum Stage: CaseIterable {
    case first, second, third, fourth, done
}

enum ReturningStage: Int, Codable {
    case upper, lower
}
