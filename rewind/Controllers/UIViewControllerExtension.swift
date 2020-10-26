//
//  UIViewControllerExtension.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-10-09.
//

import UIKit

fileprivate var indicatorBackgroundView: UIView!

extension UIViewController {
    func showIndicator() {

        indicatorBackgroundView = UIView(frame: view.bounds)
        view.addSubview(indicatorBackgroundView)
        indicatorBackgroundView.backgroundColor = .systemBackground
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .systemGray
        indicatorBackgroundView.addSubview(activityIndicator)
        
        let loadingLabel = RWBodyLabel("LOADING", alignTo: .center)
        loadingLabel.font = .preferredFont(forTextStyle: .caption2)
        indicatorBackgroundView.addSubview(loadingLabel)

        indicatorBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicatorBackgroundView)
        NSLayoutConstraint.activate([
            indicatorBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -50),
            indicatorBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            indicatorBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            indicatorBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: indicatorBackgroundView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: indicatorBackgroundView.centerYAnchor),
            loadingLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8),
            loadingLabel.centerXAnchor.constraint(equalTo: activityIndicator.centerXAnchor),
        ])

        activityIndicator.startAnimating()
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            indicatorBackgroundView.removeFromSuperview()
            indicatorBackgroundView = nil
        }
    }
}
