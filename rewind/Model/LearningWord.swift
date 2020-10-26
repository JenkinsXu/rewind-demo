//
//  LearningWord.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-26.
//

import Foundation

class LearningWord: Codable {
    
    let literal: String
    var learntCount = 0
    var lastDate = Date()
    var collocations: [Collocation] = []
    var dictionaryResult: DictionaryResult = DictionaryResult()
    var partOfSpeech: String {
        return dictionaryResult.content?.word_mean[0].components(separatedBy: " ").first?.uppercased() ?? "UNKNOWN"
    }
    var translations: [String] {
        return dictionaryResult.content?.word_mean ?? ["无释义"]
    }
    var pronounciation: String {
        return "/\(dictionaryResult.content?.ph_am ?? "Unknow")/"
    }
    
    init(literal: String, collocations: [Collocation], dictionaryResult: DictionaryResult) {
        self.literal = literal
        self.collocations = collocations
        self.dictionaryResult = dictionaryResult
    }
    
    init(_ literal: String) {
        self.literal = literal
        print("Fetching collocations for word \(literal).")
        NetworkManager.shared.getCollocations(word: literal, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let collocations):
                self.collocations = collocations
            case .failure(let errorMessage):
                print(errorMessage)
            }
        })
        
        NetworkManager.shared.getWord(literal, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let dictionaryResult):
                self.dictionaryResult = dictionaryResult
            case .failure(let errorMessage):
                print(errorMessage)
            }
        })
    }
}

extension LearningWord: Comparable {
    static func < (lhs: LearningWord, rhs: LearningWord) -> Bool {
        return lhs.literal == rhs.literal
    }
    
    static func == (lhs: LearningWord, rhs: LearningWord) -> Bool {
        return lhs.literal == rhs.literal
    }
}
