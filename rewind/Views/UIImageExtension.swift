//
//  UIImageExtension.swift
//  rewind
//
//  Created by Yongqi Xu on 2020-09-24.
//

import UIKit

extension CGImage {
    var brightness: Double {
        get {
            let imageData = self.dataProvider?.data
            let ptr = CFDataGetBytePtr(imageData)
            var x = 0
            var result: Double = 0
            for i in 0..<self.height {
                guard i % 10 == 0 else { continue }
                for j in 0..<self.width {
                    guard j % 10 == 0 else { continue }
                    let r = ptr![0]
                    let g = ptr![1]
                    let b = ptr![2]
                    result += (0.299 * Double(r) + 0.587 * Double(g) + 0.114 * Double(b))
                    x += 1
                }
            }
            let bright = result / Double (x)
            return bright
        }
    }
}
extension UIImage {
    var brightness: Double {
        get {
            return (self.cgImage?.brightness)!
        }
    }
}
