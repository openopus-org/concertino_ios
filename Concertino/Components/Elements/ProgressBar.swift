//
//  ProgressBar.swift
//  Concertino
//
//  Created by Adriano Brandao on 18/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ProgressBar: View {
    var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color(hex: 0x121212))
                    .frame(width: geometry.size.width, height: geometry.size.height)
                Rectangle()
                    .fill(Color(hex: 0xfe365e))
                    .frame(width: geometry.size.width * self.progress, height: geometry.size.height)
                    .cornerRadius(2)
            }
            .cornerRadius(geometry.size.height / 2.0)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(progress: 0.5)
    }
}
