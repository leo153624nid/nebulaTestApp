//
//  IconButton.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

/// Representing a button as an icon
struct IconButton: View {
    /// Action when button was tapped
    let action: () -> Void
    /// Image for button
    let image: Image?
    /// Color of image
    let color: Color?
    /// Image width and height
    let size: CGFloat
    
    /// Initialization
    ///
    /// - Parameter image: image for button
    /// - Parameter color: color of image
    /// - Parameter size: image width and height
    /// - Parameter action: action when button was tapped
    init(image: Image?,
         color: Color?,
         size: CGFloat = 24,
         action: @escaping () -> Void) {
        
        self.action = action
        self.image = image
        self.color = color
        self.size = size
    }
    
    var body: some View {
        if let image, let color {
            Button {
                action()
            } label: {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
                    .foregroundStyle(color)
            }
            .buttonStyle(AlphaWhenPressedButtonStyle())
        }
    }
}

/// Representing a button as an icon with background
struct IconButtonWithBackground: View {
    /// Action when button was tapped
    let action: () -> Void
    /// Image for button
    let image: Image
    /// Color of image
    let imageColor: Color
    /// Image width and height
    let imageSize: CGFloat
    /// Button width and height
    let buttonSize: CGFloat
    /// Color of background
    let backgroundColor: Color
    
    /// Initialization
    ///
    /// - Parameter image: image for button
    /// - Parameter imageColor: color of image
    /// - Parameter imageSize: image width and height
    /// - Parameter buttonSize: button width and height
    /// - Parameter backgroundColor: color of background
    /// - Parameter action: action when button was tapped
    init(image: Image,
         imageColor: Color,
         imageSize: CGFloat = 20,
         buttonSize: CGFloat = 42,
         backgroundColor: Color = .background,
         action: @escaping () -> Void) {
        
        self.action = action
        self.image = image
        self.imageColor = imageColor
        self.imageSize = imageSize
        self.buttonSize = buttonSize
        self.backgroundColor = backgroundColor
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(backgroundColor)
                    .frame(width: buttonSize, height: buttonSize)
                
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: imageSize, height: imageSize)
                    .foregroundStyle(imageColor)
            }
        }
        .buttonStyle(AlphaWhenPressedButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        IconButton(image: CommonImages.Navigation.close.swiftUIImage,
                   color: .red,
                   size: 24,
                   action: { })
        
        IconButtonWithBackground(image: CommonImages.Navigation.arrow.swiftUIImage,
                                 imageColor: .purple,
                                 imageSize: 20,
                                 buttonSize: 42,
                                 backgroundColor: .gray,
                                 action: { })
    }
}
