//
//  NetwordManager.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-26.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    var imageCache = NSCache<NSString, UIImage>()
    
    func getCollocations(word: String, completion: @escaping (Result<[Collocation], ErrorMessage>) -> Void) {
        
        let headers = [
            "x-rapidapi-host": "linguatools-english-collocations.p.rapidapi.com",
        ]
        
        #warning("This is a test endpoint.")
        guard let url = URL(string:  "https://lt-collocation-test.herokuapp.com/todos/?query=\(word)&lang=en") else {
            completion(.failure(.invalidWord))
            return
        }
        
        
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let collocations = try decoder.decode([Collocation].self, from: data)
                completion(.success(collocations))
            } catch {
                completion(.failure(.unableToDecode))
            }
        }
        task.resume()
        
    }
    
    func getWord(_ word: String, completion: @escaping (Result<DictionaryResult, ErrorMessage>) -> Void) {
        guard let url = URL(string: "http://fy.iciba.com/ajax.php?a=fy&f=en&t=zh&w=\(word)") else {
            completion(.failure(.invalidWord))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedWord = try decoder.decode(DictionaryResult.self, from: data)
                completion(.success(decodedWord))
            } catch {
                completion(.failure(.unableToDecode))
            }
            
        }
        task.resume()
    }
    
}

enum ErrorMessage: String, Error {
    case invalidWord = "This word is invalid. Please try another one."
    case unableToComplete = "Unable to complete your request. Plaease check your internet connection."
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
    case unableToDecode = "Unable to decode."
}
