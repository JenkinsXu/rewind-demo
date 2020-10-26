//
//  RWButton.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-23.
//

import UIKit

class RWButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.alpha = self.isHighlighted ? 0.6 : 1
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(buttonText: String, textColor: UIColor) {
        super.init(frame: .zero)
        setTitle(buttonText, for: .normal)
        setTitleColor(textColor, for: .normal)
        setTitleColor(.systemGray, for: .disabled)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Color
        backgroundColor = .systemGray6
        
        // Shape
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        
        // Text
        titleLabel?.font = .preferredFont(forTextStyle: .headline)
        titleLabel?.textAlignment = .center
        
        // Constraint
        heightAnchor.constraint(equalToConstant: 54).isActive = true
    }

}
