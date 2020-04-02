//
//  TinyComposerBox.swift
//  Concertino
//
//  Created by Adriano Brandao on 29/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct TinyComposerBox: View {
    var composer: Composer
    
    var body: some View {
        VStack {
            VStack {
                URLImage(composer.portrait!, placeholder: { _ in
                    Circle()
                        .fill(Color(hex: 0x2B2B2F))
                        .frame(width: 32, height: 32)
                }) { img in
                    img.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .clipShape(Circle())
                }
                .frame(width: 32, height: 32)
                Text(composer.name)
                    .foregroundColor(Color.white)
                    .font(.custom("Nunito-ExtraBold", size: 9))
                    .padding(.top, -4)
            }
            .padding(12)
        }
        .frame(minWidth: 72, maxWidth: 72, minHeight: 72,  maxHeight: 72, alignment: .top)
        .background(Color(hex: 0x202023))
        .padding(0)
        .cornerRadius(12)
    }
}

struct TinyComposerBox_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
