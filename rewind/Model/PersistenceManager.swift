//
//  PersistenceManager.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-10-13.
//

import Foundation

fileprivate let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                              in: .userDomainMask).first!

enum ArchiveURL {
    static let queueArchiveURL = documentsDirectory
        .appendingPathComponent("queue")
        .appendingPathExtension("plist")
    static let dateArchiveURL = documentsDirectory
        .appendingPathComponent("date")
        .appendingPathExtension("plist")
    static let historyArchiveURL = documentsDirectory
        .appendingPathComponent("history")
        .appendingPathExtension("plist")
}

class PersistenceManager {
    static let shared = PersistenceManager()
    private init() {}
    
    private let propertyListEncoder = PropertyListEncoder()
    private let propertyListDecoder = PropertyListDecoder()
    
    func saveQueue() {
        let encodedQueue = try? propertyListEncoder.encode(LearningWordsQueues.shared)
        try? encodedQueue?.write(to: ArchiveURL.queueArchiveURL, options: .noFileProtection)
        print("Queue saved")
    }
    
    func retriveQueue() {
        if let retrivedQueueData = try? Data(contentsOf: ArchiveURL.queueArchiveURL),
           let decodedQueue = try? propertyListDecoder.decode(LearningWordsQueues.self,
                                                              from: retrivedQueueData) {
            LearningWordsQueues.shared = decodedQueue
            print("Queue staged: \(decodedQueue.stagedWordsCount)")
            print("Queue ready:  \(decodedQueue.readyQueue.count)")
        }
//        try? FileManager.default.removeItem(atPath: "\(ArchiveURL.queueArchiveURL.path)")
//        print("All clear")
    }
    
    func saveDate() {
        let encodedQueue = try? propertyListEncoder.encode(Date())
        try? encodedQueue?.write(to: ArchiveURL.dateArchiveURL, options: .noFileProtection)
        print("Date saved")
    }
    
    func retriveDate() -> Date? {
        if let retrivedDateData = try? Data(contentsOf: ArchiveURL.dateArchiveURL),
           let decodedDate = try? propertyListDecoder.decode(Date.self,
                                                              from: retrivedDateData) {
            print("Date retrived")
            return decodedDate
        }
        return nil
    }
    
    func saveHistory(_ history: [String]) {
        let encodedQueue = try? propertyListEncoder.encode(history)
        try? encodedQueue?.write(to: ArchiveURL.historyArchiveURL, options: .noFileProtection)
        print("History saved")
    }
    
    func retriveHistory() -> [String]? {
        if let retrivedHistoryData = try? Data(contentsOf: ArchiveURL.historyArchiveURL),
           let decodedHistory = try? propertyListDecoder.decode([String].self,
                                                              from: retrivedHistoryData) {
            print("History retrived")
            return decodedHistory
        }
        return nil
    }
}
