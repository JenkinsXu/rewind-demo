//
//  SentenceLabel.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-24.
//

import UIKit

class SentenceLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(_ text: String) {
        super.init(frame: .zero)
        self.text = text
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .secondaryLabel
        textAlignment = .natural
        font = .preferredFont(forTextStyle: .body)
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
