//
//  PartOfSpeechLabel.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-24.
//

import UIKit

class PartOfSpeechLabel: UILabel {

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
        textColor = .label
        textAlignment = .natural
        font = .preferredFont(forTextStyle: .body)
        lineBreakMode = .byTruncatingTail
    }

}
