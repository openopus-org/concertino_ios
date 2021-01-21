//
//  DotsAnimation.swift
//  Concertino
//
//  Created by Adriano Brandao on 24/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct DotsAnimation: View {
    @State private var isAnimated = false
    
    var body: some View {
        HStack(spacing: 3) {
            ForEach(0...2, id: \.self) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(Color.lightRed)
                    .scaleEffect(self.isAnimated ? 0 : 1)
                    .animation(Animation.linear(duration: 0.6).repeatForever().delay(0.2 * Double(index)))
            }
        }
        .onAppear() {
            self.isAnimated = true
        }
    }
}

struct DotsAnimation_Previews: PreviewProvider {
    static var previews: some View {
        DotsAnimation()
    }
}
