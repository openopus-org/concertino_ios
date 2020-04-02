//
//  ComposerRow.swift
//  Concertino
//
//  Created by Adriano Brandao on 01/02/20.
//  Copyright © 2020 Open Opus. All rights reserved.
//

import SwiftUI
import URLImage

struct ComposerBox: View {
    var composer: Composer
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                URLImage(composer.portrait!, placeholder: { _ in
                    Circle()
                        .fill(Color(hex: 0x2B2B2F))
                        .frame(width: 52, height: 52)
                }) { img in
                    img.image
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipped()
                        .clipShape(Circle())
                }
                .frame(width: 52, height: 52)
                Text(composer.name.uppercased())
                    .foregroundColor(Color(hex: 0xfe365e))
                    .font(.custom("Nunito-ExtraBold", size: 13))
                Group{
                    Text(composer.complete_name)
                    Text("(" + composer.birth!.prefix(4)) + Text(composer.death != nil ? "-" : "") + Text((composer.death?.prefix(4) ?? "")) + Text(")")
                }
                .foregroundColor(.white)
                .lineLimit(20)
                .font(.custom("Nunito", size: 11))
            }
            .padding(12)
        }
        .frame(minWidth: 134, maxWidth: 134, minHeight: 174,  maxHeight: 174, alignment: .topLeading)
        .background(Color(hex: 0x202023))
        .padding(0)
        .cornerRadius(12)
    }
}

struct ComposerBox_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
