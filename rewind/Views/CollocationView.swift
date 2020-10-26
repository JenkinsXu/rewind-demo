//
//  CollocationView.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-27.
//

import UIKit

class CollocationView: UIStackView {
    
    var collocation: Collocation

    init(_ collocation: Collocation) {
        self.collocation = collocation
        super.init(frame: .zero)
        
        configure()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        axis = .vertical
        alignment = .leading
        spacing = 12
        
        let collocationLabel = SentenceLabel(collocation.collocation)
        collocationLabel.textColor = .label
        addArrangedSubview(collocationLabel)
        
        guard let examples = collocation.examples?.prefix(3) else {
            print("No examples in this collection.")
            return
        }
        for example in examples {
            guard let example = example else { return }
            let exampleLabel = SentenceLabel("")
            exampleLabel.text = example.htmlToString
            addArrangedSubview(exampleLabel)
        }
    }

}
