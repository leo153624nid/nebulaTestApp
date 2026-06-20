//
//  RoundedCorners.swift
//  nebulaTestApp
//
//  Created by A Ch on 20.06.2026.
//

import SwiftUI

/// Shape with rounded corners
struct RoundedCorners: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    init(corners: UIRectCorner = [.allCorners], radius: CGFloat) {
        self.corners = corners
        self.radius = radius
    }
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
