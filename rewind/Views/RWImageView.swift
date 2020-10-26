//
//  RWImageView.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-24.
//

import UIKit

class RWImageView: UIImageView {
    
    private var hiddenImage = UIImage(named: "placeholder")
    
    func isBright() -> Bool {
        guard let image = image else { return false }
        return image.brightness > 100
    }

    func updateImage(for word: String) {
        
        if let image = NetworkManager.shared.imageCache.object(forKey: NSString(string: word)) {
            self.image = image
            return
        } else {
            fetchPhoto(query: word)
            self.image = image
        }
        
    }
    
    func fetchPhoto(query: String) {
        guard let url = URL(string: "https://source.unsplash.com/375x458/?\(query)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }
            
            guard let image = UIImage(data: data) else { return }
            NetworkManager.shared.imageCache.setObject(image, forKey: NSString(string: query))
        }
        
        task.resume()
    }
    
}
