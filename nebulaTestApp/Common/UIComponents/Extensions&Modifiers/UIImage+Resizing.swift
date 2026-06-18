//
//  UIImage+Resizing.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import UIKit.UIImage

extension UIImage {
    func resizableAtCenter() -> UIImage {
        let fixedVertical = floor(size.height / 2)
        let fixedHorizontal = floor(size.width / 2)
        return resizableImage(withCapInsets: .init(top: fixedVertical - CGFloat((Int(size.height) % 2 > 0) ? 0 : 1),
                                                   left: fixedHorizontal - CGFloat((Int(size.width) % 2 > 0) ? 0 : 1),
                                                   bottom: fixedVertical,
                                                   right: fixedHorizontal))
    }
}
