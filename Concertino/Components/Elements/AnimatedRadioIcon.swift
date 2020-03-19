//
//  AnimatedRadioIcon.swift
//  Concertino
//
//  Created by Adriano Brandao on 19/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

var images: [UIImage]! = [
    UIImage(named: "radio-animated-1")!,
    UIImage(named: "radio-animated-2")!,
    UIImage(named: "radio-animated-3")!,
    UIImage(named: "radio-animated-4")!
]
let animatedImage = UIImage.animatedImage(with: images, duration: 0.8)

struct radioIconAnimation: UIViewRepresentable {
    var color: Color
    let frame: CGRect
    var isAnimated: Bool

    func makeUIView(context: Self.Context) -> UIView {
        let someView = UIView(frame: self.frame)
        let someImage = UIImageView(frame: self.frame)

        someImage.clipsToBounds = true
        someImage.autoresizesSubviews = true
        someImage.contentMode = UIView.ContentMode.scaleAspectFit
        someImage.tintColor = self.color.uiColor()
        
        if isAnimated {
            someImage.image = animatedImage
        } else {
            someImage.image = images[0]
        }
        
        someView.addSubview(someImage)
        
        return someView
      }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<radioIconAnimation>) {
        let someImage = UIImageView(frame: self.frame)

        someImage.clipsToBounds = true
        someImage.autoresizesSubviews = true
        someImage.contentMode = UIView.ContentMode.scaleAspectFit
        someImage.tintColor = self.color.uiColor()
        
        if isAnimated {
            someImage.image = animatedImage
        } else {
            someImage.image = images[0]
        }
        
        uiView.subviews[0].removeFromSuperview()
        uiView.addSubview(someImage)
    }
}

struct AnimatedRadioIcon: View, Equatable {
    var color: Color
    var isAnimated: Bool
    
    var body: some View {
        GeometryReader { proxy in
            radioIconAnimation(color: self.color, frame: proxy.frame(in: .local), isAnimated: self.isAnimated)
        }
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.isAnimated == rhs.isAnimated && lhs.color == rhs.color
    }
}

struct AnimatedRadioIcon_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
