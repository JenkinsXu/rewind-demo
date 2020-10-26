//
//  SFSymbols.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-23.
//

import UIKit

enum SFSymbols {
    private static let largeConfig = UIImage.SymbolConfiguration(pointSize: 40)
    private static let smallConfig = UIImage.SymbolConfiguration(pointSize: 30)
    private static let tabBarConfig = UIImage.SymbolConfiguration(pointSize: 18)
    static let play = UIImage(systemName: "play.circle.fill", withConfiguration: largeConfig)!
    static let close = UIImage(systemName: "xmark.circle.fill", withConfiguration: smallConfig)!
    static let learning = UIImage(systemName: "newspaper.fill", withConfiguration: tabBarConfig)!
}
