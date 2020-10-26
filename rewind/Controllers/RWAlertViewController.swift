//
//  RWAlertViewController.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-27.
//

import UIKit

class RWAlertViewController: UIViewController {

    var alertTitle: String?
    var alertDescription: String?
    var buttonText: String?
    var buttonAction: (() -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(alertTitle: String, alertDescription: String, buttonText: String, buttonAction: (() -> Void)? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.alertTitle = alertTitle
        self.alertDescription = alertDescription
        self.buttonText = buttonText
        self.buttonAction = buttonAction
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        // Dim content behind, cannot be done with layer
        view.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
        
        // Content
        let titleLabel = RWTitleLabel(alertTitle!, alignTo: .center)
        let descriptionLabel = RWBodyLabel(alertDescription!, alignTo: .center)
        let button = RWButton(buttonText: "OK", textColor: .systemBlue)
        
        let contentView = UIStackView(arrangedSubviews: [
            titleLabel,
            descriptionLabel,
            button
        ])
        view.addSubview(contentView)
        
        // Blur background
        let dummyView = UIView(frame: contentView.bounds)
        contentView.insertSubview(dummyView, at: 0)
        dummyView.pin(to: contentView)
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = dummyView.bounds
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.cornerCurve = .continuous
        blurEffectView.layer.masksToBounds = true
        blurEffectView.layer.borderColor = UIColor.systemGray.cgColor
        blurEffectView.layer.borderWidth = 0.5
        dummyView.addSubview(blurEffectView)
        blurEffectView.pin(to: dummyView)
        
        dummyView.layer.shadowColor = UIColor.black.cgColor
        dummyView.layer.shadowOffset = CGSize(width: 0, height: 10.0)
        dummyView.layer.shadowOpacity = 0.25
        dummyView.layer.shadowRadius = 18.0
        
        // Content view
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.spacing = 20
        contentView.axis = .vertical
        contentView.alignment = .center
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        
        
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 300),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        
        // TODO: Refactor this part
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.buttonAction()
        }
    }
    
}

extension UIViewController {
    func presentAlert(title: String, description: String, buttonText: String, buttonAction: @escaping() -> Void) {
        // Showing 2 different view controllers at the same time
        DispatchQueue.main.async {
            let alert = RWAlertViewController(
                alertTitle: title,
                alertDescription: description,
                buttonText: buttonText,
                buttonAction: buttonAction
            )
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
}
