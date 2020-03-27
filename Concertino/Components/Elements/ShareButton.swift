//
//  ShareButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 24/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct ShareButton: View {
    var isLoading: Bool
    var body: some View {
        VStack {
            if isLoading {
                CircleAnimation()
            } else {
                Image(systemName: "square.and.arrow.up")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 16, height: 16)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 28, height: 28)
        .background(Color(hex: 0x2B2B2F))
        .clipped()
        .clipShape(Circle())
    }
}

struct ShareButton_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
