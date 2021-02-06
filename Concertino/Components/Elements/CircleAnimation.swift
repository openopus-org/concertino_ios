//
//  CircleAnimation.swift
//  Concertino
//
//  Created by Adriano Brandao on 24/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct CircleAnimation: View {
    @State private var isAnimated = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.extraDarkGray, lineWidth: 6)
                .frame(width: 20, height: 20)
            
            Circle()
                .trim(from: 0, to: 0.2)
                .stroke(Color(.white), lineWidth: 3)
                .frame(width: 20, height: 20)
                .rotationEffect(Angle(degrees: isAnimated ? 360 : 0))
                .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                .onAppear() {
                    self.isAnimated = true
            }
        }
    }
}

struct CircleAnimation_Previews: PreviewProvider {
    static var previews: some View {
        CircleAnimation()
    }
}
