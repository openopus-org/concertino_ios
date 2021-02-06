//
//  EllipsisButton.swift
//  Concertino
//
//  Created by Adriano Brandao on 22/03/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI

struct EllipsisButton: View {
    var body: some View {
        VStack {
            Image(systemName: "ellipsis")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
        }
        .frame(width: 28, height: 28)
        .background(Color.extraDarkGray)
        .clipped()
        .clipShape(Circle())
    }
}

struct EllipsisButton_Previews: PreviewProvider {
    static var previews: some View {
        EllipsisButton()
    }
}
