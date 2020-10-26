//
//  RWTitleLabel.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-27.
//

import UIKit

class RWTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(_ text: String, alignTo textAlignment: NSTextAlignment) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        font = .preferredFont(forTextStyle: .title3)
        textColor = .label
        lineBreakMode = .byTruncatingTail
    }

}
